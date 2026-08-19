# Composition Rules

> ADD features to a base FOC model. Pick a pattern from `wiring-topologies.md`, then follow sections below.
> Check compatibility in `composition-rules-combining.md` before stacking features.
>
> **Implementation:** Use `model_edit` for structural changes (add_block, connect, configure).
> Use `evaluate_matlab_code` only for computation (PI gains, PU system, workspace storage, simulation).
> See `tool-routing.md` for complete tool selection guide.
---

## Feature: Field Weakening (FW / FWC)

### Option A: Automatic via MTPA Control Reference (simplest)

**Prerequisites:** Model uses MTPA Control Reference block.

**Changes:**
```json
[
  {"op": "configure", "target": "MTPA", "params": {"Vdc_input_select": "Specify via dialog", "V_dc": "inverter.V_dc"}}
]
```

**That's it.** Block automatically outputs more-negative id* when speed > base speed.

**CRITICAL — Speed input (u2) must be MECHANICAL rad/s:**
- Feed `DTC_Spd` output (or `IIR_Spd`) directly — do NOT multiply by pole pairs
- The block converts to electrical internally using its `polePairs` mask parameter
- Wrong unit (electrical rad/s) causes FW to engage at 1/p of the correct speed

**Full wiring for Pattern B + MTPA + FW:**
```
Speed_PI → Sat_Tref(±T_rated Nm) → MTPA.u1 (torque command)
PMSM.y3 → DTC_Spd → IIR_Spd → MTPA.u2 (mechanical rad/s)
                                 ↓ also → Spd_Err.u2 (speed feedback)
MTPA.y1 (id*) → Mux_IdqRef.u1
MTPA.y2 (iq*) → Mux_IdqRef.u2
Mux_IdqRef → FOC_CC.u1
```
**Note:** Saturation between PI and MTPA must be in **Nm** (torque), not Amps. The MTPA block handles current limiting via `ilimit`. Using iq_sat (Amps) as saturation value is a common mistake that starves the MTPA of torque authority.

**Limitations:** Does NOT implement MTPV. Only follows voltage ellipse. For motors with FluxPM/Ld >> I_rated, the CPSR is narrow (< 1.5×).

### Option B: Automatic via LUT Control Reference (best for nonlinear)

**Prerequisites:** PMSMLUT data with wrpmVec covering full speed range.

**Changes:** None — LUT already encodes MTPA + FW + MTPV trajectory in idTable/iqTable.

### Option C: Manual Voltage-Feedback FW (adaptive to Vdc changes)

**Prerequisites:** Working FOC with PI current controllers producing Vd, Vq.

**Blocks to add:** Sum, PI Controller (FW), Saturate, Unit Delay, Math Function (sqrt), Constant (Vmax)

**Wiring:**
```
Vd ──┐
     ├──► sqrt(Vd²+Vq²) ──► [Unit Delay] ──► Sum(Vmax - Vs_delayed)
Vq ──┘                                              │
                                                     ▼
                                               FW_PI (Ki only, anti-windup)
                                                     │
                                                     ▼
                                    Saturate([-Imax, 0]) ──► Sum(id_mtpa + id_fw) ──► id_ref
```

**Critical:** Unit Delay on Vs_magnitude BEFORE comparator — breaks algebraic loop.

**Reference:** See `examples/example_nonlinear_gain_sched.m` for FW+GainSched

### Common Mistakes

1. **Forgetting Vdc on MTPA block** — Block needs `V_dc` to compute FW trajectory.
2. **No voltage margin** — Use 95%: `Vmax = 0.95 * Vdc/sqrt(3)` for PI headroom.
3. **Wrong speed units** — MTPA u2 expects MECHANICAL rad/s. Do NOT feed electrical rad/s (wm×p). The block converts internally.
4. **Saturation in wrong units** — When PI_speed → MTPA, use ±T_rated (Nm) for saturation, NOT ±iq_sat (Amps). The MTPA interprets u1 as torque.
5. **Motor CPSR too low** — If FluxPM/Ld >> I_rated (e.g., >20×), FW capability is extremely limited. Motor may only achieve 5-10% above base speed.

---

## Feature: Sensorless (SMO)

**Prerequisites:** Working FOC with Clarke and InvPark transforms producing Ialpha/Ibeta and Valpha/Vbeta.

**Blocks to add:**
- Sliding Mode Observer — use type `"Sliding Mode Observer"` (resolves by name via SATK)
- I-F Controller (or manual I/f ramp) for startup
- Switch (angle handoff) + Switch (speed handoff)
- Abs (speed threshold criterion for Switch blocks)
- DTC (single→double after SMO outputs — two separate blocks: one for theta, one for speed)
- **Voltage path (Pattern B only):** Demux (3 outputs), Clarke Transform (named `Clarke_V`), Terminator (for unused Vc)
- Constant(0) — connects to SMO Reset port (u5)

**GUARDRAIL — Do NOT use Mux for SMO voltage inputs:**
SMO ports u1 (Valpha) and u2 (Vbeta) are **separate scalar** inputs. Feeding a [2×1] vector from a Mux causes dimension propagation errors throughout the model. Always use individual Clarke Transform outputs connected to separate SMO ports.

**Signals to tap:**
- Valpha, Vbeta from InvPark output (ports 1, 2)
- Ialpha, Ibeta from Clarke output (ports 1, 2)

**Wiring changes:**
```
REMOVE: BusSel(MtrElcPos) ──► Park/3, InvPark/3

ADD:
  InvPark/1 (Valpha) ──► SMO/1
  InvPark/2 (Vbeta)  ──► SMO/2
  Clarke/1 (Ialpha)  ──► SMO/3
  Clarke/2 (Ibeta)   ──► SMO/4
  Constant(0)        ──► SMO/5 (Reset)

  SMO/1 (theta_e) ──► DTC ──┐
  IF_theta ──────────────────┤──► Switch ──► Park/3, InvPark/3
  SpeedCheck (|wm|>threshold)┘

  SMO/2 (omega_m) ──► DTC ──► speed feedback (replaces BusSel MtrSpd)
```

**SMO parameter setup:**

Step 1 — Compute parameters (`evaluate_matlab_code`):
```matlab
% CRITICAL: inverter struct MUST have ISenseMax field for mcb.getPUSystemParameters
% Without it you get: "Unrecognized field name ISenseMax"
inverter.ISenseMax = pmsm.I_rated * 2;  % Current sensor max range (A)

PU_System = mcb.getPUSystemParameters(pmsm, inverter);
smo_params = mcb.computeSMOParameters(pmsm, Ts, PU_System);
% Store in workspace for model_edit string references
mdlWks = get_param(mdl, 'ModelWorkspace');
assignin(mdlWks, 'smo', smo_params);
assignin(mdlWks, 'PU_System', PU_System);
```

Step 2 — Configure block (`model_edit`):
```json
[
  {"op": "configure", "target": "SMO", "params": {
      "StatorResistance": "pmsm.Rs",
      "StatorInductance": "(pmsm.Ld + pmsm.Lq)/2",
      "DisturbanceObserverGain": "smo.BackEmfObsGain",
      "CurrentObserverGain": "smo.CurrentObsGain",
      "CutoffFreq": "smo.CutoffFreq",
      "PolePairs": "pmsm.p",
      "MaxApplicationSpeed": "PU_System.N_base * 2",
      "PerUnitSpeed": "PU_System.N_base * 2",
      "PositionUnit": "Radians",
      "SpeedUnit": "Radians/Sec"}}
]
```
**Note:** `PerUnitSpeed` MUST equal `MaxApplicationSpeed` — mismatch causes speed bias.
**CRITICAL:** `PositionUnit` and `SpeedUnit` default to `"Degrees"` / `"Degrees/sec"`. You MUST set them to `"Radians"` / `"Radians/Sec"` — Park/InvPark expect radians, and speed feedback expects rad/s.

**Critical wiring notes:**
- SMO/5 (Reset) requires an explicit `Constant(0)` block — leaving it unconnected causes error
- Two separate DTC blocks needed: one for theta_e (SMO/1), one for omega_m (SMO/2)
- SMO speed output replaces `PMSM/3 → IIR_Spd/1` in the feedback path
- Need ≥20 samples per electrical cycle: verify `1/(f_e_max * Ts) > 20`

**Pattern B (FOC CC block) — voltage signal path:**

When using FOC CC (Pattern B/B-Simple), the block outputs `V_abc` (3×1 volts) on y1 and `Debug` on y2. There is no direct Valpha/Vbeta output. To feed the SMO:
```
FOC_CC.y1 (Vabc) → Demux(3) → Clarke_V(Va, Vb) → SMO.u1(Valpha), SMO.u2(Vbeta)
                             → Term_Vc (discard Vc)
```
Current path remains the same as Pattern A:
```
PMSM.y2 → DTC_I → Demux_I → Clarke_I(Ia, Ib) → SMO.u3(Ialpha), SMO.u4(Ibeta)
```

**Incompatibilities:**
- SMO fails below ~5% rated speed (use I/f startup below that)
- SMO outputs are SINGLE precision — add DTC before double-precision blocks
- HFI requires SINGLE inputs — different from SMO path

**Simulation Behavior:**
- **SMO y1 (angle):** Works in simulation with Switch-based handoff. Expect ~8° mean steady-state angle error (acceptable for simulation; converges better on hardware with physical back-EMF). The internal `angleCompensation/atan1` uses single-precision and may produce NaN on reset→run transitions at very low speed — avoid switching to SMO below 10% rated speed.
- **SMO y2 (speed):** Works in simulation. Produces valid speed estimates once motor is above ~10% rated speed. Precision warnings (single→double) are normal and harmless.
- **SMO Reset:** Use `Constant(0)` (always running). Do NOT use Reset=1 for "monitoring only" — the observer state must accumulate to produce valid estimates.
- **Key requirement:** SMO needs sufficient back-EMF magnitude to track angle. Below ~5-10% rated speed, estimation fails — use true angle or I-F Controller for startup.

**Recommended Simulation Pattern (Switch-based handoff — MANDATORY):**
```
Architecture: SMO in-loop with Switch fallback to true angle at low speed

Angle path:
  SMO.y1 → DTC_SMO_theta(double) → Angle_Switch.u1  (SMO angle — used above threshold)
  IIR_Spd → Abs_Spd → Angle_Switch.u2               (criterion: |speed| > 10% of ref)
  BusSel('MtrElcPos') → Angle_Switch.u3              (true angle — used at startup)
  Angle_Switch.y1 → FOC_CC.u3                        (angle to FOC)

Speed path:
  SMO.y2 → DTC_SMO_spd(double) → Speed_Switch.u1    (SMO speed — used above threshold)
  DTC_Spd → Abs_Spd2 → Speed_Switch.u2              (criterion: |speed| > 10% of ref)
  DTC_Spd → Speed_Switch.u3                          (true speed — used at startup)
  Speed_Switch.y1 → IIR_Spd                          (speed to control loop)

Switch config: Criteria='u2 > Threshold', Threshold='0.1 * speed_ref_rad'
```
This gives true sensorless operation above the speed threshold while using encoder fallback during startup. Typical results: settling ~0.4s, overshoot ~15%, SMO angle error ~8° mean at steady state.

**model_edit for Switch blocks:**
```json
[
  {"op": "add_block", "type": "Switch", "name": "Angle_Switch", "ref": "asw", "params": {"Criteria": "u2 > Threshold", "Threshold": "0.1 * speed_ref_rad"}},
  {"op": "add_block", "type": "Switch", "name": "Speed_Switch", "ref": "ssw", "params": {"Criteria": "u2 > Threshold", "Threshold": "0.1 * speed_ref_rad"}},
  {"op": "add_block", "type": "Abs", "name": "Abs_Spd", "ref": "absspd"},
  {"op": "add_block", "type": "Abs", "name": "Abs_Spd2", "ref": "absspd2"}
]
```

**Reference:** See `examples/example_hfi_smo_hybrid.m` for SMO+HFI

### Common Mistakes

1. **Default units are DEGREES** — `PositionUnit` defaults to `"Degrees"` and `SpeedUnit` defaults to `"Degrees/sec"`. Omitting `"PositionUnit": "Radians"` and `"SpeedUnit": "Radians/Sec"` causes the angle output to be ~57× larger than expected (degrees vs radians), completely breaking Park/InvPark transforms and producing near-zero torque.
2. **Wrong PerUnitSpeed** — `PerUnitSpeed` MUST equal `MaxApplicationSpeed`. If they differ, SMO speed output has a bias = MaxAppSpeed/PerUnitSpeed. This causes incorrect speed feedback and unstable control.
3. **Forgetting DTC after SMO outputs** — SMO outputs are `single` precision. Downstream blocks (Sum, PI, etc.) expect `double`. Without Data Type Conversion, you get type mismatch errors or silent precision loss.
4. **CutoffFreq too low** — The PLL cutoff frequency must exceed `MaxSpeed * PolePairs / 60 * 2` (twice the max electrical frequency). Too low causes phase lag in angle estimation, leading to FOC instability at high speeds.

### V2D Gain Selection for Sensorless (I/F Handoff Stability)

The V2D (Voltage-to-Duty) gain converts FOC CC output volts to modulation index for the inverter. Two variants exist:

| V2D Formula | Value | When to Use |
|---|---|---|
| `1 / Vdc` | ~0.0032 for 310V bus | Standard (with AVI or PWM hardware) |
| `1 / (2 * Vmax)` | `1 / (2 * Vdc/sqrt(3))` | Unity-gain path (FOC CC → UnitDelay → PMSM directly) |

**For sensorless I/F handoff stability:** The direct path (`FOC_CC.y1 → UnitDelay → PMSM.u2`) is preferred in simulation because it avoids AVI gain mismatch that can cause torque transients at the I/F → observer handoff point. The FOC CC already outputs correctly-scaled Vabc in SI volts, which the MCB PMSM plant block accepts directly.

**If using AVI path:** The V2D gain matters critically for handoff — incorrect scaling means the I/F controller and observer experience different effective voltage magnitudes, causing angle discontinuity at switchover. Verify: at steady state, `|Vabc_modulation| ≈ BackEMF / (Vdc/2)` (should be < 1.0 in linear region).

---

## Feature: Gain Scheduling (Nonlinear PI)

**Prerequisites:** 2-D LUT data for Ld(id,iq), Lq(id,iq). Measured id, iq available (from Park transform).

**Blocks to add:**
- 2-D Lookup Tables (4x): Kp_d(id,iq), KiTs_d(id,iq), Kp_q(id,iq), KiTs_q(id,iq)
- slpidlib/PID Controller (replaces MCB PI Controller)

**Wiring changes:**
```
REMOVE: MCB PI Controller (internal gains)

ADD:
  Park/1 (Id_meas) ──┐
                      ├──► 2D_LUT_Kp_d ──► PID_d/2 (P port)
  Park/2 (Iq_meas) ──┤
                      ├──► 2D_LUT_KiTs_d ──► PID_d/3 (I port)
                      ├──► 2D_LUT_Kp_q ──► PID_q/2
                      └──► 2D_LUT_KiTs_q ──► PID_q/3

  Error_d ──► PID_d/1 ──► Vd
  Error_q ──► PID_q/1 ──► Vq
```

**PID Controller setup (`model_edit`):**
```json
[
  {"op": "add_block", "type": "PID Controller", "name": "PID_d", "ref": "pid_d", "params": {
      "Controller": "PI",
      "TimeDomain": "Discrete-time",
      "SampleTime": "Ts",
      "IntegratorMethod": "Forward Euler",
      "ControllerParametersSource": "external",
      "InitialConditionSource": "internal",
      "ExternalReset": "none",
      "AntiWindupMode": "clamping",
      "UpperSaturationLimit": "Vmax",
      "LowerSaturationLimit": "-Vmax"}}
]
```
**Note:** Use `"PID Controller"` type (resolves to slpidlib). With `ControllerParametersSource='external'`, ports become: u1=error, u2=P gain, u3=I gain.

**Gain computation:**
```matlab
% Use mcb.calcFOCGains at each operating point
for i = 1:nId
    for j = 1:nIq
        pmsm_local = mcb.updatePMSMLdLqFluxPM(pmsm, pmsm.PMSMLUT, idVec(i), iqVec(j), 1);
        gains = mcb.calcFOCGains(pmsm_local, Ts, Ts_speed);
        Kp_d_table(i,j) = gains.Kp_id;
        KiTs_d_table(i,j) = gains.Ki_id * Ts;
        Kp_q_table(i,j) = gains.Kp_i;
        KiTs_q_table(i,j) = gains.Ki_i * Ts;
    end
end
```

**Reference:** See `examples/example_nonlinear_gain_sched.m`

### Common Mistakes

1. **Using MCB PI Controller instead of slpidlib** — MCB PI Controller does NOT have external gain ports in a usable way for gain scheduling. You MUST use `slpidlib/PID Controller` with `ControllerParametersSource='external'` to get P and I input ports.
2. **Wrong LUT dimensions** — LUT RowIndex = idVec (rows), ColumnIndex = iqVec (columns). Table data must be size [length(idVec) x length(iqVec)]. Transposing causes wrong gains at each operating point.
3. **Forgetting Ts multiply on Ki** — `mcb.calcFOCGains` returns Ki in [1/s]. The slpidlib PID Controller with Forward Euler expects Ki*Ts at the I port. Always multiply: `KiTs = Ki * Ts`.

---

## Feature: FeedForward Decoupling

**Prerequisites:** Pattern A (manual PI). Measured id, iq, and electrical speed we available.

**Blocks to add:**
- PMSM FeedForward Control block (or manual Sum/Gain blocks)
- Gain (p × wm → we)

**Wiring changes:**
```
ADD (after PI controllers, before InvPark):
  Park/1 (Id) ──► FF/1
  Park/2 (Iq) ──► FF/2
  wm * p      ──► FF/3 (we)

  PI_d/1 + FF/1 ──► Sum_d ──► InvPark/1 (Vd_total)
  PI_q/1 + FF/2 ──► Sum_q ──► InvPark/2 (Vq_total)
```

**Manual FF formulas (if not using MCB block):**
```
Vd_ff = -we * Lq * iq
Vq_ff = +we * (Ld * id + FluxPM)
```

**Reference:** See `wiring-topologies.md` Pattern A+FF

### Common Mistakes

1. **Sign error on Vd_ff** — The d-axis feedforward is NEGATIVE: `Vd_ff = -we * Lq * iq`. Missing the negative sign causes positive feedback that destabilizes the d-axis current loop.
2. **Using mechanical speed instead of electrical speed** — Feedforward requires electrical speed `we = wm * p` (pole pairs). Using raw mechanical speed from the sensor produces gains that are p times too small, giving inadequate decoupling.
3. **Wrong pole pairs gain** — The gain block converting wm to we must use `pmsm.p` (pole PAIRS), not `2*pmsm.p` (poles). A PMSM with 6 pole pairs has p=6 — the conversion is `we = wm * 6`, not `we = wm * 12`.

---

## Feature: Position Control (Cascaded)

**Prerequisites:** Working speed-controlled FOC model.

**Blocks to add:**
- Position PI (or P) controller
- Position reference (Step, S-curve profile)
- Position feedback path (integrate speed or use MtrPos from bus)

**Wiring changes:**
```
ADD (wraps around speed loop):
  Pos_Ref ──┐
            ├──► Sum_pos ──► Pos_PI ──► Speed_Ref (replaces original Step)
  Pos_FB ──┘

  Position feedback:
    BusSel('MtrPos') ──► Pos_FB
    OR: Speed ──► Discrete Integrator ──► Pos_FB
```

**Bandwidth rule:** Position BW < Speed BW / 3 < Current BW / 10

**Reference:** See `examples/example_position_control_foc.m`

### Common Mistakes

1. **Bandwidth too high** — Position loop bandwidth must be at MOST 1/3 of speed loop bandwidth. Exceeding this causes oscillation because the inner speed loop cannot track the position controller's commands fast enough.
2. **No anti-windup on position PI** — During large position steps, the integrator winds up while speed is saturated. Use `AntiWindupMode='clamping'` and set saturation limits to `[±max_speed]` (matching speed reference limits).
3. **Wrong position units** — MtrPos from PMSM bus is in RADIANS (mechanical). If your reference is in revolutions or degrees, add appropriate scaling. Mixing units causes enormous steady-state error or violent oscillation.

---

## Feature: I/f Startup (for Sensorless)

**Prerequisites:** Sensorless model with observer.

**Option A: MCB I-F Controller block**

**Blocks to add:** I-F Controller, Switch (angle), Switch (current refs)

**Wiring:**
```
I-F Controller:
  In: Enable, theta_obs, w_ref, w_meas, Iq_meas, Vq_meas
  Out: Id_ref, Iq_ref, theta_if, Status (EnableSpeedLoop)

During startup (Status=0):
  theta for Park/InvPark = theta_if
  id*/iq* come from I-F Controller

After handoff (Status=1):
  theta = observer theta
  id*/iq* come from Control Reference (normal speed loop)
```

**Option B: Manual I/f ramp**

```
Ramp(0→w_target) ──► Discrete Integrator ──► theta_if (wraps at 2*pi)
Constant(I_startup) ──► iq_ref (during startup)
```

**Integrator wrapping (critical for Option B):**

NOTE: Discrete-Time Integrator does NOT have WrapState. Use DTI + Math Function (mod):
```json
[
  {"op": "add_block", "type": "Discrete-Time Integrator", "name": "IF_Integrator", "ref": "ifi", "params": {
      "IntegratorMethod": "Integration: Forward Euler",
      "SampleTime": "Ts", "gainval": "1.0"}},
  {"op": "add_block", "type": "Math Function", "name": "ModWrap", "ref": "mw", "params": {"Operator": "mod"}},
  {"op": "add_block", "type": "Constant", "name": "TwoPi", "ref": "tp", "params": {"Value": "2*pi"}},
  {"op": "connect", "target": "#ifi.y1 -> #mw.u1"},
  {"op": "connect", "target": "#tp.y1 -> #mw.u2"}
]
```
Output of ModWrap = theta_if wrapped to [0, 2*pi). Without wrapping: angle overflows after extended startup → NaN.

**Reference:** See `examples/example_hfi_smo_hybrid.m` for startup handoff

### Common Mistakes

1. **Alignment current too low** — Use 30-50% of rated current.
2. **Ramp too fast** — 0 to 10% rated speed in ≥0.5s. The I/f integrator MUST use a RAMP (not a constant target speed). If the I/f electrical angle races ahead of the rotor, the rotor loses magnetic synchronization and net torque averages to zero. The motor appears to not move despite commanded current.
3. **Handoff too early** — Wait until speed > threshold AND observer converged (angle error < 15°).
4. **Constant IF_Speed (WRONG)** — Using `Constant(speed_ref_rad * p)` as the integrator input creates a field rotating at full target speed immediately. The rotor (starting from rest) cannot follow → pull-out. Always use `Ramp(0 → target)` with saturation:
```json
[
  {"op": "add_block", "type": "Ramp", "name": "IF_Ramp", "ref": "ifr", "params": {"slope": "if_ramp_slope"}},
  {"op": "add_block", "type": "Saturate", "name": "Sat_IFSpd", "ref": "sifs", "params": {"UpperLimit": "speed_ref_rad * pmsm.p", "LowerLimit": "0"}}
]
```
Slope formula: `if_ramp_slope = target_elec_speed / ramp_time` where ramp_time ≥ 0.1s.
5. **Using SMO speed for handoff threshold** — SMO speed (y2) is unreliable at low speed in simulation. Use actual motor speed (`PMSM.y3 → DTC → IIR → Abs → Compare`) for the threshold decision instead.

---

> More: Protection/PWM/Load → `composition-rules-infrastructure.md` | Logging/Combining → `composition-rules-integration.md` | Combining features → `composition-rules-combining.md`

----
Copyright 2026 The MathWorks, Inc.
----
