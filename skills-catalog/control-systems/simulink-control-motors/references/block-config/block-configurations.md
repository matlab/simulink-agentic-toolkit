# Block Configuration Reference — Control Blocks

> MCB control blocks: type for model_edit, mandatory parameters, port map, and gotchas.
> For plant/sensor/inverter blocks see `block-configurations-plants.md`.
> For tool selection rules see `tool-routing.md`.

---

## PI Controller

**Type (model_edit):** `"mcbcontrolslib/PI Controller"`
**CRITICAL:** Plain `"PI Controller"` resolves to slpidlib PID — always use full path.

**Strong Recommendation:** Always prefer `"mcbcontrolslib/PI Controller"` for current and speed loops. It provides correct defaults for motor control: discrete-time, Ki×Ts convention, built-in anti-windup with clamping, and 1-input mode. The standard `slpidlib/PID Controller` CAN work but requires significantly more configuration (see "Alternative: Standard PID" below) and is a common source of subtle bugs.

**Mandatory Parameters (1-Input Mode):**

| Parameter | Value | Notes |
|-----------|-------|-------|
| ControllerParametersSource | `"internal"` | MUST set — omitting gives 3-port mode |
| ExternalReset | `"none"` | MUST set — omitting gives 3-port mode |
| InitialConditionSource | `"internal"` | MUST set — omitting gives 3-port mode |
| UseKiTs | `"on"` | I param is Ki×Ts, not raw Ki |
| P | `"Kp_var"` | Proportional gain (workspace variable) |
| I | `"Ki_var * Ts"` | Integral gain × sample time |
| SampleTime | `"Ts"` | Must match loop rate |
| UpperSaturationLimit | `"Vmax"` | Physical upper bound |
| LowerSaturationLimit | `"-Vmax"` | Physical lower bound |

**Port Map (1-Input Mode):**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | Error signal (ref - feedback) |
| y1 | Output | Controller output |

**Gotchas:**
- All THREE params (`ControllerParametersSource`, `ExternalReset`, `InitialConditionSource`) must be set — omitting ANY causes 3-port mode (breaks wiring)
- `UseKiTs='on'` means the I parameter is Ki*Ts, not raw Ki
- Saturation limits must match physical bounds (e.g., Vmax for current PI, T_rated for speed PI)
- **Anti-windup modes:** Two options via `AntiWindupMode` parameter:
  - `'clamping'` (default) — integrator stops accumulating when output hits saturation
  - `'back-calculation'` — uses `Kb` gain to discharge integrator. Set `Kb` param (typical: 1.0). Better transient for high-inertia systems.
- Anti-windup is built-in when saturation limits are set
- **Multi-rate:** Speed PI MUST have `SampleTime` = `"Ts_speed"` set explicitly (inheriting model Ts gives wrong rate)
- **Block identity:** `mcbcontrolslib/PI Controller` resolves to `slpidlib/PID Controller` with MCB presets (`UseKiTs='on'`, discrete, PI mode). The ReferenceBlock will show `slpidlib/PID Controller` — this is CORRECT, not a failure.
- **`model_edit` `replace_block`** may silently fail to change PI block type. Always verify with `model_query_params` after replace. If needed, delete + add_block instead.
- **Parameter setting with mode switch:** All params (mode + gains + limits) CAN be set in a single `set_param` or `model_edit configure` call — P/I values survive the mode switch. However, `SampleTime` defaults to `-1` and `UpperSaturationLimit` defaults to `1` — always set these explicitly. If setting params fails in practice, use two-step: (1) set 3 mode params, (2) set P/I/SampleTime/Limits.
- **Speed PI integral windup (Category A motors, kt/J > 10000):** For ultra-responsive motors, even with `iq_sat` limiting, the PI integral accumulates aggressively during ramp-up and prevents braking after overshoot. Fix: use Ki_speed ≤ Kp_speed / (10 × expected_settling_time). For J~7e-6: Ki_speed ≈ 0.005 (NOT the value from calcFOCGains which is ~0.4).

### Alternative: Standard PID Controller (slpidlib)

Use `slpidlib/PID Controller` only when gain scheduling or external parameter ports are needed. If you choose this path, ALL of the following must be configured explicitly — omitting any one leads to silent misbehavior:

| Parameter | Value | Why |
|-----------|-------|-----|
| Controller | `"PI"` | Default is PID (includes derivative) |
| TimeDomain | `"Discrete-time"` | Default is continuous — WILL NOT work correctly even with SampleTime set |
| SampleTime | `"Ts"` | Must match loop rate |
| IntegratorMethod | `"Forward Euler"` | Matches MCB convention |
| LimitOutput | `"on"` | Default is off — saturation limits are ignored without this! |
| UpperSaturationLimit | `"Vmax"` | Only active when LimitOutput='on' |
| LowerSaturationLimit | `"-Vmax"` | Only active when LimitOutput='on' |
| AntiWindupMode | `"clamping"` | Prevents integrator windup |

**Ki convention difference:** Standard PID multiplies Ki by Ts internally (Forward Euler). Pass RAW Ki (not Ki*Ts) to the I parameter: `"I": "Ki_id"`. This is the OPPOSITE of the MCB PI Controller convention.

---

## Clarke Transform

**Type (model_edit):** `"Clarke Transform"` (resolves by name)

**Parameters:** None required (defaults are correct).

**Port Map:**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | Ia (Phase A current, scalar) |
| u2 | Input | Ib (Phase B current, scalar) |
| y1 | Output | Ialpha |
| y2 | Output | Ibeta |

**Gotchas:**
- Inputs must be SCALAR (Ia, Ib separately) — NOT a vector [Ia;Ib]
- Requires Demux before it if source is [Ia;Ib;Ic] vector
- Third phase (Ic) is computed internally — do NOT connect

---

## Inverse Clarke Transform

**Type (model_edit):** `"Inverse Clarke Transform"` (resolves by name)

**Parameters:** None required.

**Port Map:**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | Valpha |
| u2 | Input | Vbeta |
| y1 | Output | Va |
| y2 | Output | Vb |
| y3 | Output | Vc |

**Gotchas:**
- Outputs 3 scalars (Va, Vb, Vc) — use Mux to create [Va;Vb;Vc] vector for inverter

---

## Park Transform

**Type (model_edit):** `"Park Transform"` (resolves by name)

**Mandatory Parameters:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| ThetaInput | `"Electrical position"` | Without this → 4-input mode |
| AngleInput | `"Radians"` | Never 'Degrees' |

**Axis Convention (default, do NOT change):**
- `AxisAlignment = 'D-axis'` — at θ_e=0, alpha-axis (Phase A) aligns with d-axis (rotor flux)
- This matches the PMSM plant's internal convention: `MtrElcPos` = d-axis electrical angle
- Math: `Id = Iα·cos(θ_e) + Iβ·sin(θ_e)`, `Iq = −Iα·sin(θ_e) + Iβ·cos(θ_e)`
- The PMSM Info bus `IdSync`/`IqSync` use this same convention — external Park with `MtrElcPos` matches exactly

**Port Map (3-Input Angle Mode):**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | Ialpha (or any alpha-axis signal) |
| u2 | Input | Ibeta (or any beta-axis signal) |
| u3 | Input | theta_e (electrical angle, radians) |
| y1 | Output | Id (d-axis) |
| y2 | Output | Iq (q-axis) |

**Gotchas:**
- Without `ThetaInput="Electrical position"`, block defaults to 4-input mode (sin/cos separate) — this causes SILENT FAILURE: connections appear OK but port 3 receives sin(theta) instead of theta, producing garbage dq output
- `AngleInput` MUST be `"Radians"` — never `"Degrees"` (downstream blocks assume radians)
- theta_e must be electrical angle (= mechanical_angle × pole_pairs)
- Do NOT change `AxisAlignment` from default `'D-axis'` — it must match the PMSM plant convention
- **Verification after add_block:** Always confirm 3 inports with `model_query_params` or check port count. If 4 inports exist, the ThetaInput param was not applied.
- **Symptom of wrong mode:** Park_iq ≠ IqSync (correlation < 0.9) while angle is correct. If you see this, check ThetaInput.

---

## Inverse Park Transform

**Type (model_edit):** `"Inverse Park Transform"` (resolves by name)

**Mandatory Parameters:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| ThetaInput | `"Electrical position"` | Same as Park Transform |
| AngleInput | `"Radians"` | — |

**Axis Convention:** Same as Park Transform — `AxisAlignment = 'D-axis'` (default, do not change).

**Port Map (3-Input Angle Mode):**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | Vd (d-axis voltage) |
| u2 | Input | Vq (q-axis voltage) |
| u3 | Input | theta_e (electrical angle, radians) |
| y1 | Output | Valpha |
| y2 | Output | Vbeta |

---

## MTPA Control Reference

**Type (model_edit):** `"mcbcontrolslib/MTPA Control Reference"`
**Fallback (if SATK fails):** `find_system('mcblib','SearchDepth',5,'Name','MTPA Control Reference')` → `get_param(blks{1},'ReferenceBlock')` → `add_block`

**Mandatory Parameters (SI Units, Interior PMSM):**

| Parameter | Value | Notes |
|-----------|-------|-------|
| Units | `"SI Units"` | Or `"PU"` for per-unit |
| VariantSelect | `"Interior PMSM"` | Or `"Surface PMSM"` (id*=0) |
| polePairs | `"pmsm.p"` | Pole pairs |
| Rs | `"pmsm.Rs"` | Stator resistance |
| Ld | `"pmsm.Ld"` | d-axis inductance |
| Lq | `"pmsm.Lq"` | q-axis inductance |
| FluxPM | `"pmsm.FluxPM"` | PM flux linkage |
| ilimit | `"pmsm.I_rated"` | Current limit (defaults to 7.1 — ALWAYS override!) |
| V_dc | `"inv.V_dc"` | Enables automatic field weakening |
| N_base | `"N_base_rpm * 2"` | Upper speed for FW region |
| I_base | `"PU_System.I_base"` | Base current |
| T_base | `"PU_System.T_base"` | Base torque |
| V_base | `"PU_System.V_base"` | Base voltage |

**Port Map (SI, with Vdc):**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | Torque reference (Nm) |
| u2 | Input | Speed feedback — **mechanical rad/s** (block converts internally using `polePairs`) |
| y1 | Output | id_ref (A) |
| y2 | Output | iq_ref (A) |

**CRITICAL — u2 speed input unit:**
- Feed **mechanical speed in rad/s** directly from `PMSM.y3 → DTC_Spd` (or `IIR_Spd` output)
- Do NOT multiply by pole pairs — the block handles conversion internally via `polePairs` mask parameter
- Feeding electrical rad/s (wm×p) causes FW to engage at ~1/p of the correct speed (e.g., at 25% of base speed for p=4), producing id*=-I_rated and iq*=0 (no torque, motor stalls)

**Variants:**
- `"Interior PMSM"`: Uses Ld < Lq, computes MTPA curve
- `"Surface PMSM"`: id_ref = 0, iq_ref = T_ref / (1.5 × p × FluxPM)

**Integration with Speed PI (Pattern B + MTPA + FW):**

When combining MTPA with speed PI (instead of Pattern B-Simple's direct iq_ref):
```
PI_speed → Sat_Tref(±T_rated) → MTPA.u1 (torque in Nm)
DTC_Spd (or IIR_Spd) → MTPA.u2 (mechanical rad/s — NO Gain_we!)
MTPA.y1 → Mux_IdqRef.u1 (id*)
MTPA.y2 → Mux_IdqRef.u2 (iq*)
Mux_IdqRef → FOC_CC.u1
```
- Saturation on PI output must be in **Nm** (use ±T_rated or ±0.8*T_rated), NOT in Amps
- Using iq_sat (Amps) as the limit makes the torque command too small for acceleration

**Gotchas:**
- `V_dc` param enables automatic FW — without it, no field weakening
- **Speed input is MECHANICAL rad/s** — block multiplies by polePairs internally. Feeding electrical rad/s causes premature FW engagement.
- `ilimit` defaults to 7.1A — MUST override with actual motor I_rated
- For PU mode: set `'Units', 'PU'` and provide base values
- MTPA FW saturates quickly for motors with small Ld (characteristic current FluxPM/Ld >> I_rated limits CPSR)
- **MTPA contains internal continuous states** — incompatible with `FixedStepDiscrete` solver. Use `ode3` (or `ode4`) fixed-step solver with `FixedStep=Ts` when MTPA is in the model.

---

## PMSM FeedForward Control

**Type (model_edit):** `"PMSM FeedForward Control"` (resolves by name via SATK)
**Fallback (if SATK fails):** `find_system('mcblib','SearchDepth',5,'Name','PMSM FeedForward Control')` → `get_param(blks{1},'ReferenceBlock')` → `add_block`

**Mandatory Parameters:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| nonLinearityChoice | `"Linear model with lumped parameters"` | |
| Units | `"SI Units"` | |
| Ld | `"pmsm.Ld"` | d-axis inductance |
| Lq | `"pmsm.Lq"` | q-axis inductance |
| FluxPM | `"pmsm.FluxPM"` | PM flux linkage |
| polePairs | `"pmsm.p"` | Pole pairs |

**Port Map:**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | id_measured (A) |
| u2 | Input | iq_measured (A) |
| u3 | Input | we (electrical speed, rad/s = wm × p) |
| y1 | Output | Vd_ff (V) |
| y2 | Output | Vq_ff (V) |

**Formulas:**
- `Vd_ff = -we * Lq * iq`
- `Vq_ff = +we * (Ld * id + FluxPM)`

**Gotchas:**
- Sign convention: Vd_ff is NEGATIVE (cross-coupling cancellation)
- Speed input is ELECTRICAL (we = wm * p), not mechanical

### Mode 4: Runtime Ld/Lq/FluxPM Input Ports (Nonlinear FeedForward)

Set `nonLinearityChoice` to `"Non-linear model with runtime inputs"` to expose additional input ports for operating-point-dependent parameters:

| Parameter | Value |
|-----------|-------|
| `nonLinearityChoice` | `"Non-linear model with runtime inputs"` |

**Port Map (Mode 4):**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | id_measured (A) |
| u2 | Input | iq_measured (A) |
| u3 | Input | we (electrical speed, rad/s) |
| u4 | Input | Ld (H) — runtime value from LUT |
| u5 | Input | Lq (H) — runtime value from LUT |
| u6 | Input | FluxPM (Wb) — runtime value from LUT |
| y1 | Output | Vd_ff (V) |
| y2 | Output | Vq_ff (V) |

**Use with gain scheduling:** Feed Ld(id,iq), Lq(id,iq), FluxPM(id,iq) from 2-D Lookup Tables driven by measured dq currents. This gives correct feedforward even for highly saturated IPM motors where Ld and Lq vary 2-3× across the operating range.

**Gotchas:**
- Mode 4 port count changes — existing wiring breaks when switching from linear mode
- LUT outputs for Ld/Lq must use SAME breakpoints as gain scheduling LUTs (consistency)
- FluxPM LUT is optional for SPM (constant) but critical for IPM under deep saturation
- If Ld/Lq/FluxPM inputs are noisy, add IIR filter (cutoff ~100 Hz) to avoid FF voltage spikes

---

## PWM Reference Generator

**Type (model_edit):** `"mcbcontrolslib/PWM Reference Generator"`

**Mandatory Parameters:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| inSignal | `"Valphabeta"` | Input format |
| inputUnits | `"Per-unit"` | Inputs must be normalized by Vmax |
| modType | `"SVM: space vector modulation"` | See options below |

**Port Map:**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | Valpha_PU (normalized: Valpha / Vmax) |
| u2 | Input | Vbeta_PU (normalized: Vbeta / Vmax) |
| y1 | Output | Da (duty cycle A, [0,1]) |
| y2 | Output | Db (duty cycle B, [0,1]) |
| y3 | Output | Dc (duty cycle C, [0,1]) |

**Output Modes (`enableDutyCycle`):**
| Setting | Output Range | Feed To | Conversion |
|---------|-------------|---------|------------|
| `"off"` (DEFAULT) | Modulation [-1.15, +1.15] | AVI directly | NONE — AVI accepts modulation via internal Switch |
| `"on"` | Duty [0, 1] | Gate drivers / PWM hardware | None needed |

**When feeding Average-Value Inverter:** Use `enableDutyCycle='off'` (default). The AVI's internal Switch detects modulation-range input and applies `Vabc = modulation × Vdc/2`. No V2D conversion needed.

**`inSignal='Valphabeta'` eliminates InvClarke:** With this input mode, PWM_RefGen takes Valpha/Vbeta directly (from InvPark outputs) and generates 3-phase modulation/duty internally. The entire signal path becomes:
```
InvPark.y1(Valpha) → Gain(1/Vmax) → PWM_RefGen.u1
InvPark.y2(Vbeta)  → Gain(1/Vmax) → PWM_RefGen.u2
PWM_RefGen.y1/y2/y3 → Mux(3) → AVI.u1
```
No InvClarke Transform block is needed.

**`expandVoltageOutput` parameter:**
| Setting | Output | Use |
|---------|--------|-----|
| `"on"` (DEFAULT) | 3 separate scalar ports (y1=Da, y2=Db, y3=Dc) | Need Mux(3) before AVI |
| `"off"` | Single [3×1] vector on y1 | Feed directly to Delay → AVI.u1 |

**`expandVoltageInput` parameter (controls input port structure):**
| inputUnits | expandVoltageInput | Input ports | Description |
|------------|-------------------|-------------|-------------|
| Per-unit | `"off"` (default) | 1: [Valpha_PU; Vbeta_PU] vector | Single vector input |
| Per-unit | `"on"` | 2: Valpha_PU, Vbeta_PU scalars | Expanded to scalar ports |
| SI | `"off"` | 2: [Valpha; Vbeta] vector + ? | Behavior undefined — avoid |
| SI | `"on"` | 3: Valpha(V), Vbeta(V), Vdc(V) | **RECOMMENDED for SI mode** |

**Input Modes (`inputUnits`):**
| Setting | Value to set | Reads back as | Normalization |
|---------|-------------|---------------|---------------|
| Per-unit (DEFAULT) | `"Per-unit"` | `"Per-unit"` | External: `Gain(1/Vmax)` where Vmax=Vdc/sqrt(3) |
| SI unit | `"SI"` | `"SI unit"` | Internal: block normalizes using Vdc port |

**SI mode details:** Set `inputUnits='SI'` and `expandVoltageInput='on'` — a 3rd input port appears for Vdc. Feed raw SI voltages from InvPark and Vdc directly. No external Gain(1/Vmax) needed.
```json
{"op": "configure", "target": "PWM_RefGen", "params": {"inSignal": "Valphabeta", "inputUnits": "SI", "expandVoltageInput": "on", "enableDutyCycle": "off", "expandVoltageOutput": "off"}}
```
Port map in SI mode: u1=Valpha(V), u2=Vbeta(V), u3=Vdc(V), y1=modulation [3×1]

**Gotchas:**
- There is NO `Vmax` mask parameter — normalization in SI mode uses Vdc INPUT PORT (not a param)
- With `inputUnits='Per-unit'`: input MUST be normalized by `Vdc/sqrt(3)` externally (Gain block)
- With `inputUnits='SI'`: set `expandVoltageInput='on'` to get the Vdc port; with `'off'` the port disappears and behavior is undefined
- `enableDutyCycle='off'` outputs modulation (NOT duty) — this is CORRECT for AVI path (no conversion needed)
- `enableDutyCycle='on'` outputs duty [0,1] — use for direct PWM hardware or when V2D is not wanted
- `expandVoltageOutput='on'` (default) gives 3 separate scalar ports — set `'off'` for single [3×1] vector output to avoid needing Mux before AVI
- `modType` options: `"SVM: space vector modulation"`, `"SPWM: sinusoidal PWM"`, `"DPWM: discontinuous PWM"`
- **Legacy DTheta mode** (`inSignal='DTheta'`): theta input is **per-unit [0,1)** NOT radians. Rarely used — prefer `Valphabeta` mode.

---

## Field-Oriented Current Controller (FOC CC)

**Type (model_edit):** `"mcbfoclib/Field-Oriented Current Controller"`

This is the **internal library reference** — stable across all MATLAB releases since R2020b. The mcblib browser path changes between releases (e.g., `mcblib/Controls/Controllers/...` in R2025b vs `mcblib/Control/Synchronous Machine/Controllers/...` in R2026a), but the internal `mcbfoclib/` path always works for `add_block` and `model_edit`.

**CRITICAL:** The short name `"Field-Oriented Current Controller"` does NOT resolve — you MUST use the full internal path `"mcbfoclib/Field-Oriented Current Controller"`. Using the short name produces "no block named" error.

**Mask Parameters (settable via model_edit configure):**

| Parameter | Value | Notes |
|-----------|-------|-------|
| AngleUnit | `"Radians"` | MUST set — default may be Degrees |
| SaturationMethod | `"D-Q Equivalence"` | Voltage limiting method |
| PWMMethod | `"SVM: space vector modulation"` | Internal modulation |

**NOT valid mask params (common mistake):** `Units`, `polePairs`, `SampleTime` — these do NOT exist on the FOC CC mask. Pole pairs and sample time are configured internally via the model's workspace variables used in gain computation. The block inherits its sample time from the model solver (FixedStep = Ts).

**Port Map:**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | [id_ref; iq_ref] (2×1 vector) |
| u2 | Input | [Ia; Ib] (2×1 vector, phase currents) |
| u3 | Input | theta_e (electrical angle, rad) |
| u4 | Input | Vmax (= Vdc/sqrt(3)) |
| u5 | Input | [Kp_d; Ki_d*Ts; Kp_q; Ki_q*Ts] (4×1 gains) |
| u6 | Input | [Vd_max; Vd_min; Vq_max; Vq_min] (4×1 limits) |
| u7 | Input | Enable (1=run, 0=hold) |
| y1 | Output | Vabc (3×1 phase voltages, VOLTS) |
| y2 | Output | Debug (internal signals — typically unused) |

**Port Dimensions (CRITICAL — dimension mismatch is the #1 build error):**
| Port | Size | Typical Source Block |
|------|------|---------------------|
| u1 | 2×1 | Mux(2): [Id_Ref; Iq_Ref] or [Id_Ref; Sat_Iq_output] |
| u2 | 2×1 | Mux(2): [Ia; Ib] from Demux_I ports 1,2 |
| u3 | 1×1 | BusSel('MtrElcPos') or MechToElec output |
| u4 | 1×1 | Constant(Vmax) where Vmax = Vdc/sqrt(3) |
| u5 | 4×1 | Constant([Kp_d; Ki_d*Ts; Kp_q; Ki_q*Ts]) |
| u6 | 4×1 | Constant([Vmax; -Vmax; 0; 0]) — see CRITICAL note below |
| u7 | 1×1 | Constant(1) for always-enabled |
| y1 | 3×1 | Vabc voltages → V2D conversion → AVI |
| y2 | varies | Debug bus (typically unconnected) |

**Wiring Pattern (model_edit operations for basic speed control):**
```json
[
  {"op": "add_block", "type": "Constant", "name": "Id_Ref", "params": {"Value": "0"}},
  {"op": "add_block", "type": "Mux", "name": "Mux_IdqRef", "ref": "miq", "params": {"Inputs": "2"}},
  {"op": "add_block", "type": "Mux", "name": "Mux_Iab", "ref": "mia", "params": {"Inputs": "2"}},
  {"op": "add_block", "type": "Constant", "name": "Vmax_Const", "params": {"Value": "Vmax"}},
  {"op": "add_block", "type": "Constant", "name": "PIGains", "params": {"Value": "[Kp_id; Ki_id*Ts; Kp_i; Ki_i*Ts]"}},
  {"op": "add_block", "type": "Constant", "name": "VLimits", "params": {"Value": "[Vmax; -Vmax; 0; 0]"}},
  {"op": "add_block", "type": "Constant", "name": "EnableFOC", "params": {"Value": "1"}},
  {"op": "connect", "target": "Id_Ref.y1 -> #miq.u1"},
  {"op": "connect", "target": "Sat_Iq.y1 -> #miq.u2"},
  {"op": "connect", "target": "#miq.y1 -> FOC_CC.u1"},
  {"op": "connect", "target": "Demux_I.y1 -> #mia.u1"},
  {"op": "connect", "target": "Demux_I.y2 -> #mia.u2"},
  {"op": "connect", "target": "#mia.y1 -> FOC_CC.u2"},
  {"op": "connect", "target": "BusSel.y1 -> FOC_CC.u3"},
  {"op": "connect", "target": "Vmax_Const.y1 -> FOC_CC.u4"},
  {"op": "connect", "target": "PIGains.y1 -> FOC_CC.u5"},
  {"op": "connect", "target": "VLimits.y1 -> FOC_CC.u6"},
  {"op": "connect", "target": "EnableFOC.y1 -> FOC_CC.u7"}
]
```

**Gotchas:**
- Output is VOLTS (not duty) — requires V2D conversion for AVI, OR connect directly to UnitDelay → PMSM.u2 (simulation-only shortcut, bypasses inverter model)
- Port u5 gains use Ki×Ts format (same as PI Controller `UseKiTs='on'`)
- **CRITICAL — Port u6 limits MUST be `[Vmax; -Vmax; 0; 0]`:** Elements 3-4 = 0 enables internal DQ voltage circle limiting (dynamic q-axis limit). Setting non-zero q-axis limits (e.g., `[Vmax; -Vmax; Vmax; -Vmax]`) overrides the internal DQ limiter and causes **silent motor drift** (motor runs at constant negative speed with no error message). This is the #1 FOC CC configuration trap.
- Internally performs Clarke, Park, InvPark, InvClarke — do NOT add external transforms
- PIConfig `[0;0;0;0]` clamps output to zero — NEVER use this
- **Internal port names** differ from documentation: IdqRef(u1), IabMeas(u2), ThetaE(u3), VSatLim(u4), Kp_KiTs(u5), PIConfig(u6), Enable(u7) — always use port NUMBERS, not names
- **Common error:** Feeding scalar id_ref to u1 — u1 ALWAYS needs a 2-element Mux
- **Direct voltage path (simulation shortcut):** For simulation-only models, skip V2D+AVI entirely: `FOC_CC.y1 → UnitDelay → PMSM.u2`. The FOC CC outputs Vabc in volts, which the PMSM accepts directly. This avoids AVI scaling issues and is the simplest working path.
- **DecouplingEnable parameter:** FOC CC may have internal cross-coupling decoupling (`DecouplingEnable`). If present, enabling adds `we*Ld*id` and `-we*Lq*iq` feedforward internally, eliminating the need for an external PMSM FeedForward block. Check with `model_query_params` — if not present in your release, use external FeedForward block.
- **Action subsystem data dependency (GAIN SCHEDULING BLOCKER):** When MCB PI Controller uses `ControllerParametersSource='external'` for gain scheduling, internal action subsystems create "Input data dependency violation" errors in closed-loop with transforms. **Workaround:** Use `slpidlib/PID Controller` with `ControllerParametersSource='external'` instead (no action subsystems). Alternatively, replace MCB PI blocks entirely with manual PI (Sum + Gain + Discrete Integrator).

---

## LUT Control Reference

**Type (model_edit):** `"LUT based PMSM Control Reference"` (resolves by name via SATK)

**Mandatory Parameters:**

| Parameter | Value | Notes |
|-----------|-------|-------|
| Units | `"SI Units"` or `"Per-Unit (PU)"` | **Default is PU** — set explicitly. See unit modes below |
| idTable | `"PMSMLUT.idTable"` | [nTorque × nSpeed] matrix |
| iqTable | `"PMSMLUT.iqTable"` | [nTorque × nSpeed] matrix |
| trefVec | `"PMSMLUT.trefVec"` | Torque breakpoints — must be symmetric! |
| wrpmVec | `"PMSMLUT.wrpmVec"` | Speed breakpoints — positive only |
| ilimit | `"pmsm.I_rated"` | **Default 7.1A — ALWAYS override** |

**Unit Modes:**

| Units | u1 (Torque) | u2 (Speed) | y1/y2 (id/iq) | Base Values Required |
|-------|-------------|------------|----------------|---------------------|
| `"SI Units"` | Nm | rad/s (mechanical) | A | None |
| `"Per-Unit (PU)"` | PU (Tref/T_base) | PU (RPM/N_base) | PU (I/I_base) | V_base, I_base, N_base, T_base |

**PU mode note:** When using PU, set `V_base`, `I_base`, `N_base`, `T_base` mask params. If motor parameters (I_rated, etc.) change, T_base and other bases must be recomputed via `mcb.getPUSystemParameters` — they don't auto-update.

**Port Map:**
| Port | Notation | Signal |
|------|----------|--------|
| u1 | Input | Torque reference (Nm if SI, PU if PU) |
| u2 | Input | Speed (rad/s if SI, PU if PU) — positive only, use abs() |
| y1 | Output | id_ref (A if SI, PU if PU) |
| y2 | Output | iq_ref (A if SI, PU if PU) |

**Vdc_input_select modes (variable DC bus):**
| Mode | Ports | Use When |
|------|-------|----------|
| `'Specify via dialog'` | 2 in (Tref, wm) | Constant Vdc (lab bench) |
| `'Input port - use 2D LUT (scaled-w based)'` | 3 in (+Vdc) | Small Vdc variation (±15%) |
| `'Input port - use 3D LUT (voltage slice based)'` | 3 in (+Vdc) | Wide Vdc swings (EV battery) |

**Gotchas:**
- `trefVec` (torque breakpoints) must be symmetric for bidirectional: `[-flip(pos(2:end)), pos]`
- `wrpmVec` must be positive only — use `abs(speed)` for input
- Tables encode MTPA + FW + MTPV trajectory (pre-computed offline)
- `vdcVec` param is **lowercase** `v` (easy to miss)
- `ilimit` defaults to 7.1A — ALWAYS override with actual motor I_rated

----
Copyright 2026 The MathWorks, Inc.
----
