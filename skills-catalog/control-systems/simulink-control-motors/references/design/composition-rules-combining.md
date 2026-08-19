
# Composition Rules — Combining Features & Compatibility

> Rules for stacking multiple features onto one model, compatibility matrix, SI/PU differences.
> For logging and speed profiles see `composition-rules-integration.md`.
> For core features (FW, SMO, GainSched, FF) see `composition-rules.md`.

---

## Combining Multiple Features

> Rules for stacking multiple features onto one model. Order matters.

### General Principles

1. **Current loop is innermost** — never modify the current PI (or FOC CC) when adding outer features
2. **Speed loop wraps current** — control reference connects speed PI output to id*/iq*
3. **Position loop wraps speed** — position PI output becomes speed reference
4. **Protection is always outermost** — gates the final PWM enable, independent of control
5. **Feedforward is parallel** — adds to PI output, does not change loop structure
6. **Observer (SMO/HFI) replaces sensor** — changes angle/speed source, not control structure

### Compatible Combinations

**FW + OVM (Field Weakening + Overmodulation):**
- FW adjusts current references (id becomes more negative) to stay within voltage circle
- OVM extends available voltage by modifying PWM duty cycles beyond linear region
- Complementary: FW reduces current demand, OVM increases voltage supply
- Both can be active simultaneously at high speed
- Wire FW before Control Reference (adjusts id*), OVM after InvPark (adjusts voltage)

**GainSched + FOC CC (Gain Scheduling + FOC Current Controller):**
- FOC CC port 5 accepts [Kp_d; KiTs_d; Kp_q; KiTs_q] vector
- Feed 2-D LUT outputs directly to port 5 via Mux(4)
- Natural fit — no structural changes needed beyond adding LUTs and routing to port 5
- LUT inputs (id, iq) come from Park transform (same as standalone gain scheduling)

**SMO + FW (Sensorless + Field Weakening):**
- SMO provides theta_e for Park/InvPark AND for FW voltage computation
- No conflict — SMO angle replaces sensor angle everywhere uniformly
- FW computation uses same voltage signals (Vd, Vq) regardless of angle source
- Ensure SMO CutoffFreq accounts for extended speed range under FW

**SMO + I/f (Sensorless + Startup):**
- Always required together — SMO cannot work below ~5% speed
- I/f provides angle and current references during startup
- Switch block selects between I/f angle and SMO angle based on speed threshold
- Handoff sequence: Alignment -> I/f ramp -> speed threshold -> SMO takeover

**GainSched + FW + SMO:**
- All three combine cleanly: SMO provides angle, gain LUTs adapt PI gains to operating point, FW adjusts id* at high speed
- Order of addition: (1) base FOC, (2) add SMO+I/f, (3) add gain scheduling LUTs, (4) add FW loop

### Mutually Exclusive or Requires Scheduler

**HFI + FW (High-Frequency Injection + Field Weakening):**
- HFI only works at LOW speed (below ~10% rated) where back-EMF is too small for SMO
- FW only activates at HIGH speed (above base speed)
- These are mutually exclusive operating regions
- Need a speed-based scheduler: HFI below threshold, SMO+FW above threshold
- Transition region (~5-15% speed) requires blending or hard switchover with hysteresis

**HFI + SMO:**
- Same mutual exclusion — HFI for standstill/low speed, SMO for medium/high speed
- Scheduler switches angle source: HFI_theta below threshold, SMO_theta above
- Standard pattern: I/f alignment -> HFI tracking -> SMO tracking (two handoff points)

### Protection Interaction Rules

**Protection + everything:**
- Protection is ALWAYS the outermost layer — it gates the PWM enable signal
- Protection does NOT modify current references or speed commands
- When fault triggers: all PWM duties -> 0 (or 0.5 for brake), regardless of control state
- Protection monitors: phase currents, DC bus voltage, temperature (if modeled)
- Protection output (enable/disable) connects to:
  - AND gate before inverter enable
  - OR: FOC CC port 7 (Enable input) set to 0
  - OR: Switch selecting between normal duty and zero duty
- Fault reset logic is independent of control — typically requires explicit reset signal
- All other features (FW, SMO, GainSched, etc.) continue computing internally during fault — only the output to inverter is blocked

### Feature Addition Order (Recommended)

When building a model with multiple features, add in this order to minimize rework:

1. Base FOC (current control + plant)
2. Speed loop (PI + Control Reference)
3. Feedforward decoupling (parallel path, no structural change)
4. Gain scheduling (replaces fixed PI gains with LUTs)
5. Field weakening (adds id* adjustment path)
6. PWM strategy (replaces V2D path)
7. Sensorless (replaces angle/speed source)
8. I/f startup (wraps sensorless with startup logic)
9. Position loop (wraps speed loop)
10. Protection (outermost gate on PWM)
11. Load model (independent, connects to PMSM/1)
12. Logging (independent, taps signals)

---

## Feature Compatibility Matrix

| Base \ Feature | +FW | +SMO | +GainSched | +FF | +Position | +OVM | +Protection |
|---------------|-----|------|-----------|-----|-----------|------|------------|
| Pattern A (Manual PI) | Yes | Yes | Yes | Yes | Yes | Yes | Yes |
| Pattern B (FOC CC) | Yes(via CtrlRef) | Yes | Yes(via port5) | N/A(built-in) | Yes | Yes(before V2D) | Yes |
| Pattern C (Torque only) | Yes | Yes | Yes | Yes | Add speed+pos loops | Yes | Yes |
| Pattern E (V/f) | N/A | N/A | N/A | N/A | N/A | N/A | Yes |
| Pattern F (BLDC) | N/A | N/A | N/A | N/A | N/A | N/A | Yes |

---

## SI vs PU: What Changes

| Component | SI Mode | PU Mode |
|-----------|---------|---------|
| Control Ref Units param | `'SI Units'` | `'Per-Unit (PU)'` |
| Control Ref Tref input | Nm | PU (Tref/T_base) |
| Control Ref wm input | rad/s | PU (wm/N_base*30/pi) |
| Control Ref id*/iq* output | Amps | PU (I/I_base) |
| V2D formula | `Vabc/(2*Vdc/sqrt(3)) + 0.5` | `Vabc_PU * 0.5 + 0.5` |
| Speed PI saturation | `+/-T_rated` (Nm) | `+/-1` (PU) |
| PI gains | SI bandwidth formula | Same formula, different scaling |
| FOC CC block | Always SI (volts/amps) | Always SI (volts/amps) |
| Transforms | Unit-agnostic | Unit-agnostic |
| PMSM plant | Always SI (volts/amps/Nm) | Always SI |

**Rule:** Only Control Reference blocks care about SI/PU. Everything else is unit-agnostic.

----
Copyright 2026 The MathWorks, Inc.
----
