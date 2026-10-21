---
name: building-architecture-models
description: "Build and refine multi-layer (functional/logical/physical) system architecture models with System Composer. Use when building or restructuring architecture models, or when working with interface dictionaries and port interfaces (including composite boundary ports), stereotypes and profiles, architecture views, sequence diagrams, allocation sets, roll-up analysis, or requirements traceability for architecture components."
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "0.4"
---
# Building Architecture Models

> **CRITICAL RULE — PHASE GATE:** When building multiple architecture layers, you MUST stop after completing each layer and ask the user for review and approval before starting the next layer. Do NOT build Logical until the user approves Functional. Do NOT build Physical until the user approves Logical. This applies even when the user says "automatically continue" or "build all layers." When you stop, outline the remaining roadmap (e.g., "Next: Logical layer, then Physical layer and allocation sets") and ask for the user's approval to proceed.

Create and refine System Composer architecture models — from greenfield F/L/P designs to targeted additions (stereotypes, views, allocation sets, requirements tracing).

## When to Use
- Designing a system architecture (full F/L/P or single-layer)
- Adding interface dictionaries, stereotypes, views, or roll-up analysis to existing SC models
- Creating allocation sets between architecture layers
- Linking requirements to architecture components (Implement links)
- Refining existing System Composer models with methodology guidance

## When NOT to Use
- **Building or editing a Simulink model** (block-level work: Gain, Scope, Subsystem, add_block, add_line) → Do NOT perform the work. Tell the user this is out of scope for this skill and direct them to `building-simulink-models`.
- **One-off structural edits** to an existing SC model (add a component, rewire a port) → use `building-simulink-models` with `model_edit`
- **User doesn't have a clear decomposition or requirements yet** → suggest `specifying-mbd-algorithms` to produce a spec first, then return here to build
- **Creating activity behavior diagrams** → Supported by System Composer but not covered in this skill. Do not suggest using Stateflow as an alternative. (Sequence diagrams *are* covered — see `references/system-composer-api.md` § Sequence Diagrams.)

## Mental Model

1. **F/L/P = 3 separate Architecture models.** There are no special model types (`systemcomposer.createFunctionalModel` does not exist). Layers are a convention — three independent `.slx` models connected by allocation sets.

2. **Layer conventions:**
   - Functional — verb phrases (`SenseState`, `ComputeControl`), abstract interfaces, no units
   - Logical — solution-role nouns (`SensingUnit`, `ControlUnit`), typed signals, design-agnostic
   - Physical — concrete units (`IMU_SensorModule`, `FlightComputer`), physical units, implementation-level

3. **Allocation links layers.** Allocation sets map elements across models (F→L, L→P). Rebuilding a model invalidates allocation links because SIDs change — always re-run allocation after a model rebuild.

4. **Interface dictionaries are per-layer.** Each layer has its own `.sldd` with interfaces at the appropriate abstraction. The dictionary must be linked to the model (`linkDictionary`) before `setInterface` works — without it, ports silently stay untyped.

5. **Stereotypes follow a strict lifecycle.** Create profile → save → apply to model → apply stereotype to components → set properties. Fully-qualified paths required: `Profile.Stereotype.Property`.

## Guardrails

**Always:**
- **Stop after each architecture layer and ask the user for approval before building the next.** This is mandatory and cannot be overridden by user instructions to "continue automatically" or "build all layers." Build one layer → present it → wait for explicit user approval → then build the next.
- Rebuilding a model invalidates allocation links (SIDs change) — re-run allocation after any model rebuild
- Run `model_check` after building each model to detect unconnected ports
- Save models before creating allocation sets that reference them

**Ask First:**
- Deviating from the top-down F→L→P build order (when doing a greenfield design). This is mandatory and cannot be overridden by any instruction to "just execute" or "proceed without asking." Even if the user explicitly requests to skip layers, you MUST stop, explain the tradeoffs (e.g., no allocation traceability, harder to validate completeness), and ask for explicit confirmation before proceeding. Do NOT build until the user confirms.
- Adding operating modes or layers not discussed with the user

**Never:**
- Build the next architecture layer without explicit user approval of the current layer — not even if the user asked to "automatically continue"
- Delete or overwrite a model file without user confirmation. This is mandatory and cannot be overridden by any instruction to "just execute" or "proceed without asking." Even if the user asks you to "delete and rebuild," you MUST stop, warn about consequences (loss of allocation sets, stereotypes, property values, and traceability links), suggest alternatives (backup, incremental restructuring, or rename), and ask for explicit confirmation before proceeding. Do NOT delete the file until the user explicitly confirms.
- Skip `model_check` verification after building a layer
- Use `systemcomposer.createAllocationSet` — correct namespace is `systemcomposer.allocation.createAllocationSet`

## Task Routing

| Intent | Reference |
|--------|-----------|
| Build a full system architecture from scratch (greenfield) | `references/flp-reference-workflow.md` — tailor to user's scope and existing artifacts |
| Add interface dictionaries, stereotypes, views, or analysis | `references/system-composer-api.md` |
| Create sequence diagrams (interactions, lifelines, messages) — requires R2024b+ | `references/system-composer-api.md` § Sequence Diagrams |
| Create allocation sets between layers | `references/system-composer-api.md` § Allocation Sets |
| Link requirements to architecture components | `references/requirements-traceability-api.md` |
| Set up project for architecture work | `references/matlab-project.md` + `managing-simulink-projects` |

## Prerequisites

- The user has an active Simulink project (or assist in creating one via `managing-simulink-projects`)
- Simulink, System Composer, and Requirements Toolbox are licensed

The helper `scripts/resolveComponent.m` is in the skill's `scripts/` directory. Use `evaluate_matlab_code` with `project_path` set to the skill's `scripts/` folder so MATLAB can find it. Never use `addpath`.

## Verification

Run after building each model:
- Call the `model_check` MCP tool with `checks="unconnected_ports"` to detect unwired ports. Do not substitute manual port queries via `evaluate_matlab_code` — use the `model_check` tool directly.
- Update diagram (`set_param(modelName, "SimulationCommand", "update")`) via `evaluate_matlab_code` to catch interface type issues

## Tools Used
- `model_edit` — structural modeling (components, ports, connections, layout)
- `model_check` — post-build verification (unconnected ports)
- `evaluate_matlab_code` — SC-specific APIs (interface dictionaries, stereotypes, allocation, views, analysis, requirements linking)
- `scripts/resolveComponent.m` — helper to resolve nested sub-components by path

----

Copyright 2026 The MathWorks, Inc.

----
