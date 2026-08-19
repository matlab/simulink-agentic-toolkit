# Wiring Topologies — Advanced Patterns (D-H)

> Patterns D through H and the Selection Guide.
> For base patterns (A, A+FF, A+PWM, B, C) see `wiring-topologies.md`.

---

## Pattern D: Position Control (Cascaded P-PI-PI)

**Use when:** Servo, CNC, robotics, position tracking.

### Additional Blocks (wraps Pattern A)
| Block Name | Block Type | Purpose |
|------------|-----------|---------|
| Pos_Ref | Constant or Signal | Position command (rad) |
| Pos_Err | Sum (+-) | Position error |
| Pos_P | Gain | Proportional position controller |
| Spd_Sat | Saturation | Speed limit between loops |
| Pos_Fb | Bus Selector ('MtrPos') | Position feedback |

### Connections (outer loop wrapping speed loop)
| From Block | From Port | To Block | To Port | Signal |
|------------|-----------|----------|---------|--------|
| Pos_Ref | 1 | Pos_Err | 1 | Position ref (+) |
| Pos_Fb | 1 | Pos_Err | 2 | Position fb (-) |
| Pos_Err | 1 | Pos_P | 1 | Position error |
| Pos_P | 1 | Spd_Sat | 1 | Unsaturated speed cmd |
| Spd_Sat | 1 | Speed_Err | 1 | Speed ref (replaces Speed_Ref) |
| PMSM | 1 | Pos_Fb | 1 | Info bus |

**Bandwidth separation:** Position BW = Speed_BW / 5 (typically)
**Kp_position** = 2 * pi * BW_pos (P-only, no integral)
**Speed saturation** MANDATORY between position and speed loops.

---

## Pattern E: V/f Open-Loop (Induction Machine Startup)

**Use when:** Simple V/f drive, no position sensor, ACIM without closed-loop.

### Block List
| Block Name | Block Type | Purpose |
|------------|-----------|---------|
| Freq_Ref | Ramp or Constant | Frequency command (Hz) |
| Gain_2pi | Gain (2*pi) | Hz -> rad/s |
| Integrator | Discrete-Time Integrator | integral(w) -> theta |
| Mod_2pi | Math Function (mod) | Wrap angle [0, 2pi] |
| V_f_ratio | Gain (V_rated/f_rated) | V/f slope |
| Boost | Constant | Low-speed voltage boost |
| Max_V | MinMax (max) | max(V_f, V_boost) |
| InvPark | Inverse Park Transform | Generate 3-phase from angle |
| InvClarke | Inverse Clarke Transform | ab -> abc |

### Connection Table
| From Block | From Port | To Block | To Port | Signal |
|------------|-----------|----------|---------|--------|
| Freq_Ref | 1 | Gain_2pi | 1 | f (Hz) |
| Gain_2pi | 1 | Integrator | 1 | omega (rad/s) |
| Integrator | 1 | Mod_2pi | 1 | theta (unwrapped) |
| Mod_2pi | 1 | InvPark | 3 | theta_e [0,2pi] |
| Freq_Ref | 1 | V_f_ratio | 1 | f (Hz) |
| V_f_ratio | 1 | Max_V | 1 | V_f |
| Boost | 1 | Max_V | 2 | V_boost |
| Max_V | 1 | InvPark | 2 | Vq (voltage magnitude) |
| Zero | 1 | InvPark | 1 | Vd = 0 |
| InvPark | 1 | InvClarke | 1 | Valpha |
| InvPark | 2 | InvClarke | 2 | Vbeta |

**No feedback path.** Open-loop; motor follows commanded frequency.

---

## Pattern F: BLDC Six-Step Hall Commutation

**Use when:** Trapezoidal BLDC with Hall sensors, cost-sensitive applications.

### Block List
| Block Name | Block Type | Purpose |
|------------|-----------|---------|
| Speed_Ref | Constant | Speed command |
| Speed_Err | Sum (+-) | Speed error |
| Speed_PI | PI Controller | -> duty [0.05, 0.95] |
| Hall_Emulate | See below | theta_e -> Hall sector (1-6) |
| SixStep | Six Step Commutation | Hall + Duty -> switches |
| DTC_bool | Data Type Conversion | boolean -> double |
| Gain_Vdc | Gain | Scale by Vdc |
| BLDC | BLDC plant | Motor |

### Hall Emulation Sub-Chain
| From Block | From Port | To Block | To Port | Signal |
|------------|-----------|----------|---------|--------|
| PMSM/BusSel | 1 | MechToElec | 1 | Mech pos |
| MechToElec | 1 | Mod_2pi | 1 | theta_e (continuous) |
| Mod_2pi | 1 | Hall_LUT | 1 | theta_e [0,2pi] |
| Hall_LUT | 1 | SixStep | 1 | Hall sector (1-6) |

**Hall_LUT:** 1-D Lookup Table
- Breakpoints: `[0, pi/3, 2*pi/3, pi, 4*pi/3, 5*pi/3, 2*pi]`
- Table data: `[6, 1, 2, 3, 4, 5, 6]` (or motor-specific sequence)
- Interpolation: **Flat** (NOT Linear -- must be discrete sectors)

### Six-Step Output Path
| From Block | From Port | To Block | To Port | Signal |
|------------|-----------|----------|---------|--------|
| Speed_PI | 1 | SixStep | 2 | Duty [0,1] |
| SixStep | 1 | DTC_bool | 1 | Switches [6x1 bool] |
| DTC_bool | 1 | Gain_Vdc | 1 | Switches [6x1 double] |
| Gain_Vdc | 1 | BLDC | 1 | Gate signals |

**CRITICAL:** `Data Type Conversion` (boolean->double) is MANDATORY after Six Step block.

### Pattern F + BEMF: Sensorless Six-Step (Average-Value Model)

**Use when:** Sensorless BLDC with average-value inverter (no Hall sensors, simulation-level fidelity).

**Why not MCB `Sensorless Six-Step Commutation` block?**
That block requires terminal voltage measurement on floating phases. The BLDC Average-Value Inverter drives all phases simultaneously — no floating phase exists. Use custom BEMF ZC detection instead.

**Additional/Replacement Blocks (vs base Pattern F):**
| Block Name | Block Type | Purpose |
|------------|-----------|---------|
| BusSel_BEMF | Bus Selector | Extract `BackEMF` [3×1] from BLDC Info bus |
| BEMF_ZC | MATLAB Function | Polarity-based sector detection (1-6) |
| Startup_Switch | Switch | Select OL sector or ZC sector based on speed |
| Handoff_Check | Compare To Constant | speed > threshold → use ZC |
| OL_Ramp | Ramp | Forced electrical angle ramp for startup |
| Mod2Pi | Math Function (mod) | Wrap angle to [0, 2π) |
| Theta2Hall_OL | 1-D Lookup Table | theta_e → forced sector (same as Hall LUT) |
| DTC_Spd | Data Type Conversion | single→double for speed |

**Replaces:** Hall_Emulate sub-chain (Wm_to_We → Theta_Integ → Mod2Pi → Theta2Hall) is replaced by BEMF_ZC + startup switch.

**Connection Table (BEMF ZC path):**
| From Block | From Port | To Block | To Port | Signal |
|------------|-----------|----------|---------|--------|
| BLDC | 1 (Info) | BusSel_BEMF | 1 | Info bus |
| BusSel_BEMF | 1 | BEMF_ZC | 1 | BackEMF [3×1] |
| BEMF_ZC | 1 | Startup_Switch | 1 | ZC sector (true path) |
| DTC_Spd | 1 | Handoff_Check | 1 | Speed (double) |
| Handoff_Check | 1 | Startup_Switch | 2 | Condition |
| Theta2Hall_OL | 1 | Startup_Switch | 3 | OL sector (false path) |
| Startup_Switch | 1 | SixStep | 1 | Active sector |

**BEMF_ZC Function (polarity → sector):**
```matlab
code = (ea>0)*4 + (eb>0)*2 + (ec>0);
% code→sector: {5→1, 4→2, 6→3, 2→4, 3→5, 1→6}
```

**See:** `examples/example_bldc_sensorless_bemf.m` for complete verified implementation.

---

## Pattern G: Simscape Electrical Plant

**Use when:** High-fidelity plant with Simscape FEM-Parameterized PMSM.

Same control structure as Pattern A, but plant subsystem uses:
- Simscape FEM-Parameterized PMSM (flux tables, not Ld/Lq)
- Three-Phase Current Sensor
- Three Controlled Voltage Sources
- Solver Configuration block
- Phase Splitter (composite -> A,B,C)

### Key Differences from Pattern A
| Aspect | Pattern A (MCB Plant) | Pattern G (Simscape) |
|--------|----------------------|---------------------|
| Solver | FixedStepDiscrete | ode14x (implicit) |
| Motor block | MCB Interior PMSM | Simscape FEM-Parameterized |
| Current sensing | Direct output port | Three-Phase Current Sensor |
| Voltage input | Direct [Vabc] port | Controlled Voltage Sources |
| Algebraic loop | Unit Delay on Vabc | Simscape handles internally |

### Simscape Plant Wiring
See `converters/plant-model-converters.md` for data conversion recipes.

**Critical conventions:**
1. **Solver:** Use `evaluate_matlab_code`: `set_param(mdl, 'Solver', 'ode14x', 'FixedStep', num2str(Ts))` — explicit solvers FAIL
2. **Sign negation (Rule 34):** Simscape uses generator convention. Negate BOTH speed AND angle:
   ```matlab
   speed_for_control = -simscape_speed;
   theta_for_control = -simscape_theta * pmsm.p;  % Also convert mech→elec
   ```
3. **FEM PMSM uses `fl_lib` foundation domain** — NOT composite 3-phase:
   - Use 3× `fl_lib/Electrical/Electrical Sources/Controlled Voltage Source` (individual phases)
   - Use 3× `fl_lib/Electrical/Electrical Sensors/Current Sensor` (individual phases)
   - Connect `PMSM/LConn4` (neutral) to `Electrical Reference`
4. **Algebraic loop breaking:** Add Unit Delay on controller voltage output path
5. **IM Squirrel Cage:** `RConn3` (rotor cage) MUST connect to `Grounded Neutral (Three-Phase)`

---

## Pattern H: Direct Torque Control (DTC)

**Use when:** Fast torque response without current PI loops, flux-based control.

### Block List
| Block Name | Block Type | Purpose |
|------------|-----------|---------|
| Speed_Ref | Constant | Speed command |
| Speed_Err | Sum (+-) | Speed error |
| Speed_PI | Discrete-Time Integrator + Gain | Speed -> torque ref |
| Flux_Ref | Constant | Flux magnitude reference |
| Flux_Est | Subsystem | Estimate |psi| from Id,Iq |
| Torque_Est | Subsystem | Estimate Te from Id,Iq,flux |
| Flux_Err | Sum (+-) | Flux error |
| Torque_Err | Sum (+-) | Torque error |
| Flux_PI | PI (or hysteresis) | Flux regulator -> Vd |
| Torque_PI | PI (or hysteresis) | Torque regulator -> Vq |
| Sat_Vd | Saturation | Vd limit |
| Sat_Vq | Saturation | Vq limit |

### Flux/Torque Estimation
```
psi_d = Ld * Id + FluxPM
psi_q = Lq * Iq
|psi| = sqrt(psi_d^2 + psi_q^2)
Te = 1.5 * p * (psi_d * Iq - psi_q * Id)
```

### Key Difference from FOC
- NO Park/InvPark transforms in control path (operates in estimated flux frame)
- Flux and torque are controlled DIRECTLY (not via id/iq)
- Hysteresis comparators (classic DTC) or PI regulators (DTC-SVM)
- Typically faster torque response but higher ripple than FOC

---

## Pattern A(ACIM): Indirect Rotor Field-Oriented Control

**Use when:** Closed-loop speed control of induction (squirrel cage) motor using indirect RFOC.

**Key difference from PMSM Pattern A:** ACIM has no permanent magnets — flux must be created by id. Angle is synthesized from slip calculation (no encoder needed for electrical angle).

### Block List
| Block Name | Block Type | Purpose |
|------------|-----------|---------|
| Speed_Ref | Step | Speed command (rad/s) |
| Speed_Err | Sum (+-) | Speed error |
| Speed_PI | PI Controller | Speed → iq_ref |
| Sat_Iq | Saturation | iq current limit |
| Id_Ref | Constant | Magnetizing current (constant) |
| Err_d | Sum (+-) | id error |
| Err_q | Sum (+-) | iq error |
| PI_d | PI Controller | d-axis current regulator |
| PI_q | PI Controller | q-axis current regulator |
| InvPark | Inverse Park Transform | Vdq → Vαβ |
| InvClarke | Inverse Clarke Transform | Vαβ → Vabc |
| Mux_V | Mux (3) | Assemble [Va;Vb;Vc] |
| Delay_V | Unit Delay | Algebraic loop break |
| ACIM | Induction Motor | Plant |
| TL | Constant | Load torque (Nm) |
| DTC_I | Data Type Conversion (double) | Single→double currents |
| DTC_Spd | Data Type Conversion (double) | Single→double speed |
| Demux_I | Demux (3) | Split phase currents |
| Clarke | Clarke Transform | Iabc → Iαβ |
| Park | Park Transform | Iαβ → Idq |
| IIR_Spd | IIR Filter | Speed noise rejection |
| Slip_Gain | Gain (1/Tr) | iq → iq/Tr |
| Slip_Div | Product (×/) | (iq/Tr) / id_ref = we_slip |
| We_Sum | Sum (++) | p*wm + we_slip = we_sync |
| Pole_Gain | Gain (acim.p) | wm → p*wm (elec speed from mech) |
| Theta_Integ | Discrete-Time Integrator | integral(we_sync) → theta |
| Mod_Wrap | Math Function (mod) | theta mod 2π |
| TwoPi | Constant (2*pi) | Wrap value |

### Connection Table (Slip Calculation + Angle Synthesis)
| From Block | From Port | To Block | To Port | Signal |
|------------|-----------|----------|---------|--------|
| DTC_Spd | 1 | Pole_Gain | 1 | wm (rad/s, double) |
| Pole_Gain | 1 | We_Sum | 1 | p*wm (+) |
| Park | 2 | Slip_Gain | 1 | iq_meas |
| Slip_Gain | 1 | Slip_Div | 1 | iq/Tr (numerator) |
| Id_Ref | 1 | Slip_Div | 2 | id_ref (denominator) |
| Slip_Div | 1 | We_Sum | 2 | we_slip (+) |
| We_Sum | 1 | Theta_Integ | 1 | we_sync |
| Theta_Integ | 1 | Mod_Wrap | 1 | theta (unwrapped) |
| TwoPi | 1 | Mod_Wrap | 2 | 2*pi |
| Mod_Wrap | 1 | Park | 3 | theta_e [0,2π] |
| Mod_Wrap | 1 | InvPark | 3 | theta_e [0,2π] |

### Connection Table (Current Control + Speed Loop)
| From Block | From Port | To Block | To Port | Signal |
|------------|-----------|----------|---------|--------|
| Speed_Ref | 1 | Speed_Err | 1 | Speed ref (+) |
| IIR_Spd | 1 | Speed_Err | 2 | Speed fb (-) |
| Speed_Err | 1 | Speed_PI | 1 | Speed error |
| Speed_PI | 1 | Sat_Iq | 1 | iq_ref (unsaturated) |
| Id_Ref | 1 | Err_d | 1 | id_ref (+) |
| Park | 1 | Err_d | 2 | id_meas (-) |
| Sat_Iq | 1 | Err_q | 1 | iq_ref (+) |
| Park | 2 | Err_q | 2 | iq_meas (-) |
| Err_d | 1 | PI_d | 1 | id error |
| Err_q | 1 | PI_q | 1 | iq error |
| PI_d | 1 | InvPark | 1 | Vd |
| PI_q | 1 | InvPark | 2 | Vq |
| InvPark | 1 | InvClarke | 1 | Valpha |
| InvPark | 2 | InvClarke | 2 | Vbeta |
| InvClarke | 1 | Mux_V | 1 | Va |
| InvClarke | 2 | Mux_V | 2 | Vb |
| InvClarke | 3 | Mux_V | 3 | Vc |
| Mux_V | 1 | Delay_V | 1 | Vabc |
| Delay_V | 1 | ACIM | 2 | Vabc (delayed) |
| TL | 1 | ACIM | 1 | Load torque |
| ACIM | 2 | DTC_I | 1 | Iabc (single) |
| ACIM | 3 | DTC_Spd | 1 | wm (single) |
| DTC_I | 1 | Demux_I | 1 | Iabc (double) |
| Demux_I | 1 | Clarke | 1 | Ia |
| Demux_I | 2 | Clarke | 2 | Ib |
| Clarke | 1 | Park | 1 | Ialpha |
| Clarke | 2 | Park | 2 | Ibeta |
| DTC_Spd | 1 | IIR_Spd | 1 | wm (double) |

### ACIM Parameter Setup (evaluate_matlab_code)
```matlab
% Motor parameters
acim.Rs = 1.405;        % Stator resistance (Ohm)
acim.Rr = 1.395;        % Rotor resistance (Ohm)
acim.Lm = 0.1722;       % Magnetizing inductance (H)
acim.Lls = 0.005839;    % Stator leakage inductance (H)
acim.Llr = 0.005839;    % Rotor leakage inductance (H)
acim.Ls = acim.Lls + acim.Lm;  % Total stator inductance
acim.Lr = acim.Llr + acim.Lm;  % Total rotor inductance
acim.p = 2;             % Pole pairs
acim.J = 0.001;         % Inertia (kg*m^2)
acim.B = 0.0001;        % Friction (Nm/(rad/s))
acim.I_rated = 4;       % Rated RMS current (A)
acim.V_rated = 230;     % Rated voltage (V)

% Derived quantities
Tr = acim.Lr / acim.Rr;                          % Rotor time constant
sigma = 1 - acim.Lm^2 / (acim.Ls * acim.Lr);    % Leakage factor
L_sigma = sigma * acim.Ls;                        % Transient inductance

% Magnetizing current (CONSTANT — maintains rated rotor flux)
id_ref = acim.I_rated / sqrt(2);

% PI tuning — current loop uses transient inductance (NOT Ls)
BW_i = 1 / (4 * Ts);
Kp_id = L_sigma * BW_i;
Ki_id = (acim.Rs + acim.Rr * acim.Lm^2 / acim.Lr^2) * BW_i;
Kp_i = Kp_id;  Ki_i = Ki_id;  % q-axis = d-axis for ACIM

% Speed loop
BW_speed = BW_i / 20;
kt_acim = 1.5 * acim.p * acim.Lm^2 / acim.Lr * id_ref;
Kp_speed = acim.J * BW_speed / kt_acim;
Ki_speed = Kp_speed * BW_speed / 5;

% Voltage limit for ACIM (differs from PMSM!)
Vmax = inverter.V_dc / sqrt(3);
max_speed_acim = Vmax / (acim.Lm * id_ref * acim.p);  % rad/s mechanical
```

### Critical Notes
1. **Angle MUST be wrapped** — Without `mod(theta, 2*pi)`, Park/InvPark internal uint16 LUTs overflow after ~6500 rad → NaN output → motor runaway
2. **Slip uses id_ref (constant), NOT id_meas** — Using measured id causes divide-by-zero at startup when id≈0
3. **Current PI uses sigma*Ls** — NOT full Ls. Using Ls gives ~5× too much gain → oscillation
4. **DefaultUnderspecifiedDataType='single'** — MCB Induction Motor block internals use single precision. Set model-level to 'single' to avoid type propagation errors with MCB blocks
5. **ACIM max speed differs from PMSM** — PMSM: `Vmax/(FluxPM*p)`. ACIM: `Vmax/(Lm*id_ref*p)` — depends on commanded flux current
6. **Torque constant for speed PI** — ACIM: `kt = 1.5*p*Lm²/Lr*id_ref` (NOT `1.5*p*FluxPM` like PMSM)
7. **Filtered speed feeds slip calculation** — IIR_Spd output feeds BOTH speed error (via RT) AND pole_gain for slip. Using unfiltered speed for slip → noise-amplified angle jitter
8. **Speed PI output is iq_ref** — NOT torque. Saturation limits `iq_ref` to `±iq_sat` where `iq_sat = sqrt((I_rated*sqrt(2))^2 - id_ref^2)` (current circle constraint, preserves id headroom)

### Voltage Path Options (after InvClarke)

Three valid paths from InvClarke output to plant. Choose ONE:

| Path | Normalization | Blocks After Mux_V | Use When |
|------|--------------|-------------------|----------|
| **Direct** | None | `Delay_V → ACIM.u2` | Simplest; MCB plant accepts raw voltages |
| **PWM Ref Gen** | `Gain(1/Vmax)` → PWM Ref Gen → `Gain(Vmax)` | Per-unit SVM/DPWM modulation | Need SVM harmonics, realistic PWM |
| **V2D + AVI** | `Gain(1/(2*Vmax))` + `Bias(0.5)` → AVI | Duty-cycle model with Average-Value Inverter | Pattern B compatibility |

**Vmax** = `inverter.V_dc / sqrt(3)` (line-to-neutral peak for SPWM)

**PWM Ref Gen path detail:**
```
InvClarke → Mux_V → Gain(1/Vmax) → PWM_RefGen.u1 → Gain(Vmax) → Delay_V → ACIM.u2
```
PWM Ref Gen expects per-unit voltage inputs [-1, +1]. Its output is also per-unit — re-scale by Vmax before plant.

**V2D + AVI path detail:**
```
InvClarke → Mux_V → Gain(1/(2*Vmax)) → Bias(+0.5) → AVI.u1 → ACIM.u2
```
AVI expects duty [0, 1]. Output is actual voltage — no re-scaling needed.

### Rate Transition for Multi-Rate

When speed loop runs at `Ts_speed` (typically 10×-20× `Ts`):
| Block | Placement | Direction |
|-------|-----------|-----------|
| RT_spd_fb | After IIR_Spd, before Speed_Err | Fast→Slow (speed feedback to speed PI) |

```json
{"op": "add_block", "type": "Rate Transition", "name": "RT_spd_fb", "params": {"OutPortSampleTime": "Ts_speed"}}
```
**Connection:** `IIR_Spd.y1 → RT_spd_fb.u1`, `RT_spd_fb.y1 → Speed_Err.u2`
**Note:** IIR_Spd output also feeds `Pole_Gain` (slip path) at `Ts` — do NOT put RT before Pole_Gain

---

## Pattern Selection Guide

| Requirement | Pattern |
|-------------|---------|
| Maximum flexibility, custom PI tuning | A |
| Official MCB style, fewer blocks | B |
| Torque-only (no speed loop) | C |
| Position tracking (servo, CNC) | D |
| V/f open-loop (ACIM startup) | E |
| Trapezoidal BLDC with Hall sensors | F |
| High-fidelity Simscape plant | G |
| Fast torque response, DTC | H |
| Induction motor closed-loop speed (RFOC) | A(ACIM) |

### Feature Suffixes (combine with base pattern)
| Suffix | Meaning | Applicable Patterns |
|--------|---------|-------------------|
| +FF | FeedForward decoupling | A, D |
| +FW | Field Weakening (voltage feedback) | A, B |
| +SMO | Sensorless (Sliding Mode Observer) | A, B |
| +PWM | PWM Reference Generator (SVM/DPWM) | A, B |
| +GainSched | LUT-based gain scheduling | A |
| +Position | Outer position loop | A -> becomes D |
| +ACIM | Induction machine (slip calc) | A (modified) |

---

## Pattern B+SMO: Sensorless FOC with I/f Startup

**Use when:** Sensorless PMSM speed control using SMO observer, no position sensor, with MTPA and optional field weakening.

### Architecture Overview

```
Phase 1 (I/f startup, t < T_handoff):
  Ramp → Saturation → ×p → Integrator → mod(2π) → FOC CC angle
  Constant IF_Tref_Nm → MTPA → FOC CC current refs
  Ramp speed → speed feedback (forced)

Phase 2 (SMO closed-loop, t ≥ T_handoff):
  Speed_Ref → Speed_PI → Tref → MTPA → FOC CC → V2D → AVI → PMSM
  PMSM Iabc → Clarke_I → SMO (Ialpha, Ibeta)
  FOC_CC Vabc → Unit Delay → Clarke_V → SMO (Valpha, Vbeta)
  SMO.y1 → DTC → speed-from-position → speed feedback
  SMO.y1 → DTC → FOC CC angle
```

### I/f Startup Blocks
| Block Name | Block Type | Purpose |
|------------|-----------|---------|
| IF_Slope | Constant | `IF_speed_rad / IF_ramp_time` |
| IF_Ramp | Discrete-Time Integrator | Integrates slope → ramp speed |
| IF_SpeedSat | Saturation | Clamp [0, IF_speed_rad] |
| IF_Rad2Elec | Gain (`motor.p`) | Mech → elec angular velocity |
| IF_AngleGen | Discrete-Time Integrator | ∫(ω_elec) → θ_elec |
| IF_WrapAngle | Math Function (mod) | θ mod 2π |
| TwoPi | Constant (`2*pi`) | Modulus value |
| IF_Tref | Constant | Startup torque (Nm) |
| Handoff_Switch | Step | 0→1 at T_handoff |

### Switch Blocks (time-based handoff)
| Block | Purpose | Port 1 (CL) | Port 3 (OL) |
|-------|---------|-------------|-------------|
| Sw_theta | Angle select | DTC_pos (SMO θ) | IF_WrapAngle (I/f θ) |
| Sw_speed | Speed select | SpdFromPos_LPF (derived ω) | IF_SpeedSat (ramp ω) |
| Sw_Tref | Torque select | RT_Tref (Speed PI out) | IF_Tref (constant) |

All switches: `Criteria='u2 >= Threshold'`, `Threshold='0.5'`. Port 2 = Handoff_Switch output.

### I/f Startup Parameters
```matlab
IF_speed_rpm = 0.10 * pmsm.N_base;          % 10% of base speed
IF_speed_rad = IF_speed_rpm * pi/30;
IF_speed_elec = IF_speed_rad * pmsm.p;
IF_ramp_time = 1.0;                          % seconds to reach IF speed
T_handoff = IF_ramp_time + 0.2;             % handoff after ramp settles

% I/f torque: must exceed drag but NOT outrun the angle ramp
alpha_mech = IF_speed_rad / IF_ramp_time;
T_needed = pmsm.J * alpha_mech + pmsm.B * IF_speed_rad;
max_safe_T = 2.0 * pmsm.J * alpha_mech;
IF_Tref_Nm = min(T_needed * 5, max_safe_T);
```

### SMO Input Wiring (SI mode)
| From Block | From Port | To Block | To Port | Signal |
|------------|-----------|----------|---------|--------|
| FOC_CC | 1 (Vabc) | Delay_Vabc | 1 | Command voltages |
| Delay_Vabc | 1 | Demux_Vabc | 1 | Vabc (delayed 1 step) |
| Demux_Vabc | 1 | Clarke_V | 1 | Va |
| Demux_Vabc | 2 | Clarke_V | 2 | Vb |
| Clarke_V | 1 | SMO | 1 | Valpha |
| Clarke_V | 2 | SMO | 2 | Vbeta |
| Demux_Iabc | 1 | Clarke_I | 1 | Ia |
| Demux_Iabc | 2 | Clarke_I | 2 | Ib |
| Clarke_I | 1 | SMO | 3 | Ialpha |
| Clarke_I | 2 | SMO | 4 | Ibeta |
| SMO_Reset (=0) | 1 | SMO | 5 | Always active |

### Critical Notes
1. **Time-based handoff (NOT speed-based):** Use Step block at T_handoff. Speed-based Switch fails because SMO NaN propagates through unselected Switch input paths in Simulink.
2. **SMO Reset = 0 always:** SMO runs during I/f phase too — it tracks and converges by handoff time.
3. **Voltage delay:** One-sample Unit Delay on FOC_CC→SMO voltage path prevents algebraic loop.
4. **Speed from position (NOT SMO port 2):** SMO speed output uses hardware-timer-based gain (~4.75e-10) that is meaningless in simulation. Always derive speed from position delta.
5. **Solver:** MTPA block may contain internal continuous states. Use `ode3` fixed-step solver (NOT `FixedStepDiscrete`). Step size = Ts.
6. **Rate Limiter:** Has continuous states; replace with Gain(1) passthrough or discrete Rate Limiter Dynamic block if rate limiting is needed.
7. **Ramp block:** Has continuous states; replace with `Constant(slope) → Discrete-Time Integrator → Saturation` for discrete models.

----
Copyright 2026 The MathWorks, Inc.
----
