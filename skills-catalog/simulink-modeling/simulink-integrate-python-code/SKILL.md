---
name: simulink-integrate-python-code
description: |
  Use this skill when running or integrating general Python code (functions,
  classes, libraries) inside a Simulink model with the Python Code block
  (R2025a+). Not for trained neural-network models (.pt, .onnx, .h5) or
  deep-learning inference; use the Deep Learning Toolbox Model Predict blocks
  or network importers. Covers the SymbolSpec API, data-type mapping,
  persistent state, shared interpreter, venvs, and module reloading.
  Triggers: "Python Code block", "Python in Simulink", "integrate Python",
  "call Python from Simulink", "run my Python function/class in a model",
  "add Python to model", "use a Python library in a simulation".
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Python Code Block Reference

Library path: `simulink/User-Defined Functions/Python Code` (R2025a+)

The **Python Code block** is the way to run Python inside a Simulink model. When
a user asks to run a Python function, call a Python class, or use a Python
library each timestep, this block is the tool — they may not name it explicitly.

Use it even when a MATLAB Function block or MATLAB System object calling `py.*`
(`coder.extrinsic`) would produce the same numbers: those cannot build in Rapid
Accelerator or model reference Accelerator mode, and they hide the Python behind
a MATLAB block. The Python Code block works in both modes.

It converts inputs to Python objects, builds a dict keyed by symbol name, calls
`exec()` with that dict as namespace, then converts outputs back to Simulink
types. The interpreter is shared with MATLAB `py.*` — same process, modules, and
state.

- [Environment setup](references/environment.md) — pyenv, venvs, sys.path, module reloading
- [Examples](references/examples.md) — verified programmatic patterns
- [PythonObject patterns](references/pythonobject-patterns.md) — class integration and persistent state

## When to Use

- Running a line or block of Python each timestep inside a Simulink model
- Calling a Python function, class, or third-party library (numpy, scipy, …) from a model
- Persisting a Python object or numeric state across timesteps
- Passing a tunable parameter or a vector/matrix signal into Python
- The user describes the goal ("run my Python code in the model") without naming the block

## When NOT to Use

- Pure MATLAB-side Python calls with no model involved — use `py.*` directly, no block needed
- MATLAB Function blocks or S-Functions — those are different mechanisms
- Running a pretrained deep-learning model (PyTorch/TensorFlow/ONNX) — use the Deep Learning Toolbox *Model Predict* blocks (PyTorch/TensorFlow/ONNX/Custom Python Model Predict), which run via Python co-execution and are configured through the block's model-file tabs, not `SymbolSpec`
- General Simulink model construction unrelated to Python — use the `building-simulink-models` skill

## Workflow

Build the block in this order — **ports do not exist until symbols are
defined**, so wiring comes last. The build takes five tool calls; batch the
operations in each call:

1. **Create and save the model** (`evaluate_matlab_code`) — `model_edit` needs
   an existing model file.
2. **Add and configure all blocks — one `model_edit` call.** Put the code
   parameters (`OutputCode`, `InitializeConditionsCode`, `TerminateCode`,
   `SampleTime`) in `add_block` `params`. The Python Code block is created with
   no ports. The response maps each `ref` to its `blk_N` ID:
   ```json
   [{"op":"add_block","type":"simulink/Sources/Constant","ref":"src","params":{"Value":"3"}},{"op":"add_block","type":"simulink/User-Defined Functions/Python Code","ref":"py","name":"Py","params":{"OutputCode":"y = u * 2.0","SampleTime":"1"}},{"op":"add_block","type":"simulink/Sinks/Out1","ref":"out"}]
   ```
3. **Define symbols — one `evaluate_matlab_code` call; this creates the ports.**
   `SymbolSpec` is a read-only handle reached only through
   `get_param(blk,'SymbolSpec')`, and `model_edit` cannot configure symbols —
   this is the one step that uses `get_param` directly. Call `ss.addSymbol(...)`
   and set each symbol's `Scope`/`Type`/`Size` in place.
4. **Wire — one `model_edit` call** using the returned IDs:
   `[{"op":"connect","target":"blk_1.y1 -> blk_2.u1"},{"op":"connect","target":"blk_2.y1 -> blk_3.u1"}]`
5. **Simulate and read the result — one `evaluate_matlab_code` call.** The
   simulation compiles the block, so it is the verification; skip separate
   inspection calls unless it fails.

The [examples](references/examples.md) give the symbol definitions and code
parameters for common patterns; read them only when the pattern isn't covered
here.

To run the model programmatically and inspect results (sim/parsim,
`Simulink.SimulationInput`, `logsout`), use the `simulating-simulink-models` skill.

## Block Parameters

| Parameter | Type | Notes |
|-----------|------|-------|
| `InitializeConditionsCode` | string | Runs once at simulation start |
| `OutputCode` | string | Runs each timestep |
| `TerminateCode` | string | Runs once at simulation end |
| `SampleTime` | string | Default `"-1"` (inherited) |
| `SymbolSpec` | handle | **Read-only param** — get and mutate in place, never `set_param` back |

**What survives from `InitializeConditionsCode` to `OutputCode`:** only imported
modules (`import m`, `import m as x`, `import pkg.sub`) and `Persistent` symbols.
Everything else in the init namespace is discarded — `from m import f` bindings,
functions, classes, and plain variables (`k = 3`) raise `NameError` in
`OutputCode`. Use the module-qualified form (`import m` → `m.f(...)`), repeat
the `from` import in `OutputCode`, or store objects in a `Persistent` symbol.

## SymbolSpec API

Class: `Simulink.PythonFunctionBlock.SymbolSpec` (handle object).

```matlab
ss = get_param(blk, 'SymbolSpec');
sym = ss.addSymbol('name');   % Returns Symbol — then set properties
sym.Scope = 'Input';
sym.Type  = 'double';
sym.Size  = '1';
got = ss.getSymbol('name');   % Retrieve existing
ss.deleteSymbol('name');      % Remove
```

Handle object: mutations apply immediately to the block.

## Symbol Properties

| Property | Values | Notes |
|----------|--------|-------|
| `Name` | char | Variable name in Python namespace |
| `Scope` | `'Input'` `'Output'` `'Parameter'` `'Persistent'` | |
| `Type` | `'double'` `'single'` `'int8'` `'int16'` `'int32'` `'int64'` `'uint8'` `'uint16'` `'uint32'` `'uint64'` `'boolean'` `'string'` `'Bus: <BusObject>'` `'fixedpoint'` `'PythonObject'` | `PythonObject` only for `Persistent`. Use lowercase `'boolean'` — `'Boolean'` is accepted by the setter but fails at compile ("not in scope"). A bus symbol names a `Simulink.Bus` object in the base workspace |
| `Size` | char | `'1'`, `'3'`, `'[2 3]'`, `'-1'` (inherit) |
| `Label` | char | Port/mask display name |
| `PortNumber` | int | Port ordering |

## Data Type Mapping

| Simulink | Python |
|----------|--------|
| scalar double | `float` |
| vector/matrix double | `numpy.ndarray` if numpy is available, else `array.array`. Shape follows `Size` (`'[2 3]'` ↔ `(2, 3)`); element `(i,j)` in MATLAB is `[i-1, j-1]` in Python — no transpose |
| `string` | `str` (output `str` becomes a MATLAB `string`). A root Inport fed from the workspace needs `Interpolate` off |
| bus (input) | `dict` keyed by element name — `u["a"]` |
| scalar integer | `int` |
| vector integer | `numpy.ndarray` if numpy is available, else `array.array` |
| `PythonObject` (Persistent) | any Python object |

## Limitations

- No variable-size signals or array of buses
- No continuous sample time with persistent variables
- No Dataflow Subsystems
- No rapid accelerator in For Each Subsystems
- No backward stepping with persistent variables
- Code generation supported (Python C API) — requires dev headers + interpreter linkage

----

Copyright 2026 The MathWorks, Inc.

----
