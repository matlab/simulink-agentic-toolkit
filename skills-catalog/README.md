<!-- Copyright 2026 The MathWorks, Inc. -->
# Skills Catalog

The skills catalog organizes agent skills into groups. Each group is a directory containing one or more skills (each with a `SKILL.md` and `manifest.yaml`).

## Skill Groups

### [Model-Based Design Core](model-based-design-core/) 

Core Model-Based Design (MBD) skills for building, testing, and specifying Simulink models


| Skill | Description |
|-------|---------------------------|
| `building-simulink-models` | Best practices for structural model changes, for example, adding blocks, wiring, layout |
| `configuring-block-policy` | Create and manage `.satk/block-policy.json` to control which blocks the agent can use and which parameters it can modify |
| `curating-library-kg` | Curate the library knowledge index — mark common blocks, define categories, and improve descriptions for better agent block selection |
| `filing-bug-reports` | Generate standalone bug reports for reproducing, investigating, and fixing issues |
| `generate-requirement-drafts` | Generate requirements. This needs Requirements Toolbox (.slreqx) with traceability links when available, falls back to structured YAML |
| `managing-simulink-projects` | Manage MATLAB projects for Simulink workflows — path management, file registration, labels, and source control configuration |
| `setup-custom-libraries` | Register and configure custom Simulink block libraries so the agent prefers them over built-in blocks during model building |
| `simulating-simulink-models` | Run simulations for data exploration, parameter sweeps, and custom analysis |
| `specifying-mbd-algorithms` | Specify algorithms for Model-Based Design (MBD) including system specs, architecture specs, implementation and test plans |
| `specifying-plant-models` | Specify plant models for closed-loop simulation |
| `testing-simulink-models` | Test model behavior, reproduce issues, verify changes, regression tests |

### [Model-Based System Engineering](model-based-system-engineering/) 

Model-Based System Engineering skills for System Composer architecture models

| Skill | Description |
|-------|---------------------------|
| `building-architecture-models` | Build multi-layer system architecture models — components, interfaces, allocations, stereotypes, and requirements traceability (requires System Composer) |

### [Verification, Validation, and Test](verification-validation-and-test/) 

Skills for authoring custom Model Advisor checks and running compliance reviews against industry standards

| Skill | Description |
|-------|---------------------------|
| `check-authoring` | Author custom Model Advisor checks for Simulink and System Composer — DetailStyle callbacks, ResultDetail reporting, edit-time checks, and auto-fix support |
| `checking-model-compliance` | Run Model Advisor against compliance standards (MISRA, MAB, JMAAB, ISO 26262, DO-178C, AUTOSAR, etc.) and summarize findings with fix suggestions |

### [Code Generation](code-generation/) 

Skills for code generation

| Skill | Description |
|-------|---------------------------|
| `simulink-single-precision-conversion` | Convert a double-precision Simulink system or subsystem to single precision (requires Fixed-Point Designer) |

---

## Adding Skills

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on adding skills to the catalog.
