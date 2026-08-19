# Workflow: Virtual Dyno Validation

**Scope:** Running a virtual dynamometer test on a Simscape motor model to extract characterization data for LUT generation.

## Prerequisites
- Simscape FEM-Parameterized PMSM model (with flux linkage tables)
- Or any Simscape motor model that can be driven at specified operating points
- Simscape Electrical + Simscape licenses

## Step 1: Dyno Model Setup

Build a speed-controlled dyno that drives the motor through operating points:

### Architecture
```
Speed Command → Speed Source (Simscape) → Motor Shaft
Motor Stator ← Controlled Current Source (id, iq injection)
Measurements: Vd, Vq, Id, Iq, Te, ωm logged at steady state
```

### Alternative: Torque-Controlled DUT + Speed Dyno
```
Dyno (speed-controlled) ← shaft → Motor (torque-controlled via FOC)
Sweep: set speed → command id/iq → measure Vd/Vq at steady-state
```

**→ Ref:** `building-motor-plant` § Simscape patterns, `shared/simscape-plant-patterns.md`

## Step 2: Define Test Point Grid

```matlab
% id/iq grid (cover full operating range including FW region):
id_min = -pmsm.I_rated;  % Negative id for field weakening
id_max = 0;               % Or small positive for ACIM
iq_min = -pmsm.I_rated;  % Negative for braking
iq_max = pmsm.I_rated;   % Positive for motoring

nId = 15;  % Grid density (more = better LUTs, slower test)
nIq = 15;

idVec = linspace(id_min, id_max, nId);
iqVec = linspace(iq_min, iq_max, nIq);

% Test speeds (for speed-dependent effects):
speedVec = [500, 1000, 2000, 3000] * pi/30;  % rad/s mechanical
```

## Step 3: Steady-State Detection

At each operating point, wait for transients to settle:

```matlab
% Settling criteria:
settling_threshold_speed = 0.01;    % |dω/dt| < 0.01 rad/s²
settling_threshold_current = 0.01;  % |dI/dt| < 0.01 A/s
settling_time_min = 0.1;            % Minimum wait (s)
settling_time_max = 2.0;            % Timeout (s)

% Implementation: run sim, check last 20% of window for flatness
window = data(end-round(0.2*N):end);
is_settled = (max(window) - min(window)) / max(abs(mean(window)), 1e-6) < 0.01;
```

## Step 4: Measurement Logging

At each steady-state point, record:

| Signal | Symbol | Units | Source |
|---|---|---|---|
| d-axis voltage | Vd | V | From Park transform of stator voltage |
| q-axis voltage | Vq | V | From Park transform of stator voltage |
| d-axis current | Id | A | From Park transform (or commanded) |
| q-axis current | Iq | A | From Park transform (or commanded) |
| Electromagnetic torque | Te | Nm | From motor block output |
| Mechanical speed | ωm | rad/s | From IRMS sensor |
| Electrical angle | θe | rad | From IRMS or encoder |

## Step 5: Sanity Checks

Run ALL checks before proceeding:

- [ ] **No NaN or Inf** in any measurement column
- [ ] **|Te| monotonic with |iq|** at fixed id (torque increases with current)
- [ ] **λd at (id=0, iq=0) ≈ FluxPM** (permanent magnet flux linkage)
- [ ] **λq at (id=0, iq=0) ≈ 0** (no q-axis flux at no current)
- [ ] **Flux magnitude reasonable:** `√(λd² + λq²)` in range 0.01–2 Wb·turns
- [ ] **Quadrant symmetry:** `Te(id, -iq) ≈ -Te(id, iq)` (within 5%)
- [ ] **Torque cross-check:** `Te_calc = 1.5·p·(λd·iq - λq·id)` matches logged Te within 5%
- [ ] **No abrupt discontinuities** in flux tables (would indicate captured transient)
- [ ] **Speed was constant** during measurement (confirms steady-state)

```matlab
% Automated sanity check:
assert(all(~isnan(FluxD(:))), 'NaN in FluxD table');
assert(all(~isnan(FluxQ(:))), 'NaN in FluxQ table');

% Torque cross-check:
Te_calc = 1.5 * pmsm.p * (FluxD .* iqGrid - FluxQ .* idGrid);
Te_error = abs(Te_calc - Te_measured) ./ max(abs(Te_measured), 0.1);
assert(max(Te_error(:)) < 0.05, 'Torque mismatch > 5%%');

% Monotonicity check (iq direction):
for i = 1:nId
    dTe = diff(Te_measured(i,:));  % Along iq axis
    assert(all(dTe >= -0.01), 'Non-monotonic torque at id index %d', i);
end
```

## Step 6: Coordinate Transformation (If Needed)

If raw measurements are in abc or αβ (not dq):

```matlab
% From abc to αβ (Clarke):
I_alpha = Ia;
I_beta = (Ia + 2*Ib) / sqrt(3);
V_alpha = Va;
V_beta = (Va + 2*Vb) / sqrt(3);

% From αβ to dq (Park):
Id = I_alpha.*cos(theta_e) + I_beta.*sin(theta_e);
Iq = -I_alpha.*sin(theta_e) + I_beta.*cos(theta_e);
Vd = V_alpha.*cos(theta_e) + V_beta.*sin(theta_e);
Vq = -V_alpha.*sin(theta_e) + V_beta.*cos(theta_e);
```

## Step 7: Flux Linkage Computation

From steady-state dq voltage equations (dλ/dt = 0):

```matlab
% λd = (Vq - Rs·iq) / ωe
% λq = -(Vd - Rs·id) / ωe
%
% REQUIRES ωe ≠ 0

we = speed_mech * pmsm.p;  % Electrical speed

for i = 1:nId
    for j = 1:nIq
        if abs(we) > 1.0  % Avoid division by zero
            FluxD(i,j) = (Vq_grid(i,j) - pmsm.Rs * iqVec(j)) / we;
            FluxQ(i,j) = -(Vd_grid(i,j) - pmsm.Rs * idVec(i)) / we;
        else
            % At zero speed: use known FluxPM + linear estimate
            FluxD(i,j) = pmsm.FluxPM + pmsm.Ld * idVec(i);
            FluxQ(i,j) = pmsm.Lq * iqVec(j);
        end
    end
end
```

## Step 8: Build LUT Struct for MCB

Package into format expected by `mcb.generateMotorLUT`:

```matlab
% For mcb.generateMotorLUT with 'idiqLUTs' purpose:
motor.p = pmsm.p;
motor.Rs = pmsm.Rs;
motor.IdVect = idVec;          % 1×nId vector (A)
motor.IqVect = iqVec;          % 1×nIq vector (A)
motor.FluxPM = FluxD(idVec==0, iqVec==0);  % Scalar (Wb)

% Apparent inductances (for MCB compatibility):
motor.LdMatrix = FluxD ./ idGrid;  % Handle id=0 carefully
motor.LqMatrix = FluxQ ./ iqGrid;  % Handle iq=0 carefully

% Or directly use flux tables with mcb.updatePMSMLdLqFluxPM:
ParamTableData.FluxD = FluxD;
ParamTableData.FluxQ = FluxQ;
ParamTableData.IdVect = idVec;
ParamTableData.IqVect = iqVec;
```

## Step 9: Proceed to Nonlinear Commissioning

With validated flux tables, continue to:
- `wf-nonlinear-motor-commissioning.md` Step 6 (incremental inductance)
- `importing-nonlinear-motor-data` (for generating control reference LUTs)

---

## Troubleshooting

| Issue | Cause | Fix |
|---|---|---|
| FluxD at id=0 not matching FluxPM | Rs error or transient captured | Verify Rs, increase settling time |
| Asymmetric flux tables | Measurement at different temperatures | Run all points in one session |
| Torque cross-check fails | Wrong θe alignment | Verify encoder offset calibration |
| Noisy flux at low speed | Low ωe amplifies Rs·I error | Test at higher speed, extrapolate |
| Ld_inc negative at high saturation | Normal physics (flux decreasing with current) | Clamp Kp to minimum value |

---

Copyright 2026 The MathWorks, Inc.
