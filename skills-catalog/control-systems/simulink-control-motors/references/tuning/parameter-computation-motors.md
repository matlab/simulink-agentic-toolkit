# Parameter Computation — Motor Types & Data

> ACIM-specific parameters, LUT generation, motor struct conventions, power classes, and simulation setup.
> For PI gains, PU system, IIR, and sample times see `parameter-computation.md`.

---

## ACIM-Specific Parameters

### Slip Calculation
```matlab
% Rotor time constant
Tr = motor.Lr / motor.Rr;        % Rotor time constant (s)

% Leakage factor
sigma = 1 - motor.Lm^2 / (motor.Ls * motor.Lr);

% Rated flux current (constant)
id_rated = motor.I_rated / sqrt(2);

% Slip frequency — CRITICAL: use id_ref (constant), NOT id_meas!
% Using id_meas causes divide-by-zero at startup (id≈0)
we_slip = iq_meas / (Tr * id_rated);  % Slip electrical frequency (rad/s)

% Synchronous angle (indirect RFOC — sensorless by design)
theta_e = integral(motor.p * wm + we_slip); % Integrated, wrapped [0, 2π]
```

### ACIM PI Tuning
```matlab
% Current loop BW
BW_i = 1 / (4 * Ts);  % Quarter of switching frequency

% CRITICAL: Use TRANSIENT inductance (sigma*Ls), NOT full Ls
% Using Ls gives ~5x too much gain → current oscillation
L_sigma = sigma * motor.Ls;

% Same for q-axis (symmetric in ACIM)
Kp_i = Kp_id;   % q-axis = d-axis for ACIM (symmetric)
Ki_i = Ki_id;

% Speed loop — use ACIM torque constant (NOT PMSM formula)
kt_acim = 1.5 * motor.p * motor.Lm^2 / motor.Lr * id_rated;


% iq saturation for ACIM (same principle as PMSM)
rpm_per_step = @(iq) iq * kt_acim / motor.J * Ts_speed * 9.55;
iq_sat = min(motor.I_rated, 10 / (kt_acim / motor.J * Ts_speed * 9.55));
```

### ACIM Voltage-Limited Maximum Speed
```matlab
% Back-EMF in ACIM = Lm * id_ref * we (electrical speed)
% At voltage limit: Vmax = Lm * id_ref * p * wm_max
Vmax = inverter.V_dc / sqrt(3);
id_ref = motor.I_rated / sqrt(2);  % Rated magnetizing current


% If max_speed is too low, options:
%   1. Reduce id_ref (field weakening) — reduces torque capability
%   2. Increase Vdc
%   3. Accept lower speed target
```

---

## LUT Control Reference Data

### Generating MTPA/FW/MTPV Lookup Tables
```matlab
% Using mcb.generateMotorLUT
PMSMLUT = mcb.generateMotorLUT(motor, 'idiqluts', ...
    'NmGrid', linspace(-T_max, T_max, 21), ...
    'wrpmVec', linspace(0, N_max, 15));

% Result fields:
%   PMSMLUT.idTable  — [nTorque × nSpeed] id reference
%   PMSMLUT.iqTable  — [nTorque × nSpeed] iq reference
%   PMSMLUT.NmGrid   — torque breakpoints (Nm)
%   PMSMLUT.wrpmVec  — speed breakpoints (RPM)
```

### Critical: Symmetric Torque Grid
```matlab
% NmGrid MUST be symmetric for bidirectional operation
NmGrid_pos = linspace(0, T_max, 11);
NmGrid = [-fliplr(NmGrid_pos(2:end)), NmGrid_pos]; % 21 points, centered at 0
```

---

## Motor Parameter Struct Convention

### MCB Database Struct (from `mcb.getPMSMParameters`)
```matlab
pmsm.Rs = 0.36;          % Stator resistance (Ohm)
pmsm.Ld = 0.0002;        % d-axis inductance (H)
pmsm.Lq = 0.0002;        % q-axis inductance (H)
pmsm.FluxPM = 0.0064;    % PM flux linkage (Wb)
pmsm.p = 4;              % Number of pole pairs
pmsm.J = 7.06e-6;        % Rotor inertia (kg*m^2)
pmsm.B = 2.64e-6;        % Viscous friction (Nm/(rad/s))
pmsm.I_rated = 7.1;      % Rated RMS current (A)
pmsm.N_max = 6000;       % Maximum speed (RPM) — NOTE: N_max, NOT N_rated
pmsm.T_rated = 0.272;    % Rated torque (Nm)
pmsm.Ke = 4.64;          % Back-EMF constant (V/krpm)
pmsm.Kt = 0.0384;        % Torque constant (Nm/A)
```

**CRITICAL:** MCB database uses `N_max` (not `N_rated`). For `mcb.calcFOCGains` which needs `N_base`:
```matlab
% Compute base speed (MTPA/FW boundary)
N_base = mcb.getMotorBaseSpeed(pmsm, inverter);  % RPM
pmsm.N_base = N_base;  % Add manually for PI tuning
```

### Custom Motor Struct (user-defined)
```matlab
motor.Rs = 0.5;          % Stator resistance (Ohm)
motor.Ld = 0.002;        % d-axis inductance (H)
motor.Lq = 0.004;        % q-axis inductance (H)
motor.FluxPM = 0.1;      % PM flux linkage (Wb)
motor.p = 4;             % Number of pole pairs
motor.J = 0.001;         % Rotor inertia (kg*m^2)
motor.B = 0.0001;        % Viscous friction (Nm/(rad/s))
motor.I_rated = 10;      % Rated RMS current (A)
motor.N_rated = 3000;    % Rated speed (RPM)
motor.T_rated = 5;       % Rated torque (Nm)
motor.V_rated = 300;     % Rated voltage (V, line-line RMS)
motor.N_base = 3000;     % Base speed for PI tuning (RPM)

% Inverter
inv.V_dc = 400;          % DC bus voltage (V)
inv.f_pwm = 10000;       % PWM frequency (Hz)
inv.deadtime = 1e-6;     % Dead time (s)
```

### Power Class Typical Ranges
| Class | Power | Rs (Ω) | Ld (mH) | FluxPM (Wb) | p | J (kg·m²) | Ts |
|-------|-------|---------|----------|-------------|---|-----------|------|
| Micro | <100 W | 0.5–20 | 0.1–5 | 0.001–0.02 | 2–7 | 1e-6–1e-4 | 25–50 μs |
| Low | 100 W–1 kW | 0.1–5 | 0.1–2 | 0.005–0.05 | 2–5 | 1e-5–1e-3 | 50 μs |
| Medium | 1–10 kW | 0.01–1 | 0.5–10 | 0.02–0.2 | 3–6 | 1e-4–0.01 | 50–100 μs |
| High | >10 kW | 0.001–0.1 | 1–50 | 0.1–1.0 | 3–8 | 0.01–1.0 | 62.5–100 μs |

**Tuning implications by power class:**
- **Micro/Low:** Rs dominates → PI tuning straightforward, board resistance negligible
- **Medium:** Board resistance (R_board ≈ 0.05–0.2 Ω) significant vs motor Rs → include in tuning
- **High:** Very low Rs → Ki extremely sensitive to Rs estimate; add `R_board` to `pmsm.Rs` before calling `mcb.calcFOCGains`

### Board Resistance Compensation
```matlab
% For medium/high-power motors, include board + MOSFET on-resistance
R_board = 0.1;  % Measure or estimate (wiring + Rds_on + sense resistor)
pmsm_tuning = pmsm;
pmsm_tuning.Rs = pmsm.Rs + R_board;
PI_params = mcb.calcFOCGains(pmsm_tuning, Ts, Ts_speed);
% Effect: Ki increases by ~Rs_eff/Rs_orig ratio (Kp unchanged)
```

---

## SynRM-Specific Parameters

### FluxPM Must Be Non-Zero
```matlab
% MCB PMSM block requires FluxPM > 0, even for SynRM (reluctance-only motor)
pmsm.FluxPM = 1e-6;  % Set to near-zero, NOT exactly 0
% Setting to 0 causes division-by-zero in mcb.calcFOCGains and MTPA block
```


---

## Simulation Parameters

```matlab
sim_time = 4;            % Total simulation time (s)
Ts = 50e-6;              % Fundamental sample time
Ts_speed = 10 * Ts;      % Speed loop sample time

% Typical load profile (Step)
TL_initial = 0;          % Starting load (Nm)
TL_step = 5;             % Step load at t_step
t_step = 2;              % Step time (s)

% Speed profile
speed_ref = 1500;        % Target speed (RPM or rad/s depending on units)
```

----
Copyright 2026 The MathWorks, Inc.
----
