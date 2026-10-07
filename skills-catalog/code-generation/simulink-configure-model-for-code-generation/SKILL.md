---
name: simulink-configure-model-for-code-generation
description: >
  Configure Simulink models for Embedded Coder (ERT), Simulink Coder (GRT
  rapid-prototyping), or AUTOSAR code generation. Use when the user asks to
  generate embedded C or C++ code, run a full build of a model, produce a code
  generation report, configure a model for production/ECU deployment or
  rapid-prototyping code, target ARM or x86 hardware, apply MISRA C/C++
  compliance (ERT/AUTOSAR only — Simulink Coder does not ship MISRA profiles),
  or set up GRT, ERT, AUTOSAR, or shared-library targets. Handles target
  selection, hardware mapping, model hierarchy propagation, and constraint
  introspection via the configure_for_codegen function. Do NOT use for GRT
  shared-library variants (grt_malloc.tlc), DDS, or ROS, or for iterative
  optimization workflows that measure baseline metrics, apply targeted changes,
  and re-measure to confirm improvement.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "2.1.0"
---

# Configure a Simulink Model for Code Generation

Configure Simulink models for Embedded Coder (ERT), Simulink Coder (GRT rapid-prototyping), or AUTOSAR code generation using the configure_for_codegen function.

## When to Use

- User asks to configure a model for code generation, production deployment, Embedded Coder, or Simulink Coder rapid prototyping
- User mentions GRT, ERT, AUTOSAR, ARM, embedded target, production code, or rapid-prototyping code
- User asks for MISRA C or MISRA C++ compliance (ERT or AUTOSAR only — MISRA is not supported on GRT)
- User describes a deployment target in domain language ("deploy to ECU", "minimize flash", "rapid prototyping on a desktop target")

## When NOT to Use

- Simulation-only tasks (running a model, tuning parameters, viewing signals)
- Data dictionary or bus object configuration (standalone, not as part of code-gen setup)
- Test harness creation or coverage analysis
- GRT shared-library variants (`grt_malloc.tlc` + manual `-shared -fPIC` linking) — no clean happy path; deferred out of scope
- MISRA compliance on GRT (Simulink Coder does not ship MISRA profiles — pick ERT if MISRA is required) or AUTOSAR on GRT
- DDS (Data Distribution Service) or ROS targets
- Modifying or formatting generated code files after code generation
- Iterative optimization of generated code after configuration — measuring baseline metrics, applying targeted changes, and re-measuring to confirm improvement

## Rules

- **Never expose the script's wrapper parameter names — describe the decision and its effect in domain terms.** The `configure_for_codegen` wrapper parameter names (`ConfigOnly`, `Build`, `Interface`, `OutputDir`, `Compliance`, `Objective`, `Target`, `Hardware`, `Language`, `Introspect`) are an implementation detail — they must never appear in text you show the user, and neither should `name="value"` syntax. **This prohibition covers only the wrapper arguments;** it does not restrict describing what the configuration does at the model or ConfigSet level. Name the decision, then describe its effect. Safe examples: "configured the model but did not build"; "used a nonreusable function interface"; "optimizing for speed enables an execution-efficiency cascade — strength reduction, inlined parameters, removal of division-by-zero protection"; "a reusable function interface produces multi-instance/reentrant code that passes state by pointer"; "a MISRA C profile drives casting mode, signed shifts, and unreachable-default suppression". **Prefer engineering-concept language over raw Simulink ConfigSet identifiers** — say "inlines parameters," not "sets `InlineInvariantSignals`". This applies everywhere (defaults, confirmations, follow-up questions, error paraphrasing) except the phrase-mapping table below, which is your internal lookup, not user-facing.
- **Model must be open.** The model must already be open in MATLAB before calling `configure_for_codegen`. If it is not, open it directly with `open_system('<model>')` via `evaluate_matlab_code` — no separate skill is needed for this.
- **Model must be saved to disk (or the user must supply a destination).** The script writes generated code next to the model's `.slx` file. If the model is a fresh `new_system`/untitled window with no file on disk, the script cannot infer a location and returns `success:false` with a message asking the user to save the model or supply an explicit output directory. Relay that message verbatim and ask the user which they prefer — never guess a location on their behalf, and never call `save_system` without permission (see "Do not save" rule below).
- **Model must be compilable.** The model and all its dependencies (data dictionaries, referenced models, bus objects, MATLAB path entries) must be resolvable in the current MATLAB session. If configuration fails due to missing dependencies, inform the user what is unresolved and ask them to fix the environment — do not attempt `addpath` or other path manipulation on their behalf.
- **Do not save; inform, then offer.** The script does not call `save_system` and does not persist any bound data dictionaries. When configuration succeeds, explicitly tell the user nothing has been saved — model and dictionary changes exist only in memory, so they can review or discard freely. As a courtesy, ask whether they want to save now. Only save if the user says yes. Saving is outside the scope of this skill's core responsibility.
  - **Name every file that would be saved.** The `pendingSaves` field lists the exact files whose in-memory state must be persisted for the configuration to reload correctly — always at least each configured `.slx`, plus any `.sldd` when a model's active ConfigSet is a ConfigSetRef backed by a data dictionary (saving the `.slx` alone would persist a reference to a dictionary entry not yet on disk, and reload would fail to resolve the target file).
  - **Save via the mechanism named by `kind`.** Read `pendingSaves` from the script output, name every entry when offering to save, and — on user consent — save each file using the mechanism named in its `kind` field (`model` → `save_system`, `dictionary` → `Simulink.data.dictionary.open(...).saveChanges()`). Never use `Simulink.data.dictionary.saveAll`; it would persist unrelated dictionaries that happen to be open in the session. If the user declines, save nothing.
- All configuration is performed via `configure_for_codegen` (in the skill's `scripts/` directory), called through `evaluate_matlab_code` with `project_path` set to `SKILL_DIR/scripts` — where `SKILL_DIR` is the absolute filesystem path this SKILL.md was loaded from. Do not guess a workspace-relative path (MCP rejects paths under `.claude/`); resolve `SKILL_DIR` to whichever absolute location the loader used. Do not `addpath` the user's model or dictionary folders — the script handles CWD/dictionary resolution internally and self-cleans. Pass `model` as an open model name — with or without the `.slx`/`.mdl` extension; the script strips it either way (e.g. `'mbasic'` or `'mbasic.slx'` both work). The model must already be open (see rule above). The agent never calls `set_param` directly.
- **Resolve MISRA ambiguity in your response.** "MISRA" alone is ambiguous — MISRA C and MISRA C++ are distinct standards. If the user says only "MISRA" without specifying, pick the one matching the source language (MISRA C for C, MISRA C++ for C++) and explicitly state the assumption in your final response — e.g., "Assuming MISRA C since the target language is C. Let me know if you meant MISRA C++."
- **State your inference for every required choice you didn't get verbatim from the user.** The four required inputs — target framework, source language, hardware device, and optimization objective — must each either come directly from the user or be a silently-safe inference that you explicitly narrate back. Never expose the script's wrapper parameter names. Common inferences to narrate (same treatment as the MISRA ambiguity rule):

  | User phrasing | Inferred choice | How to say it back |
  |---|---|---|
  | "embedded C", "production C" (no C++ mention) | source language = C | "Using C as the source language since you said 'embedded C' — let me know if you meant C++." |
  | "AUTOSAR" (bare, no Classic/Adaptive) | target = AUTOSAR Classic | "Using AUTOSAR Classic since you didn't specify — say the word if you meant AUTOSAR Adaptive." |
  | "embedded", "production", "ECU" (no shared-library / AUTOSAR / rapid-prototyping mention) | target = ERT executable | "Building for an ERT executable target — tell me if you want a shared library instead." |
  | "rapid prototyping", "GRT", "generate GRT code", "desktop test target", "HIL desktop target" | target = GRT | "Using the GRT rapid-prototyping target since you asked for rapid prototyping — this is Simulink Coder, not Embedded Coder. Tell me if you meant a production ERT build." |
  | "ARM Cortex-A", "Cortex-M4", "x86-64" (short form) | full hardware device string | "Mapped 'ARM Cortex-A' to the ARM Compatible ARM Cortex-A device — let me know if you meant a different variant." |
- **Ask one batched clarifying question for what you cannot safely infer — never guess silently.** Hardware device and optimization objective are never silently defaulted — the wrong device string picks the wrong word sizes/endianness, and speed vs. memory footprint vs. step-through debuggability is a real tradeoff the user must own. (Target may be inferred as ERT executable, and language as C, when the user says "embedded"/"production"/"ECU" or nothing target-related.) If hardware and/or objective is missing after the phrase-mapping pass, ask a **single** consolidated question naming exactly what you need, then proceed — do not ask one parameter at a time. Example: "To configure this I need two things: (1) which processor family — ARM Cortex-A, ARM Cortex-M, x86-64, PowerPC, or other? (2) optimize for execution speed, memory footprint, or step-through debuggability (preserves block-to-code traceability)?" This is the one allowed exception to the "one call, not two" rule below — a single upfront question, then exactly one script call.
- **Extract all parameters before the first call — one call, not two.** Read the user's request once and map every phrase to a `configure_for_codegen` parameter, then invoke exactly once. Making a second corrective call to add a parameter you forgot (e.g. `ConfigOnly`, `Compliance`, `Build`) is a rule violation. Common phrase mappings:

  | User phrase | Parameter |
  |---|---|
  | "just configure", "apply settings only", "prepare the model but don't generate code" | `ConfigOnly=true` |
  | "codegen", "generate code", "generate the code but don't build/compile", "generate code without building an executable" | *(no override — defaults `ConfigOnly=false, Build=false` generate source without a toolchain build)* |
  | "build it", "compile it", "generate and build", "produce an executable" | `Build=true` |
  | "MISRA" (bare) | `Compliance="MISRA C"` or `"MISRA C++"` per `Language` (see MISRA ambiguity rule) |
  | "speed", "fast", "execution efficiency" | `Objective="Speed"` |
  | "small flash", "minimize RAM", "memory-constrained", "low memory" | `Objective="RAM"` |
  | "debug", "debuggable", "step through", "step-through", "traceability", "preserve block structure" | `Objective="Debug"` |
  | "check what the model needs", "right-size the code", "accurate support flags", "match support flags to the model", "compile it first to see what the model uses" | `Introspect=true` |

  **Three distinct build modes — do not conflate them.** The words "don't build" / "don't compile" appear in *two* of these buckets and are ambiguous on their own; disambiguate by whether the user mentions generating code:

  | Intent | User signal | Mode |
  |---|---|---|
  | Apply ConfigSet only, produce no code | user says "just configure" / "apply settings" *and* does **not** mention generating code | `ConfigOnly=true` (skips `rtwbuild` entirely) |
  | Generate source files, skip toolchain build | user says "generate code" or "codegen" while also saying "don't build/compile" (or says nothing about building) | defaults — `rtwbuild(..., 'GenerateCodeOnly', true)` |
  | Generate source and produce an executable | user says "build" / "compile" / "produce an executable" | `Build=true` (calls `slbuild`) |

  If the user mentions "generate code" *anywhere* in the request, `ConfigOnly=true` is wrong — code generation is what they asked for. "Don't build/compile" in that same sentence means skip the *executable* build, not skip codegen.
- **Never modify generated code files.** After code generation, the output files (.c, .cpp, .h, .arxml, etc.) are read-only artifacts. Do not edit, reformat, or overwrite them.
- **Relay `success:false` verbatim — never invent workarounds.** The script returns JSON with a `success` flag and a populated `errors[]` list when a prerequisite is missing (e.g. AUTOSAR Blockset not installed or unlicensed, model not loaded, invalid MISRA/language combination). When `success:false`, quote the error message to the user and stop. Do NOT retry with `ConfigOnly=true` to mask the missing dependency, do NOT fall back to direct `set_param()` calls, and do NOT rerun with different flags hoping the second try succeeds. The refusal is the correct outcome — the user needs the specific error to fix their environment.
- By default, generated code is placed next to the model file. Only pass `OutputDir` if the user explicitly requests a different location.
- **Report assumed defaults in plain language — name every one, don't cherry-pick, and never expose wrapper parameter names.** When the user does not specify a value, tell them which default you applied for **each** decision: function interface style, MISRA compliance, whether to build, whether to configure only, output location, and whether the model was introspected. Use user-facing prose — do not name the underlying wrapper arguments or show `name=value` pairs; describing what each choice *does* at the model/ConfigSet level is encouraged. Name your default even for the "none" case (e.g. no MISRA). **The introspection default is a real engineering tradeoff and must always be surfaced:** by default the script skips the compile-time introspection pass and applies conservative support-flag settings (`SupportComplex`, `SupportContinuousTime`, `SupportVariableSizeSignals`, etc. left `'on'`), producing slightly larger generated code but avoiding a full model compile per call. If the user cares about right-sized code, they can opt in with phrases like "check what the model needs" or "right-size the code" (see the phrase-mapping table below). Example: "Since you didn't specify, I applied these defaults: nonreusable function interface, no MISRA compliance profile, configured the model but did not run a build, placed generated code next to the model file, and skipped model introspection to keep this fast (support flags applied conservatively — say the word if you'd like me to compile the model to right-size them). Let me know if you want any of these changed."
- **Only itemize `parameterChanges` when the user explicitly asks for it — otherwise summarize in domain terms.** The script's JSON output includes a `parameterChanges` array with `parameter`, `description`, `from`, and `to` fields for every ConfigSet parameter it touched. Do NOT enumerate this by default — a domain-phrased summary of what the configuration accomplishes is the expected response shape. Render the table only when the user's prompt explicitly requests structured detail, e.g. "list every parameter you changed", "show me the changes as a table", "which parameters did the configuration modify?", "produce a report of the applied settings". When asked, render as a 4-column markdown table:

  | Parameter | Description | From | To |
  |---|---|---|---|

  Populate directly from the script fields — `parameter` (raw ConfigSet identifier such as `SystemTargetFile`), `description` (the ConfigSet's own human-readable prompt, e.g. "System target file"), `from` (previous value), `to` (applied value). This opt-in table is the one context where raw ConfigSet parameter identifiers may appear in user-facing output; everywhere else — defaults, confirmations, follow-ups, error paraphrasing — prefer engineering-concept language over raw parameter identifiers.
- **Warn before long operations.** When the user sets `Build=true`, or opts into introspection (`Introspect=true`) on a large model hierarchy, inform them that the operation may take significant time before invoking the script — both paths compile the model, potentially across the referenced hierarchy. Default calls (introspection off, `ConfigOnly=false` without `Build=true`) run without a model compile and are fast even on hierarchies; do not warn in those cases.
- **Refuse MISRA (and AUTOSAR) on GRT — pick a different target or drop the profile.** Simulink Coder does not ship MISRA style profiles, and AUTOSAR is an Embedded Coder feature. If the user asks for MISRA on GRT (or AUTOSAR on GRT), do not invoke the script — explain that MISRA and AUTOSAR are not available on GRT, and ask whether they want to (a) switch to ERT to keep MISRA/AUTOSAR, or (b) keep GRT and drop the compliance profile. This is a one-question clarification, not a silent choice.
- **On GRT, narrate the warnings the script returns.** When the target is GRT, the JSON output may include a non-empty `warnings` field — typically for Objective=RAM, where the boolean-bitfield storage flag is locked on GRT and cannot be turned on. When `warnings` is non-empty, paraphrase each entry in domain language after the primary success narration, without exposing raw parameter names: "Configured the model for RAM optimization; note that on the GRT target the boolean-bitfield storage knob is locked, so it was skipped — the rest of the memory-footprint cascade still applied." **Be precise about what was skipped:** the skipped item is *booleans-as-bitfields* specifically (packing boolean signals into single bits). Do NOT generalize it as "bitfield storage/packing" — state-bitfield and data-bitfield packing *are* applied on GRT and appear in `parameterChanges` as `StateBitsets`/`DataBitsets` set to `'on'`. If you mention "bitfield" as the skipped concept, cross-check `parameterChanges` first to confirm no other bitfield-family parameter shows as applied; otherwise scope the language to booleans.
- Never read script source at runtime — use this interface documentation as the invocation contract.

## Script Interface

### `configure_for_codegen(model, Name=Value)`

Atomic Embedded Coder configuration via ConfigSetManager. Configures the model (and all referenced sub-models) or reverts entirely on failure.

**Positional input:**

| Parameter | Description |
|-----------|-------------|
| `model` | Open model name; the `.slx`/`.mdl` extension is optional — `'MyModel'` and `'MyModel.slx'` both work (string) |

**Name-value arguments:**

| Name | Required | Values | Default |
|------|----------|--------|---------|
| `Target` | Yes | `"grt"`, `"ert"`, `"ert_shrlib"`, `"autosar"`, `"autosar_adaptive"` | — |
| `Language` | Yes | `"C"` or `"C++"` — `autosar` requires C, `autosar_adaptive` requires C++, `ert_shrlib` requires C | — |
| `Hardware` | Yes | Device string (e.g. `"ARM Compatible->ARM Cortex-A"`) | — |
| `Objective` | Yes | `"Speed"`, `"RAM"`, or `"Debug"` (on GRT, `"RAM"` skips the boolean-bitfield storage flag and records the skip in `warnings`) | — |
| `Interface` | No | `"Nonreusable function"`, `"Reusable function"`, `"C++ class"` (requires `Language="C++"`) | `"Nonreusable function"` |
| `Build` | No | `true` or `false` | `false` |
| `ConfigOnly` | No | `true` or `false` | `false` |
| `Compliance` | No | `"MISRA C"`, `"MISRA C++"`, or `""` — not available on `Target="grt"` (Simulink Coder does not ship MISRA profiles) | `""` |
| `OutputDir` | No | Directory path for generated code | Model's directory |
| `Introspect` | No | `true` or `false` — when `true`, the script compiles the model to right-size `Support*` flags and `IncludeMdlTerminateFcn`; when `false`, applies conservative defaults (all `Support*` flags `'on'`) without a compile. Skipped on AUTOSAR targets regardless. | `false` |

**Output:** JSON string with fields: `success`, `modelsConfigured`, `artifactsGenerated`, `reportPath`, `errors`, `warnings`, `parameterChanges`, `pendingSaves`. `parameterChanges` is an array of `{parameter, description, from, to}`, one per ConfigSet parameter touched — do not itemize by default (see the "Only itemize `parameterChanges`" rule above). `pendingSaves` is an array of `{kind, name, path}` where `kind` is `"model"` or `"dictionary"` — use it to name files when offering to save and to pick the save mechanism. `warnings` is an array of plain-language strings recording partial fulfillment; when non-empty, paraphrase each to the user (see the "On GRT, narrate the warnings" rule above).

**Example call** (invoked via `evaluate_matlab_code` with `project_path` set to this skill's `scripts/` directory):
```matlab
configure_for_codegen('mbasic', Target="ert", Language="C", Hardware="Intel->x86-64 (Linux 64)", Objective="Speed")
```

----

Copyright 2026 The MathWorks, Inc.

----
