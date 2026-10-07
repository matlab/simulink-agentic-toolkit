# Compiler Options — `BuildConfiguration` and `UseGCCFastMath`

The Simulink Real-Time toolchain compiles with `gcc`/`g++`. For normal Simulink Real-Time configuration work, use the product-exposed build options instead of overriding target-managed toolchain settings by hand.

Use `BuildConfiguration` for optimization presets and `UseGCCFastMath` for the Simulink Real-Time option that enables GCC `-ffast-math`. Do not use `RTWCompilerOptimization` as the optimization control for Simulink Real-Time builds.

## `BuildConfiguration`

`BuildConfiguration` is a model configuration parameter. Change it to the preset that matches the user's goal:

| Value           | Behavior                                                                                | When to use                                                                 |
|-----------------|-----------------------------------------------------------------------------------------|-----------------------------------------------------------------------------|
| `Faster Runs`   | `-O2` (default after switching to a Simulink Real-Time TLC, non-Mac)                                 | Production deployment; default                                              |
| `Faster Builds` | `-O0`                                                                                   | Iterating on model structure where build time dominates over run time       |
| `Debug`         | `-O0 -g`                                                                                | Step-debug the generated code with gdb                                      |
| `Specify`       | No preset; uses `CustomToolchainOptions` verbatim                                       | Need to pass flags that no preset covers (see below)                        |

Setting `Specify` makes `CustomToolchainOptions` authoritative for the four entries it contains.

## `CustomToolchainOptions`

`CustomToolchainOptions` is a **flat cell array of alternating `{label, value, label, value, ...}`** describing per-tool flag strings. Treat it as an advanced escape hatch, not the default optimization path. Prefer `BuildConfiguration` and `UseGCCFastMath` whenever they cover the user's request.

`CustomToolchainOptions` is a model configuration parameter. When a custom flag is truly needed, inspect its existing value, locate the `C Compiler` and `C++ Compiler` entries, append only the target-compatible flag to their existing flag strings, then apply and verify the complete cell array. Do not overwrite the full option list from memory.

**Documented tooling gap.** `CustomToolchainOptions` holds a cell array that must be read, edited in place, and written back. The model-configuration tooling in the agent environment sets parameters to literal values; it has no read-modify-write op for a cell array, and it cannot return the existing option list for you to amend. So this one parameter has no supported non-`set_param` path — raw `get_param`/`set_param` is the intended route here, and it is the only place in this skill where that is true. Every other parameter in this reference must go through the environment's model-configuration capabilities.

Example only: the following MATLAB code assumes `C Compiler` and `C++ Compiler` each appear exactly once and that `-fdisable-rtl-sched2` is not already present. Verify those assumptions before using it; otherwise adapt the read-modify-write logic to avoid a missing label or duplicate flag.

```matlab
options = get_param(modelName, 'CustomToolchainOptions');
ccompiler_idx   = find(strcmp(options, 'C Compiler'));
cppcompiler_idx = find(strcmp(options, 'C++ Compiler'));

options{ccompiler_idx + 1}   = [options{ccompiler_idx + 1}   ' -fdisable-rtl-sched2'];
options{cppcompiler_idx + 1} = [options{cppcompiler_idx + 1} ' -fdisable-rtl-sched2'];

set_param(modelName, 'CustomToolchainOptions', options);
```

Change the `BuildConfiguration` model configuration parameter to `Specify` first if the user explicitly wants to override the preset, or leave it as-is if they are appending a target-compatible flag to the current preset. Do not use this path to modify the selected `Toolchain`, make command, hardware device type, or code replacement library.

## Common Custom Flags

### `-ffast-math` — floating-point speed at the cost of IEEE-754 compliance

Enabled via the **Compile with GCC -ffast-math** model parameter (Simulink Real-Time pane), represented by `UseGCCFastMath`. This is the recommended path; do not edit `CustomToolchainOptions` for `-ffast-math` alone.

Use when: the user reports CPU overloads or wants more floating-point throughput and is willing to relax IEEE-754 (no NaN/Inf checking, fused multiply-add reordering).

`UseGCCFastMath` is a model configuration parameter. Change it to `"on"` to enable `-ffast-math` or `"off"` to disable it.

### `-fdisable-rtl-sched2` — workaround for Simscape Multibody long build times

 Apply when a model with Simscape Multibody blocks takes  long to compile. Append to both the C Compiler and C++ Compiler entries via `CustomToolchainOptions`, with `BuildConfiguration='Specify'`.

### `-g` — debug symbols

Use `BuildConfiguration='Debug'` instead of appending `-g` manually.

## Verification After Changing

Read back `BuildConfiguration`, `UseGCCFastMath`, and, for advanced custom-flag changes, `CustomToolchainOptions`. Confirm the cell array contents match expectations.

## What This Skill Will Not Touch

- `MakeCommand` (locked to `make_rtw`)
- `RTWCompilerOptimization` (locked off)
- `Toolchain` (locked by architecture; do not switch)
- `CodeReplacementLibrary` (locked by architecture)

If any of these look wrong after selecting the Simulink Real-Time STF, treat it as a support-package, target-file callback, or installation problem instead of manually overriding the values.

----

Copyright 2026 The MathWorks, Inc.

----
