# Simscape Plant Integration Patterns

## Pattern: ACIM with Simscape Induction Machine (Squirrel Cage)

### Block Sourcing
| Block | Library Path | Domain |
|---|---|---|
| Induction Machine Squirrel Cage | `ee_lib/Electromechanical/Asynchronous/Induction Machine\nSquirrel Cage` | Composite 3-phase |
| Controlled Voltage Source (Three-Phase) | `ee_lib/Sources/Controlled Voltage Source (Three-Phase)` | Composite 3-phase |
| RLC (Three-Phase) | `ee_lib/Passive/RLC Assemblies/RLC (Three-Phase)` | Composite 3-phase |
| Current Sensor (Three-Phase) | `ee_lib/Sensors & Transducers/Current Sensor (Three-Phase)` | Composite 3-phase |
| Grounded Neutral (Three-Phase) | `ee_lib/Connectors & References/Grounded Neutral (Three-Phase)` | Composite 3-phase |

### Port Mapping
| Block | Port | Type | Connects to |
|---|---|---|---|
| CVS3 | LConn1 | Signal input (S2PS) | Voltage command |
| CVS3 | LConn2 | Neutral (foundation) | Electrical Reference |
| CVS3 | RConn1 | + (composite 3ph) | RLC3/LConn1 |
| RLC3 | LConn1 | In (3ph) | CVS3/RConn1 |
| RLC3 | RConn1 | Out (3ph) | CS3/LConn1 |
| CS3 | LConn1 | In (3ph) | RLC3/RConn1 |
| CS3 | RConn1 | Signal out | PS2S (current measurement) |
| CS3 | RConn2 | Out (3ph) | IM/RConn2 (stator) |
| IM | LConn1 | Shaft | Inertia, Damper, IRMS, TorqueLoad |
| IM | LConn2 | Case | MechRef |
| IM | RConn2 | Stator (3ph) | CS3/RConn2 |
| IM | RConn3 | Rotor (3ph) | **Grounded Neutral (CRITICAL!)** |

### Configuration
| Block | Parameter | Value | Notes |
|---|---|---|---|
| IM | nPolePairs | `num2str(acim.p)` | |
| IM | Rs | `num2str(acim.Rs)` | Stator resistance |
| IM | Xls | `num2str(2*pi*f_rated*(Ls-Lm))` | Stator leakage REACTANCE |
| IM | Rrd | `num2str(acim.Rr)` | Rotor resistance |
| IM | Xlrd | `num2str(2*pi*f_rated*(Lr-Lm))` | Rotor leakage REACTANCE |
| IM | Xm | `num2str(2*pi*f_rated*Lm)` | Magnetizing REACTANCE |
| RLC3 | component_structure | `'ee.enum.rlc.structure.R'` | R-only for stability |
| RLC3 | R | `'0.01'` | Small series R |
| PS2S_Speed | unit | `'rad/s'` | |
| PS2S_Iabc | unit | `'1'` | Dimensionless (current ratio) |
| S2PS_Vabc | unit | `'V'` | |
| S2PS_TL | unit | `'N*m'` | |

### Critical Rules
- **IM uses REACTANCES** (X = 2πf·L at rated frequency), NOT inductances
- **IM/RConn3 MUST connect to Grounded Neutral** — squirrel cage rotor must be shorted
- **Negate speed feedback** — Simscape generator convention (positive speed = negative torque)
- **RLC3 in series** — small R (0.01 Ω) for numerical stability between CVS3 and CS3
- **Solver: ode14x** — mandatory for Simscape DAE

---

## Pattern: PMSM with Simscape FEM-Parameterized PMSM

### Block Sourcing
| Block | Library Path | Notes |
|---|---|---|
| FEM-Parameterized PMSM | `ee_lib/Electromechanical/Permanent Magnet/FEM-Parameterized PMSM` | Needs flux LUTs |
| Controlled Voltage Source | `fl_lib/Electrical/Electrical Sources/Controlled Voltage Source` | Foundation domain (per-phase) |
| Current Sensor | `fl_lib/Electrical/Electrical Sensors/Current Sensor` | Foundation domain |
| Ideal Rotational Motion Sensor | `fl_lib/Mechanical/Mechanical Sensors/Ideal Rotational Motion Sensor` | Speed + angle |

### Winding Configuration
- **Wye with exposed neutral**: Individual phase connections (3x CVS + 3x CS)
- Each phase: CVS → CS → FEM-PMSM phase terminal
- Neutral point: all CVS negatives → common node → Electrical Reference

### Port Mapping (FEM-PMSM)
| Port | Type | Connects to |
|---|---|---|
| LConn1 (or ~) | Phase A stator | CS_A/RConn |
| LConn2 (or ~) | Phase B stator | CS_B/RConn |
| LConn3 (or ~) | Phase C stator | CS_C/RConn |
| RConn1 | Shaft (mechanical rotational) | Inertia, IRMS, Load |

### Signal Feedback
| Measurement | Path | Notes |
|---|---|---|
| Speed | IRMS/RConn2 → PS2S → **Negate** → IIR | Must negate (generator convention) |
| Angle | IRMS/RConn3 → PS2S → **Negate** → Gain(1/(2π)) → MechToElec | Must negate AND convert to PU |
| Currents | 3x CS signal → PS2S → [Ia, Ib, Ic] → Clarke → Park | |

### Critical Rules
- **Negate BOTH speed AND angle** from IRMS (Simscape generator convention)
- **Angle output is radians** — MCB MechToElec expects PU (0-1), add `Gain(1/(2*pi))`
- **Do NOT change MechToElec `selectedRange` to 'Radians'** — output also becomes radians, breaking Sine-Cosine Lookup
- **3x individual CVS** for foundation domain (NOT CVS Three-Phase which is composite domain)
- **Solver: ode14x**, FixedStep = Ts/2

---

## Pattern: Ideal Average-Value Inverter (MCB + Simscape Plant)

For connecting MCB discrete controller output to Simscape plant:

```
Controller Vabc [3×1] → Unit Delay → S2PS (Simulink-PS Converter, unit='V')
→ Controlled Voltage Source (Three-Phase) → Simscape plant
```

Or per-phase:
```
Controller Vabc → Demux → 3x S2PS → 3x CVS → 3x CS → FEM-PMSM phases
```

### Voltage-to-Duty Conversion (for MCB AV Inverter)
```
duty = Vabc · 1/(2·Vdc/√3) + 0.5    % Maps ±Vdc/√3 → [0, 1]
```
Implemented as: `Gain(1/(2*Vmax))` → `Add(+0.5)` → `Inverter`

---

## Mechanical Subsystem Pattern

All Simscape mechanical components connect to a shared shaft node:

```
Motor shaft (LConn1) ──┬── Inertia (1-port, LConn1 only)
                       ├── Damper/LConn1
                       ├── IRMS/LConn1
                       └── TorqueLoad/RConn2 (or LConn1 depending on sign convention)

Reference node ────────┬── Motor case (LConn2)
                       ├── Damper/RConn1
                       ├── IRMS/RConn1
                       └── TorqueLoad/LConn1 (or RConn2)
                       └── Mechanical Rotational Reference
```

**Inertia is 1-port** (only LConn1) — no separate reference port needed.

---

## Converter Block Summary

| Direction | Block | Library | Key Param |
|---|---|---|---|
| Simulink → Physical | Simulink-PS Converter | `nesl_utility/Simulink-PS Converter` | `unit` |
| Physical → Simulink | PS-Simulink Converter | `nesl_utility/PS-Simulink Converter` | `unit` |

Common units: `'V'`, `'A'`, `'rad/s'`, `'rad'`, `'N*m'`, `'1'` (dimensionless)

---

Copyright 2026 The MathWorks, Inc.
