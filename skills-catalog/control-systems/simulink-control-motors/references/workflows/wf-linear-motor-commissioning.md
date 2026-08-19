# Workflow: Linear Motor Commissioning

**Scope:** From motor datasheet (lumped parameters) to fully running closed-loop FOC with all refinements.

## Prerequisites
- Motor datasheet with at least: p, V_rated, I_rated, N_rated
- Inverter Vdc known
- MCB installed

## Step 1: Motor Parameters

**Goal:** Obtain Rs, Ld, Lq, FluxPM, J, B

**If datasheet complete:** Build pmsm struct directly.
**If parameters missing:** → `estimating-motor-parameters` skill

```matlab
pmsm = mcb.getPMSMParameters;  % Start from template, fill in values
inverter = mcb.getInverterParameters;
inverter.V_dc = 400;  % Set actual bus voltage
```

## Step 2: Motor Characterization

**Goal:** Understand operating envelope before building controller.

```matlab
% Base speed (where voltage limit activates):
base_speed = mcb.getMotorBaseSpeed(pmsm, inverter, 'actual');

% Maximum speed with field weakening:
max_speed = mcb.PMSMMaxSpeed(pmsm, inverter, FWCMethod='vclmt');

% Rated torque and milestone id/iq:
[T_rated, speeds, id, iq] = mcb.PMSMRatedTorque(pmsm, inverter);

% Milestone speeds (base, FW-start, MTPV, max):
milestone_speeds = mcb.PMSMSpeeds(pmsm, inverter, verbose=true);

% Full constraint curves (voltage ellipse, current circle, MTPA):
chars = mcb.PMSMCharacteristics(pmsm, inverter, driveCharacteristics=2, constraintCurves=true);
```

**→ Ref:** `tuning-motor-foc-gains`, `wf-motor-characterization.md`

## Step 3: V/f Open-Loop Validation (Optional)

**Goal:** Validate motor params + inverter hardware before closing loops.

Build V/f model using VbyF Controller block. If motor spins at expected synchronous speed with reasonable current draw, parameters are roughly correct.

**→ Ref:** `references/configurations/` § acim-vf-openloop.md

## Step 4: ADC Calibration

**Goal:** Remove current sensor offset and gain errors.

- Measure ADC output with zero current → offset
- Apply known current → gain correction
- Phase delay compensation if using analog filters

**→ Ref:** `configuring-mcb-blocks` § ADC configuration

## Step 5: Position Sensor Offset Calibration

**Goal:** Align encoder/resolver electrical zero with motor d-axis.

- Inject DC current into known phase → motor aligns to d-axis
- Read encoder position → this is the offset
- Store offset in Position Compensation block

**→ Ref:** `configuring-mcb-blocks` § Position Compensation block

## Step 6: Current Loop PI Gains

**Goal:** Compute and verify current loop gains.

```matlab
Ts = 5e-5;           % 20 kHz control rate
Ts_speed = 10 * Ts;  % 2 kHz speed loop

PI_params = mcb.calcFOCGains(pmsm, Ts, Ts_speed);
% Fields: Kp_id, Ki_id, Kp_i, Ki_i, Kp_speed, Ki_speed
```

**→ Ref:** `tuning-motor-foc-gains`, `shared/gain-formulas.md`

## Step 7: Closed-Loop FOC (Current + Speed)

**Goal:** Build Pattern B model, verify step response.

Build FOC model with:
- Clarke → Park → PI_d/PI_q → InvPark → PWM Ref Gen → Inverter → PMSM
- Speed PI → MTPA → id*/iq* references
- IIR filter on speed feedback

Verify: current step settles in <10 samples, speed step settles in <200 ms.

**→ Ref:** Building Motor Controller § Pattern B, Configuring MCB Blocks

## Step 8: Feed-Forward Decoupling

**Goal:** Add cross-coupling compensation for better dynamic response.

Formulas:
```
Vd_ff = -ωe · Lq · iq
Vq_ff = ωe · (Ld · id + FluxPM)
```

Add using MCB PMSM FeedForward Control block or manual Gain + Product blocks.

**→ Ref:** `references/wiring/` § composition-rules (FF)

## Step 9: Field Weakening Control

**Goal:** Extend speed range above base speed.

- Add FW-MTPA feature via MTPA Control Reference block (has internal FW)
- Or add explicit FW controller (voltage feedback → negative id injection)
- Verify: motor reaches max_speed from Step 2 without voltage saturation

**→ Ref:** `references/wiring/` § composition-rules (FW)

## Step 10: Speed Loop Tuning Verification

**Goal:** Verify speed loop stability with frequency-domain analysis.

```matlab
PU_System = mcb.getPUSystemParameters(pmsm, inverter);
mcb.getMotorControlAnalysis(pmsm, inverter, PU_System, PI_params, Ts, Ts_speed);
% Check: phase margin > 30°, gain margin > 6 dB
```

**→ Ref:** `tuning-motor-foc-gains`

## Step 11: Position Control (If Required)

**Goal:** Add cascaded P-controller for position tracking.

Key rules:
- Position loop: **P-only** (no I term)
- `Kp_pos = BW_speed / 5`
- Speed saturation **MANDATORY** between position and speed loops
- Position from speed integration (mechanical), NOT θe

**→ Ref:** `references/configurations/` § position-cascade-foc.md

## Step 12: PWM Refinements

**Goal:** Optimize modulation strategy.

Options:
- SVM (space vector modulation) — standard, best DC utilization
- DPWM (discontinuous PWM) — lower switching losses, higher ripple
- Overmodulation — extends voltage beyond linear SVM hexagon

**→ Ref:** `configuring-mcb-blocks` § PWM Reference Generator

## Step 13: ADC Sampling Strategy

**Goal:** Align current sampling with PWM for minimum distortion.

| Strategy | Description | When |
|---|---|---|
| Mid-PWM (center-aligned) | Sample at PWM counter peak/valley | Standard (best SNR) |
| Double-update | Sample at both peak and valley | Higher bandwidth |
| Single-shunt | Reconstruct 3 currents from 1 shunt | Cost reduction |
| Oversampling | Multiple samples per PWM period, averaged | Noise reduction |

**→ Ref:** `configuring-mcb-blocks` § ADC timing

## Step 14: Dead-Time Compensation

**Goal:** Correct voltage distortion at current zero-crossings.

Dead-time causes:
- Voltage error = ±Vdc · Td/Ts (depends on current direction)
- Distortion worst at low current (frequent zero-crossings)
- 6th harmonic torque ripple

Compensation methods:
- Lookup-based (current direction → voltage correction)
- Model-based (online dead-time estimation)
- MCB Dead-Time Compensator block

**→ Ref:** `references/wiring/` § composition-rules (DTC)

## Step 15: Protection and Limits

**Goal:** Add safety features.

- Overcurrent (hardware comparator + software limit)
- Overvoltage (DC bus monitoring)
- Thermal derating (temperature → current limit reduction)
- Speed limit (prevent mechanical overspeed)

**→ Ref:** `references/wiring/` § composition-rules-infrastructure (Protection)

---

## Summary: Minimum Viable vs Full System

| Milestone | Steps | What You Get |
|---|---|---|
| Basic FOC running | 1, 6, 7 | Current + speed control, no refinements |
| Production-ready | 1–10, 14, 15 | Full FOC with FF, FW, protection |
| Servo-grade | All 15 | Position control, optimized PWM, dead-time comp |

---

Copyright 2026 The MathWorks, Inc.
