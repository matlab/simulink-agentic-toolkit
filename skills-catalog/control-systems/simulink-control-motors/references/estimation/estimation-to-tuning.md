# From Estimated Parameters to FOC Gains

## Building the pmsm Struct

After estimation, assemble the motor parameter struct:

```matlab
pmsm.p = 4;                % Pole pairs (from datasheet — cannot estimate)
pmsm.Rs = Rs_estimated;    % From Rs Estimation block
pmsm.Ld = Ld_estimated;    % From Ld Lq Estimation block
pmsm.Lq = Lq_estimated;    % From Ld Lq Estimation block
pmsm.FluxPM = FluxPM_estimated;  % From back-EMF test
pmsm.I_rated = I_rated;    % From datasheet (nameplate current)
pmsm.J = J_estimated;      % From Mechanical Parameter Estimation
pmsm.B = B_estimated;      % From Mechanical Parameter Estimation
```

## Computing FOC Gains

### Using mcb.calcFOCGains (Recommended)

```matlab
Ts = 5e-5;           % Control sample time (match PWM period)
Ts_speed = 10 * Ts;  % Speed loop sample time (10x decimation)

% Standard gains:
PI_params = mcb.calcFOCGains(pmsm, Ts, Ts_speed);

% Output struct contains:
%   PI_params.Kp_id   — d-axis current proportional
%   PI_params.Ki_id   — d-axis current integral
%   PI_params.Kp_i    — q-axis current proportional
%   PI_params.Ki_i    — q-axis current integral
%   PI_params.Kp_speed — speed proportional
%   PI_params.Ki_speed — speed integral
```

### Derating for Specific Applications

| Application | Derating | Why |
|---|---|---|
| Sensorless (SMO/HFI) | `'SpdLoopFactor', 0.3` | Observer adds delay |
| Nonlinear/saturating motor | `'DCurrLoopFactor', 0.5, 'QCurrLoopFactor', 0.5` | LUT uncertainty |
| Low-Rs motor (< 0.01 Ω) | `'SpdLoopFactor', 0.1` | Speed gains too aggressive |
| High-inertia (J > 0.1) | No derating needed | Standard formula works |

### Verification

```matlab
% Frequency-domain analysis (Bode plots, phase margin):
PU_System = mcb.getPUSystemParameters(pmsm, inverter);
mcb.getMotorControlAnalysis(pmsm, inverter, PU_System, PI_params, Ts, Ts_speed);

% Check: current loop phase margin > 45°, speed loop phase margin > 30°
```

## Motor Characterization (After Estimation)

With estimated parameters, compute operating envelope:

```matlab
inverter.V_dc = 400;  % Bus voltage
inverter.ISenseMax = 2 * pmsm.I_rated;

% Base speed (voltage limit starts):
base_speed = mcb.getMotorBaseSpeed(pmsm, inverter, 'actual');

% Maximum speed:
max_speed = mcb.PMSMMaxSpeed(pmsm, inverter, FWCMethod='vclmt');

% Rated torque + milestone currents:
[T_rated, speeds, id, iq] = mcb.PMSMRatedTorque(pmsm, inverter);

% Full drive characteristics + constraint curves:
chars = mcb.PMSMCharacteristics(pmsm, inverter, driveCharacteristics=2);
```

## Common Issues After Estimation

| Symptom | Likely Cause | Fix |
|---|---|---|
| Current oscillation at all speeds | Ld/Lq overestimated | Re-estimate at higher current |
| Speed oscillation (bang-bang) | Kp_speed too high | Use `'SpdLoopFactor', 0.3` |
| Slow current response | Ld/Lq underestimated | Re-estimate with lower injection freq |
| Motor doesn't reach rated speed | FluxPM overestimated | Verify with back-EMF test |
| Torque lower than expected | FluxPM underestimated or wrong p | Cross-check with T = 1.5·p·FluxPM·Iq |

## Estimation → Model Workspace Assignment

```matlab
% Store in model workspace (not base workspace):
hws = get_param(mdl, 'ModelWorkspace');
hws.assignin('pmsm', pmsm);
hws.assignin('inverter', inverter);
hws.assignin('PI_params', PI_params);
hws.assignin('Ts', Ts);
hws.assignin('Ts_speed', Ts_speed);
hws.assignin('Vmax', PU_System.V_base);
```

---

Copyright 2026 The MathWorks, Inc.
