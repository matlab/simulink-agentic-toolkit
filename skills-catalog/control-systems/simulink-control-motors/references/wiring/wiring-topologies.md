# Wiring Topologies

> Base patterns (A, A+FF, A+PWM, B, C) as explicit connection tables.
> Each pattern defines the signal flow; implement via `model_edit` connect operations.
> For advanced patterns (D-H) and selection guide see `wiring-topologies-advanced.md`.
> Block configuration details → see `block-configurations.md`
> Tool selection → see `tool-routing.md`

**Port notation:** `From Port 1` = `.y1` (output), `To Port 1` = `.u1` (input).
Use `model_edit` connect: `{"op": "connect", "target": "FromBlock.y1 -> ToBlock.u1"}`

**Angle feedback (RECOMMENDED):** Use `BusSel('MtrPos')` → MechToElec block → theta_e. This matches the hardware path (encoder → position → electrical conversion) and is proven stable. The MechToElec block wraps the output to [0, 2π] and handles pole-pair multiplication correctly.

**Alternative (simulation-only shortcut):** `BusSel('MtrElcPos')` provides theta_e directly — no MechToElec needed. This works in simulation but does NOT emulate the real hardware signal chain.

**Speed feedback (RECOMMENDED):** Use `BusSel('MtrPos')` → discrete derivative (or Speed Measurement block) → IIR filter. This emulates encoder-based speed measurement. Direct `PMSM.y3` is acceptable for simulation-only models but bypasses the measurement path.

**Data type:** PMSM outputs y2 (currents) and y3 (speed) are **single precision** — always add DTC (→double) before arithmetic blocks.

---

## Pattern A: Manual PI Current Loop (Speed FOC)

> **WARNING: Pattern A causes SUSTAINED OSCILLATION with MCB discrete PMSM in closed-loop speed control.** Use Pattern B or Pattern B-Simple instead. Pattern A is only appropriate for: open-loop voltage testing, current-mode control without speed feedback, or educational purposes. See `model-sanity-check-domain.md` §18.1.

**Use when:** Current-mode control, open-loop testing, or when full manual flexibility is needed for non-speed-loop applications

### Block List
| Block Name | Block Type | Purpose |
|------------|-----------|---------|
| Speed_Ref | Constant or Step | Speed command (rad/s or RPM) |
| Speed_Err | Sum (+-) | Speed error = ref - feedback |
| Speed_PI | PI Controller | Speed regulator → torque command |
| RT_Tref | Rate Transition | Ts_speed → Ts bridge |
| RT_spd | Rate Transition | Ts → Ts_speed bridge |
| MTPA | MTPA Control Reference | Torque → id*/iq* |
| Err_d | Sum (+-) | id error = id_ref - id_meas |
| Err_q | Sum (+-) | iq error = iq_ref - iq_meas |
| PI_d | PI Controller | d-axis current regulator |
| PI_q | PI Controller | q-axis current regulator |
| InvPark | Inverse Park Transform | Vdq → Valphabeta |
| InvClarke | Inverse Clarke Transform | Valphabeta → Vabc |
| Mux_V | Mux (3) | Va,Vb,Vc → [3×1] |
| Delay_V | Unit Delay | Algebraic loop break |
| PMSM | Interior PMSM | Motor plant |
| TL | Constant or Step | Load torque |
| BusSel | Bus Selector ('MtrPos') | Mechanical position (for angle + speed) |
| MechToElec | Mechanical to Electrical Position | theta_mech → theta_e (wraps [0,2π]) |
| DTC_I | Data Type Conversion (double) | Single→double for phase currents |
| DTC_Spd | Data Type Conversion (double) | Single→double for speed |
| Demux_I | Demux (3) | [Ia;Ib;Ic] → scalars |
| Term_Ic | Terminator | Sink for unused Ic (Demux port 3) |
| Clarke | Clarke Transform | Ia,Ib → Ialpha,Ibeta |
| Park | Park Transform | Ialpha,Ibeta → Id,Iq |
| IIR_Spd | IIR Filter | Speed low-pass filter |

### Connection Table
| From Block | From Port | To Block | To Port | Signal |
|------------|-----------|----------|---------|--------|
| Speed_Ref | 1 | Speed_Err | 1 | Speed reference |
| IIR_Spd | 1 | RT_spd | 1 | Filtered speed |
| RT_spd | 1 | Speed_Err | 2 | Speed feedback (−) |
| Speed_Err | 1 | Speed_PI | 1 | Speed error |
| Speed_PI | 1 | RT_Tref | 1 | Torque command |
| RT_Tref | 1 | MTPA | 1 | Torque ref at Ts |
| PMSM | 3 | DTC_Spd | 1 | Raw speed (single→double) |
| DTC_Spd | 1 | IIR_Spd | 1 | Speed (double) |
| IIR_Spd | 1 | MTPA | 2 | Speed for FW (if needed) |
| MTPA | 1 | Err_d | 1 | id_ref (+) |
| MTPA | 2 | Err_q | 1 | iq_ref (+) |
| Park | 1 | Err_d | 2 | id_meas (−) |
| Park | 2 | Err_q | 2 | iq_meas (−) |
| Err_d | 1 | PI_d | 1 | id error |
| Err_q | 1 | PI_q | 1 | iq error |
| PI_d | 1 | InvPark | 1 | Vd |
| PI_q | 1 | InvPark | 2 | Vq |
| BusSel | 1 | MechToElec | 1 | Mechanical position (rad) |
| MechToElec | 1 | Park | 3 | theta_e (electrical) |
| MechToElec | 1 | InvPark | 3 | theta_e (electrical) |
| InvPark | 1 | InvClarke | 1 | Valpha |
| InvPark | 2 | InvClarke | 2 | Vbeta |
| InvClarke | 1 | Mux_V | 1 | Va |
| InvClarke | 2 | Mux_V | 2 | Vb |
| InvClarke | 3 | Mux_V | 3 | Vc |
| Mux_V | 1 | Delay_V | 1 | Vabc [3×1] |
| TL | 1 | PMSM | 1 | Load torque |
| Delay_V | 1 | PMSM | 2 | Vabc delayed |
| PMSM | 1 | BusSel | 1 | Info bus |
| PMSM | 2 | DTC_I | 1 | [Ia;Ib;Ic] (single→double) |
| DTC_I | 1 | Demux_I | 1 | [Ia;Ib;Ic] (double) |
| Demux_I | 1 | Clarke | 1 | Ia |
| Demux_I | 2 | Clarke | 2 | Ib |
| Demux_I | 3 | Term_Ic | 1 | Ic (unused) |
| Clarke | 1 | Park | 1 | Ialpha |
| Clarke | 2 | Park | 2 | Ibeta |

### Sample Times
- Current loop: `Ts` (e.g., 50μs)
- Speed loop: `Ts_speed = 10 * Ts` (e.g., 500μs)
- `RT_Tref`: OutPortSampleTime = `Ts`
- `RT_spd`: OutPortSampleTime = `Ts_speed`

---

## Pattern A+FF: Manual PI with FeedForward

**Adds to Pattern A:** FeedForward decoupling voltages summed with PI outputs.

### Additional Blocks
| Block Name | Block Type | Purpose |
|------------|-----------|---------|
| FF | PMSM FeedForward Control | Decoupling compensation |
| Sum_Vd | Sum (++) | Vd = PI_d + FF_d |
| Sum_Vq | Sum (++) | Vq = PI_q + FF_q |

### Additional Connections (replaces PI→InvPark direct)
| From Block | From Port | To Block | To Port | Signal |
|------------|-----------|----------|---------|--------|
| Park | 1 | FF | 1 | id_meas |
| Park | 2 | FF | 2 | iq_meas |
| PMSM | 3 | Gain_we | 1 | wm (mechanical) |
| Gain_we | 1 | FF | 3 | we = wm*p |
| PI_d | 1 | Sum_Vd | 1 | Vd_pi |
| FF | 1 | Sum_Vd | 2 | Vd_ff |
| PI_q | 1 | Sum_Vq | 1 | Vq_pi |
| FF | 2 | Sum_Vq | 2 | Vq_ff |
| Sum_Vd | 1 | InvPark | 1 | Vd_total |
| Sum_Vq | 1 | InvPark | 2 | Vq_total |

---

## Pattern A+PWM: Manual PI with PWM Reference Generator

**Replaces:** InvClarke + Mux with normalized PWM path + Average-Value Inverter.

### Additional/Changed Blocks
| Block Name | Block Type | Purpose |
|------------|-----------|---------|
| Gain_norm_a | Gain (1/Vmax) | Normalize Valpha |
| Gain_norm_b | Gain (1/Vmax) | Normalize Vbeta |
| PWM_RefGen | PWM Reference Generator | αβ → duty |
| Mux_Duty | Mux (3) | Da,Db,Dc → [3×1] |
| Inverter | Average-Value Inverter | Duty + Vdc → Vabc |
| Vdc | Constant | DC bus voltage |

### Changed Connections (replaces InvClarke path)
| From Block | From Port | To Block | To Port | Signal |
|------------|-----------|----------|---------|--------|
| InvPark | 1 | Gain_norm_a | 1 | Valpha (V) |
| InvPark | 2 | Gain_norm_b | 1 | Vbeta (V) |
| Gain_norm_a | 1 | PWM_RefGen | 1 | Valpha_PU |
| Gain_norm_b | 1 | PWM_RefGen | 2 | Vbeta_PU |
| PWM_RefGen | 1 | Mux_Duty | 1 | Da |
| PWM_RefGen | 2 | Mux_Duty | 2 | Db |
| PWM_RefGen | 3 | Mux_Duty | 3 | Dc |
| Mux_Duty | 1 | Inverter | 1 | [Da;Db;Dc] |
| Vdc | 1 | Inverter | 2 | Vdc |
| Inverter | 1 | Delay_V | 1 | Vabc |

**Vmax computation:** `Vmax = Vdc / sqrt(3)`

---

## Pattern B: FOC CC Block Current Loop

**Use when:** Want official MCB pattern, fewer blocks, built-in gain scheduling port.

### Block List
| Block Name | Block Type | Purpose |
|------------|-----------|---------|
| Speed_Ref | Constant or Step | Speed command |
| Speed_Err | Sum (+-) | Speed error |
| Speed_PI | PI Controller | Speed regulator |
| RT_Tref | Rate Transition | Rate bridge |
| RT_spd | Rate Transition | Rate bridge |
| MTPA | MTPA Control Reference | Torque → id*/iq* |
| Mux_idiq | Mux (2) | [id_ref; iq_ref] |
| Mux_Iab | Mux (2) | [Ia; Ib] |
| FOC_CC | Field-Oriented Current Controller (see `block-configurations.md` for full library path) | All-in-one current control |
| Gains | Constant | [Kp_d; Ki_d*Ts; Kp_q; Ki_q*Ts] |
| Limits | Constant | [Vmax; -Vmax; 0; 0] (q uses D-Q equivalence) |
| Enable | Constant (1) | Always enabled |
| Vmax_calc | Gain (1/sqrt(3)) | Vdc → Vmax |
| V2D_Gain | Gain (1/(2*Vmax)) | Voltage→normalized scaling |
| V2D_Add | Add (++) | Add +0.5 offset for duty centering |
| Half | Constant (0.5) | Duty offset |
| Inverter | Average-Value Inverter | Duty → Vabc |
| Delay_V | Unit Delay | Algebraic loop break |
| PMSM | Interior PMSM | Plant |
| BusSel | Bus Selector ('MtrPos') | Mechanical position |
| MechToElec | Mechanical to Electrical Position | theta_mech → theta_e |
| DTC_I | Data Type Conversion (double) | Single→double for currents |
| DTC_Spd | Data Type Conversion (double) | Single→double for speed |
| Demux_I | Demux (3) | Current split |
| IIR_Spd | IIR Filter | Speed filter |

### Connection Table
| From Block | From Port | To Block | To Port | Signal |
|------------|-----------|----------|---------|--------|
| Speed_Ref | 1 | Speed_Err | 1 | Speed ref |
| RT_spd | 1 | Speed_Err | 2 | Speed fb (−) |
| Speed_Err | 1 | Speed_PI | 1 | Speed error |
| Speed_PI | 1 | RT_Tref | 1 | Torque cmd |
| RT_Tref | 1 | MTPA | 1 | Torque at Ts |
| MTPA | 1 | Mux_idiq | 1 | id_ref |
| MTPA | 2 | Mux_idiq | 2 | iq_ref |
| Mux_idiq | 1 | FOC_CC | 1 | [id_ref;iq_ref] |
| Demux_I | 1 | Mux_Iab | 1 | Ia |
| Demux_I | 2 | Mux_Iab | 2 | Ib |
| Mux_Iab | 1 | FOC_CC | 2 | [Ia;Ib] |
| BusSel | 1 | MechToElec | 1 | Mechanical position |
| MechToElec | 1 | FOC_CC | 3 | theta_e |
| Vmax_calc | 1 | FOC_CC | 4 | Vmax |
| Gains | 1 | FOC_CC | 5 | PI gains [4×1] |
| Limits | 1 | FOC_CC | 6 | Limits [4×1] |
| Enable | 1 | FOC_CC | 7 | Enable=1 |
| FOC_CC | 1 | V2D_Gain | 1 | Vabc (volts) |
| V2D_Gain | 1 | V2D_Add | 1 | Scaled |
| Half | 1 | V2D_Add | 2 | +0.5 offset |
| V2D_Add | 1 | Inverter | 1 | Duty [3×1] |
| Vdc | 1 | Inverter | 2 | Vdc |
| Vdc | 1 | Vmax_calc | 1 | Vdc |
| Inverter | 1 | Delay_V | 1 | Vabc |
| TL | 1 | PMSM | 1 | Load torque |
| Delay_V | 1 | PMSM | 2 | Vabc delayed |
| PMSM | 1 | BusSel | 1 | Info bus |
| PMSM | 2 | DTC_I | 1 | [Ia;Ib;Ic] (single→double) |
| DTC_I | 1 | Demux_I | 1 | [Ia;Ib;Ic] (double) |
| PMSM | 3 | DTC_Spd | 1 | Speed (single→double) |
| DTC_Spd | 1 | IIR_Spd | 1 | Speed (double) |
| IIR_Spd | 1 | RT_spd | 1 | Filtered speed |

**V2D Conversion:** `duty = Vabc / (2*Vmax) + 0.5` where `Vmax = Vdc/sqrt(3)`
```json
[
  {"op": "add_block", "type": "Gain", "name": "V2D_Gain", "ref": "v2d", "params": {"Gain": "1/(2*inverter.V_dc/sqrt(3))"}},
  {"op": "add_block", "type": "Add", "name": "V2D_Add", "ref": "v2a", "params": {"Inputs": "++"}},
  {"op": "add_block", "type": "Constant", "name": "Half", "ref": "hf", "params": {"Value": "0.5"}},
  {"op": "connect", "target": "InvClarke.y1 -> #v2d.u1"},
  {"op": "connect", "target": "#v2d.y1 -> #v2a.u1"},
  {"op": "connect", "target": "#hf.y1 -> #v2a.u2"},
  {"op": "connect", "target": "#v2a.y1 -> Delay_V.u1"}
]
```

---

## Pattern B-Simple: FOC CC Speed Control (No MTPA, No Rate Transition)

**Use when:** Basic PMSM speed control below base speed, id_ref=0 (surface-mount or no FW needed). Fewest blocks for a working closed-loop speed FOC.

**RECOMMENDED over Pattern A** for all closed-loop speed control. Pattern A causes sustained oscillation with MCB discrete PMSM.

### Block List
| Block Name | model_edit type | Purpose | Key params |
|------------|----------------|---------|------------|
| SpdRef | `"Step"` | Speed command (rad/s) | `InitialValue='0'`, `FinalValue='speed_ref_rad'`, `Time='0.1'`, `SampleTime='Ts_speed'` — NOT `Before`/`After` |
| Spd_Err | `"Sum"` | Speed error | `Inputs='+-'` |
| PI_speed | `"mcbcontrolslib/PI Controller"` | Speed regulator → iq_ref | See block-configurations.md §PI Controller |
| Sat_Iq | `"Saturate"` | Current limit | `UpperLimit='iq_sat'`, `LowerLimit='-iq_sat'` |
| Id_Ref | `"Constant"` | No field weakening | `Value='0'` |
| Mux_IdqRef | `"Mux"` | [id_ref; iq_ref] for FOC_CC.u1 | `Inputs='2'` |
| Mux_Iab | `"Mux"` | [Ia; Ib] for FOC_CC.u2 | `Inputs='2'` |
| FOC_CC | `"mcbfoclib/Field-Oriented Current Controller"` | Current control (internal transforms) | `AngleUnit='Radians'`, `SaturationMethod='D-Q Equivalence'` |
| Vmax_Const | `"Constant"` | Voltage saturation for FOC_CC.u4 | `Value='Vmax'` |
| PIGains | `"Constant"` | Current PI gains for FOC_CC.u5 | `Value='[Kp_id; Ki_id*Ts; Kp_i; Ki_i*Ts]'` |
| VLimits | `"Constant"` | Voltage limits for FOC_CC.u6 — q-axis MUST be 0 | `Value='[Vmax; -Vmax; 0; 0]'` |
| EnableFOC | `"Constant"` | FOC_CC.u7 enable | `Value='1'` |
| V2D_Gain | `"Gain"` | Voltage to duty scaling | `Gain='1/(2*Vmax)'` |
| V2D_Bias | `"Bias"` | Duty centering | `Bias='0.5'` |
| AVI | `"Average-Value Inverter"` | Duty → Vabc | (no params) |
| Vdc_Const | `"Constant"` | DC bus voltage | `Value='inverter.V_dc'` |
| Delay_V | `"Unit Delay"` | Algebraic loop break | `SampleTime='Ts'` |
| PMSM | `"Interior PMSM"` | Plant (sim_type=Discrete) | See block-configurations-plants.md |
| TL | `"Constant"` | Load torque | `Value='0'` |
| BusSel | `"Bus Selector"` | Electrical angle (simulation shortcut) | `OutputSignals='MtrElcPos'` |
| DTC_I | `"Data Type Conversion"` | Single→double currents | `OutDataTypeStr='double'` |
| DTC_Spd | `"Data Type Conversion"` | Single→double speed | `OutDataTypeStr='double'` |
| Demux_I | `"Demux"` | [Ia;Ib;Ic] → scalars | `Outputs='3'` |
| IIR_Spd | `"IIR Filter"` | Speed low-pass filter | `cutOff_freq='20'`, `Ts='Ts'` — see block-configurations-utility.md |
| Term_Ic | `"Terminator"` | Sink for unused Ic (Demux port 3) | — |

### Connection Table
| From Block | From Port | To Block | To Port | Signal |
|------------|-----------|----------|---------|--------|
| SpdRef | 1 | Spd_Err | 1 | Speed reference (rad/s) |
| IIR_Spd | 1 | Spd_Err | 2 | Speed feedback (−) |
| Spd_Err | 1 | PI_speed | 1 | Speed error |
| PI_speed | 1 | Sat_Iq | 1 | Unbounded iq command |
| Id_Ref | 1 | Mux_IdqRef | 1 | id_ref = 0 |
| Sat_Iq | 1 | Mux_IdqRef | 2 | iq_ref (saturated) |
| Mux_IdqRef | 1 | FOC_CC | 1 | [id_ref; iq_ref] (2×1) |
| Demux_I | 1 | Mux_Iab | 1 | Ia |
| Demux_I | 2 | Mux_Iab | 2 | Ib |
| Mux_Iab | 1 | FOC_CC | 2 | [Ia; Ib] (2×1) |
| BusSel | 1 | FOC_CC | 3 | theta_e (rad) |
| Vmax_Const | 1 | FOC_CC | 4 | Vmax (scalar) |
| PIGains | 1 | FOC_CC | 5 | [Kp_d; Ki_d*Ts; Kp_q; Ki_q*Ts] (4×1) |
| VLimits | 1 | FOC_CC | 6 | [Vmax; -Vmax; 0; 0] (4×1) — q=0 enables DQ limiter |
| EnableFOC | 1 | FOC_CC | 7 | Enable = 1 |
| FOC_CC | 1 | V2D_Gain | 1 | Vabc (3×1 volts) |
| V2D_Gain | 1 | V2D_Bias | 1 | Scaled voltage |
| V2D_Bias | 1 | AVI | 1 | Duty [3×1] |
| Vdc_Const | 1 | AVI | 2 | Vdc |
| AVI | 1 | Delay_V | 1 | Vabc from inverter |
| TL | 1 | PMSM | 1 | Load torque |
| Delay_V | 1 | PMSM | 2 | Vabc delayed |
| PMSM | 1 | BusSel | 1 | Info bus |
| PMSM | 2 | DTC_I | 1 | [Ia;Ib;Ic] (single) |
| DTC_I | 1 | Demux_I | 1 | [Ia;Ib;Ic] (double) |
| PMSM | 3 | DTC_Spd | 1 | Speed (single) |
| DTC_Spd | 1 | IIR_Spd | 1 | Speed (double) |

### Key Configuration
- **SpdRef (Step):** `FinalValue='speed_ref_rad'`, `InitialValue='0'`, `Time='0.1'`, `SampleTime='Ts_speed'` — note: Simulink Step uses `FinalValue`/`InitialValue` (NOT `After`/`Before`)
- **PI_speed:** `SampleTime=Ts_speed`, `UseKiTs='on'`, `I='Ki_speed*Ts_speed'`, saturation `±iq_sat`
- **BusSel:** `OutputSignals='MtrElcPos'` (simulation shortcut — no MechToElec needed)
- **VLimits:** MUST be `[Vmax; -Vmax; 0; 0]` — non-zero q-axis values cause silent motor drift
- **V2D:** `duty = Vabc/(2*Vmax) + 0.5` where `Vmax = Vdc/sqrt(3)`
- **No Rate Transitions** needed when BusSel uses 'MtrElcPos' and speed PI uses explicit SampleTime
- **StopTime:** Use `2` seconds minimum (Category A motors settle in ~0.5s; 0.5s StopTime hides issues)
- **speed_ref_rad:** Test at 70% of max_speed_rpm — NOT 90%. Near-max refs mask tuning problems via voltage limiting.

### Category A Speed Tuning (kt/J > 10,000 — MANDATORY)

**Do NOT use `calcFOCGains` Ki_speed for Category A motors.** It produces Ki~0.18 which causes integral windup → overshoot → oscillation. Use these values directly:

```matlab
% Category A defaults (proven stable):
Kp_speed = 0.0004;    % Proportional (can use calcFOCGains value)
Ki_speed = 0.005;     % MANUAL — 30-100x lower than calcFOCGains
iq_sat = 5 / (kt/pmsm.J * Ts_speed * 60/(2*pi));  % 5 RPM/step target
iq_sat = max(iq_sat, 0.01 * pmsm.I_rated);
% Expected: settling ~0.5s, overshoot ~40% (reduce with ramp reference)
```

**Why calcFOCGains fails here:** The integral accumulates during the acceleration ramp (PI saturated at iq_sat). With Ki=0.18, unwinding takes ~1.5s. With Ki=0.005, unwinding takes ~50ms. See `parameter-computation.md` for full derivation.

### Voltage Path Options

**Option A (full inverter model):** `FOC_CC → V2D_Gain(1/(2*Vmax)) → V2D_Bias(+0.5) → AVI(duty, Vdc) → Delay_V → PMSM`
- Use when modeling inverter nonlinearity, dead-time, or PWM effects
- AVI block: Use `"Average-Value Inverter"` (resolves by name via SATK) or dynamic resolution via `find_system('mcblib','SearchDepth',5,'Name','Average-Value Inverter')`

**Option B (direct — RECOMMENDED for simulation):** `FOC_CC → Delay_V → PMSM.u2`
- Simplest path, fewest blocks, proven stable
- FOC CC outputs Vabc in volts; PMSM.u2 accepts volts directly
- Omit: V2D_Gain, V2D_Bias, AVI, Vdc_Const from the block list
- Change connection: `FOC_CC | 1 | Delay_V | 1 | Vabc (volts)`

### Data Logging (MUST include in initial model_edit call)

**Include these blocks in the FIRST model_edit (layout_mode="full"):**
```json
[
  {"op": "add_block", "type": "To Workspace", "name": "ToWS_Speed", "ref": "tws", "params": {"VariableName": "speed_log", "SaveFormat": "Timeseries", "MaxDataPoints": "inf", "Decimation": "10", "SampleTime": "Ts_speed"}},
  {"op": "connect", "target": "IIR_Spd.y1 -> #tws.u1"}
]
```

- Access via `simOut.speed_log` — timeseries has own `.Time` at speed loop rate
- **MaxDataPoints must be 'inf'** — default (1000) truncates to last 50ms at Ts=50us
- **Do NOT try to add logging after the fact** via evaluate_matlab_code — always build it in
- **Do NOT use `DataLogging` param** on MCB masked blocks (IIR Filter, PI, SMO) — it doesn't exist on their masks

---

## Pattern B-Simple + MTPA + FW: FOC CC with Field Weakening

**Use when:** Speed control above base speed, automatic field weakening needed, FOC CC current control.

**Derives from:** Pattern B-Simple, replacing `Id_Ref=0` + direct `Sat_Iq→Mux` with MTPA Control Reference.

### Changes vs Pattern B-Simple
| Remove | Add | Purpose |
|--------|-----|---------|
| Id_Ref (Constant 0) | MTPA Control Reference | Computes optimal id*/iq* with FW |
| — | Sat_Tref (Saturate) | Torque limit (Nm, NOT Amps!) |

### Connection Table (differences from B-Simple)
| From Block | From Port | To Block | To Port | Signal |
|------------|-----------|----------|---------|--------|
| Spd_Err | 1 | PI_speed | 1 | Speed error |
| PI_speed | 1 | Sat_Tref | 1 | Unbounded torque cmd |
| Sat_Tref | 1 | MTPA | 1 | Torque ref (Nm) |
| DTC_Spd | 1 | IIR_Spd | 1 | Speed (double) |
| IIR_Spd | 1 | MTPA | 2 | **Mechanical rad/s (NO ×p!)** |
| IIR_Spd | 1 | Spd_Err | 2 | Speed feedback (−) |
| MTPA | 1 | Mux_IdqRef | 1 | id_ref (from MTPA+FW) |
| MTPA | 2 | Mux_IdqRef | 2 | iq_ref (from MTPA+FW) |
| Mux_IdqRef | 1 | FOC_CC | 1 | [id*; iq*] |

### Key Configuration
- **Sat_Tref:** `UpperLimit='T_rated'`, `LowerLimit='-T_rated'` where `T_rated = 1.5*pmsm.p*pmsm.FluxPM*pmsm.I_rated`
- **MTPA:** Must have `V_dc='inverter.V_dc'` to enable FW. Set `ilimit='pmsm.I_rated'`.
- **MTPA u2 is MECHANICAL rad/s** — do NOT add a Gain(pmsm.p) before it. Block converts internally.
- **PI_speed saturation:** Set to `±T_rated` (torque, not current). Or use separate Sat_Tref block.

### CPSR Check (before building)
```matlab
CPSR = 1 / (1 - pmsm.Ld * pmsm.I_rated / pmsm.FluxPM);
fprintf('CPSR = %.2fx (max speed = %.0f RPM)\n', CPSR, base_speed_rpm * CPSR);
% If CPSR < 1.2: FW range is very narrow, consider higher Vdc or different motor
```

---

## Pattern C: Torque-Only FOC (No Speed Loop)

**Use when:** Direct torque/current commands, no speed regulation needed.

Same as Pattern A but:
- REMOVE: Speed_Ref, Speed_Err, Speed_PI, RT_Tref, RT_spd, IIR_Spd
- Torque_Ref (Constant/Step) → MTPA/1 directly
- Speed feedback for MTPA/2: PMSM/3 → DTC_Spd → MTPA/2 (mechanical rad/s, no pole-pair gain)


----
Copyright 2026 The MathWorks, Inc.
----
