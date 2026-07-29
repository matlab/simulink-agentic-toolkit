# Fix Strategy

The tool provides facts — the agent identifies root causes and decides fixes. No hardcoded
defect-to-fix mapping; block types and model context vary too much for rigid rules.

## Root Cause Identification

1. **Trace the counterexample:** Follow input values through the slice blocks to find which
   block produces the value that triggers the defect
2. **Use model context:** Call `model_overview` / `model_read` on slice blocks to understand
   their role — what does each block do in the design?
3. **If slice is shallow (< 3 blocks) or reaches a Stateflow/MATLAB Function block:**
   - The slicer could not trace through this block — use `model_read` to interpret what it does
   - Read the Stateflow chart logic to understand what conditions produce the defect-triggering output
   - Use counterexample input values to determine which path through the chart is active
4. **Prioritize using Locality data:**
   - High `Locality` (close to 1.0) = narrow blast radius = safer to fix
   - High `FindingCount` = fixing this block resolves more defects
5. **Check Cascades:** Blocks appearing in multiple findings' slices are high-value fix targets
6. **For independent-root cascades:** Each independent partition has a separate root cause
   requiring a separate fix — address them individually

## Applying the Fix

1. **Clone the model first** — never patch the original:
   ```matlab
   clonePath = fullfile(outputDir, model + "_fix.slx");
   save_system(model, clonePath);
   load_system(clonePath);
   ```

2. **Decide the fix** based on what you learned from counterexample + model context:
   - What value does this block produce that causes the defect?
   - What should it produce instead?
   - What's the minimal change to correct it?

3. **Apply via `model_edit`:**
   ```matlab
   model_edit(cloneModel, scope, ops_json);
   ```

4. **Verify** — compile the clone and re-run DED:
   ```matlab
   eval(sprintf('%s([],[],[],''compile'')', cloneModel));
   eval(sprintf('%s([],[],[],''term'')', cloneModel));
   result = sldv_run_defect_checker(cloneModel);
   ```

## Fix Principles

- **Correct the source** — fix the block that produces the wrong value, not the block that reports the error
- **Prefer minimal changes:** parameter correction > range constraint > structural addition
- **Never add Assumption blocks for design errors** — they hide the problem
- **Verify no regressions** — re-running DED should show the defect resolved with no new defects
- **Constant-block root causes — report, don't prescribe.** When the root cause is a Constant
  block whose value makes downstream logic dead (e.g., a mode constant feeding mutually
  exclusive Stateflow transitions), report it to the user and explain how the value propagates
  to create the dead logic. Let the user decide what to change — changing the constant often
  just shifts which branch is dead rather than eliminating the structural issue.

## Propose Multiple Fix Alternatives

Propose a fix for **every** finding — do not stop after addressing only some of them. Each `design_error` finding must be covered.

When possible, present **2–3 fix options** per finding, ranked by preference. For each alternative, explain:
- What to change (specific block, parameter, or structure)
- Why it works (how it eliminates the root cause)
- Trade-offs (simplicity, generality, performance impact)

## Fix Safety and Blast Radius

For every proposed fix, explicitly discuss:
1. **Blast radius** — which other signals, subsystems, or paths are affected by the change? Use `Locality` data to quantify.
2. **Unaffected paths** — confirm that paths NOT involved in the defect remain unchanged by the fix.
3. **Re-verification requirement** — state that DED must be re-run after the fix to confirm the defect is resolved and no new defects are introduced.
4. **Cascade impact** — if fixing a shared root cause, list all downstream findings that will be resolved by the single-point fix.
