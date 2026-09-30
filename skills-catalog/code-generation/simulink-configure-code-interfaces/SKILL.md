---
name: simulink-configure-code-interfaces
description: Use the skill to control and verify the code interface configuration of your model — how Simulink® model elements are represented in the generated C or C++ code.
 This includes — (1) specifying names, types (storage classes), and placement of variables that represent model elements (for example, making a model parameter tunable as a global extern variable); (2) specifying names, types, and placement of functions that represent model algorithms; (3) selecting the deployment type (Component, Subcomponent, or Automatic); (4) selecting the interface configuration type (data or service interface); (5) linking a shared Embedded Coder dictionary to a model; (6) creating Embedded Coder dictionary entries and setting their properties; (7) for service interface configuration — specifying service interface definitions, including sender, receiver, client, and server services. Items 1 and 2 can be set per element or as a category-wide default. Item 1 applies to GRT and ERT models; the rest to ERT models only.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0.1"
---

# Configuring Code Interfaces

Configure how model elements map to generated code — storage classes for elements in models configured with data interface configuration, and service interfaces for elements in models configured with service interface configuration.

**Prerequisite:** For full functionality of the skill (such as function mapping, specifying the deployment type, and using service interface configuration),
the model needs to be configured with the ERT system target file (`SystemTargetFile = "ert.tlc"`, or an ERT-based derivative such as `ert_shrlib.tlc` or a vendor ERT target). When the model is configured with the GRT system
target file (`SystemTargetFile = "grt.tlc"`), only basic configuration operations such as specifying the storage class of model elements are supported. To configure the model with the ERT system target file, use the neighboring skill `simulink-configure-model-for-code-generation`.

**Requires:**
- For models configured with the GRT system target file, a Simulink® Coder license is required.
- For models configured with the ERT system target file, an Embedded Coder® license is required.

## When to Use

- When setting storage classes for inports, outports, states, or parameters through **code mappings**. If the project assigns storage classes through **data objects** instead (such as `Simulink.Parameter` or `Simulink.Signal`), that is a different workflow — see `references/code_mapping.md`, which also covers the one case that must be configured on the object.
- When specifying the **code representation** of **signals**, **states** (such as values that Unit Delay and Integrator blocks hold between steps), **parameters**, or **data stores**. For example, when mapping a model element in this category to a global or extern variable, or when placing its declaration in a designated `.h` or its definition in a designated `.c` file. These requests map model elements to storage classes even when the user never explicitly says "storage class" or "code mapping".
- When making a **parameter tunable** in the generated code (a global parameter that the rest of the software can read and update).
- When mapping function names. This happens when the user explicitly names generated entry-points or any other type of generated functions. For example: "make the startup routine be called `mFunctions_startup`".
- When specifying data defaults or function defaults for code generation.
- When configuring the model with either data or service interface configuration for code generation.
- When linking a shared Embedded Coder dictionary to a model.
- When configuring sender-receiver or client-server interface patterns.
- When setting deployment types and function prototypes for generated code.
- When inspecting or verifying the current model interface. For example: "is this model set up for data interface or for service interface?", or "did my dictionary link take effect?"

## When NOT to Use

- When configuring non-mapping-related aspects of the model for code generation (such as specifying the target platform, hardware, or objective). For these purposes, use the skill `simulink-configure-model-for-code-generation`.
- When opening, editing, or building a model or its structure. For these purposes, use the skill `building-simulink-models`.
- When **customizing the exported A2L (ASAP2) calibration file** — COMPU_METHODs, GROUPs, STD_AXIS→COM_AXIS, BIT_OPERATIONs, or VARIANT_CODING. For these purposes, use the skill `simulink-customize-a2l` (`coder.asap2.*`). This skill owns the **model-side** calibration attributes that code mappings carry (`Export`, `CalibrationAccess`, `BitMask`, `CompuMethod`, `DisplayIdentifier`, `Format`) and that the A2L export then reads; it does not edit the A2L file.
- When the code generation target is not C/C++ through Simulink Coder or Embedded Coder. For example, when it is one of these:
  - HDL Coder, which uses `hdlcoder.*` APIs and generates VHDL/Verilog.
  - Simulink PLC Coder, which generates IEC 61131-3 Structured Text.
  - MATLAB Coder or GPU Coder, which generate C/CUDA code from MATLAB functions (these do not generate code from Simulink models).
- When using an API surface that does not rely on `coder.mapping.*` or `coder.dictionary.*`. The generated code is still C or C++, but uses different mapping APIs. For example, when the API surface is one of these:
  - AUTOSAR Classic or AUTOSAR Adaptive (`autosar.api.*`). For authoring a Classic AUTOSAR software component — including its port, data, and service interface configuration — use the skill `simulink-author-classic-autosar-swc`.
  - DDS (Data Distribution Service) code mapping
  - C++ class code interface packaging (`SystemTargetFile = "ert.tlc"` and `CodeInterfacePackaging = "C++ class"`).
- When deploying the generated code for Embedded Linux.

This skill covers **C Data Interface** configuration when using **Simulink Coder** or **Embedded Coder**.
The skill also covers **C Service Interface** configuration when using **Embedded Coder**.

## Critical Guardrails

- **Read-only inspection needs no permission — run it.** Queries that do not modify the model or dictionary — `introspect_api`, `find(cm,...)`, `model_read`/`model_query_params`, `getModelParameter`/`getDeploymentType`/`getDataStore`, `coder.dictionary`/`coder.mapping` getters — are safe. Run them freely to diagnose, detect mode, and verify; never stop to ask before a read. The confirmation gate below applies **only to writes** (`save_system`, `slbuild`, `addEntry`/`set(entry,...)`).
- **Call `introspect_api` (in `scripts/`) BEFORE assigning any storage class, service, deployment type, or per-element property.** It returns allowed values, valid properties, and the current mode (DataInterface vs ServiceInterface). This is a required first step — do NOT discover valid values by trial-and-error or repeated probing calls. Enumerate first, then set the value you learned is valid.
- **NEVER save or build the model on your own — always ask the user first.** Do not call `save_system` or `slbuild` (or set `GenCodeOnly` and build) without explicit user confirmation. Saving overwrites the user's model/dictionary on disk; building can be long-running and writes generated code. Configure the mappings, report exactly what you changed, ask, and wait for a yes.
- **STOP before creating any dictionary entry** — do not write `addEntry`/`set(entry,...)` until the user provides the actual values (pragmas, storage classes, interface entries encode project intent).
- **Link a shared Embedded Coder dictionary through `EmbeddedCoderDictionary` only, and only through `model_edit` (a `configure` op on `config:<ModelName>`).** Never set `DataDictionary` to bring in a coder dictionary — it fails **silently**, leaving the model resolved to `DataInterface`. Do not reach for `set_param`/`get_param` on either parameter. See `references/coder_dictionary.md`.
- **NEVER edit generated code** — it is overwritten every build. All changes go to the model, code mappings, or dictionary.
- **Do not manufacture configuration the user did not ask for.** A Data Interface model builds from a default code interface with no code mapping object; create mappings only to override defaults.
- **Configuring a parameter's storage class — pick the mechanism by where the parameter lives.** Model workspace → *always* code mappings (`setModelParameter`), even on GRT; never set `.StorageClass` on the object. External parameter object (base workspace or data dictionary) → `.StorageClass` on the object; `setModelParameter` cannot address it. See `references/code_mapping.md`.
- **Confirm any model-design or configuration change that a requested interface change depends on — before making it.** Some code-interface configurations cannot be applied on the model as-is and require a prerequisite change to the model's design or configuration (for example, switching GRT→ERT for function mapping, deployment types, or Service Interface; requiring a fixed-step solver; converting to an export-function model). Such a change can alter or prevent code generation. Do not apply it silently — explain what the interface change requires, why, and wait for the user's yes.

## Reference Files

- `references/simulink-configure-code-interfaces.md` — mode selection, per-mode workflows, deployment types, per-model mappings in a model-reference hierarchy, and the end-to-end "fresh model → generated code" spine
- `references/code_mapping.md` — `coder.mapping.*` API: storage-class mechanisms, port/state mapping, function naming/prototypes, silent-failure detection and verification patterns
- `references/coder_dictionary.md` — `coder.dictionary.*` API: creating/linking dictionaries, entries and their properties (`getAvailableProperties`), communication methods

----

Copyright 2026 The MathWorks, Inc.

----
