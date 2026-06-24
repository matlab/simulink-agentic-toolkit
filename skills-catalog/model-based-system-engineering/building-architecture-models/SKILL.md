---
name: building-architecture-models
description: "Common steps for building multi-layer system architecture models using System Composer. Use when implementing architecture models or when interacting  with interface dictionaries, allocation sets, stereotypes, and requirements for architecture components."
license: MathWorks BSD-3-Clause
metadata:
  author: MathWorks
  version: "0.2.0"
---
# Building Architecture Models

Create and refine System Composer architecture models — from greenfield F/L/P designs to targeted additions (stereotypes, views, allocation sets, requirements tracing).

## When to Use
- Designing a system architecture (full F/L/P or single-layer)
- Adding interface dictionaries, stereotypes, views, or roll-up analysis to existing SC models
- Creating allocation sets between architecture layers
- Linking requirements to architecture components (Implement links)
- Refining existing System Composer models with methodology guidance

## When NOT to Use
- **Building or editing a Simulink model** (block-level work) → use `building-simulink-models`
- **One-off structural edits** to an existing SC model (add a component, rewire a port) → use `building-simulink-models` with `model_edit`
- **User doesn't have a clear decomposition or requirements yet** → suggest `specifying-mbd-algorithms` to produce a spec first, then return here to build
- **Creating activity/sequence behavior diagrams** → These are supported features of System Composer, but are not covered in this skill. Do not suggest using Stateflow as an alternative.

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
- Get user review and approval before moving to the next phase
- Rebuilding a model invalidates allocation links (SIDs change) — re-run allocation after any model rebuild
- Run `model_check` after building each model to detect unconnected ports
- Save models before creating allocation sets that reference them

**Ask First:**
- Deviating from the top-down F→L→P build order (when doing a greenfield design)
- Adding operating modes or layers not discussed with the user

**Never:**
- Delete or overwrite a model file without user confirmation
- Skip `model_check` verification after building a layer
- Use `systemcomposer.createAllocationSet` — correct namespace is `systemcomposer.allocation.createAllocationSet`

## Task Routing

| Intent | Reference |
|--------|-----------|
| Build a full system architecture from scratch (greenfield) | `references/flp-reference-workflow.md` — tailor to user's scope and existing artifacts |
| Add interface dictionaries, stereotypes, views, or analysis | `references/system-composer-api.md` |
| Create allocation sets between layers | `references/system-composer-api.md` § Allocation Sets |
| Link requirements to architecture components | `references/requirements-traceability-api.md` |
| Set up project for architecture work | `references/matlab-project.md` + `managing-simulink-projects` |

## Prerequisites

- The user has an active Simulink project (or assist in creating one via `managing-simulink-projects`)
- Simulink, System Composer, and Requirements Toolbox are licensed

## Verification

Run after building each model:
- `model_check` with `checks="unconnected_ports"` to detect unwired ports
- Update diagram (`set_param(modelName, "SimulationCommand", "update")`) to catch interface type issues

## Tools Used
- `model_edit` — structural modeling (components, ports, connections, layout)
- `model_check` — post-build verification (unconnected ports)
- `evaluate_matlab_code` — SC-specific APIs (interface dictionaries, stereotypes, allocation, views, analysis, requirements linking)
- `scripts/resolveComponent.m` — helper to resolve nested sub-components by path

----

Copyright 2026 The MathWorks, Inc.

----
