# Behavior Consistency Check — Reference

This is the optional add-on to the `fix-sldv-incompatibility` workflow. It
applies **only** when the surrounding intent calls for confirming the fix
preserved behavior (test generation, design error detection, or the user asks).
For a plain compatibility request the skill stops after Step 4 — do **not**
load or run this.

Step 4 already confirms the model is analyzable — the endpoint for a plain
compatibility request. Compatibility does **not** confirm the fix *preserved
behavior*; the consistency check is the optional add-on that addresses this.
Be precise about what it delivers: it replays a **finite** set of
SLDV-generated test cases and confirms the original and fixed copy **agree on
those cases**. That **raises confidence** the fix preserved behavior — it does
**not** prove equivalence, because inputs the generated suite does not exercise
could still diverge. Decide from conversation context (you cannot detect the
caller):

- **User only wants compatibility:** stop after Step 4. Optionally suggest:
  *"The fixed copy is compatible. I can also raise confidence the fix preserved
  behavior by replaying SLDV-generated tests on the original model — note this
  checks agreement on the generated cases, not full equivalence."*
- **Behavior must be preserved** (test generation, design error detection, or
  the user asks): run the consistency replay below.

## Back-to-back consistency replay (I/O-preserving fixes)

The tool is **self-contained**: `sldv_verify_consistency` obtains the baseline
itself — reusing an sldvData file for the fixed copy if present, otherwise
running SLDV test generation on the fixed copy with `SaveExpectedOutput='on'` —
then replays those inputs through the original. SLDV cannot *analyze* the
incompatible original, but it still *simulates*, which is what makes the replay
direction work.

```matlab
% Pass the ORIGINAL model and the FIXED copy; the tool generates/reuses the
% baseline internally, then replays and compares.
con = sldv_verify_consistency(originalModelPath, result.copyPath);    % tight default (1e-9)
% For discretization fixes (Integrator/Derivative/Transfer Fcn -> discrete),
% loosen the tolerance since continuous vs discrete numerics differ:
con = sldv_verify_consistency(originalModelPath, result.copyPath, 'absTol', 1e-3, 'relTol', 1e-3);
```

**Read `con.status`, not just `con.passed`** — the check classifies its outcome
into four cases so a structurally-uncheckable fix is never mistaken for a
regression:
- `'pass'` — the comparison ran and every output signal matched within tolerance
  across all generated test cases (`con.applicable == true`). Consistency on
  those cases, not a guarantee of equivalence.
- `'fail'` — the comparison ran and a real value divergence was found
  (`con.applicable == true`). This IS a regression. `con.firstFailure` reports
  the exact test case, output port, time step, expected/actual values, and
  deviation.
- `'not-applicable'` — the fix is structurally uncheckable, NOT wrong
  (`con.applicable == false`, `con.statusReason` explains which case):
  the fix changed the root port signature, or the fixed model exposes no free
  root inputs so SLDV generated zero test cases. Report compatibility only.
- `'error'` — an exception (missing file, generation failed, malformed data);
  `con.errorId`/`con.errorMsg` carry the detail.

Gate your judgment on `con.applicable`: only `applicable == true` results
(`'pass'`/`'fail'`) say anything about behavior. `con.passed` stays true only
for `'pass'` (kept for back-compat). `con.generated` tells you whether this call
generated the baseline or reused an existing one.

**Eligibility (deterministic, not a hardcoded rule list):** the replay compares
original vs fixed copy port-for-port, so it is meaningful only for
I/O-**preserving** fixes (same root In/Outport signature). The tool detects an
ineligible fix itself — a changed root port signature, or a fixed model with no
free root inputs (zero test cases) — and returns `status='not-applicable'`
rather than a false pass or fail. It is always safe to run; for these fixes the
meaningful confirmation is just that Step 4 passed:
- Random Number / From File / From Spreadsheet → Inport (adds a root input)
- Stop / Parameter Writer → deleted
- Simscape plant → bounded Inports
- Self-contained models with no free root inputs (e.g. Constant-driven)

Report the compatible copy path plus, if you ran it, the consistency result
(stating it is confidence on the generated tests, not proof of equivalence).
For a `'not-applicable'` result, state explicitly that the consistency check
did not apply (only compatibility was confirmed) and why, quoting
`con.statusReason`.

<!-- Copyright 2026 The MathWorks, Inc. -->
