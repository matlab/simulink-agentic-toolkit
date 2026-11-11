# PythonObject Patterns

## Integrating External Systems and Classes

Primary use case: instantiate a Python class or library object in Start, persist
it as `PythonObject`, call methods each timestep in Output.

1. Define a `Persistent` symbol with `Type = 'PythonObject'`
2. `InitializeConditionsCode`: import and instantiate
3. `OutputCode`: call `.step()`, `.update()`, etc.
4. `TerminateCode`: clean up if needed

Only the `Persistent` instance and imported modules reach `OutputCode` — names
from `from m import X` are init-only, so call methods on the instance.

**External system (battery model, physics sim, controller, etc.):**
```python
# Start
from my_package import MySystem
system = MySystem(dt=0.01, param_a=9.81)
```
```python
# Output
result = system.step(input_signal)
y = result.output_value
```

**Third-party library (e.g., PyBaMM battery simulation):** `sim` is a
`Persistent` `PythonObject`, `dt` a `Parameter`. PyBaMM only accepts `inputs=`
for parameters set to `"[input]"`.
```python
# Start
import pybamm
model = pybamm.lithium_ion.SPMe()
params = model.default_parameter_values
params["Current function [A]"] = "[input]"
sim = pybamm.Simulation(model, parameter_values=params)
```
```python
# Output
sim.step(dt=dt, inputs={"Current function [A]": current_in})
voltage_out = float(sim.solution["Voltage [V]"].entries[-1])
```

## General-Purpose Persistent State

`PythonObject` stores any Python object across timesteps — not limited to classes.
Useful when data does not map to Simulink numeric types.

**Config dict** — pack many parameters into one symbol:
```python
# Start
config = {'alpha': 0.5, 'beta': 0.3, 'threshold': 100, 'mode': 'fast'}
```
```python
# Output
y = x * config['alpha'] + config['beta']
```

**Rolling window:**
```python
# Start
from collections import deque
history = deque(maxlen=100)
```
```python
# Output
history.append(sensor_val)
y = sum(history) / len(history)
```

Other examples: compiled regexes, database connections, caches, protocol buffers,
accumulators — anything you would store in a Python variable.

----

Copyright 2026 The MathWorks, Inc.

----
