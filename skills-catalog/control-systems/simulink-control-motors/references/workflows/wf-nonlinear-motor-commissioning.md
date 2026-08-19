# Workflow: Nonlinear Motor Commissioning

**Scope:** From FEA/Motor-CAD data or virtual dyno measurements to running gain-scheduled FOC with nonlinear LUTs.

## Prerequisites
- Simscape FEM-Parameterized PMSM model with flux tables, OR
- FEA characterization data (id/iq grid with flux linkages), OR
- Virtual dyno test results (Vd, Vq, Id, Iq at steady-state operating points)
- MCB installed

## Step 1: Virtual Dyno Setup (If No FEA Data)

Build Simscape FEM-PMSM + speed-controlled dyno model.

**→ Ref:** `building-motor-plant` § FEM-PMSM, `wf-virtual-dyno-validation.md`

## Step 2: Run Dyno Tests (If No FEA Data)

Sweep id/iq grid at multiple speeds, log Vd, Vq, Id, Iq, torque, speed.

**→ Ref:** `wf-virtual-dyno-validation.md` Steps 2–4

## Step 3: Measurement Sanity Check

**→ Ref:** `wf-virtual-dyno-validation.md` Step 5

## Step 4: Data Transformation to dq Flux

If data is in abc or αβ, transform to dq using logged θe:
```matlab
% Clarke: [Ia, Ib] → [Iα, Iβ]
I_alpha = Ia;
I_beta = (Ia + 2*Ib) / sqrt(3);

% Park: [Iα, Iβ, θe] → [Id, Iq]
Id = I_alpha*cos(theta_e) + I_beta*sin(theta_e);
Iq = -I_alpha*sin(theta_e) + I_beta*cos(theta_e);
```

## Step 5: Flux Linkage Computation

From steady-state dq voltage equations:
```matlab
% Steady-state: dλ/dt = 0, so:
%   Vd = Rs·id - ωe·λq  →  λq = -(Vd - Rs·id) / ωe
%   Vq = Rs·iq + ωe·λd  →  λd = (Vq - Rs·iq) / ωe
%
% REQUIRES ωe ≠ 0. For zero-speed point, extrapolate.

for i = 1:numel(idVec)
    for j = 1:numel(iqVec)
        FluxD(i,j) = (Vq_grid(i,j) - Rs*iqVec(j)) / we;
        FluxQ(i,j) = -(Vd_grid(i,j) - Rs*idVec(i)) / we;
    end
end
```

## Step 6: Incremental Inductance Computation

**Critical for gain scheduling.** Use numerical gradient on flux tables:

```matlab
[nId, nIq] = size(FluxD);
Ld_inc = zeros(nId, nIq);
Lq_inc = zeros(nId, nIq);

% ∂λd/∂id — partial derivative along id axis
for j = 1:nIq
    Ld_inc(:,j) = gradient(FluxD(:,j), idVec);
end

% ∂λq/∂iq — partial derivative along iq axis
for i = 1:nId
    Lq_inc(i,:) = gradient(FluxQ(i,:), iqVec);
end
```

### Why Incremental (Not Apparent) Inductance?

| Type | Definition | Use |
|---|---|---|
| Apparent | `Ld_app = λd/id` | Steady-state flux calculation |
| Incremental | `Ld_inc = ∂λd/∂id` | **PI controller plant model** |

The PI controller regulates *changes* in current. The plant gain for small perturbations is the incremental inductance. At heavy saturation, `Ld_inc << Ld_app` → PI gains must be larger to maintain bandwidth.

## Step 7: LUT Generation (Control Reference)

Generate optimal id*/iq* reference trajectories (MTPA + FW):

```matlab
% Build motor struct with LUT fields:
motor.p = pmsm.p;
motor.Rs = pmsm.Rs;
motor.IdVect = idVec;
motor.IqVect = iqVec;
motor.FluxPM = FluxD(id==0, iq==0);  % PM flux at no-load
motor.LdMatrix = Ld_table;  % Apparent Ld(id,iq) = FluxD/id
motor.LqMatrix = Lq_table;  % Apparent Lq(id,iq) = FluxQ/iq

% Generate reference current LUTs:
outSt = mcb.generateMotorLUT(motor, inverter, 'idiqLUTs');
% Output: outSt.idRef, outSt.iqRef as functions of (torque, speed)
```

**→ Ref:** `importing-nonlinear-motor-data` § generateMotorLUT

## Step 8: PI Gain Scheduling LUTs

Compute operating-point-dependent PI gains:

```matlab
BW_i = 1 / (4 * Ts);  % Target current loop bandwidth

% Gain tables indexed by (id, iq):
Kp_d_LUT = Ld_inc * BW_i;                    % Varies with operating point
Kp_q_LUT = Lq_inc * BW_i;                    % Varies with operating point
Ki_d_LUT = Rs * BW_i * ones(nId, nIq);       % Rs-dominated (weakly varies)
Ki_q_LUT = Rs * BW_i * ones(nId, nIq);       % Rs-dominated (weakly varies)

% For MCB PI Controller with UseKiTs='on':
KiTs_d_LUT = Ki_d_LUT * Ts;
KiTs_q_LUT = Ki_q_LUT * Ts;

% Store in model workspace:
hws.assignin('Kp_d_LUT', Kp_d_LUT);
hws.assignin('Kp_q_LUT', Kp_q_LUT);
hws.assignin('KiTs_d_LUT', KiTs_d_LUT);
hws.assignin('KiTs_q_LUT', KiTs_q_LUT);
hws.assignin('idVec_gs', idVec);   % Breakpoints for 2-D interp
hws.assignin('iqVec_gs', iqVec);
```

### Implementation in Simulink
Use 2-D Lookup Table blocks:
- Input 1: id_meas (current d-axis feedback)
- Input 2: iq_meas (current q-axis feedback)
- Output: Kp or KiTs at current operating point
- Feed into PI Controller external gain ports (if available) or use manual PI structure

## Step 9: Build Gain-Scheduled FOC Model

Build Pattern B + GainScheduling feature:
- 2-D Lookup Tables for Kp_d, KiTs_d, Kp_q, KiTs_q
- LUT PMSM Control Reference for id*/iq* (from Step 7)
- FEM-Parameterized PMSM as plant (or MCB PMSM with nonlinear data)

**→ Ref:** `references/wiring/` § composition-rules (GainSched), configurations/nonlinear-gain-scheduled.md

## Step 10: Validate Against FEM Plant

Simulate gain-scheduled FOC against the Simscape FEM-PMSM:
- Speed step response at multiple operating points
- Load step at various speeds (below and above base speed)
- Verify: no oscillation across full operating range
- Verify: current tracking error < 5% at all points

```matlab
% Spot-check Vd/Vq at specific operating point:
[vd, vq, vs] = mcb.calcPMSMVdVq(pmsm, ParamTableData, id_op, iq_op, 1, we_op);
% Verify vs < Vmax (voltage headroom exists)
```

## Step 11: Continue with Linear Workflow Steps 8–15

From `wf-linear-motor-commissioning.md`:
- Feed-forward (using nonlinear flux maps for decoupling)
- Field weakening (handled by LUT Control Reference)
- Speed loop tuning (use mcb.calcFOCGains with SpdLoopFactor derating)
- PWM, dead-time compensation, protection

---

## Summary: Key Differences from Linear Workflow

| Aspect | Linear | Nonlinear |
|---|---|---|
| Inductance | Single Ld, Lq values | 2-D tables Ld(id,iq), Lq(id,iq) |
| PI gains | Fixed | Gain-scheduled via 2-D LUTs |
| Control reference | MTPA formula | Precomputed LUTs from mcb.generateMotorLUT |
| Plant for PI tuning | Ld, Lq (constant) | Ld_inc(id,iq), Lq_inc(id,iq) (incremental) |
| Feed-forward | ωe·Ld·id, ωe·Lq·iq | ωe·λd(id,iq), ωe·λq(id,iq) from LUTs |

---

Copyright 2026 The MathWorks, Inc.
