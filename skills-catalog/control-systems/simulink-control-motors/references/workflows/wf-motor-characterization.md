# Workflow: Motor Characterization

**Scope:** Computing motor operating envelope, constraint curves, and performance maps from parameters using verified MCB APIs.

## Prerequisites
- pmsm struct with: p, Rs, Ld, Lq, FluxPM, I_rated (minimum)
- inverter struct with: V_dc (minimum)
- MCB installed

## Step 1: Prepare Input Structs

```matlab
% From datasheet or estimation:
pmsm.p = 4;
pmsm.Rs = 0.36;
pmsm.Ld = 3.5e-3;
pmsm.Lq = 8e-3;
pmsm.FluxPM = 0.1714;
pmsm.I_rated = 12;
pmsm.J = 7.06e-5;
pmsm.B = 1e-5;

inverter.V_dc = 400;
inverter.ISenseMax = 2 * pmsm.I_rated;  % Required by some APIs
```

## Step 2: Compute PU System Base Values

```matlab
PU_System = mcb.getPUSystemParameters(pmsm, inverter);
% Output fields: V_base, I_base, T_base, N_base, Z_base, L_base, etc.

fprintf('V_base = %.1f V\n', PU_System.V_base);
fprintf('I_base = %.1f A\n', PU_System.I_base);
fprintf('T_base = %.2f Nm\n', PU_System.T_base);
fprintf('N_base = %.0f RPM\n', PU_System.N_base);
```

## Step 3: Base Speed

Speed where voltage limit first constrains MTPA operation:

```matlab
% Approximate (faster, ignores Rs):
base_speed_approx = mcb.getMotorBaseSpeed(pmsm, inverter, 'approximate');

% Actual (accounts for Rs voltage drop):
base_speed_actual = mcb.getMotorBaseSpeed(pmsm, inverter, 'actual');

fprintf('Base speed: %.0f RPM (approx), %.0f RPM (actual)\n', ...
    base_speed_approx, base_speed_actual);
```

## Step 4: Maximum Speed

Speed at MTPV or voltage limit with zero torque:

```matlab
% With voltage-current limit method (most common):
max_speed_vclmt = mcb.PMSMMaxSpeed(pmsm, inverter, FWCMethod='vclmt');

% With constant-voltage constant-power:
max_speed_cvcp = mcb.PMSMMaxSpeed(pmsm, inverter, FWCMethod='cvcp');

fprintf('Max speed: %.0f RPM (VCLMT), %.0f RPM (CVCP)\n', ...
    max_speed_vclmt, max_speed_cvcp);
```

## Step 5: Rated Torque and Milestone Currents

```matlab
[T_rated, speeds, id_currents, iq_currents] = mcb.PMSMRatedTorque(pmsm, inverter);

fprintf('Rated torque: %.2f Nm\n', T_rated);
fprintf('Milestone speeds: %s RPM\n', mat2str(round(speeds)));
fprintf('id at milestones: %s A\n', mat2str(round(id_currents, 2)));
fprintf('iq at milestones: %s A\n', mat2str(round(iq_currents, 2)));
```

## Step 6: All Milestone Speeds

```matlab
milestone_speeds = mcb.PMSMSpeeds(pmsm, inverter, ...
    FWCMethod='vclmt', verbose=true, constraintCurves=true);

% With full current/speed matrix:
[full_matrix] = mcb.PMSMSpeeds(pmsm, inverter, ...
    FWCMethod='vclmt', outputAll=true);
% Columns: [id, iq, electrical_speed]
```

## Step 7: Full Drive Characteristics and Constraint Curves

```matlab
% Plot everything: torque-speed envelope, constraint curves, MTPA/MTPV loci
characteristics = mcb.PMSMCharacteristics(pmsm, inverter, ...
    driveCharacteristics=2, ...   % 0=none, 1=T-speed, 2=T-speed+P-speed
    constraintCurves=true, ...    % Voltage ellipse + current circle
    FWCMethod='vclmt');

% Output struct contains numerical data for programmatic use:
% characteristics.torque_speed, characteristics.power_speed, etc.
```

## Step 8: Voltage at Specific Operating Point

Verify voltage headroom at a target operating condition:

```matlab
% For linear motor (goLUT=0):
id_op = -5;  % d-axis current (A)
iq_op = 10;  % q-axis current (A)
we_op = 2000 * pi/30 * pmsm.p;  % Electrical speed (rad/s)

[vd, vq, vs] = mcb.calcPMSMVdVq(pmsm, [], id_op, iq_op, 0, we_op);
fprintf('Vd=%.1f V, Vq=%.1f V, |Vs|=%.1f V (Vmax=%.1f V)\n', ...
    vd, vq, vs, PU_System.V_base);

% For nonlinear motor with LUTs (goLUT=1):
% [vd, vq, vs] = mcb.calcPMSMVdVq(pmsm, ParamTableData, id_op, iq_op, 1, we_op);
```

## Step 9: ACIM Characterization

```matlab
acim = mcb.getACIMParameters;  % Template struct
% Fill in: acim.Rs, acim.Rr, acim.Ls, acim.Lr, acim.Lm, acim.p, etc.

mcb.ACIMCharacteristics(acim, inverter);
% Plots: slip-speed curves, breakdown torque, efficiency
```

## Summary: Key Outputs

| Output | API | Interpretation |
|---|---|---|
| Base speed | `mcb.getMotorBaseSpeed` | Below this: MTPA operates freely |
| Max speed | `mcb.PMSMMaxSpeed` | Maximum achievable with FW |
| Rated torque | `mcb.PMSMRatedTorque` | Max continuous torque at rated current |
| Constraint curves | `mcb.PMSMCharacteristics` | id-iq plane showing operational boundaries |
| Voltage headroom | `mcb.calcPMSMVdVq` | Whether specific operating point is feasible |

---

Copyright 2026 The MathWorks, Inc.
