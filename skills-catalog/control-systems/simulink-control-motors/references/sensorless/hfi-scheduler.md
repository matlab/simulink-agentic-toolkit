# HFI + SMO Hybrid Scheduler Reference

> Full-range sensorless: HFI at zero/low speed, SMO at mid/high speed, blending in transition zone.
> For SMO-only configuration see `sensorless-blocks.md`.

---

## Architecture Overview

```
Speed = 0          → HFI active, SMO off (standstill position)
Speed = 5-15%      → Transition zone (blend both estimates)
Speed > 15% rated  → SMO active, HFI off (back-EMF based)
```

**Requirement:** Motor must have saliency (Ld ≠ Lq, ratio > 1.2) for HFI to work.

---

## Pulsating HF Observer Block

**Path:** `mcblib/Control/Synchronous Machine/Position Decoders/Sensorless Estimators/Pulsating High Freq Observer`

### Port Map

| Port | Dir | Signal | Unit | Notes |
|------|-----|--------|------|-------|
| u1 | In | I_ab_hf | PU or A | HF current response (alpha-beta). **Must be single precision** |
| u2 | In | Enable | 0/1 | Enable HFI estimation |
| u3 | In | θ_in | rad | Initial/external angle estimate |
| u4 | In | IPE_En | 0/1 | Initial Position Estimation enable |
| y1 | Out | V_αβ_hf | PU or V | HF injection voltage (add to FOC voltage) |
| y2 | Out | θ_est | rad | Estimated electrical angle |
| y3 | Out | Pos_En | 0/1 | Position estimation valid flag |
| y4 | Out | Info | — | Debug/status |

### Key Parameters

| Parameter | Type | Typical | Notes |
|-----------|------|---------|-------|
| `Voltphf` | scalar | 10-40V | HF injection amplitude. Higher = better SNR, more noise |
| `Frqphf` | scalar | 500-2000 Hz | Must be > 5× current loop BW and < f_pwm/4 |
| `Cfrqphf` | scalar | 0.3 × Frqphf | Demodulation filter cutoff |
| `Kp` | scalar | — | PLL proportional: `2×ζ×ωn / (Lq-Ld)` |
| `Ki` | scalar | — | PLL integral: `ωn² / (Lq-Ld)` |
| `PolCorrTech` | enum | `'Dual Pulse Injection'` | Polarity correction for N/S ambiguity |

### CRITICAL: All HFI inputs must be SINGLE precision

Add DTC (double→single) blocks before all PHFO inputs. Double-precision inputs cause silent errors.

---

## HFI Tuning Guidelines

| Step | Rule | Formula |
|------|------|---------|
| 1. Verify saliency | Lq/Ld > 1.2 | Cannot use HFI on SPMSM |
| 2. Injection voltage | 5-20% of rated phase voltage | `Vh = 0.1 × Vdc/√3` |
| 3. Injection frequency | Above current loop BW, below Nyquist/2 | `5×BW_current < f_hf < f_pwm/4` |
| 4. PLL gains | Standard PLL design | `Kp = 2ζωn/(Lq-Ld)`, `Ki = ωn²/(Lq-Ld)` |
| 5. Demod filter cutoff | ~30% of injection frequency | `Cfrqphf = 0.3 × Frqphf` |

Typical PLL natural frequency: ωn = 100-500 rad/s, ζ = 0.707.

---

## Blending Scheduler Concept

Smooth angle blending between HFI and SMO across a speed window:

```
alpha = clamp((|ω_est| - ω_low) / (ω_high - ω_low), 0, 1)

theta_out = (1-alpha) × theta_hfi + alpha × theta_smo
```

| Parameter | Typical Value |
|-----------|---------------|
| ω_low (start blending) | 5% of rated speed (rad/s) |
| ω_high (end blending) | 15% of rated speed (rad/s) |

**Implementation:** Use Abs → Subtract → Gain(1/(ω_high-ω_low)) → Saturation[0,1] for alpha computation, then Product blocks for weighted sum.

**Key consideration:** Filter speed estimate before computing alpha — noise in speed causes chattering at blend boundaries.

---

## PHFO→EEMF 4-State Machine (Official MCB Pattern)

For production systems, MCB uses a Stateflow chart:

```
State-1: Low-speed FOC with PHFO (standstill + low speed)
State-2: Transition → EEMF (PHFO still active, EEMF warming up)
State-3: Transition → PHFO (EEMF still active, PHFO warming up)
State-4: High-speed FOC with EEMF

Accelerating:  1 → 2 → 4
Decelerating:  4 → 3 → 1
Hovering:      2 ↔ 3 (at transition speed)
```

Key parameters:
- `TimeToActivateEEMF`: Duration in State-2 before committing to State-4
- `TimeToActivatePHFO`: Duration in State-3 before committing to State-1
- Both observers run simultaneously in transition states
- Handoff requires angle agreement between observers (< 10° electrical)

---

## Position Compensation Block

**Path:** `mcblib/Control/Synchronous Machine/Position Decoders/Sensorless Estimators/Position Compensation`

Corrects for observer phase lag at high speed.

| Port | Dir | Signal |
|------|-----|--------|
| u1 | In | θ_in (raw angle) |
| u2 | In | ω (speed) |
| y1 | Out | θ_out (compensated) |

| Parameter | Options | Notes |
|-----------|---------|-------|
| `PhaseCompensationType` | `'Sample delay'`, `'Frequency-based'` | Method |
| `NumberSampleDelay` | integer | For sample-delay method |
| `CutOffFreq` | Hz | For frequency-based method |

Phase lag becomes significant (>3° electrical) above: `speed_rpm ≈ 3 / (delay_samples × Ts × p × π/30)`

---

## Common Mistakes

1. **HFI on SPMSM** — Ld = Lq means zero saliency signal; HFI cannot work
2. **Injection frequency within current loop BW** — distorts currents
3. **Missing single-precision DTC on HFI inputs** — silent errors
4. **Blending with unfiltered speed** — chattering at transition boundaries
5. **No polarity detection** — N/S ambiguity at standstill; enable `PolCorrTech`
6. **Handoff without angle agreement** — >10° mismatch causes torque transient

----
Copyright 2026 The MathWorks, Inc.
----
