# Circuit Envelope vs Idealized Baseband

The Library choice is a fundamentally different solver architecture (30-150x speed).

## Solver Architecture

| | Circuit Envelope | Idealized Baseband |
|--|-----------------|-------------------|
| **Domain** | Simscape physical network | Simulink signal flow |
| **Solver** | Nonlinear network (Newton iterations) | Unidirectional function calls |
| **Topology** | Arbitrary (feedback, reflections) | Cascade only |
| **Speed** | Baseline | 30-150x faster |
| **Code gen** | No | Yes (Simulink Coder) |
| **Multi-carrier** | Yes (multiple Tones) | Single-carrier only |
| **Impedance** | Real at every node | Nominal 1 Ohm |
| **Harmonics** | Generated and tracked | Not modeled |
| **Mismatch** | Inherent | `Mismatch=true` adds first-order loss |

## Decision Criteria

**Use Circuit Envelope when:**
- Impedance mismatch matters (VSWR effects between stages)
- Multi-carrier signals (intermodulation between carriers)
- Harmonic generation matters (PA harmonics, mixer spurs)
- Bidirectional power flow needed (antenna reflections)
- You're unsure -- CE is always correct (just slower)

**Use Idealized Baseband when:**
- Well-matched system (50 Ohm throughout, VSWR < 1.5)
- Single-carrier signal
- Unidirectional power flow
- Speed matters (long sims, power sweeps, many iterations)
- Verified CE and IB give same answer for your system

## When Does IB Break Down?

IB models per-block in-band nonlinearity but cannot capture cross-stage frequency
interaction -- where one stage creates out-of-band content that a downstream nonlinearity
remixes back onto the signal band.

**CE required:** Mixer without channel-select + downstream nonlinear amp; PA in compression
+ another nonlinear stage; multi-carrier through any nonlinearity.

## Validation Workflow

Always verify before choosing IB:

```matlab
% Step 1: Create BOTH from same rfbudget
rfs_ce = rfsystem(b, ModelName='rx_ce', Library='CircuitEnvelope');
rfs_ib = rfsystem(b, ModelName='rx_ib', Library='IdealizedBaseband', Mismatch=true);

% Step 2: Run same signal through both (>= 3000 samples)
rfs_ce.SampleTime = 1/Fs; rfs_ib.SampleTime = 1/Fs;
y_ce = rfs_ce(x); release(rfs_ce);
y_ib = rfs_ib(x); release(rfs_ib);

% Step 3: Align (different group delays)
[c, lags] = xcorr(y_ce, y_ib);
[~, idx] = max(abs(c));
delay = lags(idx);
if delay > 0
    y_ce_aligned = y_ce(delay+1:end);
    y_ib_aligned = y_ib(1:end-delay);
else
    y_ib_aligned = y_ib(-delay+1:end);
    y_ce_aligned = y_ce(1:end+delay);
end

% Step 4: Compare
alpha = (y_ce_aligned' * y_ib_aligned) / (y_ib_aligned' * y_ib_aligned);
error_pct = 100 * rms(y_ce_aligned - alpha*y_ib_aligned) / rms(y_ce_aligned);
fprintf('CE vs IB error: %.1f%%\n', error_pct);
% Error > 10% -> CE is needed
```

## Staged Approach (Recommended)

```
Step 1: START with CE on small system / short duration
        -> High fidelity, affordable when small

Step 2: CHECK -- does IB give same answer?
        -> Run comparison above

Step 3: SCALE UP with IB for production simulation
        -> Many chains (Rx=16), long sim (full 5G frame)
        -> Iterative optimization loops (DPD training)
```

## Library Property is Read-Only

Cannot change Library after creation. Must recreate from rfbudget:
```matlab
% WRONG: rfs.Library = 'IdealizedBaseband';  % Error!
% RIGHT:
rfs_ib = rfsystem(b, ModelName='rx_ib', Library='IdealizedBaseband');
```

## IB Constraints

- Only supports: amplifier, modulator, rffilter, nport elements
- Cannot contain `rfelement` objects
- `Mismatch=true` adds first-order loss approximation (not full reflection)

## Hybrid Approach

Valid: keep CE for bidirectional/multi-frequency sections, use IB for unidirectional
gain stages. The 5G frame example achieves 9x speedup with "little loss in accuracy."

```matlab
% Programmatic comparison
rfs_ce = rfsystem(b, Library='CircuitEnvelope');
rfs_ib = rfsystem(b, Library='IdealizedBaseband', Mismatch=true);
```

## Gotchas (duplicated here for convenience)

- **Library is read-only after creation.** Cannot change Library on existing rfsystem.
  Must recreate from rfbudget: `rfs = rfsystem(b, Library='IdealizedBaseband')`.
- **"Efficient simulation" = Library choice, NOT SimulationMode.** Don't confuse with
  Simulink's 'normal'/'accelerator'/'rapid accelerator' — those only affect code gen,
  not solver architecture.
- **IB silently gives wrong answers for certain topologies.** A mixer without
  channel-select followed by a nonlinear amp requires CE. Always verify before choosing IB.
- **IB cannot contain rfelement objects.** Only amplifier, modulator, rffilter, nport.
- **Mismatch=true on IB.** Adds first-order loss approximation (not full reflection).
  Without it, IB ignores impedance mismatch entirely.
- **SampleTime must match for comparison.** When comparing CE vs IB outputs, both must
  use the same SampleTime and input signal for a valid comparison.

----

Copyright 2026 The MathWorks, Inc.

----
