# Configuration: ACIM V/f Open-Loop

**Motor:** ACIM (MCB Induction Motor block)
**Control:** VbyF Controller (no current loop, no position sensor)
**Use case:** Pumps, fans, compressors (variable speed, no precision)

## Architecture
```
Speed_Ref(RPM) → VbyF Controller → Vabc[3] → Induction Motor ← TorqueLoad
No inverter block needed (VbyF outputs actual voltages directly)
No current loop, no speed feedback — pure open-loop V/f
```

## Solver
- `FixedStepDiscrete`, Ts = 1e-4 (10 kHz)

## Block Configuration

### VbyF Controller (`mcblib/Control/Induction Machine/Controllers/VbyF Controller`)
| Parameter | Value | Notes |
|---|---|---|
| SpeedUnit | `'RPM'` | Input is synchronous speed in RPM |
| Wrated | `N_sync_rated` | f_rated * 60 / p |
| Npp | `acim.p` | Pole pairs |
| Vrated | `V_peak_rated` | V_ll_rms * sqrt(2/3) |
| Vmin | `V_min` | Rs*I_rated*0.5 (low-speed boost) |
| Nramp | `N_ramp` | round(2.0 / Ts) samples |
| WrefLimitMode | `'Acceleration limit'` | Smooth ramp |
| ParamInMethod | `'Specify via dialog'` | 2-input mode: ref + enable |
| Ts | `Ts` | Sample time |

### MCB Induction Motor (`mcblib/.../Induction Motor`)
| Parameter | Value | Notes |
|---|---|---|
| sim_type | `'Discrete'` | |
| Ts | Sample time | |
| P | Pole pairs | |
| Zs | `[Rs, Lls]` | Stator resistance + LEAKAGE inductance |
| Zr | `[Rr, Llr]` | Rotor resistance + LEAKAGE inductance |
| Lm | Magnetizing inductance | |
| mechanical | `[J, B, 0]` | |
| port_config | `'Torque'` | Input 1 = torque load |

- IMPORTANT: Zs/Zr use LEAKAGE inductance (Lls = Ls - Lm), NOT total inductance!
- Info bus: 18 elements (larger than PMSM's 12)
- Ports: In1=TorqueLoad, In2=PhaseVolt[3]. Out1=Info(18), Out2=PhaseCurr[3], Out3=MtrSpeed

## Key Formulas
```matlab
N_sync_rated = f_rated * 60 / p;           % Synchronous speed (RPM)
V_peak_rated = V_rated * sqrt(2/3);        % Peak phase voltage from line-line RMS
V_min = Rs * I_rated * 0.5;               % Low-speed voltage boost
N_ramp = round(2.0 / Ts);                 % Ramp duration in samples
Lls = Ls - Lm;  Llr = Lr - Lm;           % Leakage inductances
```

## Default Motor Data
| Parameter | Pump | Fan |
|---|---|---|
| p | 2 | 2 |
| Rs | 1.2 Ω | 0.8 Ω |
| Rr | 0.8 Ω | 0.6 Ω |
| Ls/Lr | 0.18 H | 0.15 H |
| Lm | 0.14 H | 0.13 H |
| V_rated | 230 V | 230 V |
| f_rated | 50 Hz | 50 Hz |
| V_dc | 340 V | 340 V |

## Things to Avoid
- DO NOT use PMSM as IM placeholder — V/f doesn't produce torque in PMSM correctly
- DO NOT add inverter between VbyF and IM — VbyF outputs Vabc VOLTS directly
- DO NOT confuse Ls (total) with Lls (leakage) — IM block uses LEAKAGE inductance
- DO NOT expect zero error — V/f has inherent slip (3-8% at load is normal)
- DO NOT set Nramp too small — fast ramp causes overcurrent/stall
- DO NOT set Vmin=0 — motor stalls at low speed without Rs voltage boost

## Pass Criteria
- Error from synchronous speed < 10% (slip is normal, not a bug)
- Oscillation P-P < 15%

## Version Notes
- Older releases have 7-port VbyF block (wm_ref, wm_rated, Npp, Vrated, Vmin, Nramp, Enable)
- Newer releases have 2-port VbyF (ref, enable) with dialog params
- Check `get_param('VbyF','Ports')` — if ports(1)>2, use signal-based inputs

---
**Cross-references:** `wf-linear-motor-commissioning.md` Step 3, `wiring-topologies.md` § ACIM

---
Copyright 2026 The MathWorks, Inc.
