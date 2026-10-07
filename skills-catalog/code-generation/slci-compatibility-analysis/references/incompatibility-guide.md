# SLCI Incompatibility Guide

## Severity Levels

| Severity | Meaning | Impact |
|----------|---------|--------|
| **FATAL** | Inspection will abort | Inspection cannot proceed with FATAL warnings; must be fixed |
| **Nonfatal** | Inspection proceeds with gaps | Some blocks/paths may not be verified; results are incomplete |

Use severity to prioritize fixes: resolve all FATAL issues first, then address
Nonfatal issues that affect the subsystems the user cares about verifying.

## Constraint Categories

| Category | Reference File | Description | Check Title Keywords |
|----------|---------------|-------------|---------------------|
| Code generation | [code_generation_constraints.md](code_generation_constraints.md) | Target language, optimizations, interface, identifiers | "code generation", "target", "optimization" |
| Diagnostics | [diagnostics_constraints.md](diagnostics_constraints.md) | Stateflow, data validity, sample time, bus signals | "diagnostic", "validity", "bus" |
| Solver | [solver_constraints.md](solver_constraints.md) | Solver type, step size, multitasking | "solver", "step size", "rate" |
| Hardware | [hardware_implementation_constraints.md](hardware_implementation_constraints.md) | Bit widths, integer division, shift behavior | "hardware", "bit", "division" |
| Math & data types | [math_data_types_constraints.md](math_data_types_constraints.md) | Boolean types, row-major algorithms | "math", "data type", "boolean", "row-major" |
| Data import/export | [data_import_export_constraints.md](data_import_export_constraints.md) | Initial state loading | "import", "export", "initial state" |
| Model-wide attributes | [model_wide_attribute_constraints.md](model_wide_attribute_constraints.md) | Unsupported blocks, storage classes, sample times | "model-wide", "storage class", "sample time" |
| Block-level (universal) | [block_constraints_universal.md](block_constraints_universal.md) | Constraints applying to all blocks (data type, complexity, dimensionality, naming, frame-based, storage class) | "data type", "complexity", "frame", "storage class" |
| Block-level (per-block) | [block_support_constraints.md](block_support_constraints.md) | Per-block parameter requirements (index to sub-files) | specific block type names |
| Stateflow | [stateflow_constraints.md](stateflow_constraints.md) | Chart-level constraints | "Stateflow" |
| MATLAB Function | [matlab_function_block_constraints.md](matlab_function_block_constraints.md) | MATLAB Function block constraints | "MATLAB Function" |
| Code replacement | [code_replacement_libraries_constraints.md](code_replacement_libraries_constraints.md) | CRL constraints | "code replacement", "CRL" |
| Model Advisor checks | [model_advisor_checks_constraints.md](model_advisor_checks_constraints.md) | Additional Model Advisor checks | "Model Advisor" |
| Known limitations | [code_inspection_limitations.md](code_inspection_limitations.md) | Features SLCI cannot handle regardless of settings | — |

Use the **Check Title Keywords** column to map failing check titles from
`checkCompatibility()` output to the appropriate reference file.

## Error Recovery

| Error | Recovery |
|-------|----------|
| Model won't load (missing dependencies, data dictionaries, bus objects) | Identify missing dependencies from the error; add required paths or load data |
| Incompatible `slprj` directory | Run from a clean working directory with the model directory on the path |
| SLCI license unavailable | Inform user; cannot proceed without license |
| Protected model references | Note these cannot be inspected; check the referencing model only |
| `checkCompatibility` throws (corrupt/incomplete model state) | Display the MATLAB error; suggest loading the model interactively first to resolve issues |
| Model Advisor infrastructure failure | Display error; suggest `ModelAdvisor.fixModelAdvisorDatabase()` |
| Timeout (>600s) | Report timeout; suggest running interactively or on a simpler model |
| `save_system` fails on copied file (read-only) | Run `fileattrib('<copy>', '+w')` after `copyfile` before applying fixes |
| `Invalid Simulink object name` on block paths | Block names may contain newlines (e.g., `Discrete-Time\nIntegrator`). Use `find_system(model, 'BlockType', '<type>')` to locate blocks by type instead of constructing paths with special characters |

----

Copyright 2026 The MathWorks, Inc.

----
