# Python Environment

## Shared Interpreter

The Python Code block and MATLAB `py.*` share the same interpreter (InProcess).
Modules, globals, and state are visible from both sides. `pyenv` applies to both.

## pyenv Configuration

```matlab
pyenv                                          % Check current config
pyenv(Version="/usr/bin/python3.11")           % Set interpreter path
pyenv(ExecutionMode="InProcess")               % Required for Python Code block (default)
```

If Python is already loaded InProcess, restart MATLAB to change interpreter.
Check `pyenv` — if `Status` is `Loaded`, restart first.

## Virtual Environments

Preferred over system Python. Point `pyenv` at the venv interpreter:

```matlab
pyenv(Version="/path/to/venv/bin/python")          % Linux/macOS
pyenv(Version="C:/path/to/venv/Scripts/python.exe") % Windows
```

Packages installed in that venv are available to the block automatically.

## sys.path — Making Python Find Your Code

The block resolves imports via `sys.path` and current directory.

**Default: set `sys.path` in a model or library callback** (`InitFcn`,
`PostLoadFcn`). Callbacks keep environment setup out of the algorithm code,
run before any block initializes, and can resolve the path relative to the
model file instead of hardcoding it. Keep `InitializeConditionsCode` limited to
imports and state setup.

Set `sys.path` in block `InitializeConditionsCode` **only when generating
code** — callbacks do not run in generated code, so a codegen target that needs
`sys.path` must get it from the block. This hardcodes the path in the block,
so do not use it for simulation-only models.

Set the callback with a `model_edit` configure op on the model (`InitFcn`) or
library (`PostLoadFcn`); the value is the MATLAB code below.

**Model callback** (`InitFcn` — runs once before simulation):
```matlab
modelDir = fileparts(which(bdroot));
if count(py.sys.path(), modelDir) == 0
    py.sys.path().insert(int32(0), modelDir);
end
```

**Library callback** (`PostLoadFcn` — fires when library is loaded):
```matlab
libDir = fileparts(which(bdroot));
if count(py.sys.path(), libDir) == 0
    py.sys.path().insert(int32(0), libDir);
end
```
`bdroot` inside a library callback returns the library name, so
`fileparts(which(bdroot))` resolves to the library's directory.

**MATLAB side (py.* — shared interpreter carries over to block):**
```matlab
py.sys.path().append('/path/to/my/code');
```

Can also be done in project startup scripts or `startup.m`.

**Block InitializeConditionsCode** (code generation only):
```python
import sys
sys.path.insert(0, '/path/to/my/code')
import mymodule
```

## Module Reloading

Python caches modules after first import. Changed source requires explicit reload.

**From MATLAB** (useful when iterating via MCP):
```matlab
mod = py.importlib.reload(py.importlib.import_module('mymodule'));
```

**In block Start section** (development workaround):
```python
import importlib
import mymodule
mymodule = importlib.reload(mymodule)
```

If still stale, delete `__pycache__` next to the `.py` file.

----

Copyright 2026 The MathWorks, Inc.

----
