# SLDV Incompatibility Rules — Catalog

This is the operative rule catalog for the `fix-sldv-incompatibility` skill.
`SKILL.md` intentionally carries no rule content: for each `sldvcompat` finding
you **load this file and match** `.msgid` (and, for block-level findings, the
`.blockType` at `.blockPath`) against the entries below, then apply the listed
fix. Use the Disambiguation Guide at the end when one msgid maps to several
rules.

## Provenance & Deviations from Source

The 43 numbered rules derive from `SLDV_Incompatibility_Rules.md` (shipped in
`incompatibility.zip`), which was assembled from official SLDV documentation and
customer escalations. This catalog reproduces those rules in a
Detection/Fix table form and **adds** the following, based on field feedback
that the source did not cover:

- **Rule D — Derivative → Discrete Derivative.** The source only listed the
  continuous Integrator and Transfer Fcn under Continuous-Time Blocks. The
  continuous `Derivative` block has the same "cannot be stubbed" problem and is
  added here.
- **Integrator/Derivative port-matching.** The source said "replace with a
  Discrete-Time Integrator" but gave no guidance on the I/O ports that appear
  under non-default parameter combinations (external reset, external IC, state
  port, saturation port). A blind swap breaks lines. The port-matching table
  below is an addition, and the matching is **release-dependent** — see the note.
- **Block-reduction / optimize-out guard.** Blocks can be optimized out *before*
  a replacement runs (observed on bus selectors/creators and IC blocks), so the
  standard replacement silently finds nothing. This guard is an addition.
- **Rule S — S-Function not built with `slcovmex`.** The source did not cover the
  analysis-time `Simulink:SFunctions:SLDVUnSupSfunc` signal, which surfaces from
  an SLDV *run* (not from `sldvcompat`) when a binary S-Function was compiled
  with plain `mex`. It is added here.

When a discrepancy exists between this catalog and the source `.md`, **this
catalog wins** — it is the maintained copy the skill loads.

## Why Some Rules Share a msgid

Several rules share the same underlying `sldvcompat` msgid (e.g. rules 1/6/41
all produce `UnsupSolver`; rules 22/29/30 all produce
`UnsupportedUsageVariableRestrictedType`). They are kept as separate entries on
purpose:

1. **Different root causes need different fixes.** `BlockCannotBeStubbed` fires
   for six block types, each with a distinct remediation (Integrator →
   Discrete-Time Integrator vs. Random Number → bounded Inport vs. delete Stop
   block).
2. **Matching needs specific signal.** The fix is selected by matching the
   *combination* of msgid + model context (block type, config param, code
   pattern), so more granular entries give a cleaner match.
3. **Each entry is a real scenario.** Even with a shared detection mechanism, the
   user's mental model differs (a Simscape user reasons differently than someone
   who accidentally set `ode45`).

---

## Missing External Dependencies — Ask, Don't Fix

Before matching any rule below, rule out a **genuinely missing external
dependency**. This is *not* an SLDV incompatibility to fix in the model — the
model is fine, but a resource it needs is **absent from the environment** (the
file/variable does not exist or cannot be located), so SLDV cannot resolve the
model and `sldvcompat` fails. Applying a compatibility rule here (replacing or
stubbing the flagged block) would be wrong: it masks a real gap and discards the
model's intended behavior. The correct response is to **explain why the model is
incompatible, name the missing resource, and ask the user to provide it**, then
re-run the diagnostic (see SKILL.md Step 1.5).

**How to recognize it:** `result.compiles == false` and the `result.buildError`
(or a `result.findings` message) names a resource that is *missing / not found /
does not exist / cannot be located or resolved*. Match on that **meaning**, not
on a fixed msgid list — the identifiers are resource- and release-specific.
Representative shapes observed (non-exhaustive):

| Missing resource | Where it surfaces | Message names |
|---|---|---|
| Data-dictionary file (`.sldd`) not on disk | finding `Sldv:Setup:DataDictionaryAccErr` | the `.sldd` the model is linked to |
| Referenced-model **file** that cannot be located | finding `Simulink:modelReference:findMdlrefsMissingModel`; buildError `Simulink:modelReference:ModelNotFoundWithBlockName` | the referenced model + the Model block |
| `From File` / `From Spreadsheet` data file that does not exist | buildError `Simulink:blocks:ToFromFileGeneralErr` (and similar `sl_iofile:*`) | the source block whose file is missing |
| Library / linked block, MATLAB class, or workspace variable nowhere on the path | model-load or compile error (`Simulink:Engine:UnableToUpdateModel`, unresolved-symbol/undefined-variable errors) | the unresolved library, class, or variable |

The table is illustrative — the test is always "does the message name an
external artifact that **isn't there**?", regardless of the exact identifier.
For a missing library block, MATLAB class, or workspace variable that the
*caller* could make resolvable on the path/workspace, ask the user to supply it
or point the skill at its location rather than editing the model.

**Do NOT confuse this with a present-but-opaque resource, which you DO fix by
stubbing.** A resource that *exists and resolves* but whose internals SLDV cannot
analyze is an ordinary stubbing job (see "Stubbing Strategy" below and Rules
16–20, 36–38), **not** a missing dependency:

- a **protected** referenced model (`.slxp`) — the file is present, SLDV just
  cannot see inside it → stub the `Model` block with an I/O-preserving Subsystem
  (Rule 38);
- external **custom code** or an **S-function** whose source is opaque, or a
  MATLAB Function block calling an external routine → bounded `sldv.stub` (Rules
  16–20).

The discriminator is simple: **missing → the artifact cannot be found (ask the
user); opaque → the artifact is found but unanalyzable (stub it).** If
`result.compiles == true`, it is not a missing dependency at all — proceed to the
rules.

Contrast also with a plain **authoring bug** (also `compiles == false`, e.g. a
block parameter set to an expression that references nothing): that is fixed by
*repairing the model*, not by providing a resource — but likewise never by a
compatibility rule.

---

## Stubbing Strategy (general, cross-cutting alternative to replacement)

The rules below mostly do **semantic replacement** — swap an unsupported block
for an analyzable equivalent (Integrator → Discrete-Time Integrator, Random
Number → bounded Inport, …). **Stubbing** is the general fallback for when no
faithful equivalent exists, or the block's internals are irrelevant to the
property under analysis (custom/external code, an opaque plant, a source whose
value SLDV should treat as free). It applies to *any* block or subsystem, so it
is not tied to a single msgid.

`sldv.stub(u)` tells SLDV to treat the output as an **uninterpreted (free)
value** — SLDV stops analyzing inside the block and picks any value the data
type allows. In *simulation* `sldv.stub` is identity (pass-through); only
*analysis* sees the abstraction. You place it inside a MATLAB Function (or
Stateflow function) that replaces the block or wraps its output.

**Plain stub** — universal compatibility, but the output is *unconstrained*, so
findings can be over-broad or unrealistic (SLDV may pick absurd values):

```matlab
function y = fcn(u)
%#codegen
y = sldv.stub(u);
```

**Bounded stub (preferred)** — constrain the free value to a realistic range so
analysis stays meaningful. Branch on shape so the scalar case gives Polyspace a
precise `[mn .. mx]` range on the value itself; the logical-index form used for
arrays does not convey a scalar range as cleanly:

```matlab
function y = fcn(u, mn, mx)
%#codegen
y = sldv.stub(u);
if isscalar(y)
    if (y < mn)
        y = mn;
    elseif (y > mx)
        y = mx;
    end
else
    y(y < mn) = mn;      % constrain every element to [mn .. mx]
    y(y > mx) = mx;
end
```

The bounded stub is the code-form of the "bounded Inport" fix used for source
blocks (Rules 10–13).

**Replacement vs. stub — how to choose:**
- Prefer **semantic replacement** when a faithful analyzable equivalent exists
  (continuous → discrete, native block for an S-function). It preserves the
  block's behavior for analysis.
- Prefer **stubbing** when no equivalent exists, the internals are external/
  opaque, or they don't affect the property. Prefer the **bounded** form.

**Consistency-check interaction:** an inline stub keeps the root In/Outport
signature, so a *plain* stub is I/O-preserving and consistency-checkable. A
*bounded/clamped* stub deliberately changes behavior at the saturation limits,
so a back-to-back consistency replay will legitimately diverge there — expected,
not a regression. Say so when reporting.

---

## Solver and Configuration (Rules 1–7)

| Rule | Rule ID | msgid | Detection | Fix (set_param) |
|------|---------|-------|-----------|-----------------|
| 1 | `sldv.variable-step-solver.v1` | `Sldv:Compatibility:UnsupSolver` | SolverType == 'Variable-step' | `set_param(mdl,'SolverType','Fixed-step'); set_param(mdl,'Solver','FixedStepDiscrete'); set_param(mdl,'FixedStep','0.01')` |
| 2 | `sldv.zero-step-size.v1` | `Simulink:ConfigSet:BdInvSimParam` | FixedStep == '0' | `set_param(mdl,'FixedStep','0.01')` |
| 3 | `sldv.concurrent-execution.v1` | `Sldv:Compatibility:UnsupConcurrentExecution` | ConcurrentTasks == 'on' | `set_param(mdl,'ConcurrentTasks','off')` |
| 4 | `sldv.import-initial-state.v1` | `Sldv:Compatibility:UnsupInitialState` | LoadInitialState == 'on' | `set_param(mdl,'LoadInitialState','off')` |
| 5 | `sldv.model-callback-initfcn.v1` | `Sldv:Compatibility:ModelCallbackInitFcn` | InitFcn non-empty | `set_param(mdl,'InitFcn','')` |
| 6 | `sldv.zero-rel-zero-abs-tolerance.v1` | `Sldv:Compatibility:UnsupSolver` | RelTol=='0' AND AbsTol=='0' | `set_param(mdl,'SolverType','Fixed-step'); set_param(mdl,'Solver','FixedStepDiscrete')` |
| 7 | `sldv.compiler-flag-include.v1` | `Simulink:cgxe:BuildError` (+ `SymbolicLinkErrorCause`) | CustomInclude has '--include' | `set_param(mdl,'CustomInclude','')` |

## Continuous-Time Blocks (Rules 8–9, plus Derivative)

| Rule | Rule ID | msgid | Detection | Fix (model_edit) |
|------|---------|-------|-----------|------------------|
| 8 | `sldv.continuous-integrator.v1` | `Sldv:Compatibility:BlockCannotBeStubbed` | `.blockType == 'Integrator'` | Replace Integrator → Discrete-Time Integrator (`simulink/Discrete/Discrete-Time Integrator`), set SampleTime. **See port-matching note below.** |
| 9 | `sldv.continuous-transfer-function.v1` | `Sldv:Compatibility:BlockCannotBeStubbed` | `.blockType == 'TransferFcn'` | Replace Transfer Fcn → Discrete Transfer Fcn, compute coeffs via c2d |
| D | *(addition)* `sldv.continuous-derivative.v1` | `Sldv:Compatibility:BlockCannotBeStubbed` | `.blockType == 'Derivative'` | Replace Derivative → Discrete Derivative (`simulink/Discrete/Discrete Derivative`), set SampleTime |

**Integrator/Derivative port-matching (critical).** The Integrator block exposes
different I/O ports depending on its parameters — a blind swap breaks lines.
Before replacing, read the offending block's port-affecting parameters at
`.blockPath` (via `model_read`, or `get_param(finding.blockPath, ...)`) and
reproduce the equivalent port configuration on the Discrete-Time Integrator:

| Integrator param | Effect | Match on replacement |
|------------------|--------|----------------------|
| `ExternalReset` ≠ `none` | adds a reset input port | set the same `ExternalReset` |
| `InitialConditionSource == 'external'` | adds an IC input port | set `InitialConditionSource = 'external'` |
| `ShowStatePort == 'on'` | adds a state output port | set `ShowStatePort = 'on'` |
| `ShowSaturationPort == 'on'` | adds a saturation output port | enable saturation output |
| `LimitOutput == 'on'` | affects saturation behavior | set `LimitOutput` + `UpperSaturationLimit`/`LowerSaturationLimit` |

Reproduce the port set **first**, then reconnect lines by matching port index,
then delete the original block. **Port combinations vary by release** — if
`get_param` errors that a param does not exist, that variant does not exist in
the running release and can be skipped. (See the Integrator port-matching geck
for the release-by-release matrix.)

## Unsupported Source Blocks (Rules 10–13)

| Rule | Rule ID | msgid | Detection | Fix (model_edit) |
|------|---------|-------|-----------|------------------|
| 10 | `sldv.unsupported-random-source-blocks.v1` | `Sldv:Compatibility:BlockCannotBeStubbed` | RandomNumber block | Replace → Inport with OutMin=-10, OutMax=10 |
| 11 | `sldv.unsupported-random-source-blocks.v1` (BLWN) | `Sldv:Compatibility:BlockCannotBeStubbed` | Band-Limited White Noise block | Replace → Inport with OutMin/OutMax |
| 12 | `sldv.unsupported-file-workspace-source-blocks.v1` (From File) | `Sldv:Compatibility:UnstubBlks` | FromFile block | Replace → Inport with OutMin/OutMax |
| 13 | `sldv.unsupported-file-workspace-source-blocks.v1` (Spreadsheet) | `sl_iofile:excelfile:BlockSimError` | From Spreadsheet block | Replace → Inport with OutMin/OutMax |

For all of Rules 10–13 the fix is *a bounded free input*. Replacing with a
bounded Inport adds a root input port (not I/O-preserving). If you need to keep
the root signature — e.g. so the fix stays consistency-checkable — use a
**bounded stub** in place instead (see "Stubbing Strategy"): a MATLAB Function
that wraps `sldv.stub(u)` with the scalar/array clamp (see the exact form under
"Stubbing Strategy") fed by a constant/ground, which expresses the same
bounded-free-value idea without adding a root port.

## Algebraic Loops (Rules 14–15)

| Rule | Rule ID | msgid | Detection | Fix (model_edit) |
|------|---------|-------|-----------|------------------|
| 14 | `sldv.algebraic-loop.v1` | `Simulink:Engine:AlgebraicLoopsNotSupportedInRTWGEN` | Feedback loop, no model ref | Insert Unit Delay in feedback path |
| 15 | `sldv.model-ref-artificial-algebraic-loop.v1` | `Simulink:Engine:AlgebraicLoopsNotSupportedInRTWGEN` | Model Reference feedthrough | Insert Unit Delay at Model block output |

## S-Function and Custom Code (Rules 16–20)

| Rule | Rule ID | msgid | Detection | Fix |
|------|---------|-------|-----------|-----|
| 16 | `sldv.sfunction-level2-matlab.v1` | `Simulink:blocks:MSFB_NumPrmsError` | M-S-Function block | model_edit: replace with native Simulink equivalent |
| 17 | `sldv.custom-code-unresolved-symbols.v1` | `BuildError`+`SymbolicLinkErrorCause` | coder.ceval in MATLAB Function | model_edit: replace coder.ceval with native MATLAB |
| 18 | `sldv.stateflow-custom-code-unsupported.v1` | `BuildError`+`SymbolicLinkErrorCause` | C calls in Stateflow | model_edit: replace C calls with MATLAB in chart |
| 19 | `sldv.custom-code-pointer-cast.v1` | `BuildError`+`SymbolicLinkErrorCause` | Pointer casts in CustomSourceCode | set_param: clear CustomSourceCode; model_edit: add MATLAB Function |
| 20 | `sldv.coder-ceval-matlab-system-block.v1` | `BuildError`+`MakeErrorCause` | MATLAB System with coder.ceval | model_edit: replace MATLAB System → MATLAB Function block |
| S | *(addition)* `sldv.sfunction-not-slcovmex.v1` | `Simulink:SFunctions:SLDVUnSupSfunc` | A binary S-Function (`.mex*`) built with plain `mex`, not `slcovmex` — see note | **Recompile the S-Function source, don't stub it.** `slcovmex <sfun_src>.c -sldv` (run from the folder holding the source), then re-run the analysis. Only stub/replace when the source is unavailable. |

**Rule S is an analysis-time signal, not a `sldvcompat` finding.** Unlike every
other rule here, `Simulink:SFunctions:SLDVUnSupSfunc` does **not** come back from
`sldvcompat` — the model reports **compatible** and `result.findings` is empty.
It surfaces only when an SLDV *run* (test generation, design error detection)
executes: a binary S-Function built with plain `mex` is silently stubbed because
it lacks the coverage instrumentation `slcovmex` adds, and the run reports (exact
text): *"S-Function '<name>' invoked from block '<path>' is incompatible with
Simulink Design Verifier. Recompile <name> with slcovmex with '-sldv' option."*
`sldvData.AnalysisInformation.HasNotInterpretableStubing == 1` corroborates it.
This rule therefore fires from the **"an SLDV run warns/reports"** trigger, not
from a Step 1 finding. The fix is to recompile the *source* — do not stub,
replace, or delete the block when the source is available, since that discards
its behavior.

## MATLAB Function Block Code (Rules 21–26)

| Rule | Rule ID | msgid | Detection | Fix (model_edit) |
|------|---------|-------|-----------|------------------|
| 21 | `sldv.malloc-memcpy-free.v1` | `UnsupportedArithmetic`/`UnsupportedObjects` | Variable-length arrays | Rewrite with fixed-size preallocated arrays |
| 22 | `sldv.coder-ceval-layout-any.v1` | `UnsupportedUsageVariableRestrictedType` | char in switch/case | Replace char with numeric/enum |
| 23 | `sldv.matlab-function-unsupported-characters.v1` | `EmlCInterfaceAnyLayoutNotAvailableDV` | strcmp, char arrays | Replace with numeric comparisons |
| 24 | `sldv.matlab-function-unsupported-file-io.v1` | `LoadFailedWithCause` | coder.load, file I/O | Replace with constant assignment |
| 25 | `sldv.matlab-function-unsupported-handle-object.v1` | `IllegalMatlabType` | containers.Map, handle objects | Replace with arrays/structs/switch |
| 26 | `sldv.matlab-function-unsupported-dynamic-eval.v1` | `FunctionNotSupportedForCodeGeneration` | eval, feval | Replace with direct computation |

## Stateflow (Rules 27–29)

| Rule | Rule ID | msgid | Detection | Fix (model_edit) |
|------|---------|-------|-----------|------------------|
| 27 | `sldv.stateflow-recursion.v1` | `DesignVerifierIncompatible`+`Generic:Coder` | Recursive graphical function | Convert to iterative loop with accumulator |
| 28 | `sldv.stateflow-cyclic-behavior.v1` | `DesignVerifierIncompatible`+`Generic:Coder` | Mutual recursion (A→B→A) | Replace with iterative loop/state variable |
| 29 | `sldv.stateflow-string-literal.v1` | `UnsupportedUsageVariableRestrictedType`+`DesignVerifierIncompatible` | char in Stateflow | Replace with numeric constants/enums |

## Data Type and Signal Issues (Rules 30–35)

| Rule | Rule ID | msgid | Detection | Fix (model_edit) |
|------|---------|-------|-----------|------------------|
| 30 | `sldv.string-data-type.v1` | `UnsupportedUsageVariableRestrictedType` | string/char in signals | Replace with numeric/enum logic |
| 31 | `sldv.multiword-fixedpoint.v1` | `UnsupportedBlockParameterDataTypeFixpt` | Fixed-point > 128 bits | Reduce word length to ≤128 |
| 32 | `sldv.nonfinite-data.v1` | `Simulink:Parameters:InfParamUnSup` | NaN/Inf/-Inf in params | Replace with finite values |
| 33 | `sldv.variable-size-signal.v1` | `InferredVarMatrixTypeMismatch` | Variable-size output | Declare fixed size (y=zeros(N,1)) |
| 34 | `sldv.root-level-variable-size-signal.v1` | `InportVarDimsCannotInterp` | Root Inport variable-size | Set fixed PortDimensions |
| 35 | `sldv.unbounded-variable-size-signal.v1` | `InvalidInferredSize` | Unbounded variable-size | Add coder.varsize with upper bound |

## Model Reference (Rules 36–38)

| Rule | Rule ID | msgid | Detection | Fix |
|------|---------|-------|-----------|-----|
| 36 | `sldv.global-dsm-across-model-refs.v1` | `DSMemoryBlockNotFound`+`BlockReplacement` | DSM across model refs | model_edit: replace DSM Read/Write with Inport/Outport in ref model |
| 37 | `sldv.gain-param-inherit-mismatch.v1` | `ModelReferenceHWSettingConsistency` | HW setting mismatch | set_param: align ref model HW settings with top |
| 38 | `sldv.protected-model-reference.v1` | `protectedModelNoExtensionButLoadedError` | .slxp model ref | model_edit: replace Model block with Subsystem stub |

## Sink/Control Blocks (Rules 39–40)

| Rule | Rule ID | msgid | Detection | Fix (model_edit) |
|------|---------|-------|-----------|------------------|
| 39 | `sldv.unsupported-sink-control-blocks.v1` | `Sldv:Compatibility:BlockCannotBeStubbed` | Stop Simulation block | Delete Stop block (add Terminator if needed) |
| 40 | `sldv.parameter-writer.v1` | `Sldv:Compatibility:BlockCannotBeStubbed` | Parameter Writer block | Delete Parameter Writer block |

## Toolbox-Specific (Rules 41–42)

| Rule | Rule ID | msgid | Detection | Fix |
|------|---------|-------|-----------|-----|
| 41 | `sldv.simscape-blocks.v1` | `Sldv:Compatibility:UnsupSolver` | Simscape blocks present | model_edit: replace plant with bounded Inports; set_param: fixed-step |
| 42 | `sldv.vehicle-network-toolbox-blocks.v1` | `vnt:vntblks:startError` | VNT CAN blocks | model_edit: CAN Receive→Inport, CAN Transmit→Outport |

## MATLAB System Block (Rule 43)

| Rule | Rule ID | msgid | Detection | Fix (model_edit) |
|------|---------|-------|-----------|------------------|
| 43 | `sldv.matlab-system-coder-rowmajor.v1` | `SystemBlock:MATLABSystem:InferenceError` | MATLAB System with coder.rowMajor | Replace MATLAB System → MATLAB Function, remove coder.rowMajor |

---

## Block Reduction / Optimized-Out Blocks (guard before ANY replacement)

Block reduction can delete blocks *before* a replacement runs, so the standard
replacement silently finds nothing to replace and the model stays incompatible.
This has been observed on **bus selectors/creators and IC (Initial Condition)
blocks**. Before replacing, check whether the replacement target may be optimized
away:

```matlab
get_param(result.copyName, 'BlockReduction')   % 'on' by default
```

If `'on'` and the target may be reduced out, disable reduction first so the block
survives to be replaced:

```matlab
set_param(result.copyName, 'BlockReduction', 'off');
```

Then replace and re-run the diagnostic.

> **Caveat.** Disabling `BlockReduction` alone is not always sufficient — some
> blocks (bus selectors/creators, IC blocks) can still resolve away before
> replacement. When that happens, do a **pre-replacement pass**: swap the
> affected blocks for analyzable equivalents first, then run the standard
> replacement. Do not rely on the `BlockReduction='off'` one-liner as a complete
> fix for the optimize-out case.

---

## Disambiguation Guide

When a msgid matches multiple rules, use additional context (block type, config
param, code pattern) to select the correct fix:

| msgid | Check | Rule |
|-------|-------|------|
| `UnsupSolver` | SolverType == 'Variable-step' | 1 |
| `UnsupSolver` | RelTol=='0' AND AbsTol=='0' | 6 |
| `UnsupSolver` | Simscape blocks present | 41 |
| `BlockCannotBeStubbed` | Integrator block | 8 |
| `BlockCannotBeStubbed` | Transfer Fcn block | 9 |
| `BlockCannotBeStubbed` | Derivative block | D |
| `BlockCannotBeStubbed` | Random Number block | 10 |
| `BlockCannotBeStubbed` | Band-Limited White Noise | 11 |
| `BlockCannotBeStubbed` | Stop Simulation block | 39 |
| `BlockCannotBeStubbed` | Parameter Writer block | 40 |
| `BuildError`+`SymbolicLinkErrorCause` | --include in CustomInclude | 7 |
| `BuildError`+`SymbolicLinkErrorCause` | coder.ceval in MATLAB Function | 17 |
| `BuildError`+`SymbolicLinkErrorCause` | C calls in Stateflow | 18 |
| `BuildError`+`SymbolicLinkErrorCause` | Pointer casts in CustomSourceCode | 19 |
| `BuildError`+`MakeErrorCause` | MATLAB System with coder.ceval | 20 |
| `UnsupportedUsageVariableRestrictedType` | char in MATLAB Function | 22 |
| `UnsupportedUsageVariableRestrictedType` | char in Stateflow | 29 |
| `UnsupportedUsageVariableRestrictedType` | string in signals | 30 |
| `AlgebraicLoopsNotSupportedInRTWGEN` | Loop within single model | 14 |
| `AlgebraicLoopsNotSupportedInRTWGEN` | Model Reference feedthrough | 15 |
| `DesignVerifierIncompatible`+`Generic:Coder` | Direct recursion | 27 |
| `DesignVerifierIncompatible`+`Generic:Coder` | Mutual/cyclic recursion | 28 |
| `BlockReplacement`+`FailedToCompile` | DSM across refs | 36 |
| `BlockReplacement`+`FailedToCompile` | .slxp protected model | 38 |

<!-- Copyright 2026 The MathWorks, Inc. -->
