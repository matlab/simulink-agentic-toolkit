# Parameter Computation Reference

> How to compute all numerical parameters for motor control models.
> Covers PI gains, PU system, filter coefficients, sample times, and limits.

---

## PI Gain Computation

### Preferred Method: `mcb.calcFOCGains`

```matlab
% Syntax (requires 3 positional arguments)
[PI_Params, OLTF, CLTF] = mcb.calcFOCGains(motor, Ts, Ts_speed);
[PI_Params, OLTF, CLTF] = mcb.calcFOCGains(motor, Ts, Ts_speed, Name=Value);

% Example
motor.Rs = 0.5;       % Stator resistance (Ohm)
motor.Ld = 0.002;     % d-axis inductance (H)
motor.Lq = 0.004;     % q-axis inductance (H)
motor.FluxPM = 0.1;   % PM flux linkage (Wb)
motor.p = 4;          % Pole pairs
motor.J = 0.001;      % Inertia (kg*m^2)
motor.B = 0.0001;     % Viscous damping (Nm/(rad/s))
motor.I_rated = 10;   % Rated current (A)
motor.N_rated = 3000; % Rated speed (RPM)
motor.N_base = 3000;  % Base speed (RPM) — required field

Ts = 50e-6;           % Current loop sample time (s)
Ts_speed = 500e-6;    % Speed loop sample time (s)

% RECOMMENDED: Always use SpdLoopFactor to tame speed gains
PI_params = mcb.calcFOCGains(motor, Ts, Ts_speed, 'SpdLoopFactor', 0.05);

% Without SpdLoopFactor (raw gains — often too aggressive for speed loop):
% PI_params = mcb.calcFOCGains(motor, Ts, Ts_speed);
% Returns struct with fields:
%   .Kp_i, .Ki_i       — q-axis current PI (NOTE: NOT Kp_iq!)
%   .Kp_id, .Ki_id     — d-axis current PI
%   .Kp_speed, .Ki_speed — speed PI
%   .Ti_i, .Ti_id, .Ti_speed — time constants

% CRITICAL: Ki values are RAW (1/s). MCB PI blocks expect Ki*Ts!
%   Ki_for_block = PI_params.Ki_id * Ts;   % d-axis
%   Ki_for_block = PI_params.Ki_i  * Ts;   % q-axis (field is .Ki_i, NOT .Ki_iq)

% Name-Value options:
%   'DCurrLoopFactor', 0.5   — reduce d-axis gains (default 1)
%   'QCurrLoopFactor', 0.5   — reduce q-axis gains (default 1)
%   'SpdLoopFactor', 0.5     — reduce speed gains (default 1)
%   'SpdLPFltCoeff', alpha   — speed filter coefficient (default 1)
```


### Default SpdLoopFactor Recommendation

**ALWAYS use `'SpdLoopFactor', 0.05`** (or at most 0.1) as a starting point. The raw speed gains from `mcb.calcFOCGains` are computed from plant pole-zero cancellation and are almost always too aggressive for simulation without load/friction modeling. This is the #1 cause of speed oscillation in agent-built models.

```matlab
% Standard call (recommended for ALL motors):
PI_params = mcb.calcFOCGains(motor, Ts, Ts_speed, 'SpdLoopFactor', 0.05);

% Only increase SpdLoopFactor after verifying stability:
% 0.05 = conservative (start here)
% 0.1  = moderate (after first sim looks stable)
% 0.5  = aggressive (only for high-friction/high-inertia systems)
% 1.0  = raw (almost never appropriate for simulation)
```

### Cautions

- `mcb.calcFOCGains` can give aggressive speed gains for low-Rs, low-J motors
- For IPMSM with p=6, Rs<0.01, J<0.2: cap Kp_speed ≤ 2.0 to avoid oscillation
- For nonlinear plants (ACIM, FEM): use 50% of computed bandwidth (multiply gains by 0.5)
- Always verify with a short simulation before long runs

### Speed Loop Tuning by Motor Class

**Classify by `kt/J` ratio** (torque responsiveness in rad/s²/A):
```matlab
kt = 1.5 * pmsm.p * pmsm.FluxPM;   % Torque constant (Nm/A)
responsiveness = kt / pmsm.J;        % rad/s² per amp — determines tuning category
```

| Category | kt/J (rad/s²/A) | Examples | Primary Risk |
|---|---|---|---|
| **A** (ultra-responsive) | > 10,000 | Small hobby PMSM (J~7e-6), tiny actuators | Voltage-limited max speed |
| **B** (fast/drone-class) | 1,000–10,000 | Drone outrunners (L~5µH, p>6), small robot joints | Speed measurement noise |
| **C** (industrial) | 10–1,000 | Servo drives, EV motors (J~1e-3 to 0.1) | None (standard tuning works) |
| **D** (high-inertia) | < 10 | Ship propulsion, wind turbine, rolling mill (J>1) | calcFOCGains under-actuates |

**Recommended settings by category:**

| Parameter | Cat A (kt/J>10k) | Cat B (1k–10k) | Cat C (10–1k) | Cat D (<10) |
|---|---|---|---|---|
| SpdLoopFactor | 0.02–0.05 | 0.01–0.05 | 0.05 (default) | N/A (manual) |
| iq_sat (no-load sim) | 5% I_rated | 5% I_rated | 50% I_rated | I_rated |
| IIR cutoff (Hz) | 15–30 | 3–10 | 50 (default) | 10–50 |
| Speed BW target (Hz) | 5–10 | 0.5–2 | 5–20 | 0.1–2 |
| Gain method | calcFOCGains | Manual BW-based | calcFOCGains | Manual symmetric |
| Speed ref check | CRITICAL | Important | Usually OK | Always OK |
| Current Kp magnitude | Normal | TINY (correct!) | Normal | Normal |

**How to use this table:**
```matlab
kt = 1.5 * pmsm.p * pmsm.FluxPM;
ratio = kt / pmsm.J;
if ratio > 10000      % Category A — DO NOT trust calcFOCGains for speed loop
    % calcFOCGains Ki_speed is ALWAYS too aggressive (causes windup + oscillation)
    % Use manual values directly:
    Kp_speed = 0.0004;        % Keep proportional from calcFOCGains (or similar)
    Ki_speed = 0.005;         % OVERRIDE — 30-100x lower than calcFOCGains output
    iq_sat_rpm_per_step = 5;  % Target 5 RPM/step (NOT 15 — integral winds up)
    iq_sat = iq_sat_rpm_per_step / (kt / pmsm.J * Ts_speed * 60/(2*pi));
    iq_sat = max(iq_sat, 0.01 * pmsm.I_rated);
    IIR_fc = 20;
    use_calcFOCGains_for_speed = false;  % Flag: skip calcFOCGains speed gains
elseif ratio > 1000   % Category B
    SpdLoopFactor = 0.01;
    iq_sat = 0.05 * pmsm.I_rated;
    IIR_fc = 5;
elseif ratio > 10     % Category C (standard)
    SpdLoopFactor = 0.05;
    iq_sat = 0.5 * pmsm.I_rated;
    IIR_fc = 50;
else                  % Category D (manual tuning)
    % Do NOT use calcFOCGains for speed loop
    BW_target = 2*pi*0.5;  % 0.5 Hz typical
    Kp_speed = 2 * pmsm.J * BW_target;
    Ki_speed = pmsm.J * BW_target^2;
    iq_sat = pmsm.I_rated;
    IIR_fc = 20;
end
```

**CRITICAL — Category A trap:** `calcFOCGains` with `SpdLoopFactor=0.02` gives Ki_speed ~0.18 for small motors (J~7e-6). This appears stable in the first simulation ONLY because the voltage limit prevents overshoot when speed_ref ≈ max_speed. When speed_ref has headroom (e.g., 500 of 681 RPM max), the integral winds up during acceleration and the motor oscillates violently. **Always use manual Ki_speed=0.005 for Category A.**

`mcb.calcFOCGains` with `SpdLoopFactor=0.05` produces ~7 Hz speed BW regardless of motor size (it normalizes internally). The gains themselves are rarely the root cause of oscillation. Instead, instability comes from **system-level mismatches**:

| Root Cause | Symptom | Fix |
|---|---|---|
| Speed ref exceeds voltage-limited max | PI saturates → limit cycle | `speed_ref < 0.9 * Vmax/(FluxPM*p)*9.55` |
| iq saturation too high for no-load | Massive acceleration → overshoot | Limit iq_sat per category table above |
| IIR cutoff >> speed BW | Noise triggers PI → oscillation | Set IIR = 2×–5× speed BW |
| calcFOCGains derating for large J | Sluggish, never reaches setpoint | Manual symmetric-optimum tuning |
| Cat A: Ki_speed from calcFOCGains (any SpdLoopFactor) | Overshoot + slow settling or oscillation | Manual Ki_speed=0.005, iq_sat at 5 RPM/step |
| Voltage-limit masking | First sim "looks OK" near max speed, breaks at lower refs | Always test at 70% of max_speed_rpm |


### iq_sat Sizing Formula

**Objective:** Limit acceleration so the motor doesn't overshoot wildly before PI can react.

```matlab
% Target RPM/step depends on motor category:
%   Category A (kt/J > 10000): target = 5 RPM/step (integral windup risk)
%   Category B (kt/J 1000-10000): target = 5 RPM/step
%   Category C (kt/J 10-1000): target = 15 RPM/step (standard)
%   Category D (kt/J < 10): target = 15-20 RPM/step
kt = 1.5 * pmsm.p * pmsm.FluxPM;
ratio = kt / pmsm.J;
if ratio > 1000,  target_rpm_per_step = 5;   % Cat A/B: aggressive motors
else,             target_rpm_per_step = 15;  % Cat C/D: standard
end

kt = 1.5 * pmsm.p * pmsm.FluxPM;
iq_sat = target_rpm_per_step / (kt / pmsm.J * Ts_speed * 60/(2*pi));

% Clamp to physical limits
iq_sat = min(iq_sat, pmsm.I_rated);
iq_sat = max(iq_sat, 0.01 * pmsm.I_rated);  % Never zero

% Verify
rpm_per_step = iq_sat * kt / pmsm.J * Ts_speed * 60/(2*pi);
fprintf('iq_sat = %.3f A (%.0f%% of I_rated), %.1f RPM/step\n', ...
    iq_sat, iq_sat/pmsm.I_rated*100, rpm_per_step);
```

**Quick reference by category:**
| Category | kt/J | iq_sat rule | Typical value |
|----------|------|-------------|---------------|
| A (>10k) | 5000+ | 5% I_rated | 0.05-0.5 A |
| B (1k-10k) | 1000-10000 | 5-10% I_rated | 0.1-1.0 A |
| C (10-1k) | 10-1000 | 50% I_rated | 1-10 A |
| D (<10) | <10 | 100% I_rated | Full rated |

**Common mistake:** Setting iq_sat = I_rated for a Cat A/B motor → 50-100 RPM/step → guaranteed oscillation. Always compute rpm_per_step first.

**Voltage headroom at overshoot speed (CRITICAL for Cat A):**
```matlab
% Speed overshoot can reach 2× reference during transients.
% If back-EMF at overshoot speed ≥ Vmax, current PI saturates → can't brake → limit cycle
overshoot_speed = 2 * speed_ref_rad;  % assume 100% overshoot worst case
backEMF_at_overshoot = pmsm.FluxPM * pmsm.p * overshoot_speed;
assert(backEMF_at_overshoot < 0.85 * Vmax, ...
    'Speed ref too high! Back-EMF at overshoot (%.1fV) exceeds 85%% of Vmax (%.1fV). Reduce speed_ref.', ...
    backEMF_at_overshoot, Vmax);
% Rule of thumb: speed_ref < 0.45 * max_speed for Cat A motors (allows 100% overshoot)
```

**Integral windup mitigation for Cat A (verified empirically):**
```matlab
% mcb.calcFOCGains Ki_speed causes integral windup in low-J no-load sims.
% The integral accumulates during ramp-up faster than the motor can respond.
% Fix: OVERRIDE Ki_speed directly (do NOT use calcFOCGains value):
Ki_speed = 0.005;  % Validated: 15% overshoot, 630ms settling, 0.01 RPM error
% NOTE: calcFOCGains with SpdLoopFactor=0.05 gives Ki_speed ≈ 0.000453 (raw)
% which causes persistent steady-state error (13 RPM after 1s) due to
% insufficient integral action: integral += Ki*Ts_speed*error = 2.3e-7 * error/step
% With Ki=0.005: integral += 2.5e-6 * error/step → reaches setpoint in <1s
```

**Validated Cat A parameters (J~7e-6, Teknic2310P, Vdc=24V):**
```matlab
Kp_speed = 0.000905;    % From calcFOCGains with SpdLoopFactor=0.05
Ki_speed = 0.005;       % OVERRIDE (not from calcFOCGains — too conservative)
iq_sat   = 0.1;         % 1.4% of I_rated (limits RPM/step to 9.2)
speed_ref = 500;        % RPM — 34% of max (1464 RPM), allows 100% overshoot
IIR_fc   = 20;          % Hz (IIR_coeff = 2*pi*20*Ts/(1+2*pi*20*Ts) ≈ 0.006)
% Results: 15% overshoot, 110ms rise, 630ms settling, 0.01 RPM SS error
```

#### Low-Inertia Motors (J < 1e-4 kg·m²)

Motors with very small inertia (e.g., J=7e-6 for small PMSM) are extremely responsive. The key issue is NOT gain magnitude (SpdLoopFactor=0.05 gives correct 7 Hz BW) but rather:
- At I_rated, acceleration can exceed 100,000 rad/s² (651 RPM per 500 µs step!)
- Back-EMF-limited max speed is often LOW (e.g., 1464 RPM for 24V bus)
- Without load torque, the motor accelerates to voltage limit almost instantly
- Speed reference above max_speed causes permanent PI saturation → limit cycle


**Typical safe values for J~7e-6:** Kp_speed=0.000905, Ki_speed=0.005, iq_sat=0.1A, IIR_fc=20 Hz, speed_ref≤500 RPM

Use `'SpdLoopFactor'` to reduce computed gains:
```matlab
PI_params = mcb.calcFOCGains(motor, Ts, Ts_speed, 'SpdLoopFactor', 0.01);
```

#### Low-Inductance Motors (L < 20 µH)

Drone/high-KV motors with extreme low inductance. Current loop Kp will be TINY (e.g., 0.01 for L=5 µH) — **this is mathematically correct, not an error**.

```matlab
% Current loop: Kp = L * BW, Ki = Rs * BW  (standard formula)
% For L=5e-6, BW=2000: Kp=0.01, Ki=40  → Ki/Kp = Rs/L = 4000 (resistive-dominant)
% Do NOT halve or apply safety factors — destroys current response!

% Speed loop: noise-limited, NOT gain-limited
BW_speed_Hz = 0.8;  % Very conservative due to speed measurement noise
IIR_fc = 3;         % Heavy filtering required
Kp_speed = pmsm.J * (2*pi*BW_speed_Hz) / kt;
Ki_speed = Kp_speed * 1.0;  % Minimal integral action
```

#### High-Inertia Motors (J > 1 kg·m²)

`mcb.calcFOCGains` applies an internal derating (~22×) for large J values, making speed gains too conservative. Check this behaviour.



### Observer-Aware Gain Tuning

When using sensorless (SMO/EEMF), reduce current loop BW to account for observer delay:
```matlab
% Observer adds ~1-2 sample delays to angle estimate
% Reduce BW by 30% when observer is in the loop
BW_id_sensorless = BW_id * 0.7;
Kp_id_sensorless = BW_id_sensorless * motor.Ld;
```
Use `SpdLoopFactor` and `QCurrLoopFactor` to reduce gains:
```matlab
PI_params = mcb.calcFOCGains(motor, Ts, Ts_speed, ...
    'QCurrLoopFactor', 0.7, 'SpdLoopFactor', 0.7);
```

**PositionObserver parameter (R2026a+)** — must be a **struct**, NOT a string:
```matlab
% Flux Observer compensation:
obs.Type = 'FO';
obs.Parameters.CutOffFrq = 200;  % Hz
PI = mcb.calcFOCGains(motor, Ts, Ts_speed, 'PositionObserver', obs);

% Extended EMF:
obs.Type = 'EEMF';
obs.Parameters.CutOffFrq = 300;

% Pulsating HF (no CutOffFrq needed):
obs.Type = 'PHF';

% WRONG — string does NOT work:
% mcb.calcFOCGains(motor, Ts, Ts_speed, 'PositionObserver', 'FO')  % ERROR!
```

### Legacy Method (avoid if possible)

```matlab
% mcb.getPIControllerParameters — can give wildly wrong speed gains
% Only use if mcb.calcFOCGains is unavailable (pre-R2024b)
[Kp, Ki] = mcb.getPIControllerParameters(motor, Ts, 'speed');
```

---

## Per-Unit (PU) System

### Preferred: `mcb.getPUSystemParameters`

```matlab
% Official API (returns V_base, I_base, N_base, P_base, T_base)
motor = mcb.getPMSMParameters('Teknic2310P');
inverter = mcb.getInverterParameters('BoostXL-DRV8305');
PU_System = mcb.getPUSystemParameters(motor, inverter);
```

**CRITICAL — Required `inverter` fields:**
- `inverter.V_dc` — DC bus voltage (V)
- `inverter.ISenseMax` — Maximum current sense range (A). Set to `2 * pmsm.I_rated` if building a custom inverter struct. Omitting this field causes `"Unrecognized field name ISenseMax"` error.

When using a custom inverter struct (not from `mcb.getInverterParameters`), always include:
```matlab
inverter.V_dc = 24;                      % DC bus voltage
inverter.ISenseMax = 2 * pmsm.I_rated;   % Current sense max (required by getPUSystemParameters)
```

### Manual Computation (when using custom motor struct)

```matlab
% From motor nameplate data
PU_System.I_base = motor.I_rated * sqrt(2);          % Peak current (A)
PU_System.V_base = inv.V_dc / sqrt(3);               % Phase voltage (V)
PU_System.N_base = motor.N_rated;                     % Base speed (RPM)
PU_System.w_base = motor.N_rated * 2*pi / 60;        % Base speed (rad/s)
PU_System.T_base = 1.5 * motor.p * motor.FluxPM * PU_System.I_base; % Base torque (Nm)
PU_System.P_base = PU_System.T_base * PU_System.w_base; % Base power (W)
PU_System.Z_base = PU_System.V_base / PU_System.I_base; % Base impedance (Ohm)
PU_System.L_base = PU_System.Z_base / PU_System.w_base; % Base inductance (H)
PU_System.Flux_base = PU_System.V_base / PU_System.w_base; % Base flux (Wb)
```

### Converting Gains to PU

```matlab
% Current PI in PU
Kp_id_pu = Kp_id / PU_System.Z_base;
Ki_id_pu = Ki_id * Ts / PU_System.Z_base;  % Already multiplied by Ts for UseKiTs

% Speed PI in PU
Kp_speed_pu = Kp_speed * PU_System.w_base / PU_System.T_base;
Ki_speed_pu = Ki_speed * Ts_speed * PU_System.w_base / PU_System.T_base;
```

---

## SMO Parameter Computation

```matlab
% mcb.computeSMOParameters(pmsm, Ts, PU_System)
% Requires: pmsm.Rs, pmsm.Lq, pmsm.p, pmsm.N_base
%           PU_System.N_base, PU_System.V_base
%
% CRITICAL: mcb.getPMSMParameters does NOT return N_base!
% You MUST add it manually before calling computeSMOParameters:
pmsm.N_base = pmsm.N_max;  % or pmsm.N_rated if available
% Without this: "Unrecognized field name N_base" error

smo = mcb.computeSMOParameters(pmsm, Ts, PU_System);
% Returns struct with:
%   .BackEmfObsGain  = 0.9 (fixed)
%   .CurrentObsGain  = computed from motor params
%   .CutoffFreq      = 3 * pmsm.N_base * pmsm.p / 60 (Hz)
```


---

## IIR Filter Coefficient

### Low-Pass Filter (Speed Feedback)

```matlab
fc = 50;                          % Cutoff frequency (Hz) — typical for speed
IIR_coeff = 2*pi*fc*Ts / (1 + 2*pi*fc*Ts);
```

| Application | fc (Hz) | Rationale |
|------------|---------|-----------|
| Speed feedback | 50 | Reject PWM noise, preserve dynamics |
| Torque feedback | 100 | Faster response needed |
| Position feedback | 200 | Minimal delay for servo |
| Vibration suppression | 20 | Aggressive noise rejection |

### Formula Derivation
First-order IIR: `y[n] = (1-α)*y[n-1] + α*x[n]` where `α = IIR_coeff`

---

## Sample Time Selection

### Ratios
```matlab
Ts = 1 / (2 * f_pwm);            % Current loop = half PWM period
Ts_speed = 10 * Ts;              % Speed loop = 10× slower
Ts_position = 5 * Ts_speed;      % Position loop = 5× slower than speed
```

### Typical Values
| Application | f_pwm | Ts | Ts_speed |
|-------------|-------|-----|----------|
| Industrial servo | 10 kHz | 50 μs | 500 μs |
| EV traction | 8 kHz | 62.5 μs | 625 μs |
| High-speed (>50k RPM) | 20 kHz | 25 μs | 250 μs |
| Low-cost BLDC | 20 kHz | 25 μs | 500 μs |
| ACIM V/f | 5 kHz | 100 μs | 1 ms |

---

## Voltage and Current Limits

### Voltage
```matlab
Vmax = inv.V_dc / sqrt(3);       % Maximum phase voltage (linear region)
Vmax_95 = 0.95 * Vmax;           % With 5% headroom (recommended)
```

### Current
```matlab
I_max = motor.I_rated * sqrt(2); % Peak current limit
% For PI saturation:
PI_d_upper = Vmax;               % d-axis voltage limit
PI_d_lower = -Vmax;
PI_q_upper = Vmax;               % q-axis voltage limit
PI_q_lower = -Vmax;
Speed_PI_upper = motor.T_rated;  % Torque limit (Nm)
Speed_PI_lower = -motor.T_rated; % Regeneration limit
```

---

> For ACIM parameters, LUT data, motor struct conventions, and simulation setup see `parameter-computation-motors.md`.

----
Copyright 2026 The MathWorks, Inc.
----
