# Configuring Code Interfaces

Configure how model elements map to generated code — storage classes (Data Interface) or service interfaces (Service Interface).

**Prerequisite:** ERT target (`SystemTargetFile = "ert.tlc"`) required for full functionality (function mapping, deployment types, Service Interface). GRT supports basic Data Interface StorageClass operations. Use `simulink-configure-model-for-code-generation` first if needed.

**Requires:** Embedded Coder license for Service Interface or advanced Data Interface features. Simulink Coder sufficient for basic Data Interface.

## End-to-End: Fresh Model → Generated Code

Ordered steps for taking a model that has no code mappings all the way to generated code. Steps in **[brackets]** are conditional — do them only if the situation calls for it. **This skill covers steps 4–7 and 9–10** (create mappings, update diagram, deployment type, element configuration, generate code, verify). Steps 1 and 8 are handled by neighboring skills, called out below. The mode-specific detail for each step is in the workflow sections below and in the reference files.

1. **Configure the model for code generation** *(prerequisite — NOT this skill; use the `simulink-configure-model-for-code-generation` skill)*
   Set the ERT target and any hardware/optimization/objective settings first. Full interface functionality requires `SystemTargetFile = "ert.tlc"`. If this is not done, do it before anything below.

   *If the algorithm itself still needs structural work (adding/wiring blocks, subsystems, ports) — NOT this skill; use the `building-simulink-models` skill (skills-catalog/model-based-design-core) before configuring interfaces.*

2. **Decide the interface mode** — Data Interface or Service Interface (see *Mode Selection*). Default to Data Interface when ambiguous. *(this skill)*

3. **[Service Interface only] Create and link a coder dictionary** *(this skill)*
   Create a ServiceInterface dictionary in a shared `.sldd` and link it by setting the `EmbeddedCoderDictionary` parameter of the model to `"dict.sldd"` with `model_edit` (`configure` op on `config:<ModelName>`). Required before `"Component"` deployment appears. (Data Interface can also use a dictionary but does not require one.) See `coder_dictionary.md`.

4. **Create code mappings** — `coder.mapping.utils.create(model)`, then `cm = coder.mapping.api.get(model)`. *(this skill)*
   - **Service Interface: required.** `setDeploymentType`, `setInport`/`setOutport`/`setState`, and every service assignment are methods on the code mapping object — you cannot obtain that object, or reach `"Component"` deployment, without creating mappings first.
   - **Data Interface: only needed to override the defaults.** A model with an ERT target generates code from a *default code interface* — no code mapping object is created in the background, and none is required to build. Create mappings only when you intend to override element interfaces or set a deployment type. **Do not manufacture configuration the user did not ask for.**

5. **[Update diagram — required only for rate-based step functions and Data Transfer]** — `set_param(model, 'SimulationCommand', 'update')` (or `Ctrl+D`). *(this skill)*

6. **[Set deployment type if needed]** — `setDeploymentType(cm,"Component")` (Service Interface) or `"Automatic"`/`"Subcomponent"` (either mode). *(this skill)*

7. **[Configure element interfaces]** — assign storage classes / service interfaces per port, state, and parameter. *(this skill; see the workflow sections and `code_mapping.md`. Skip entirely if the default interface is acceptable — this walkthrough does.)*

8. **Save the model** — `save_system(model)` (and save the dictionary if you changed it). *(general Simulink action, not specific to this skill)* Unsaved mapping / dictionary / `EmbeddedCoderDictionary` changes are a common silent cause of "my configuration did not take effect." **Do not save on your own — ask the user first** (see guardrail in *Key Rules*). Saving overwrites the `.slx`/`.sldd` files that are on disk; this is for the user to decide, not you.

9. **Generate code** — `slbuild(model)` for a full build, or code generation only: *(this skill)*
   ```matlab
   slbuild(model, 'GenerateCodeOnly', true)   % generate C/C++ without compiling
   ```
   The equivalent through the configuration set — set `GenCodeOnly` to `"on"` with `model_edit` (`configure` op on `config:<ModelName>`), then `slbuild(model)` — works too, but the `slbuild` option above is one call and leaves the saved configuration untouched. **Do not build on your own — ask the user first** (see guardrail in *Key Rules*). A build can be long-running and writes generated artifacts to disk; confirm the user wants it before invoking `slbuild`.

10. **Verify** — confirm the generated interface matches intent (mode-specific; see the *Verification* sections in `code_mapping.md` and `coder_dictionary.md`). For Service Interface, confirm the service header/functions exist; for Data Interface, confirm the expected variable declarations. Check `getCodeInterfaceType(...)` and the build-reason log if results are unexpected. *(this skill)*

**Model-reference hierarchy:** code mappings are per-model — each model in a hierarchy (top model and every referenced model) has its own code mapping, and each must be configured separately. There is no inheritance or propagation of mappings from the top model to referenced models. Repeat steps 4–7 for each model whose interface you need to control; configuring only the top model leaves referenced models on their own default (or existing) mappings.

## Mode Selection

Detect current mode: `introspect_api("mode",model)` — returns `"DataInterface"` or `"ServiceInterface"`.

**Use Data Interface** (majority use case) when the user wants:
- Global variables, extern declarations, struct fields in generated code
- Control over header files, definition files, identifiers
- Storage class assignment on elements
- Standalone application deployment

**Use Service Interface** when the user wants:
- Function-call services (get/set pattern)
- Sender/receiver or client/server communication
- Service-oriented runtime integration (platform abstraction layer)
- AUTOSAR-like architecture

**Do NOT route to Service Interface** just because the user says "component." A model can generate code as a reusable component in Data Interface mode (deployment type `"Automatic"`). Only use Service Interface when the user explicitly mentions services, sender/receiver, or client/server patterns.

When ambiguous, default to Data Interface.

## Workflow — Data Interface

1. **Create code mapping** — `cm = coder.mapping.utils.create(model)` *(required on fresh models — skipped if mappings already exist; returns the mapping object)*
2. **Get code mapping** — `cm = coder.mapping.api.get(model)`
3. **Set data defaults** — `setDataDefault(cm, category, property, value)`
4. **Override individual elements** — `setInport(cm, port, 'StorageClass', 'ExportToFile')`
5. **Configure functions** — `setFunctionDefault(cm, 'Execution', 'MemorySection', 'MemConst')`

Storage class can be assigned two ways — **code mappings** (with the model) or **data objects** (`Simulink.Parameter`/`Simulink.Signal`, with the data, reusable across models). Ask which the project uses; do not assign in both places for the same signal (conflicting non-`Auto` specs fail codegen). See `code_mapping.md` → "Storage Class: Two Mechanisms."

Deployment type: `"Automatic"` or `"Subcomponent"` — `"Component"` is not a settable value here. `"Automatic"` determines the deployment type based on context; for a top model that is a component.

## Workflow — Service Interface

1. **Create a ServiceInterface dictionary** — `coder.dictionary.create(sldd,"ServiceInterface")`
2. **Link it to the model** — set `EmbeddedCoderDictionary` to `"dict.sldd"` through `model_edit` (`configure` op on `config:<ModelName>`)
3. **Create code mapping** — `cm = coder.mapping.utils.create(model)`
4. **Set deployment type** — `setDeploymentType(cm,"Component")` *(settable only in service interface configuration)*
5. **Configure interfaces** using dictionary entries

## Key Rules

- **Call `introspect_api` (`scripts/introspect_api.m`) BEFORE assigning any storage class, service, deployment type, or per-element property** — it returns the allowed values, valid properties, categories, and current mode. This is a required first step, not an optional convenience. Do NOT discover valid values by trial-and-error (setting a value to see if it errors, or making repeated `set_param` / `coder.mapping` calls to probe) — enumerate with `introspect_api` first, then set the value you learned is valid. Detect mode with `introspect_api("mode",model)` before choosing property names (DataInterface vs ServiceInterface differ).
- `EmbeddedCoderDictionary` is distinct from `DataDictionary` — they serve different purposes
- **NEVER edit generated code.** Generated C/C++ files are outputs of the code generator — they are overwritten on every build. All changes must be made to the model, code mappings, or dictionary entries. If the user asks to modify generated code, redirect them to the appropriate model-level configuration.
- **STOP before creating any dictionary entry** — do NOT write `addEntry` or `set(entry,...)` calls until the user has provided the actual values. Memory sections require target-specific pragmas, storage classes require project conventions, interface entries require design intent. If values are not in the conversation, ask and wait.
- **NEVER save or build the model on your own — always ask the user first.** Do not call `save_system` or `slbuild` (or `set_param(model,"GenCodeOnly",...)` followed by a build) without explicit user confirmation. Saving overwrites the saved model and dictionary files on disk; building can be long-running and writes generated code to disk. Configure the mappings, tell the user exactly what you changed, and ask whether they want you to save and/or generate code. Wait for a yes before proceeding.

## Reference Files

- **`references/code_mapping.md`** — `coder.mapping.*` API: port/state mapping, function naming/prototypes, mode awareness, discovery techniques.
- **`references/coder_dictionary.md`** — `coder.dictionary.*` API: creating and linking dictionaries, sections, entries, communication methods, naming tokens.
- **`scripts/introspect_api.m`** — Runtime introspection of allowed values, properties, categories, and mode detection.

----

Copyright 2026 The MathWorks, Inc.

----
