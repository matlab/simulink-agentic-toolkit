---
name: simulink-frequency-response
description: >
  Estimate frequency response from Simulink models using frestimate. Use when frequency response should be obtained from simulation rather than model linearization.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Simulink Frequency Response Estimation

Obtain frequency response data from Simulink models using simulation-based estimation (`frestimate`) when analytical linearization is not viable or as a validation tool.

## When to Use

- Model contains hard discontinuities (PWM, switching, relay, quantizer) that linearize to zero or NaN
- Validating a linear model against a simulation based linearization of a Simulink model
- Estimating frequency response directly from simulation data

## When NOT to Use

- Model linearizes cleanly with `linearize` — use `simulink-linearize` instead
- Working with measured data only (no Simulink model) — use System Identification Toolbox

## Workflow

```
1. Define I/O  →  2. Choose Signal  →  3. Configure  →  4. Estimate  →  5. Fit (optional)
   (linio)          (PRBS/Sinestream)    (constraints)    (frestimate)     (tfest)
```

### Stage 1: Define I/O Points

Determine I/O points for the estimation using this decision sequence. Use the first case that applies:

**Case A — IO points can be inferred from prompt or model context:**

Use the first sub-case that matches:

1. **User specifies explicit I/O signals or blocks** (e.g., "from r to y") → define `linio` points. All `linio` points must reference a block's output port. If a candidate block has no output ports (Outport, Terminator, Scope) → trace upstream to find the source block and port with `model_read`.
   ```matlab
   io = [linio(sprintf("%s/InputBlock", mdl), 1, "input"); ...
         linio(sprintf("%s/OutputBlock", mdl), 1, "output")];
   ```

2. **Root-level Inport/Outport blocks exist** → use `model_read` at root scope (depth `"0"`) to identify root-level Inport/Outport blocks, then define linio at those blocks (trace Outport blocks upstream to their source for the output linio point).

**Case B — Cannot determine IO points:**

If none of the above apply → **do not guess**. Ask the user which signals to use as estimation input and output. Present the available blocks/signals from the model to help them decide.

**Pre-flight checks (before choosing a signal):**

1. Verify I/O points are NOT at blocks without output ports (Outport, Terminator, Scope)
2. Check sample times at I/O points — both must match the perturbation signal rate, or both must be continuous
3. Consider whether the model has time-varying source blocks (Step, Ramp, Signal Generator, etc.) that could drive the system away from its steady-state operating point during estimation. If so, see **Disabling Time-Varying Sources** below.

### Stage 2: Choose Perturbation Signal

**Decision (follow in order):**

1. Is broadband estimation sufficient (most cases)? → Use `frest.PRBS` **(DEFAULT)**
2. Is the model discrete? → Use `frest.PRBS` with `Ts` matching the I/O sample time, or `frest.createFixedTsSinestream` if per-frequency data needed
3. Do you need precise magnitude/phase at specific frequencies? → Use `frest.Sinestream` (continuous) or `frest.createFixedTsSinestream` (discrete)

Prefer `frest.PRBS` — it estimates the full frequency range in a single simulation. Sinestream simulates each frequency sequentially and is significantly slower for broadband estimation.

### Stage 3: Configure the Signal

**PRBS (default):**

```matlab
in = frest.PRBS(Ts=Ts, Amplitude=0.01, Order=10, NumPeriods=2);
```

If the I/O signal is discrete, set `Ts` to match the signal sample time. If continuous, set `Ts` to a value that provides sufficient temporal resolution. Choose `Amplitude` small enough to stay in the linear regime of saturations/nonlinearities.

> **Why PRBS first?** A single PRBS simulation estimates the full frequency range at once. Sinestream simulates each frequency sequentially — for 30 frequencies with 8 periods each, this can take 10-100x longer. Use Sinestream only when you need precise per-frequency data (e.g., gain/phase margin at specific crossover frequencies).

**Sinestream (continuous models):**

```matlab
in = frest.Sinestream(Frequency=logspace(-1, 2, 30), Amplitude=0.01);
in.NumPeriods = 8;
in.SettlingPeriods = 3;
```

The filtering constraint: `NumPeriods - SettlingPeriods >= 3` when `ApplyFilteringInFRESTIMATE = "on"` (default). Violating this throws an error at estimation time.

**Fixed-Ts Sinestream (discrete models):**

```matlab
Ts = 0.01;
in = frest.createFixedTsSinestream(Ts, {wmin, wmax});
in.Amplitude = 0.01;
in.NumPeriods = 8;
in.SettlingPeriods = 3;
```

Use the cell syntax `{wmin, wmax}` for the frequency range — this auto-selects frequencies that are valid integer divisors of the sampling frequency. Do NOT pass an explicit frequency vector:

```matlab
% CORRECT — cell syntax auto-selects valid frequencies
in = frest.createFixedTsSinestream(Ts, {wmin, wmax});

% WRONG — explicit vector (most frequencies violate integer-multiple constraint)
in = frest.createFixedTsSinestream(Ts, logspace(-1, 2, 30));  % Error
```

**When to use Sinestream instead of PRBS:**
- PRBS results are too noisy (high variance at individual frequencies)
- Need precise magnitude/phase at specific frequencies
- Very nonlinear system where broadband excitation causes intermodulation

**Check simulation time:**
Always verify that the signal duration is practical before launching the estimation:

```matlab
tFinal = getSimulationTime(in);
fprintf("Estimated simulation time: %.1f seconds\n", tFinal);
```

If `tFinal` is too big compared to `Ts`, use larger lower frequency bounds for estimation.

### Stage 4: Estimate

Determine where to start the experiment. Choose one:

| Situation | Approach |
|-----------|----------|
| Model ICs | Skip — `frestimate` uses model initial conditions |
| Steady-state trim | `operspec` → configure → `findop` |
| Need snapshot from simulation | `findop(mdl, tSnapshot)` |
| Operating point known | `operpoint` object → configure |

```matlab
sysest = frestimate(mdl, op, io, in, opts);
```
`op` and `opts` are optional arguments. If `op` is not provided, the experiment will start at model initial conditions.

`opts` is a `frestimateOptions` object. Pass it when time-varying sources need to be disabled (see below).

The result is an `frd` (frequency response data) object.

### Stage 5: Fit Parametric Model (Optional)

Only perform this step if a parametric model (transfer function, state-space, zpk) is required. If the goal is frequency response data only (e.g., Bode plot, gain/phase margins from frd), stop after Stage 4.

Convert the non-parametric `frd` to a parametric model:

```matlab
sysFit = tfest(sysest, np, nz);
fprintf("Fit: %.1f%%\n", sysFit.Report.Fit.FitPercent);
```

## Disabling Time-Varying Sources

Time-varying source blocks (Step, Ramp, Signal Generator, etc.) can drive the model away from its steady-state operating point during estimation. When this happens, the system does not remain near the operating point and the estimated response is unreliable — gain estimates can be off by orders of magnitude while executing without error.

**When to disable sources:**

- The model contains source blocks (other than the perturbation input) that change value during the estimation simulation
- Estimation results are implausible or don't match an expected linearization
- The time-domain response does not reach steady state at individual frequencies

**How to identify and disable them:**

Use `frest.findSources` to identify time-varying source blocks in the estimation path, then set `BlocksToHoldConstant` so they are held at their initial value during estimation:

```matlab
srcblks = frest.findSources(mdl, io);
opts = frestimateOptions;
opts.BlocksToHoldConstant = srcblks;
sysest = frestimate(mdl, io, in, opts);
```

Note: `frest.findSources` requires model compilation. The perturbation input is not affected by `BlocksToHoldConstant`.

## The Fallback Pattern

When `linearize` returns zero, follow this sequence:

```matlab
% 1. Try linearize
sys = linearize(mdl, io);
if dcgain(sys) == 0
    % 2. Disable time-varying sources if present
    srcblks = frest.findSources(mdl, io);
    opts = frestimateOptions;
    opts.BlocksToHoldConstant = srcblks;
    % 3. Fall back to frestimate with PRBS
    in = frest.PRBS(Ts=Ts, Amplitude=0.01, Order=10, NumPeriods=2);
    sysest = frestimate(mdl, io, in, opts);
    % 4. Fit parametric model
    sysFit = tfest(sysest, 2);
end
```

Do NOT use manual block substitution (`replace_block`) as a workaround for zero linearization. The `frestimate` approach is generalizable to any discontinuous model without requiring domain knowledge of each block's averaged equivalent.

## Key Functions

| Function | Purpose | Available From |
|----------|---------|----------------|
| `frestimate` | Estimate frequency response from Simulink | R2009b |
| `frest.findSources` | Identify time-varying source blocks to hold constant | R2010b |
| `frestimateOptions` | Options including `BlocksToHoldConstant` | R2010a |
| `frest.PRBS` | Pseudorandom binary sequence signal | R2020a |
| `frest.Sinestream` | Multi-sine perturbation signal | R2009b |
| `frest.createFixedTsSinestream` | Fixed sample time sinestream | R2009b |
| `getSimulationTime` | Check signal duration before running | R2012a |
| `tfest` | Fit transfer function to frequency data | R2012a |
| `ssest` | Fit state-space model to frequency data | R2012a |

## Common Mistakes

| Mistake | Why It Fails | Correct Approach |
|---------|-------------|-----------------|
| Not disabling time-varying sources | Source blocks drive the model away from its steady-state operating point, producing unreliable estimates without error | Use `frest.findSources` to identify sources, set `opts.BlocksToHoldConstant` to disable them |
| Using `replace_block` to work around zero linearization | Requires domain knowledge of averaged equivalents; doesn't generalize | Use `frestimate` with PRBS — works for any discontinuous model |
| Setting `NumPeriods=5, SettlingPeriods=3` with filtering on | Violates `NumPeriods - SettlingPeriods >= 3` constraint | Use `NumPeriods=8, SettlingPeriods=3` or disable filtering |
| Output linio at different rate than input signal | `frestimate` rejects multi-rate I/O configurations | Place both I/O points at blocks matching the signal's sample time |
| Only using `frest.Sinestream` (ignoring PRBS) | Sinestream is much slower — simulates each frequency sequentially | Start with `frest.PRBS` for broadband estimation; use Sinestream only when frequency-by-frequency precision is needed |
| Large perturbation amplitude near saturations | Drives system into nonlinear regime, corrupting estimation | Choose amplitude small relative to saturation limits (e.g., 1-5% of range) |

## Conventions

- **Always:** Consider whether time-varying sources could drive the model from its operating point — use `frest.findSources` and `BlocksToHoldConstant` to disable them
- **Prefer:** `frest.PRBS` for broadband estimation — faster than Sinestream for most workflows
- **Always:** Use cell syntax `{wmin, wmax}` with `frest.createFixedTsSinestream`
- **Always:** Ensure `NumPeriods - SettlingPeriods >= 3` when filtering is enabled
- **Always:** Place I/O points at rate-compatible blocks for multi-rate models
- **Always:** Call `getSimulationTime` — Validate signal duration before running. Long simulations relative to max solver step size should prompt redesign.
- **Prefer:** `frestimate` over manual block substitution for discontinuous models
- **Prefer:** `tfest` or `ssest` for fitting parametric models to `frd` results
- **Prefer:** Small amplitude — Keep perturbation small enough to stay in the locally linear regime (typically 1-5% of operating range).
- **Never:** Use `replace_block` as a general linearization workaround

----

Copyright 2026 The MathWorks, Inc.

----
