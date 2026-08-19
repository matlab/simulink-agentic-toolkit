# Gain Formulas for Motor Control

> **IMPORTANT:** Always use MCB APIs as the primary approach for gain computation.
> Manual formulas below are FALLBACK ONLY — use when the API is unavailable, deprecated, or
> when the motor type is not supported by the API (e.g., SynRM speed loop).

---

## Primary Approach: MCB APIs

### `mcb.calcFOCGains` (Preferred for ALL supported motors)

```matlab
% Standard usage — covers PMSM, IPMSM, SPMSM, BLDC:
PI_params = mcb.calcFOCGains(pmsm, Ts, Ts_speed);
% Output fields: Kp_id, Ki_id, Kp_i, Ki_i, Kp_speed, Ki_speed

% With speed loop derating (for sensorless or nonlinear):
PI_params = mcb.calcFOCGains(pmsm, Ts, Ts_speed, 'SpdLoopFactor', 0.3);

% With loop delay compensation:
PI_params = mcb.calcFOCGains(pmsm, Ts, Ts_speed, ...
    'CLForwardPathDelay', struct('nTs', 1.5), ...
    'CLFeedbackPathDelay', struct('nTs', 1));
```

**Covers:** Current loop (d and q axes) + speed loop gains.
**Convention:** MCB PI blocks use `Ki*Ts` (UseKiTs='on'). Multiply: `KiTs = Ki * Ts`.

### `mcb.computeSMOParameters` (Sensorless observer gains)

```matlab
smo = mcb.computeSMOParameters(pmsm, Ts, PU_System);
% Key outputs: smo.BackEmfObsGain, smo.CurrentObsGain
```

### Operating-Point Linearization (Nonlinear motors)

```matlab
% Get scalar Ld/Lq/FluxPM at operating point, then use calcFOCGains:
pmsm_op = mcb.updatePMSMLdLqFluxPM(pmsm, pmsm.PMSMLUT, id_op, iq_op, 1);
PI_params = mcb.calcFOCGains(pmsm_op, Ts, Ts_speed);
```

---

## When APIs Don't Apply (Fallback Manual Formulas)

### SynRM Speed Loop (API gives Inf because FluxPM=0)

```matlab
% mcb.calcFOCGains divides by FluxPM for speed loop — fails for SynRM
% Compute manually:
Kt_synrm = 1.5 * pmsm.p * (pmsm.Ld - pmsm.Lq) * pmsm.I_rated / sqrt(2);
BW_speed = 1 / (40 * Ts);  % Conservative
Kp_speed = pmsm.J * BW_speed / Kt_synrm;
Ki_speed = Kp_speed * BW_speed / 5;
% NOTE: Current loop gains (Kp_id, Ki_id, Kp_i, Ki_i) from calcFOCGains ARE valid for SynRM
```

### Gain Scheduling LUTs (Nonlinear motors — incremental inductance)

```matlab
% Incremental inductance from flux tables:
Ld_inc(i,j) = gradient(FluxD(:,j), idVec);  % dFluxD/did
Lq_inc(i,j) = gradient(FluxQ(i,:), iqVec);  % dFluxQ/diq

% PI gains at each operating point:
BW_i = 1 / (4 * Ts);
Kp_d_LUT = Ld_inc * BW_i;
Kp_q_LUT = Lq_inc * BW_i;
KiTs_d_LUT = Rs * BW_i * Ts * ones(size(Ld_inc));
KiTs_q_LUT = Rs * BW_i * Ts * ones(size(Lq_inc));
```

### ACIM Current Loop (when calcFOCGains not available for ACIM)

```matlab
sigma = 1 - Lm^2 / (Ls * Lr);       % Leakage factor
L_sigma = sigma * Ls;                 % Transient inductance (plant seen by PI)
BW_i = 1 / (4 * Ts);
Kp_i = L_sigma * BW_i;               % Both d and q axes
Ki_i = (Rs + Rr*Lm^2/Lr^2) * BW_i;  % Effective resistance
```

### BLDC Six-Step Speed PI (Duty output, no calcFOCGains)

```matlab
duty_per_radps = pmsm.FluxPM * pmsm.p / inverter.V_dc;  % Steady-state sensitivity
Kp_speed = 2 * duty_per_radps;
Ki_speed = Kp_speed * 10;  % ~100 ms time constant
% Saturation: [0.05, 0.95] duty cycle limits
```

---

## Supporting Parameters (Used with any approach)

### IIR Low-Pass Filter Coefficient

```matlab
alpha = 2*pi*fc*Ts / (1 + 2*pi*fc*Ts);  % fc = cutoff frequency
% Typical: fc=20-50 Hz for speed, fc=50-200 Hz for position
```

### SMO CutoffFreq Selection

```matlab
CutoffFreq = max(500, N_max * pmsm.p / 60 * 2 * 1.5);  % Must exceed 2x max elec freq
```

### Voltage Headroom Check

```matlab
Vmax = inverter.V_dc / sqrt(3);  % Peak phase voltage
N_max_approx = Vmax / (pmsm.FluxPM * pmsm.p) * 30/pi;  % RPM
% If speed_ref > 90% of N_max_approx → enable field weakening
```

---

## Design Rules (Always Apply)

| Rule | Value | Rationale |
|------|-------|-----------|
| Speed BW < Current BW / 5 | Cascade stability | Inner loop must be faster |
| Position BW < Speed BW / 5 | Cascade stability | Middle loop must be faster |
| Current BW ≤ 1/(4*Ts) | Nyquist limit | Quarter of sampling frequency |
| Saturation limits | ±Vmax for current PI, ±T_max for speed PI | Prevent windup |
| KiTs convention | `Ki * Ts` (UseKiTs='on') | MCB PI block standard |

---

Copyright 2026 The MathWorks, Inc.
