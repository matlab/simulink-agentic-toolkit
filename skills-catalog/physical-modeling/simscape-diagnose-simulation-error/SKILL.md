---
name: simscape-diagnose-simulation-error
description: "Triage Simscape simulation errors and solver warnings and dispatch to the appropriate diagnostic surface. Covers transient/runtime failures — min step size violations (stiffness, parasitics, event-time), transient initialization failures, and index reduction (\"Cannot solve for one or more variables\"), including errors that appear only with run-time parameters. Use whenever a Simscape model fails to simulate or warns while simulating, even if the user doesn't quote the message and it only shows up after you run the model or read a warnings log; load it before attempting a fix."
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "0.2"
---

Diagnose the simulation error for a Simscape model. In the code below,
`modelName` is the name of that model.

In your answer, quote the tool results your diagnosis rests on (e.g. the
compiled sample times, or the stiffest row with its time, λ and coefficient).
Don't re-run fixes the user says they already tried.

## When to Use

When a Simscape model hits "min step size" violations (stiffness, parasitics, event-time), "transient initialization failed to converge", "Cannot solve for one or more variables, including dynamic variable derivatives", or "stepsize control for transient solve".

## When NOT to Use

- Errors in custom .ssc source (parse, unit, equation count, validation): use `simscape-write-ssc`.
- Building or editing a model that has no simulation error: use `building-simulink-models`.

## Setup

The diagnostic API is bundled with this skill as MATLAB packages under
`scripts/+simscape/+agentic`. Use `evaluate_matlab_code` with `project_path`
set to this skill's `scripts/` folder so MATLAB resolves the
package-qualified calls (e.g. `simscape.agentic.statistics_viewer_run(...)`).
Don't `addpath` `scripts/`. Because `project_path` also makes `scripts/` the
current folder, a model that uses `.ssc` files from its own folder fails to
compile (`Unrecognized function or variable`): `addpath` the model's folder first.

Keep warnings on when you check a fix (use `evalc` to shorten the output
instead): after `warning('off','all')`, Simulink records no warnings, so a fix
that didn't work looks like it did. If the script errors, they stay off for the
rest of the session.

Don't run tight-tolerance "reference" sims to check accuracy: on stiff models
they can take many minutes.

## Triage: Which path to follow?

Messages on large models can run to thousands of characters, with the key phrase buried after long lists of variables or components. Don't read them end-to-end: scan for the keywords below and stop at the first match:

- If it mentions **"Event iteration failed to converge within the iteration limit"** → the cause is mode chattering, not a discontinuity or index problem. This skill does not apply. Report to the user that the failing component's mode transition logic is entering an infinite loop and needs review.
- If it mentions **"min step size"** at an event time (Step block firing, mode change), OR **"transient initialization failed to converge"** mid-simulation (not at t=0) → start with the **Discontinuous Inputs** path
- If it mentions **"high stiffness"**, **"min step size"**, or **"step size control"** and is NOT clearly tied to an event → start with the **Stiffness** path
- If it mentions **"transient initialization failed to converge"** at **t=0**, **"cannot solve for one or more variables"**, or **"problems possible for transient initialization"** → start with the **Index Reduction** path
- If none of these match (e.g. an undefined variable or a dimension mismatch) → no path applies. Report the error to the user and fix it directly, without starting a path.

---

## Discontinuous Inputs path

Event-time min-step violations and mid-sim transient initialization failures are both symptoms of the same underlying issue: a discontinuity forces the solver to re-initialize, and either the step size or Newton convergence fails at the discontinuity time. Do Steps 1–5 in order; try Stiffness-path fixes (e.g., parasitics) only if smoothing fails.

### Step 1 — Pin AbsTol and turn off auto-scale first

Often sufficient on its own. Use `model_query_params` to read the model-level `AbsTol` and `AutoScaleAbsTol`.

The Simscape-recommended default (set by `ssc_new`) is `AbsTol = 1e-3` with `AutoScaleAbsTol = off`. With `AutoScaleAbsTol = on`, the effective AbsTol tracks the running maximum of each state — once a transient spike widens `xmax`, AbsTol stays loose for the rest of the sim. The solver can then accept bad steps it never recovers from. It can also end up too tight if `xmax` is small, causing Newton to fail to converge on DAE re-solves after discontinuities. With `daessc`, `AutoScaleAbsTol` has no effect and `auto` behaves like AbsTol = RelTol, so this step changes little.

Use `model_edit` (configure operation) to set `AbsTol` to `1e-3` and `AutoScaleAbsTol` to `off`. `1e-3` (roughly `xmax · reltol` with `xmax = 1`) is only a starting point: tighter values like `1e-4` or `1e-5` are often better, as long as sim time and convergence stay acceptable. Suggest that the user tighten it step by step. If this fixes it, stop here.

### Step 2 — Find discontinuity sources with zero-crossing detection off

Use `model_query_params` to read the model's `ZeroCrossControl` and the `ZeroCross` parameter of the source blocks. Without zero-crossing (ZC) detection, the solver steps past the event without re-initializing, so it never solves for consistent states across the discontinuity. Fix: either enable ZC detection on the source block, or eliminate the discontinuity (e.g., replace `Pulse Generator` with `Signal Generator` using a square waveform — `Pulse Generator` is discrete and has a known Fixed-In-Minor quirk where the signal appears one-step-delayed to Simscape).

### Step 3 — Inspect the compiled sample times at each S-PS input

Run `simscape.agentic.spsInputSampleTimes(modelName)`. It compiles the model and returns each S-PS (Simulink-PS Converter) block, where Simulink signals enter the Simscape network, with the compiled sample time of its input. Fix only inputs that change near the failure; a constant signal needs no fix.

- `[T 0]` with T > 0 — discrete signal (discontinuous). Fix: insert a First Order Hold just before the S-PS converter. A First Order Hold needs a discrete input, so don't replace an upstream Zero-Order Hold: its input is usually continuous. Prefer this to the S-PS converter's input filtering, which needs a well-chosen time constant.
- `[0 1]` — Fixed-In-Minor. Still discontinuous (updates at minor time steps). If it comes from a Rate Transition with a discrete input, replace the Rate Transition with a First Order Hold, which then gets that discrete input.
- `[0 0]` — continuous, but it can still step, e.g. after a Switch, MultiPortSwitch, sharp lookup table, comparator, or a Data Store written by a discrete controller. For a mid-sim failure, log the S-PS inputs and look for jumps just before the failure ([S-PS input jumps](references/sps_input_jumps.md)). Fix: turn on the S-PS converter's input filtering, which starts from the input's initial value. A Transfer Function low-pass starts from 0, so it suits only signals that start at 0.

### Step 4 — Choose the smoothing time constant

For the input filter or the Transfer Function `1/(τ·s + 1)`, pick τ based on the physical bandwidth of what the signal represents:

- Match the controller sample period
- Or match the actuator response time (a real actuator can't follow a step anyway)

Too small → doesn't smooth enough to help the solver. Too large → sluggish response, loses genuine transient behavior.

### Step 5 — Apply and verify

Use `model_edit` to insert/replace the smoothing blocks, then use `model_test` (or `sim` via `evaluate_matlab_code`) to verify the simulation completes.

### When NOT to smooth

Do not smooth signals that represent physically real discontinuities — e.g., a valve command that should snap shut, a circuit-breaker trip, an impact event. For those, the mode change is real and the solver should re-initialize; investigate solver settings (`MaxModeIter`, `ConsistencyTolSource` — read/write with `model_query_params` and `model_edit` on the Solver Configuration block) or the physics instead. If the event blocks an ideal source (e.g., a flow source behind a closed valve), add a relief valve or leakage path; compliance alone (e.g., a Constant Volume Chamber) runs, but pressure keeps rising.

If none of the above resolves the issue, proceed to the Stiffness path or the Index Reduction path, depending on the error message. For a mid-sim failure, do the `[0 0]` jump check first.

---

## Stiffness path (min step not at event time)

### Step 1 — Collect blocks with nonzero parasitic parameters

Run `simscape.agentic.parasiticParameters(modelName)`. It finds the parasitic parameters of all blocks and returns every nonzero value with its block, `ReferenceBlock`, parameter name, and unit, smallest first. Do not iterate a per-state table.

Each parasitic creates a time constant ε, e.g. ε = L·g for a parallel conductance on an inductor, ε = r·C for a series resistance on a capacitor. If ε is much smaller than the simulation step size (e.g., ε ≤ 1e-6 s), the parasitic introduces a fast mode. The equation is `ε·ẋ = -x`, which decays as exp(-t/ε) — the solver interprets this as a discontinuity.

### Step 2 — Group by (library block, parasitic value); order smallest first

Bucket the records from Step 1 by **(`ReferenceBlock`, parasitic value)** — instances of the same library block with the same parasitic value form one group, even if the blocks have different names. Zero the whole group in one run: if you zero only one instance, the others keep the same fast mode and the warning stays. Sort groups by parasitic value, smallest first. The smallest value gives the fastest mode, the most likely culprit.

Splitting on value keeps an outlier instance from hiding behind the others.

### Step 3 — Zero one group at a time

For each group, in smallest-first order (if the stiffness results or the circuit point to a group, test it first):

1. Zero every instance in the group and simulate.
2. Interpret:
   - **Sim runs cleanly, model no longer stiff** — the fast mode came from this group. The Stiffness path succeeded. In your answer, list every group (blocks, parameter, value) with its test result, and which parasitics you zeroed; restoring them is the user's decision.
   - **Sim runs cleanly, model still stiff** — the group is not the cause. Restore every instance in the group and continue to the next group.
   - **Singular Jacobian or index reduction error** — at least one instance in the group is structurally required. Restore every instance in the group and continue to the next group.

If no group yields a non-stiff sim, proceed to Step 4.

### Step 4 — If parasitics are not the cause, query Simscape Stiffness

Seed the query with the failure time from the warning message — this is essential for hanging simulations, where the solver never accepts a step at the failure region:

```matlab
% TEMPLATE — not executable
tFail = <failure time>;
[data, simError] = simscape.agentic.stiffness_analyzer_run(modelName, tFail);
```

The wrapper enables stiffness detection, seeds it with `tFail`, and runs the model, catching the expected failure at `tFail`.

If `simError` is not empty, the simulation errored. Tell the user and quote the message, then continue with the rows in `data`.

Each row of `data` reports a stiff state pair with fields including `.stiffness` (the eigenvalue), `.variable`, `.block`, `.coefficient`, and `.location`. The `.block` field points at the source of the fast mode.

See [Stiffness Analyzer reference](references/stiffness_analyzer.md) for the full API.

### Step 5 — Interpret the eigenvalue rows and pick a fix

**1. Convert `λ` to a decay timescale and sanity-check retuning.**

The `.stiffness` field is the fast-mode eigenvalue reported by Simscape's stiffness detection. The parasitic mode's decay time constant is `τ ≈ 1 / |λ|`. Compare `τ_min = 1/|λ|_max` to the fastest genuine physical timescale the model needs to resolve — the inner control loop, the fastest actuator, whatever is intentionally fast in the physics. If `τ_min` is many orders of magnitude below that, the fast mode is a numerical artifact and retuning is safe. If it's close, retuning may distort real dynamics.

Simulink's MinStep floor scales as `eps(t)` — approximately `t · 2.2e-16`. The earliest absolute time at which the solver can resolve a mode of eigenvalue `|λ|` (needing ~3 samples) is roughly `t_fail ≈ 1 / (3 · |λ| · 2.2e-16)`. Use this to pick a target: choose `|λ|_target` so `t_fail_target` is well past the simulation stop time. This is a lower bound — MinStep violations can also arise from coupled groups (see next step) that this single-mode formula does not predict.

**2. Group rows by |λ| — coupled modes must be retuned together.**

Sort rows by `|λ|` descending. If the top row is >10× larger than the next → single-block fix, act on that `.block` alone. If the top 2–N rows share the same `|λ|` (within a factor of ~2) → coupled group, act on all their `.block`s together. Retuning only part of such a group leaves the MinStep violations.

**3. Map `.block` to the actual dialog parameter that controls the mode.**

`.coefficient` gives the parasitic's signed magnitude (e.g. `-2e-11`), not its unit or type. Read the block's `DialogParameters` and look for names containing `C`, `L`, `R`, `G_parasitic`, `R_parasitic`. Each parameter has a `<name>_unit` sibling (e.g. `c_unit = 'F'`, `l_unit = 'H'`); read it with `model_query_params` to confirm the parameter type. The retune direction depends on what the parameter sits against, not on its name:

- **Capacitance** or **inductance** (`C`, `L`) → **raise** to slow the mode.
- **Series resistance** (`r`, `R_parasitic`) → **raise** against a capacitance (τ = R·C), **lower** against an inductance (τ = L/R).
- **Parallel conductance** (`g`, `G_parasitic`) → **lower** against a capacitance (τ = C/G), **raise** against an inductance (τ = L·G).

Unsure (e.g. `G_parasitic` on a current source)? Change it 10×, re-run the analyzer, keep the direction that lowers |λ|.

Prefer to retune parasitic terms over main capacitances/inductances when both are candidates: main `C` and `L` values are design choices, while `G_parasitic` and `R_parasitic` are usually left at defaults.

Scale the parameter to move `τ` in the chosen direction by the ratio `|λ|_current / |λ|_target`. Example: `|λ|_current = 7.6e12`, `|λ|_target = 1e6` ⇒ ratio 7.6e6. Raise by multiplying (`C_new = C_old · 7.6e6`), lower by dividing (`G_new = G_old / 7.6e6`).

After retuning, re-run the stiffness detection. If `|λ|_max` dropped by roughly the expected ratio, the fix landed. If it rose, reverse the direction. If it didn't move, the parameter may be unused in this block configuration, or the group is larger — expand.

### Step 6 — If stiffness is inconclusive or the user can't change the parameters, try variable scaling

See [Variable Scaling Analyzer reference](references/variable_scaling_analyzer.md) and [Nominal Values reference](references/nominal_values.md) for the full API.

1. Run the Variable Scaling Analyzer:
   ```matlab
   scaling = simscape.agentic.variable_scaling_analyzer_run(modelName);
   T = scaling.scalingTable();
   disp(head(T(T.IsFlagged, :), 20))   % flagged states, at most 20
   ```
2. Check suggestions:
   ```matlab
   msgs = scaling.suggestions();
   disp(msgs')
   ```
3. If any state is flagged (`IsFlagged`), set nominal values for its unit, even if nominal values are already on. New models have them on by default, so the suggestions may not ask you to enable them.
   - Read the `MinData` and `MaxData` columns to find the operating magnitude of the flagged states. Skip states whose unit is `unknown` or `1`.
   - Set the nominal value of each unit to the order of magnitude of the operating point (e.g., 100 V, 10 A). Tell the user that every state with that unit is now checked against AbsTol × nominal value (e.g., 1e-3 × 100 V = 0.1 V) and that other units keep AbsTol.
   ```matlab
   N = simscape.agentic.nominal_values_get_nominal_values(modelName);
   N.Value(N.Unit == "V") = "10";   % add a row if the unit is not in the table
   simscape.agentic.nominal_values_set_nominal_values(modelName, N);
   simscape.agentic.nominal_values_set_nominal_enabled(modelName, true);
   ```
4. Re-run to verify the warning is gone

---

## Index Reduction path (transient initialization failure)

### Background

A transient initialization error (see Triage) can occur when the Simscape solver receives an unreduced high-index DAE.

A common root cause is that **index reduction did not engage** for one or more algebraic constraints in the model's SSC equations. To confirm it, switch to Projection and check whether the constraint count increases.

### Step 1 — Record baseline constraint count

See [Statistics Viewer reference](references/statistics_viewer.md) for the full API.

```matlab
stats1 = simscape.agentic.statistics_viewer_run(modelName);
summary1 = stats1.summary();
fprintf('Baseline constraints: %d\n', summary1.numConstraints);
```

Record `summary1.numConstraints` as the baseline (N1).

### Step 2 — Switch to Projection

Use `model_overview` to find the Solver Configuration block (reference block: `nesl_utility/Solver Configuration`). Then use `model_query_params` to read its current `IndexReductionMethod`.

If it is already `Projection`, stop: tell the user that the failure has a different root cause (see the "N2 == N1" causes in Step 3).

Otherwise, use `model_edit` (configure operation) to set `IndexReductionMethod` to `Projection`.

- **DerivativeReplacement** (default): Differentiates constraint equations analytically and adds the derived equations to the system. Usually faster. Can fail silently: the model compiles, but index reduction does not engage for the problematic constraint.
- **Projection**: Lets the solver integrate freely, then projects the solution back onto the constraint manifold at each step. Particularly effective for systems with fixed geometric constraints in Cartesian coordinates (e.g., pendulums, linkages, closed kinematic chains).

### Step 3 — Check constraint count after switching

```matlab
stats2 = simscape.agentic.statistics_viewer_run(modelName);
summary2 = stats2.summary();
fprintf('Constraints after Projection: %d\n', summary2.numConstraints);
```

Record `summary2.numConstraints` as the new count (N2).

**Interpretation:**

- **If N2 > N1:** Projection exposed constraints that DerivativeReplacement was not handling: a high-index problem that requires Projection. Go to Step 4.
- **If N2 == N1:** Switching to Projection did not change the constraint count. The transient initialization error is NOT caused by failed index reduction — the problem lies elsewhere. Use `model_edit` to set `IndexReductionMethod` back to its original value, and tell the user that this skill does not apply. Common alternative causes:
  - **Inter-component non-reducible high-index constraint:** Two components on the same node both define the across-variable from independent state variables. The error message identifies the conflicting components directly; don't write code to trace the wiring. Neither method can detect or reduce this. Fix: insert an algebraic element to break the constraint. If the constrained differential variable is an across variable, insert something in **series** (e.g., a Rotational Damper). If the constrained differential variable is a through variable, insert something in **parallel**. A damper is ideal: one linear equation relating through and across variables.
  - **Failed IC/CIC solve for reasons other than index reduction:** the initialization Newton iteration diverged. Use [`initialization_analyzer`](references/initialization_analyzer.md) to trace the state trajectory of each Newton iteration (for models with the local solver enabled, use [`variable_viewer`](references/variable_viewer.md) instead). A single run captures multiple solves (IC at t=0, plus CIC and re-solves after mode changes); call `analysis.solveEvents()` first to list them and pick the `solveIdx` that matches the failure time reported in the error message. Then call `analysis.stateTable(solveIdx)` and `analysis.suggestions(solveIdx)` — do not use the default `solveIdx=1` unless the failure is at t=0.

### Step 4 — Verify the fix

Re-simulate the model using `model_test` (or `evaluate_matlab_code` with `sim(modelName)`) to confirm the error is resolved.

Report to the user: the model has a high-index constraint that DerivativeReplacement was not reducing. Projection handles it correctly. The change is applied to the model in memory — leave it to the user to decide whether to save.

### Step 5 — Last resort

If none of the above resolves the issue, try enabling the local solver on the Solver Configuration block (`UseLocalSolver = 'on'`).

----

Copyright 2026 The MathWorks, Inc.

----
