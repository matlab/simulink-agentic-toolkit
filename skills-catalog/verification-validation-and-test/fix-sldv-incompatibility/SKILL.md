---
name: fix-sldv-incompatibility
description: Use when a Simulink model is incompatible with Simulink Design Verifier (sldvcompat returns false, or an SLDV analysis errors out on an unsupported construct) and needs to be made analyzable. Diagnoses the incompatibility, applies the matching fix to a copy, and confirms the copy is compatible; optionally raises confidence the fix preserved behavior via a back-to-back consistency replay (agreement on the generated tests, not a proof of equivalence). Do NOT use for running test generation, design error detection, or requirement verification themselves — only for making a model compatible so those can proceed.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# SLDV Incompatibility Fixer

Fix Simulink Design Verifier incompatibilities by diagnosing the model and applying the matching fix. Block-level fixes go through `model_edit`; solver/config-level fixes are the one exception that requires setting the parameter directly (see Step 3).

## When to Use

- User asks "why is my model incompatible with SLDV?"
- User asks "make this model compatible with SLDV"
- User asks to fix SLDV incompatibility issues
- User runs `sldvcompat` and gets `false`
- A test-generation or design-error-detection run errors out on an unsupported
  construct, and the user asks to get past it — make the model analyzable first,
  then hand back to that workflow

## When NOT to Use

- The model is already compatible (`sldvcompat` returns `true`) — there is
  nothing to fix.
- The task is to *run* an SLDV analysis mode (test generation, design error
  detection, property proving) on an already-compatible model — use the
  corresponding analysis skill, not this one.
- The incompatibility is intended and the user wants to keep the unsupported
  construct — do not silently rewrite the model.
- The request is a general Simulink modeling edit unrelated to SLDV
  compatibility.

## Scope

The core job is **diagnose → fix → confirm compatible** (Steps 1–4). That is the
default endpoint. Running an SLDV analysis mode (test generation, design error
detection) and verifying behavior on the original model is **optional** and only
happens when the surrounding intent calls for it (Step 5). A user who just wants
compatibility gets the fix and nothing more.

## Prerequisites

- **Products:** Simulink and Simulink Design Verifier, R2023b or later.
- **The model must build in a normal Simulink compile, with all its external
  dependencies present.** SLDV compatibility is a separate question from whether
  the model compiles at all. Two non-compat cases also make `sldvcompat` return
  `false`: a genuine authoring bug (undefined block parameter, unresolved
  reference), fixed by repairing the model; and a **genuinely missing** external
  dependency — a data-dictionary file, referenced-model file, data file,
  library, or workspace variable the model needs that is *not present / cannot be
  located* — fixed by *providing the resource*, not by editing the model (see
  Step 1.5). Neither is fixed with a compatibility rule. (A resource that is
  present but merely *opaque* to SLDV — a protected `.slxp` reference, external
  custom code, an S-function — is different again: that you **do** fix, by
  stubbing.) When a model fails `sldvcompat`, Step 1 also runs a normal-mode
  compile probe and reports `result.compiles` / `result.buildError` so you can
  tell these apart before matching a rule.
- This skill's functions live in its `scripts/` directory. Call them with
  `evaluate_matlab_code` using `project_path` set to that folder so MATLAB can
  find them.

## Workflow

### Step 1: Run the Diagnostic Tool

Call via `evaluate_matlab_code`:

```matlab
% project_path = the skill's scripts/ folder (via evaluate_matlab_code)
result = sldv_diagnose_incompatibility('<model_path>');
```

This will:
- Create a copy named `<model>_sldv_compatible.slx` in the same folder
- Run `sldvcompat` on the copy

It returns a `result` struct with these top-level fields:
- `.compatible` — `true`/`false`, the `sldvcompat` status on the copy
- `.copyPath` — full path to the working copy (`<model>_sldv_compatible.slx`).
  Later steps pass this to `model_edit` and to `sldv_verify_consistency`
- `.copyName` — name of the copy with no extension (use with `sldvcompat` /
  `save_system` / `close_system`)
- `.findings` — struct array, one entry per issue `sldvcompat` itself reports,
  each with `.msgid`, `.message`, `.type`, `.blockPath`, and `.blockType`
- `.compiles` — logical, populated only when `.compatible == false`: the result
  of a normal-mode Simulink compile probe on the copy. It is a **diagnostic aid,
  not a gate** — the findings above stay authoritative and are matched against
  the catalog regardless. Its purpose is the case where the findings are only
  generic: `true` means the model builds (a real SLDV limitation), `false` means
  it does not compile at all (a plain authoring bug the catalog does not cover —
  see Prerequisites; fix the model first).
- `.buildError` — when `.compiles == false`, the compile error's `.identifier`
  and `.message`; empty strings otherwise.

`sldvcompat` is authoritative: each finding already names the offending object.
For a **block-level** issue, `.blockPath` is the full block path (nesting
included, e.g. `mdl/Sub/White Noise`) and `.blockType` its BlockType. For a
**config-level** issue (variable-step solver, nonempty InitFcn, concurrent
execution, …), `.blockPath` is the model name, `.blockType` is empty, and
`.msgid` identifies the setting.

The diagnostic does **not** scan blocks or pre-read config params: use
`model_overview` / `model_read` / `model_query_params` to inspect whatever a
finding points to, and the rule catalog in `references/incompatibility-rules.md`
to decide the fix.

**A config-level finding can MASK block-level findings.** A variable-step
solver, for example, stops `sldvcompat` before it reaches the blocks. So more
issues may surface only *after* you fix the config-level ones and re-run the
diagnostic — never assume the first pass lists everything (Step 4 loops).

If `result.compatible == true`, the model is already compatible. Done.

### Step 1.5: Triage a Missing External Dependency (ask, don't fix)

Some incompatibilities are not something to *fix* in the model at all — the
model is fine, but an external resource it depends on is **genuinely absent from
the environment**: a data dictionary (`.sldd`) file that is not on disk, a
referenced model file that cannot be located, a `From File` / `From Spreadsheet`
data file that does not exist, a library / MATLAB class / workspace variable a
parameter resolves to that is nowhere on the path. SLDV cannot analyze what it
cannot *find*, so `sldvcompat` fails — but applying a compatibility rule
(replacing or stubbing the block) would be **wrong**: it hides a real gap and
discards the model's intended behavior.

Recognize this class before matching a rule: it shows up as `result.compiles ==
false` together with a `result.buildError` (or a `result.findings` entry) whose
message says a named resource is **missing / not found / does not exist / cannot
be located or resolved**. The identifiers vary by resource and release (e.g. a
missing data-dictionary file, a not-found referenced-model file, an absent data
file), so match on the *meaning* — a named external artifact that **isn't
there** — not on a fixed list of msgids. See "Missing External Dependencies" in
`references/incompatibility-rules.md`.

**This is NOT the present-but-opaque case — do not confuse the two.** A resource
that *exists* but SLDV cannot see inside is a normal stubbing job, **not** a
missing dependency: a **protected** (`.slxp`) referenced model, a
`Model` block referencing one that is present, external **custom code** / an
**S-function** whose source is opaque, a MATLAB Function block calling an
external routine. These are on disk and resolve fine — SLDV just can't analyze
their internals. **Fix them (stub the block), do not ask the user for them.** If
`result.compiles == true` (the model builds), it is by definition *not* a
missing dependency — go straight to Step 2. Only defer to the user when the
named artifact truly cannot be found.

When you hit one, **do not fix or rewrite the model.** Instead:
1. **Explain why** it is incompatible, in plain terms, quoting the exact resource
   named in `result.buildError.message` / the finding message (e.g. *"the model
   references data dictionary `params.sldd`, which SLDV cannot find on the
   path"*).
2. **Ask the user to provide it** — supply the missing file / dictionary /
   referenced model / variable, or point the skill at its location so it is
   resolvable — and then re-run the diagnostic.

Only once the dependency is resolvable does the normal diagnose → match → fix
flow apply. Two other `compiles == false` cases are **not** this and must not be
routed here: a plain **authoring bug** (undefined parameter, broken expression)
is resolved by *repairing the model*; a **present-but-opaque** resource
(protected `.slxp` reference, external custom code, S-function) is resolved by
*stubbing the block* per Step 2/3. Ask the user **only** when the named artifact
genuinely cannot be found — never for a resource that is present but unanalyzable.

### Step 2: Match the Rule

The rule catalog is **not** inlined here — it lives in
**`references/incompatibility-rules.md`**. **Load and follow that file.** For
each entry in `result.findings`, match `.msgid` (and, for block-level findings,
the `.blockType` at `.blockPath`) against the catalog, then apply the listed
fix. Use `model_read` on `.blockPath` to inspect the offending block's
parameters. Use the catalog's Disambiguation Guide when a msgid maps to multiple
rules, and its Stubbing Strategy / Integrator port-matching / block-reduction
sections for the cross-cutting guidance the fixes reference.

### Step 2.5: Localize a Generic Finding (only when the finding is not actionable)

Most findings already name the offending object in `.blockPath`. But some are
**generic** — the message is vague (e.g. a bare `SLDV:Compatibility:Generic`)
and `.blockPath` points at a *container* (the model root or a `SubSystem`)
rather than a leaf block. A generic, container-scoped finding does not tell you
what to fix. When (and only when) you hit one, narrow it:

```matlab
% project_path = the skill's scripts/ folder
loc = sldv_localize_incompatibility('<model_or_atomic_subsystem_path>');
```

This drills the hierarchy, scoping `sldvcompat` onto each atomic subsystem,
atomic Stateflow subchart, and referenced model, and keeps descending into
whichever children are *individually* incompatible. It descends **through**
virtual subsystems (which `sldvcompat` cannot scope) to the next atomic
boundary. It returns:
- `loc.culprits` — one entry per **deepest responsible scope** (the narrowest
  subsystem/subchart/model that is incompatible while none of its scopable
  children are), each with that scope's `.path`, `.kind`, and `.findings`.
- `loc.drilled` — true if the search narrowed below the scope you passed in.
- `loc.searched` — every scope it scoped `sldvcompat` onto (for transparency).

Then match the rule (Step 2) against each culprit's `.findings`, which are now
scoped to the responsible subsystem instead of the whole model. If
`loc.culprits` still points at a scope whose own findings are generic (the
issue is that scope's wiring/config, not a nested block), inspect that scope
directly with `model_read` / `model_query_params`.

Do **not** run localization for findings that already name a leaf block — use
those directly. Localization is only for the generic, container-scoped case.

### Step 3: Apply the Fix

Based on the matched rule:
- For **block-level fixes**: use `model_edit` on `result.copyName`. This is the
  default — all block edits (replacement, stubbing, port matching, rewiring) go
  through `model_edit`.
- For **configuration / model-root fixes**: these change solver/config settings
  (variable-step solver, InitFcn, concurrent execution, …), which `model_edit`
  cannot touch — it only operates on blocks. This is the **one exception** where
  you set the parameter directly via `evaluate_matlab_code` (`set_param` on the
  model root, e.g. the solver type). Most such fixes are the config-level rules
  (Rules 1–7), but a handful of otherwise block-level rules also include a
  config-level `set_param` step (e.g. clearing `CustomSourceCode`, aligning
  referenced-model hardware settings, forcing a fixed-step solver, or disabling
  `BlockReduction`) — those config steps use `set_param` too. The exception is
  defined by the **kind** of fix (a config/model-root parameter), not by the
  rule number. Do **not** generalize it to block-level edits: never reach for
  `set_param` to add, delete, replace, or rewire a block — that is always
  `model_edit`'s job.

Most block-level rules do **semantic replacement** (swap the unsupported block
for an analyzable equivalent). When no faithful equivalent exists — or the
block's internals are irrelevant to the analysis — use the general **stubbing
strategy** instead (see "Stubbing Strategy" in
`references/incompatibility-rules.md`). Stubbing abstracts a block's output to a
free value so SLDV stops analyzing inside it; prefer a *bounded* stub so
analysis stays realistic.

**Before any block replacement, guard against optimized-out blocks.** Block
reduction can delete blocks (bus selectors/creators, IC blocks, …) *before* the
replacement runs, so it silently finds nothing to replace — check
`get_param(result.copyName,'BlockReduction')` and disable it first if needed.
See "Block Reduction / Optimized-Out Blocks" in
`references/incompatibility-rules.md` for the procedure and its open caveats.

### Step 4: Verify and Finish (default endpoint)

Run the diagnostic again:
```matlab
[compat, ~] = sldvcompat(result.copyName);
```

If still incompatible, repeat Steps 2–3 (multiple issues may exist).

Once compatible, save and report — **this is where the skill stops by default**:
```matlab
save_system(result.copyName);
close_system(result.copyName);
```

Report the compatible copy path to the user. If the user only asked to make the
model compatible, you are done. Do **not** run test generation or design error
detection unless the surrounding task calls for it (see Step 5).

### Step 5: Offer a Behavior Consistency Check (optional — only when the intent is present)

Step 4 is the default endpoint. Compatibility does **not** confirm the fix
*preserved behavior*. When — and only when — the surrounding intent calls for
behavior preservation (test generation, design error detection, or the user
explicitly asks), an optional back-to-back consistency replay
(`sldv_verify_consistency`) can raise confidence the fix preserved behavior by
replaying SLDV-generated tests through the original model.

This is a specialized sub-case with its own API, status codes, and eligibility
rules. **Load and follow `references/consistency-check.md`** for the full
procedure. Do not load it for a plain compatibility request — stop after Step 4.

<!-- Copyright 2026 The MathWorks, Inc. -->

