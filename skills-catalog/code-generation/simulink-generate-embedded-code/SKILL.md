---
name: simulink-generate-embedded-code
description: >
  Configure Simulink models for Embedded Coder (ERT) or AUTOSAR code generation.
  Use when the user asks to configure a model for production/ECU deployment,
  generate embedded C or C++ code, target ARM or x86 hardware, optimize code
  generation for speed or RAM, apply MISRA C/C++ compliance, or set up ERT,
  AUTOSAR, or shared-library targets — including running a full build or
  producing a code generation report. Handles target selection, optimization
  cascades, hardware mapping, model hierarchy propagation, and constraint
  introspection via the configure_for_codegen function. Do NOT use for Simulink
  Coder / GRT / grt.tlc / rapid-prototyping targets, DDS, or ROS — this skill
  is Embedded Coder and AUTOSAR only.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Generate Embedded Code from Simulink Models

Configure Simulink models for Embedded Coder code generation using the configure_for_codegen function.

## When to Use

- User asks to configure a model for code generation, production deployment, or Embedded Coder
- User mentions ERT, AUTOSAR, ARM, embedded target, or production code
- User wants to optimize generated code for speed or RAM
- User asks for MISRA C or MISRA C++ compliance
- User describes a deployment target in domain language ("deploy to ECU", "minimize flash")

## When NOT to Use

- Simulation-only tasks (running a model, tuning parameters, viewing signals)
- Data dictionary or bus object configuration (standalone, not as part of code-gen setup)
- Test harness creation or coverage analysis
- Simulink Coder (GRT) targets — this skill only handles Embedded Coder (ERT) and AUTOSAR
- DDS (Data Distribution Service) or ROS targets
- Modifying or formatting generated code files after code generation

## Rules

- **Never expose the script's wrapper parameter names — describe the decision and its effect in domain terms.** The `configure_for_codegen` wrapper parameter names (`ConfigOnly`, `Build`, `Interface`, `OutputDir`, `Compliance`, `Objective`, `Target`, `Hardware`, `Language`) are an implementation detail of the script — they must never appear in text you show the user, and neither should `name="value"` syntax. **This prohibition covers only the wrapper arguments.** It does not restrict describing what the configuration does at the model or ConfigSet level: you may and should explain the engineering substance of each choice in domain terms. Combine both — name the decision, then describe its effect. Tier-1 decision phrasing (safe as-is): "configured the model but did not build", "used a nonreusable function interface", "optimized for speed", "placed generated code next to the model". Concept-level effect phrasing (also safe, and expected on cascade-driven decisions): "optimizing for speed enables an execution-efficiency cascade — strength reduction, inlined parameters, and removal of division-by-zero protection"; "a reusable function interface produces multi-instance/reentrant code that passes state by pointer"; "a MISRA C profile drives specific style rules — casting mode, signed shifts, unreachable-default suppression". **Caution:** prefer engineering-concept language over raw Simulink ConfigSet parameter identifiers — say "inlines parameters," not "sets `InlineInvariantSignals`"; say "removes division-by-zero protection," not "sets `NoFixptDivByZeroProtection`". This applies to defaults, confirmations, follow-up questions, and error paraphrasing — everywhere except the phrase-mapping table below (which is your internal lookup, not user-facing).
- **Model must be open.** The model must already be open in MATLAB before calling `configure_for_codegen`. If it is not, open it directly with `open_system('<model>')` via `evaluate_matlab_code` — no separate skill is needed for this.
- **Model must be saved to disk (or the user must supply a destination).** The script writes generated code next to the model's `.slx` file. If the model is a fresh `new_system`/untitled window with no file on disk, the script cannot infer a location and returns `success:false` with a message asking the user to save the model or supply an explicit output directory. Relay that message verbatim and ask the user which they prefer — never guess a location on their behalf, and never call `save_system` without permission (see "Do not save" rule below).
- **Model must be compilable.** The model and all its dependencies (data dictionaries, referenced models, bus objects, MATLAB path entries) must be resolvable in the current MATLAB session. If configuration fails due to missing dependencies, inform the user what is unresolved and ask them to fix the environment — do not attempt `addpath` or other path manipulation on their behalf.
- **Do not save; inform, then offer.** The script does not call `save_system` and does not persist any bound data dictionaries. When configuration succeeds, explicitly tell the user nothing has been saved — model and dictionary changes exist only in memory, so they can review or discard freely. As a courtesy, ask whether they want to save now. Only save if the user says yes. Saving is outside the scope of this skill's core responsibility.
  - **Name every file that would be saved.** The script's JSON output includes a `pendingSaves` field listing the exact files whose in-memory state must be persisted for the configuration to reload correctly — always at least each configured `.slx`, plus any `.sldd` when a model's active ConfigSet is a ConfigSetRef backed by a data dictionary (the script writes the applied settings into a new dictionary entry, and saving the `.slx` alone would persist a reference to an entry that is not yet on disk — on reload, `get_param(model, 'SystemTargetFile')` would fail with "Unable to get parameter ... from referenced configuration set ... in data dictionary.").
  - **Save via the mechanism named by `kind`.** Read `pendingSaves` from the script output, name every entry when offering to save, and — on user consent — save each file using the mechanism named in its `kind` field (`model` → `save_system`, `dictionary` → `Simulink.data.dictionary.open(...).saveChanges()`). Never use `Simulink.data.dictionary.saveAll`; it would persist unrelated dictionaries that happen to be open in the session. If the user declines, save nothing.
- All configuration is performed via `configure_for_codegen` (in the skill's `scripts/` directory), called through `evaluate_matlab_code` with `project_path` set to `SKILL_DIR/scripts` — where `SKILL_DIR` is the absolute filesystem path this SKILL.md was loaded from. Do not guess a workspace-relative path (MCP rejects paths under `.claude/`); resolve `SKILL_DIR` to whichever absolute location the loader used. Do not `addpath` the user's model or dictionary folders — the script handles CWD/dictionary resolution internally and self-cleans. Pass `model` as an open model name — with or without the `.slx`/`.mdl` extension; the script strips it either way (e.g. `'mbasic'` or `'mbasic.slx'` both work). The model must already be open (see rule above). The agent never calls `set_param` directly.
- **Resolve MISRA ambiguity in your response.** "MISRA" alone is ambiguous — MISRA C and MISRA C++ are distinct standards. If the user says only "MISRA" without specifying, pick the one matching the source language (MISRA C for C, MISRA C++ for C++) and explicitly state the assumption in your final response — e.g., "Assuming MISRA C since the target language is C. Let me know if you meant MISRA C++."
- **State your inference for every required choice you didn't get verbatim from the user.** The four required inputs — target framework, source language, hardware device, and optimization objective — must each either come directly from the user or be a silently-safe inference that you explicitly narrate back. Never expose the script's wrapper parameter names. Common inferences to narrate (same treatment as the MISRA ambiguity rule):

  | User phrasing | Inferred choice | How to say it back |
  |---|---|---|
  | "embedded C", "production C" (no C++ mention) | source language = C | "Using C as the source language since you said 'embedded C' — let me know if you meant C++." |
  | "AUTOSAR" (bare, no Classic/Adaptive) | target = AUTOSAR Classic | "Using AUTOSAR Classic since you didn't specify — say the word if you meant AUTOSAR Adaptive." |
  | "embedded", "production", "ECU" (no shared-library / AUTOSAR mention) | target = ERT executable | "Building for an ERT executable target — tell me if you want a shared library instead." |
  | "ARM Cortex-A", "Cortex-M4", "x86-64" (short form) | full hardware device string | "Mapped 'ARM Cortex-A' to the ARM Compatible ARM Cortex-A device — let me know if you meant a different variant." |
- **Ask one batched clarifying question for what you cannot safely infer — never guess silently.** Among the four required inputs, `hardware` and `objective` are never silently defaulted — the wrong device string picks the wrong word sizes and endianness, and the choice between speed, memory footprint, and step-through debuggability is a real engineering tradeoff the user must own. `target` may be inferred as ERT executable when the user says "embedded", "production", "ECU", or nothing target-related; `language` may be inferred as C in the same conditions. If either or both of hardware / objective is missing after the phrase-mapping pass, ask a **single** consolidated question naming exactly what you need, then proceed once. Do not ask one parameter at a time. Example: "To configure this I need two things: (1) which processor family — ARM Cortex-A, ARM Cortex-M, x86-64, PowerPC, or something else? (2) should I optimize for execution speed, memory footprint, or step-through debuggability (preserves block-to-code traceability)?" This is the one allowed exception to the "one call, not two" rule below — a single upfront clarifying question, then exactly one script call.
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
- **Report assumed defaults in plain language — name every one, don't cherry-pick, and never expose the script's wrapper parameter names.** When the user does not specify a value, tell them which default you are applying for **each** of these decisions: function interface style, MISRA compliance, whether to build, whether to configure only, and output location. Describe every choice in user-facing prose — do not name the underlying script wrapper arguments (no `ConfigOnly`, `Build`, `Interface=`, `OutputDir=`, etc.) or show `name=value` pairs. Engineering-substance descriptions of what those choices *do* at the model/ConfigSet level are fine and encouraged where relevant. If the user didn't name a choice, you must still name your default — even for the "none" case (e.g. no MISRA compliance). Example: "Since you didn't specify, I applied these defaults: nonreusable function interface, no MISRA compliance profile, configured the model but did not run a build, and placed generated code next to the model file. Let me know if you want any of these changed."
- **Only itemize `parameterChanges` when the user explicitly asks for it — otherwise summarize in domain terms.** The script's JSON output includes a `parameterChanges` array with `parameter`, `description`, `from`, and `to` fields for every ConfigSet parameter it touched. Do NOT enumerate this by default — a domain-phrased summary of what the configuration accomplishes is the expected response shape. Render the table only when the user's prompt explicitly requests structured detail, e.g. "list every parameter you changed", "show me the changes as a table", "which parameters did the configuration modify?", "produce a report of the applied settings". When asked, render as a 4-column markdown table:

  | Parameter | Description | From | To |
  |---|---|---|---|

  Populate directly from the script fields — `parameter` (raw ConfigSet identifier such as `SystemTargetFile`), `description` (the ConfigSet's own human-readable prompt, e.g. "System target file"), `from` (previous value), `to` (applied value). This opt-in table is the one context where raw ConfigSet parameter identifiers may appear in user-facing output; the `description` column keeps every row engineering-substantive so the table remains readable. Everywhere else — defaults, confirmations, follow-ups, error paraphrasing — the "prefer engineering-concept language over raw parameter identifiers" guidance above still governs.
- **Warn before long operations.** When the user mentions a model hierarchy or sets `Build=true`, inform them that configuration may take significant time for complex/large hierarchies before invoking the script.
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
| `Target` | Yes | `"ert"`, `"ert_shrlib"`, `"autosar"`, `"autosar_adaptive"` | — |
| `Language` | Yes | `"C"` or `"C++"` — `autosar` requires C, `autosar_adaptive` requires C++, `ert_shrlib` requires C | — |
| `Hardware` | Yes | Device string (e.g. `"ARM Compatible->ARM Cortex-A"`) | — |
| `Objective` | Yes | `"Speed"`, `"RAM"`, or `"Debug"` | — |
| `Interface` | No | `"Nonreusable function"`, `"Reusable function"`, `"C++ class"` (requires `Language="C++"`) | `"Nonreusable function"` |
| `Build` | No | `true` or `false` | `false` |
| `ConfigOnly` | No | `true` or `false` | `false` |
| `Compliance` | No | `"MISRA C"`, `"MISRA C++"`, or `""` | `""` |
| `OutputDir` | No | Directory path for generated code | Model's directory |

**Output:** JSON string with fields: `success`, `modelsConfigured`, `artifactsGenerated`, `reportPath`, `errors`, `parameterChanges`, `pendingSaves`. `parameterChanges` is an array of `{parameter, description, from, to}` — one entry per ConfigSet parameter the script touched. Do not itemize this by default; render only when the user explicitly asks (see the "Only itemize `parameterChanges`" rule above). `pendingSaves` is an array of `{kind, name, path}` — `kind` is `"model"` or `"dictionary"`; use it to name files when offering to save and to pick the save mechanism (`save_system` vs `Simulink.data.dictionary.open(...).saveChanges()`).

**Example call** (invoked via `evaluate_matlab_code` with `project_path` set to this skill's `scripts/` directory):
```matlab
configure_for_codegen('mbasic', Target="ert", Language="C", Hardware="Intel->x86-64 (Linux 64)", Objective="Speed")
```

----

Copyright 2026 The MathWorks, Inc.

----
