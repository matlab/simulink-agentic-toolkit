---
name: simulink-configure-model-for-code-generation
description: >
  Configure Simulink models for Embedded Coder (ERT), Simulink Coder (GRT
  rapid-prototyping), or AUTOSAR code generation. Use when the user asks to
  generate embedded C or C++ code, run a full build of a model, produce a code
  generation report, configure a model for production/ECU deployment or
  rapid-prototyping code, target ARM or x86 hardware, apply a MISRA C/C++
  code-generation profile (ERT/AUTOSAR only, not GRT), or set up GRT, ERT,
  AUTOSAR, or shared-library targets.
  Handles target selection, hardware mapping, model hierarchy propagation, and
  optional support-flag introspection. Do NOT use for GRT shared-library
  variants (grt_malloc.tlc), DDS, or ROS. Do NOT use for Simulink
  Real-Time/Speedgoat targets (simulink-configure-real-time-model), Classic
  AUTOSAR component mapping/ports/runnables/ARXML authoring
  (simulink-author-classic-autosar-swc), auditing a model against MISRA
  guidelines (checking-model-compliance), or iterative optimization of
  existing generated code (simulink-optimizing-embedded-code).
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "2.2.0"
---

# Configure a Simulink Model for Code Generation

Configure Simulink models for Embedded Coder (ERT), Simulink Coder (GRT rapid-prototyping), or AUTOSAR code generation using the configure_for_codegen function.

## When to Use

- User asks to configure a model for code generation, production deployment, Embedded Coder, or Simulink Coder rapid prototyping
- User mentions GRT, ERT, AUTOSAR, ARM, embedded target, production code, or rapid-prototyping code
- User asks for a MISRA C or MISRA C++ code-generation profile (ERT or AUTOSAR only — MISRA is not supported on GRT)
- User describes a deployment target in domain language ("deploy to ECU", "minimize flash", "rapid prototyping on a desktop target")

## When NOT to Use

- Measure/apply/re-measure optimization of existing generated code → use `simulink-optimizing-embedded-code`
- Simulink Real-Time, Speedgoat, Real-Time Linux, or HIL rigs → use `simulink-configure-real-time-model` (configure) and `simulink-run-real-time-application` (build/deploy)
- Classic AUTOSAR SWC authoring (mappings, runnables, ports, IRVs, BSW callers, ARXML import/update) → use `simulink-author-classic-autosar-swc`
- Checking or auditing MISRA or other guideline compliance, or fixing block-level violations → use `checking-model-compliance`
- Storage classes, function names/prototypes, Embedded Coder dictionaries → use `simulink-configure-code-interfaces`
- Simulation-only tasks (running a model, tuning parameters, viewing signals) → use `simulating-simulink-models`
- Test harness creation or coverage analysis → use `testing-simulink-models`
- SLCI code-inspection readiness → use `slci-compatibility-analysis`
- Rapid Accelerator builds → use `simulink-check-rapid-accelerator-compatibility`
- Double→single precision conversion → use `simulink-single-precision-conversion`
- Integrating legacy C/C++ code into a model → use `simulink-use-c-function-block`
- GRT shared-library variants (`grt_malloc.tlc` + manual `-shared -fPIC` linking) — no clean happy path; out of scope
- MISRA on GRT (pick ERT if MISRA is required) or AUTOSAR on GRT — see the GRT refusal rule below
- DDS (Data Distribution Service) or ROS targets — out of scope
- Modifying or formatting generated code files after code generation — out of scope

## Rules

- **Warn before long operations — in the same message as the call, never only in the final summary.** Code generation, a full build, and introspection compile the model; only configure-only without introspection does not. Before calling the script for a full build, or for code generation or introspection on a model hierarchy, tell the user in text in that same message, before the tool call, that it may take a while — e.g. "A full build compiles the model and runs the toolchain, so this may take a few minutes." Warn even if the build may turn out to be quick. Do not warn for configure-only calls without introspection or for code generation on a single model.
- **Describe decisions in domain terms — never expose the wrapper's parameter names.** The `configure_for_codegen` argument names (`ConfigOnly`, `Build`, `Interface`, `OutputDir`, `Compliance`, `Objective`, `Target`, `Hardware`, `Language`, `Introspect`) and `name="value"` syntax must never appear in text you show the user — in confirmations, defaults, warnings, follow-up questions, or error paraphrasing. The prohibition covers only the wrapper arguments; describing what the configuration does at the model/ConfigSet level is encouraged. Name the decision, then its effect: "configured the model but did not build"; "used a nonreusable function interface"; "optimizing for speed enables an execution-efficiency cascade — strength reduction, inlined parameters, removal of division-by-zero protection"; "a reusable function interface produces multi-instance/reentrant code that passes state by pointer". Prefer engineering-concept language over raw ConfigSet identifiers — say "inlines parameters," not "sets `InlineInvariantSignals`" — except in the opt-in `parameterChanges` table below.
- **Model must be open.** The model must already be open in MATLAB before calling `configure_for_codegen`. If it is not, open it directly with `open_system('<model>')` via `evaluate_matlab_code` — no separate skill is needed for this.
- **Generating code needs a saved model (or a destination).** The script writes generated code next to the model's `.slx` file. If code is to be generated and the model is a fresh `new_system`/untitled window with no file on disk, the script refuses before changing anything and asks the user to save the model or name an absolute output folder. Relay that message verbatim and ask the user which they prefer — never guess a location on their behalf, and never call `save_system` without permission. A configure-only call on an unsaved model works; nothing is written to disk.
- **Model must be compilable.** Referenced models and data dictionaries stored next to the top model are found automatically — the script works from the top model's folder. Dependencies stored elsewhere (other folders, bus objects, MATLAB path entries) must be resolvable in the user's session; if configuration fails because one is not, relay the error, tell the user what is unresolved, and ask them to fix the environment. Never call `addpath` or change the MATLAB path on the user's behalf.
- **Do not save; inform, then offer.** This is the default whenever the user has said nothing about saving; the user's explicit instructions about saving ("save and close", "don't write anything to disk yet") take precedence over it. The script does not call `save_system` and does not persist any bound data dictionaries. When configuration succeeds, explicitly tell the user nothing has been saved — model and dictionary changes exist only in memory, so they can review or discard freely — and ask whether they want to save now. Only save if the user says yes.
  - **Name every file that would be saved.** `pendingSaves` lists the exact files whose in-memory state must be persisted for the configuration to reload correctly — always each configured `.slx`, plus any `.sldd` when a model's active ConfigSet is a ConfigSetRef backed by a data dictionary (saving the `.slx` alone would persist a reference to a dictionary entry not yet on disk).
  - **Save via the mechanism named by `kind`.** On user consent, save each entry using its `kind` (`model` → `save_system`, `dictionary` → `Simulink.data.dictionary.open(...).saveChanges()`). Never use `Simulink.data.dictionary.saveAll`; it would persist unrelated dictionaries that happen to be open in the session. If the user declines, save nothing.
- **Invoke the script the documented way.** All configuration is performed via `configure_for_codegen` (in the skill's `scripts/` directory), called through `evaluate_matlab_code` with `project_path` set to `SKILL_DIR/scripts` — where `SKILL_DIR` is the absolute filesystem path this SKILL.md was loaded from. Do not guess a workspace-relative path (MCP rejects paths under `.claude/`). Do not `addpath` the user's model or dictionary folders — the script handles CWD/dictionary resolution internally and self-cleans. Pass `model` as an open model name, with or without the `.slx`/`.mdl` extension. Never call `set_param` directly.
- **Resolve MISRA ambiguity in your response.** MISRA C profiles need MATLAB R2024a or later (the script refuses them on earlier releases). "MISRA" alone is ambiguous — MISRA C and MISRA C++ are distinct standards. If the user says only "MISRA", pick the one matching the source language (MISRA C for C, MISRA C++ for C++) and explicitly state the assumption in your final response — e.g., "Assuming MISRA C since the target language is C. Let me know if you meant MISRA C++."
- **When a MISRA profile is applied, explain it in prose.** Say that MISRA C (or MISRA C++) is a compliance profile that drives several code-generation settings, and name at least two of them by their effect — e.g. standards-compliant casting, no signed shifts, keeping default cases in switch statements. Do this even when you also show the parameter table; the table does not replace the explanation.
- **State your inference for every required choice you didn't get verbatim from the user.** The four required inputs — target framework, source language, hardware device, and optimization objective — must each either come directly from the user or be a silently-safe inference that you explicitly narrate back. Read the inference table in [references/phrase-mapping.md](references/phrase-mapping.md) before the first call.
- **Ask one batched clarifying question for what you cannot safely infer — never guess silently.** Hardware device and optimization objective are never silently defaulted — the wrong device string picks the wrong word sizes/endianness, and speed vs. memory footprint vs. step-through debuggability is a real tradeoff the user must own. (Target may be inferred as ERT executable, and language as C, when the user says "embedded"/"production"/"ECU" or nothing target-related.) If hardware and/or objective is missing after the phrase-mapping pass, ask a **single** consolidated question naming exactly what you need, then proceed — do not ask one parameter at a time. Example: "To configure this I need two things: (1) which processor family — ARM Cortex-A, ARM Cortex-M, x86-64, PowerPC, or other? (2) optimize for execution speed, memory footprint, or step-through debuggability (preserves block-to-code traceability)?" In that same message, after your inferences, list all five defaults you will apply unless told otherwise — (1) function interface (nonreusable), (2) MISRA profile (none), (3) build mode (generate code, no executable build), (4) output location (next to the model), (5) introspection (skipped — conservative support flags, slightly larger code) — so the user can change any of them in the same reply. Never ask a question just to show defaults: when nothing needs clarifying, make the call and report defaults afterwards. This is the one allowed exception to the "one call, not two" rule below — a single upfront question, then exactly one script call.
- **Extract all parameters before the first call — one call, not two.** Read the user's request once and map every phrase to a `configure_for_codegen` parameter, then invoke exactly once. Making a second corrective call to add a parameter you forgot (e.g. configure-only, compliance, or build) is a rule violation. Read the phrase-mapping and build-mode tables in [references/phrase-mapping.md](references/phrase-mapping.md) before the first call — "don't build/compile" is ambiguous on its own: "don't generate code" means configure-only, while "generate code but don't build" means the default mode.
- **Never modify generated code files.** After code generation, the output files (.c, .cpp, .h, .arxml, etc.) are read-only artifacts. Do not edit, reformat, or overwrite them.
- **Relay `success:false` verbatim — never invent workarounds.** The script returns JSON with a `success` flag and a populated `errors[]` list when a prerequisite is missing (e.g. AUTOSAR Blockset not installed or unlicensed, model not loaded, invalid MISRA/language combination). When `success:false`, quote the error message to the user and stop. Do NOT retry with `ConfigOnly=true` to mask the missing dependency, do NOT fall back to direct `set_param()` calls, and do NOT rerun with different flags hoping the second try succeeds. The refusal is the correct outcome — the user needs the specific error to fix their environment.
- By default, generated code is placed next to the model file. Only pass `OutputDir` if the user explicitly requests a different location; a relative folder name is placed relative to the model's folder.
- **Report assumed defaults in plain language — name every one, don't cherry-pick.** When the user does not specify a value, tell them which default you applied for **each** decision: function interface style, MISRA compliance, whether to build, whether to configure only, output location, and whether the model was introspected. Name your default even for the "none" case (e.g. no MISRA). **The introspection default is a real engineering tradeoff and must always be surfaced:** by default the script skips the compile-time introspection pass and applies conservative support-flag settings (`SupportComplex`, `SupportContinuousTime`, `SupportVariableSizeSignals`, etc. left `'on'`), producing slightly larger generated code but avoiding a full model compile per call; the user can opt in with phrases like "check what the model needs" or "right-size the code". See the narration example in [references/phrase-mapping.md](references/phrase-mapping.md).
- **Only itemize `parameterChanges` when the user explicitly asks for it — otherwise summarize in domain terms.** The script's JSON output includes a `parameterChanges` array with `parameter`, `description`, `from`, and `to` fields for every ConfigSet parameter it touched. Do NOT enumerate this by default. Render the table only when the user's prompt explicitly requests structured detail, e.g. "list every parameter you changed", "show me the changes as a table", "which parameters did the configuration modify?", "produce a report of the applied settings". When asked, render as a 4-column markdown table:

  | Parameter | Description | From | To |
  |---|---|---|---|

  Populate directly from the script fields — `parameter` (raw ConfigSet identifier such as `SystemTargetFile`), `description` (the ConfigSet's own human-readable prompt, e.g. "System target file"), `from` (previous value), `to` (applied value). This opt-in table is the one context where raw ConfigSet parameter identifiers may appear in user-facing output.
- **Refuse MISRA (and AUTOSAR) on GRT — pick a different target or drop the profile.** Simulink Coder does not ship MISRA style profiles, and AUTOSAR is an Embedded Coder feature. If the user asks for MISRA on GRT (or AUTOSAR on GRT), do not invoke the script — explain that MISRA and AUTOSAR are not available on GRT, and ask whether they want to (a) switch to ERT to keep MISRA/AUTOSAR, or (b) keep GRT and drop the compliance profile. This is a one-question clarification, not a silent choice.
- **Narrate the warnings the script returns, on any target.** A non-empty `warnings` field records partial fulfillment — e.g. MISRA C++ class-scoped settings skipped on a non-class interface, or a RAM objective on GRT. Paraphrase each entry in domain language after the primary success narration.
  - **GRT booleans-as-bitfields:** say e.g. "note that on the GRT target the boolean-bitfield storage knob is locked, so it was skipped — the rest of the memory-footprint cascade still applied." The skipped item is *booleans-as-bitfields* specifically. Do NOT generalize it as "bitfield storage/packing" — state- and data-bitfield packing *are* applied on GRT (`StateBitsets`/`DataBitsets` set to `'on'` in `parameterChanges`). If you mention "bitfield" as the skipped concept, cross-check `parameterChanges` first.
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
| `OutputDir` | No | Directory path for generated code; a relative path is resolved against the top model's folder | Model's directory |
| `Introspect` | No | `true` or `false` — when `true`, the script compiles the model to right-size `Support*` flags and `IncludeMdlTerminateFcn`; when `false`, applies conservative defaults (all `Support*` flags `'on'`) without a compile. Skipped on AUTOSAR targets regardless. | `false` |

**Output:** JSON string with fields: `success`, `modelsConfigured`, `artifactsGenerated`, `reportPath`, `errors`, `warnings`, `parameterChanges`, `pendingSaves`. `parameterChanges` is an array of `{parameter, description, from, to}`, one per ConfigSet parameter touched — do not itemize by default (see the "Only itemize `parameterChanges`" rule above). `pendingSaves` is an array of `{kind, name, path}` where `kind` is `"model"` or `"dictionary"` — use it to name files when offering to save and to pick the save mechanism. `warnings` is an array of plain-language strings recording partial fulfillment; when non-empty, paraphrase each to the user (see the "On GRT, narrate the warnings" rule above). During long phases (introspection compile, code generation, build) the script prints one-line `configure_for_codegen:` progress messages; the JSON is always the last output.

**Example call** (invoked via `evaluate_matlab_code` with `project_path` set to this skill's `scripts/` directory):
```matlab
configure_for_codegen('mbasic', Target="ert", Language="C", Hardware="Intel->x86-64 (Linux 64)", Objective="Speed")
```

----

Copyright 2026 The MathWorks, Inc.

----
