# Configuration: Position Cascade FOC (P-PI-PI)

**Motor:** IPMSM (MCB Interior PMSM)
**Control:** Cascaded Position(P) -> Speed(PI) -> Current(PI) control
**Use case:** Servo positioning, CNC, robotics

## Architecture
```
Position_Ref -> P-controller -> Speed_Ref(sat) -> Speed_PI -> Tref -> MTPA -> id*/iq*
id*/iq* -> PI_d/PI_q -> InvPark -> PWM -> Inverter -> PMSM
Position feedback: mechanical angle from speed integration (NOT electrical theta_e)
```

## Position Loop Design Rules

| Rule | Value | Reason |
|---|---|---|
| Controller type | **P-only** (no I term) | I causes limit-cycle oscillation |
| Kp_pos | BW_speed / 5 | Must be slower than speed loop |
| Speed saturation | **MANDATORY** | Between position output and speed PI input |
| Position source | Integral of mechanical speed | NOT electrical angle theta_e |
| Units | Mechanical radians | Cumulative (no wrap) |

## Position Gain Calculation
```matlab
BW_speed = 2*pi*30;                      % Speed loop bandwidth (Hz)
Kp_pos = BW_speed / 5;                   % Position loop ~6x slower
speed_limit = 0.8 * N_rated * pi/30;     % Speed saturation (rad/s)
```

## Position Feedback
```
PMSM/3 (MtrSpd, rad/s) -> Discrete Integrator -> position_mech (rad)
```
- NOT from MtrPos (wraps at 2*pi per mechanical revolution)
- For absolute position: integrate speed continuously
- Integrator: Forward Euler, Ts, no saturation (position is unbounded)

## Speed Saturation (CRITICAL)
- Saturation block between position P-output and speed PI input
- Limits: +/- speed_limit (typically 80% of N_rated)
- Without this: large position error -> huge speed command -> overcurrent trip

## Cascade Bandwidth Separation

| Loop | Bandwidth | Sample Time |
|---|---|---|
| Current | 1/(10*Ts) | Ts (50us) |
| Speed | 2*pi*30 Hz | 10*Ts (500us) |
| Position | BW_speed/5 = ~6 Hz | 10*Ts or slower |

## Default Motor
- IPMSM: p=4, Rs=0.36, Ld=3.5mH, Lq=8mH, FluxPM=0.1714, I_rated=12A
- Vdc=400V, Ts=50us
- Position step = pi rad at t=0.5s
- Speed limit = 80% of N_rated

## Things to Avoid
- DO NOT add integral term to position loop — causes limit cycles
- DO NOT omit speed saturation — position error spikes cause overcurrent
- DO NOT use electrical angle for position — wraps every electrical revolution
- DO NOT make position loop faster than speed loop — instability guaranteed
- DO NOT use theta_e from encoder directly — need mechanical cumulative angle
- DO NOT use derivative term (PD) without heavy filtering — amplifies noise

## Pass Criteria
- Position settling < 500ms for pi rad step
- No overshoot > 5% of final position
- Speed remains within saturation limits during transient

---
**Cross-references:** `wf-linear-motor-commissioning.md` Step 11, `wiring-topologies-advanced.md` § Position

---
Copyright 2026 The MathWorks, Inc.
