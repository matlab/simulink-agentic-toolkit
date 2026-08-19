
# Interactive Onboarding — Start Here

> When the motor-control skill is invoked, the agent SHOULD start in **enquiry mode** if the user's
> intent is unclear or broad. Ask questions first, then act.

---

## Agent Enquiry Protocol

When a user invokes the motor-control skill without a specific technical request, follow this
interactive flow. Ask ONE question at a time (not all at once).

### Step 1 — Intent Discovery

Ask the user similar to the following:

```
What would you like to do?
  1. Learn about Motor Control Blockset
     → Choose this if you're new to MCB or want to understand FOC, dq frames, etc.
  2. Build a motor control model from scratch
     → Choose this if you want to create a new Simulink model for your motor
  3. Fix or improve an existing model
     → Choose this if you have a model that errors, oscillates, or needs a new feature
  4. Find a specific block, API, or architecture
     → Choose this if you know what you're looking for (e.g., "SMO block", "calcFOCGains")
```

- If **1** → go to [Learning Path](#learning-path)
- If **2** → go to [Build Enquiry](#build-enquiry)
- If **3** → go to [Fix/Improve Enquiry](#fiximprove-enquiry)
- If **4** → go directly to `api-and-tooling.md` or `application-catalog.md`

---

## Build Enquiry

Ask these questions similar to the following ONE AT A TIME (adapt based on answers):

### Q1: Motor Type
```
What type of motor are you controlling?
  1. PMSM (Permanent Magnet Synchronous — most common for servo/EV/drone)
  2. BLDC (Brushless DC — trapezoidal back-EMF, typically simpler)
  3. ACIM / Induction Motor (industrial pumps, fans, compressors)
  4. SynRM (Synchronous Reluctance — no magnets, industrial)
  5. Not sure / I'll describe my application
```

If answer is 5, ask: "Describe your application (e.g., e-bike, drone, robot arm, pump, fan)"
and infer motor type from application.

### Q2: Control Objective
```
What do you need to control?
  1. Speed (maintain RPM under varying load)
  2. Torque (precise force/torque output)
  3. Position (servo, move to angle/distance)
  4. Just spin it (open-loop, V/f, simplest possible)
```

### Q3: Sensor Configuration
```
What position/speed sensor do you have?
  1. Encoder (incremental or absolute)
  2. Hall sensors (3 digital signals)
  3. Resolver
  4. Sensorless (no sensor — estimate from voltages/currents)
  5. Not decided yet
```

### Q4: Special Features (optional)
```
Do you need any of these? (pick all that apply, or skip)
  - Field weakening (run above base speed)
  - Sensorless startup (I/f, HFI)
  - Gain scheduling (nonlinear motor)
  - Protection (overcurrent, overvoltage)
  - Energy efficiency (MTPA optimization)
```

### After All Questions — Architecture Selection

Based on answers, search `application-catalog.md` for the matching application and present:

```
Based on your answers:
  Motor: IPMSM | Control: Speed | Sensor: Encoder | Features: FW

  Recommended architecture: Pattern B + Field Weakening
  Reference: application-catalog.md → "Field Weakening (voltage feedback)"

  Would you like me to:
  1. Build this model now (I'll create the .slx file)
  2. Explain how it works first (theory + block diagram)
  3. Show a similar example (reference implementation)
  4. Something else (refine requirements)
```

---

## Fix/Improve Enquiry

```
What's happening with your model?
  1. Simulation error (algebraic loop, dimension mismatch, etc.)
  2. Motor doesn't reach target speed / oscillates
  3. Want to add a feature (sensorless, FW, protection, etc.)
  4. Performance issue (slow simulation, wrong data types)
```

- If **1** → Go to [Troubleshoot Mode](#troubleshoot-mode) below
- If **2** → Go to [Troubleshoot Mode](#troubleshoot-mode) § Performance Diagnosis
- If **3** → Use `composition-rules.md` for that feature
- If **4** → Check solver settings in `model-sanity-check-infrastructure.md`

---

## Troubleshoot Mode

> Structured diagnostic flow for fixing motor control model errors.
> References: `auto_fix/ERROR_PATTERNS.md`, `auto_fix/auto-fix-recipes.md`, `critical-constraints.md`, `recovery-protocol.md`

### Step 1 — Classify the Problem

```
What kind of issue are you seeing?
  1. Simulation won't run (error message in red)
  2. Motor doesn't spin / produces zero torque
  3. Motor oscillates or current is noisy
  4. Motor spins wrong direction
  5. Speed doesn't reach target / saturates early
  6. NaN / divergence / "derivative not finite"
  7. Build/code generation error
  8. I have an error message — let me paste it
```

### Step 2 — Diagnosis by Category

#### Category A: Simulation Errors (won't run)

**Agent action:** Ask user to paste the error message, then pattern-match against `auto_fix/ERROR_PATTERNS.md`.

| Error Pattern | Most Likely Cause | Quick Fix |
|---|---|---|
| "algebraic loop involving..." | No delay between controller output and plant input | Add Unit Delay on voltage path (Rule 1) |
| "dimension mismatch" / "cannot unify" | Bus vs vector confusion, or wrong port width | Check: PMSM Info → Bus Selector (not Selector); Clarke expects 2 scalars, not vector |
| "port width mismatch on FOC CC" | Passing 3-phase `[Ia;Ib;Ic]` instead of 2-phase | FOC CC port 2 = `[Ia;Ib]` only (reconstructs Ic internally) |
| "block not found" / "invalid library" | Wrong block path for this MATLAB release | Use model_edit with the block display name — SATK resolves library paths automatically |
| PI Controller has 5 inputs | External parameters mode enabled by default | Set `ControllerParametersSource='internal'`, `ExternalReset='none'`, `InitialConditionSource='internal'` |
| Park/InvPark has 4 inputs | Default sin/cos mode active | Set `ThetaInput='Electrical position'` + `AngleInput='Radians'` |

**Reference:** `critical-constraints.md` Rules 1-3 (algebraic loops), `auto_fix/ERROR_PATTERNS.md` Category 1-3

#### Category B: Motor Doesn't Spin / Zero Torque

**Agent action:** Run the 7-point zero-torque checklist:

```
Zero Torque Checklist:
  □ 1. Enable signal = 1? (not 0 or disconnected)
  □ 2. pmsm.p > 0? (pole pairs, not poles — e.g., 4 not 8)
  □ 3. pmsm.FluxPM > 0? (in Wb, not mWb — e.g., 0.17 not 171)
  □ 4. Speed reference > 0? (or intended direction)
  □ 5. PI gains non-zero? (Kp, Ki both > 0)
  □ 6. PIConfig saturation limits set? ([Vmax; -Vmax; 0; 0], not [0;0;0;0])
  □ 7. theta_e connected to BOTH Park AND InvPark?
```

If all pass → check MTPA ilimit: default is 7.1A, must match `pmsm.I_rated`.

**Reference:** `auto_fix/ERROR_PATTERNS.md` § 4.10, `block-configurations.md` § PI Controller

#### Category C: Oscillation / Noisy Current

**Agent action:** Diagnose PI tuning issues:

| Symptom | Diagnosis | Fix |
|---|---|---|
| High-frequency current ripple | Current PI bandwidth too high (near Nyquist) | Reduce Kp_id, Kp_i by 50%. Rule: `Kp = L/(3*Ts)` not `L/(2*Ts)` |
| Speed overshoot > 20% | Speed PI too aggressive | Reduce Kp_speed by 50% OR check cascade BW rule: speed BW < current BW / 5 |
| id/iq are random (not DC) | theta_e not connected properly | Connect PMSM theta_e to BOTH Park/3 AND InvPark/3 |
| Current oscillates but gains look OK | Sample time mismatch | Control Ts = 5e-5, Plant Ts = 2.5e-5 (Ts/2), Model FixedStep = Ts/2 |

**Recompute gains:** `PI = mcb.calcFOCGains(pmsm, Ts, Ts_speed)` — use as starting point.

**Reference:** `auto_fix/auto-fix-recipes.md` § Reduce PI Bandwidth, `parameter-computation.md`

#### Category D: Wrong Direction

**Agent action:** Apply default fix (negate speed reference — simplest, reversible):

```
Default fix: Negate the speed reference value.
  Example: speed_ref = 2000 → speed_ref = -2000

Alternative (hardware-equivalent): Swap phases B↔C at the Inverse Clarke output.
```

For Simscape plants: must negate BOTH speed AND angle feedback (not just one).

**Reference:** `auto_fix/auto-fix-recipes.md` § Fix Phase Order

#### Category E: Speed Doesn't Reach Target / Saturates

**Agent action:** Check voltage margin and plot constraint curves:

```
Voltage check:
  Max achievable speed ≈ (Vdc/sqrt(3)) / (FluxPM × p) × 30/π  [RPM]

  If target speed > max achievable speed:
    → Option 1: Increase Vdc (higher bus voltage)
    → Option 2: Enable Field Weakening (composition-rules.md § FW)
    → Option 3: Reduce speed reference
```

**Visualize operating point validity:**
```matlab
% Plot constraint curves with target operating point marked:
chars = mcb.PMSMCharacteristics(pmsm, inverter, ...
    'driveCharacteristics', 2, ...
    'constraintCurves', true, ...
    'speed', target_speed_rpm, ...
    'torque', target_torque_Nm);

% Check if operating point is inside the envelope:
% speed_milestone is in RPM: (1)=base, (2)=max
if chars.speed_milestone(2) < target_speed_rpm
    fprintf('Target %.0f RPM exceeds max %.0f RPM — need FW or higher Vdc\n', ...
        target_speed_rpm, chars.speed_milestone(2));
end
```

Also check: MTPA `ilimit` default (7.1A) may be clamping torque for larger motors.

**Reference:** `auto_fix/ERROR_PATTERNS.md` § 4.3, `composition-rules.md` § Field Weakening, `design/constraint-curves.md`

#### Category F: NaN / Divergence

**Agent action:** Diagnose in priority order:

1. **Check motor parameters** — Rs, Ld, Lq, FluxPM, J must all be > 0 (never zero)
2. **Check units** — Ld in H (not mH), FluxPM in Wb (not mWb), p = pole pairs (not poles)
3. **Check voltage saturation** — `Vmag = sqrt(Vd²+Vq²)` must stay < `Vdc/sqrt(3)`
4. **Check solver** — FixedStep must equal `Ts/2` (not Ts, not 0)
5. **Check Simscape** — Must use `ode14x` (implicit), not FixedStepDiscrete

**Common unit mistakes causing instant divergence:**

| Parameter | Wrong | Correct | Result if wrong |
|---|---|---|---|
| `pmsm.Ld` | `3.5` (mH) | `3.5e-3` (H) | Gains 1000× wrong → diverges |
| `pmsm.FluxPM` | `171.4` (mWb) | `0.1714` (Wb) | Instant voltage saturation |
| `pmsm.p` | `8` (poles) | `4` (pairs) | Speed doubled → angle wrong → NaN |
| `pmsm.J` | `0` | `7e-5` (kg·m²) | Division by zero in speed calc |

**Reference:** `auto_fix/ERROR_PATTERNS.md` § Category 4, `auto_fix/auto-fix-recipes.md` § Fix Voltage Saturation

#### Category G: Build / Code Generation Errors

| Error | Fix |
|---|---|
| `cl2000: command not found` | `setenv('CCSINSTALLDIR', 'C:\ti\ccs1271\ccs')` |
| Build hangs at gmake (R2025+) | Use `GenCodeOnly='on'` + manual gmake |
| .out file missing after build | Check both parent dir and `_ert_rtw/` subfolder |

**Reference:** `auto_fix/ERROR_PATTERNS.md` § Category 5

### Step 3 — Recovery Without Starting Over

If the model is partially built and fails mid-construction:

1. **DO NOT delete and restart** — use `model_overview` to see what exists
2. **Identify last good state** — find the last successfully wired block
3. **Fix the specific error** using the diagnosis above
4. **Continue from failure point** using `model_edit` (not re-running full script)
5. **Post-fix cleanup:** `Simulink.BlockDiagram.arrangeSystem(mdl)` + `save_system(mdl)`
6. **Validate:** `sim(mdl, 'StopTime', '0.1')` — brief sim to confirm no crash

**Reference:** `recovery-protocol.md` (full decision tree)

### Step 4 — Preventive Checks (avoid future issues)

After fixing, run the sanity check to prevent recurrence:

```
Post-fix validation:
  □ model-sanity-check-infrastructure.md — solver, plant, transforms, data types
  □ model-sanity-check-control.md — PI controllers, speed loop, inverter
  □ model-sanity-check-domain.md — sensorless, ACIM, angle, workspace
  □ validation-checks.md — pre-sim assertions
```

### Troubleshoot Quick-Reference Table

| User Says | Agent Does |
|---|---|
| "algebraic loop" | → Rule 1: add Unit Delay on voltage path |
| "dimension mismatch" | → Check Bus Selector vs Selector, Clarke scalar inputs |
| "oscillates" / "noisy" | → Reduce PI gains, check Ts matching |
| "doesn't spin" | → 7-point zero-torque checklist |
| "wrong direction" | → Negate speed reference |
| "NaN" / "diverges" | → Check units (H not mH, Wb not mWb, pairs not poles) |
| "saturates" / "won't reach speed" | → Voltage margin check, consider FW |
| "build failed" | → Check CCSINSTALLDIR, gmake PATH |
| Pastes error message | → Pattern-match against ERROR_PATTERNS.md |

---

## Learning Path

### Step 0 — Zero Knowledge Entry

If the user seems unfamiliar with motor control terminology:

```
Let me help you get oriented. What's your background?
  (a) Electrical engineering — I know circuits but not motor control
  (b) Controls/systems — I know PID but not motors
  (c) Software/embedded — I know Simulink but not power electronics
  (d) Completely new — start from the very beginning
```

Based on the answer:
- **(a)** Skip electrical basics, focus on dq-frame and FOC concepts
- **(b)** Skip control theory, focus on motor physics and MCB block structure
- **(c)** Skip Simulink basics, focus on motor + control theory
- **(d)** Start at Step 1 below with full explanations

---

### Learning Progression

Show something similar to the following. 

```
Here's your MCB learning path:

Step 1: Vocabulary (5 min)
  → Key concepts: FOC, PMSM, BLDC, dq reference frame, Clarke/Park transforms
  → I'll explain any term that's unclear
  → Reference: api-and-tooling.md § Glossary

Step 2: See MCB in Action (2 min)
  → Run a shipped MCB example, see a motor spinning in simulation
  → Try: mcb.getPMSMParameters('BLY172S') to get a demo motor
  → Try: mcb.PMSMCharacteristics(pmsm) for operating envelope plot

Step 3: Understand the Architecture (10 min)
  → I'll explain Pattern B (FOC with speed loop) block by block
  → Reference: wiring-topologies.md § Pattern B-Simple
  → Each block has a clear role: why it's there and what it does

Step 4: Build Your First Model (15 min)
  → Guided build of a basic PMSM speed control model
  → I'll explain every step as we go
  → You'll have a working model you fully understand

Step 5: Explore Applications (ongoing)
  → Browse application-catalog.md for architectures similar to yours
  → Add features: sensorless, field weakening, protection
  → Reference: composition-rules.md

Which step would you like to start with?
```

---

## Quick Wins (immediate value in <2 minutes)

For any user — new or experienced — offer something similar to these as a fast demonstration of MCB:

```
Want to see MCB in action right now? Try one of these:

  1. Get motor parameters from the MCB database:
     >> pmsm = mcb.getPMSMParameters('BLY172S');
     >> disp(pmsm)

  2. Compute PI gains automatically:
     >> inverter = mcb.getInverterParameters('BoostXL-DRV8305');
     >> PI = mcb.calcFOCGains(pmsm, 5e-5, 5e-4);
     >> disp(PI)

  3. Visualize motor operating envelope:
     >> mcb.PMSMCharacteristics(pmsm, inverter);

  4. Browse MCB block library:
     >> mcblib  (opens the Motor Control Blockset library browser)

Pick one, or tell me what you'd like to build.
```

---

## MCB Product Highlights

When explaining concepts to beginners, naturally highlight MCB product features:

### What MCB Provides (vs manual implementation)

| Without MCB | With MCB |
|---|---|
| Wire Clarke + Park + 2× PI + InvPark + InvClarke + PWM manually (6+ blocks, 15+ connections) | Single **FOC Current Controller** block does it all |
| Compute PI gains from motor equations manually | `mcb.calcFOCGains(pmsm, Ts, Ts_speed)` — one line |
| Look up motor parameters from datasheets | `mcb.getPMSMParameters('MotorName')` — database of 20+ motors |
| Implement SMO from academic papers | **Sliding Mode Observer** block — drop in, configure 5 params |
| Build MTPA optimization from flux equations | **MTPA Control Reference** block — handles interior/surface PMSM |
| Design protection logic from scratch | **Protection Relay** block — configurable fault thresholds |
| Implement V/f control from theory | **VbyF Controller** block — complete with ramp and boost |

### Why FOC? (common beginner question)

Field-Oriented Control gives you:
- **Precise torque control** — decouple d-axis (flux) from q-axis (torque)
- **Maximum efficiency** — MTPA puts current where it produces most torque
- **Smooth operation** — no torque ripple at any speed (unlike six-step)
- **Full speed range** — field weakening extends operation above base speed

MCB's FOC Current Controller encapsulates the complete inner loop (Clarke → Park → PI_d + PI_q → InvPark) in one block with 7 inputs and 2 outputs. This eliminates the most common wiring errors.

### Why Sensorless? (common follow-up)

- **Lower cost** — no encoder/resolver ($5–$50 saved per unit)
- **Higher reliability** — fewer mechanical components to fail
- **Smaller package** — no sensor wiring harness

MCB provides multiple sensorless estimators:
- **Sliding Mode Observer (SMO)** — robust, works above 5-10% rated speed
- **Extended EMF Observer** — exploits saliency for better low-speed
- **High Frequency Injection (HFI)** — works at standstill (IPMSM only)
- **I-F Controller** — open-loop startup before handoff to observer

---

## Quick-Start Table (for experienced users who skip enquiry)

| User Says | Agent Does |
|---|---|
| "build FOC for PMSM" | Skip to Q2 (control objective), then build |
| "sensorless BLDC" | Recommend six-step or FOC based on precision needs |
| "fix my model" | Go to Troubleshoot Mode |
| "algebraic loop" / "NaN" / error msg | Go to Troubleshoot Mode § pattern match |
| "what is FOC?" | Go to Learning Path |
| "show me the PI tuning API" | Go to `api-and-tooling.md` § mcb.calcFOCGains |
| Specific architecture keyword (MTPA, SMO, HFI) | Skip enquiry, go to relevant doc |
| Complete spec provided | Skip all enquiry, build immediately |

---

## Parameter Collection Template

After architecture selection, before building, collect motor parameters:

```matlab
%% Motor Parameters (REQUIRED)
pmsm.Rs     = ____;   % Stator resistance [Ohm]
pmsm.Ld     = ____;   % d-axis inductance [H] (NOT mH!)
pmsm.Lq     = ____;   % q-axis inductance [H]
pmsm.FluxPM = ____;   % PM flux linkage [Wb]
pmsm.p      = ____;   % Pole pairs (integer)
pmsm.J      = ____;   % Rotor inertia [kg.m²]

%% Inverter Parameters (REQUIRED)
inverter.V_dc = ____;  % DC bus voltage [V]
inverter.I_max = ____;  % Max phase current [A]
inverter.ISenseMax = ____;  % Current sense range [A]

%% Operating Point (OPTIONAL — defaults provided)
speed_ref = ____;      % Target speed [RPM]
T_load    = ____;      % Load torque [Nm]
Ts        = 5e-5;     % Control sample time [s] (default: 20 kHz)
```

If user doesn't have parameters:
- Suggest `mcb.getPMSMParameters('BLY172S')` for a demo motor
- Suggest `mcb.getInverterParameters('BoostXL-DRV8305')` for a demo inverter
- All MCB parameters use **SI base units** (H, Ω, Wb, V, A, kg·m²) — never milli/micro

### Common Unit Mistakes

| Parameter | Wrong (common) | Correct | Effect |
|---|---|---|---|
| `pmsm.Ld` | `3.5` (mH) | `3.5e-3` (H) | Gains 1000× too small → no response |
| `pmsm.FluxPM` | `171.4` (mWb) | `0.1714` (Wb) | Voltage saturates instantly |
| `pmsm.p` | `8` (poles) | `4` (pole pairs) | Speed/angle doubled → diverges |
| `pmsm.J` | `0` | `7e-5` (kg·m²) | Division by zero in speed PI |

---

## Agent Behavior Rules

1. **Never dump all architectures at once** — filter by user's application first
2. **Ask at most 4-5 questions** before acting — don't interrogate
3. **Offer defaults** — if user says "I don't know", suggest a reasonable default
4. **Show confidence** — "Based on your answers, I recommend X" (not "maybe try X?")
5. **Allow shortcuts** — if user provides a complete spec, skip enquiry entirely
6. **Remember context** — if user already said "PMSM" in conversation, don't ask again
7. **Promote MCB features naturally** — when explaining a concept, mention the MCB block that implements it

----
Copyright 2026 The MathWorks, Inc.
----
