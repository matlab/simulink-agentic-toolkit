# Configuration: Wind Turbine PMSG Generator Control

**Motor:** PMSG (MCB Surface Mount PMSM in generator mode)
**Control:** MPPT speed reference + FOC with generator sign conventions
**Use case:** Variable-speed wind turbine with permanent magnet synchronous generator

## Architecture
```
Wind -> Turbine Model -> Torque -> PMSG <- FOC Controller
MPPT: w_opt = lambda_opt * V_wind / R_blade -> Speed_Ref
Speed_Ref -> Speed_PI -> Tref -> id*=0, iq*=Tref/k_t
FOC controls braking torque to track optimal tip-speed ratio
```

## Generator Sign Conventions (CRITICAL)

```matlab
% PMSG generates power -> motor convention reversed:
% Option A: Negate speed and angle feedback
speed_feedback = -wm;
theta_e_feedback = -theta_e;

% Option B: Negate torque reference
Tref_gen = -Tref_motor;   % Braking torque is negative in motor convention
```
- Choose ONE convention and apply consistently
- Mixing conventions causes positive feedback -> runaway

## MPPT (Maximum Power Point Tracking)
```matlab
lambda_opt = 8.1;                        % Optimal tip-speed ratio (turbine-specific)
R_blade = 3.0;                           % Blade radius (m)
rho = 1.225;                             % Air density (kg/m^3)
A = pi * R_blade^2;                      % Swept area (m^2)
w_opt = lambda_opt * V_wind / R_blade;   % Optimal rotor speed (rad/s)
```

## Turbine Torque Model
```matlab
lambda_tsr = w_rotor * R_blade / V_wind; % Tip-speed ratio
Cp = f(lambda_tsr, beta);                % Power coefficient (2-D LUT)
P_turbine = 0.5 * rho * A * Cp * V_wind^3;
T_turbine = P_turbine / w_rotor;         % Aerodynamic torque (drives generator)
```

## SPMSM for PMSG (typical wind generator)
- Ld approx Lq (surface mount, no saliency)
- id* = 0 (no field weakening for generator mode)
- iq* = Tref / (1.5 * p * FluxPM)
- Braking: iq is negative (extracting power)

## Block Configuration
- PMSM block: `port_config='Torque'`
- Turbine torque as positive input (drives the generator shaft)
- FOC commands negative iq to extract power (braking torque)
- Speed PI output = braking torque magnitude (negated before PMSM)

## Default Parameters
- PMSG: p=6, Rs=0.5, Ld=Lq=5mH, FluxPM=0.5 Wb, J=10
- Turbine: R=3m, lambda_opt=8.1, rho=1.225 kg/m^3
- Wind speed: step from 8 to 12 m/s
- Speed PI: moderate bandwidth (wind changes slowly)

## IIR Filter for Speed
- Cutoff: 5-10 Hz (wind turbine dynamics are slow)
- Higher cutoff causes noise from turbine torque pulsations

## Things to Avoid
- DO NOT forget generator sign convention — motor drives forward, generator brakes
- DO NOT use MTPA for PMSG — id*=0 is correct (no FW in generation)
- DO NOT confuse wind turbine Cp with motor efficiency
- DO NOT allow over-speed — add speed limiter for gust protection
- DO NOT use high-bandwidth speed PI — wind is slow, fast PI amplifies turbulence

## Pass Criteria
- Speed tracks MPPT reference within 5%
- Power extraction > 90% of theoretical maximum (Cp near Cp_max)
- Stable during wind step changes

---
**Cross-references:** `simscape-plant-patterns.md` § Generator Convention, `wiring-topologies.md` § Pattern B

---
Copyright 2026 The MathWorks, Inc.
