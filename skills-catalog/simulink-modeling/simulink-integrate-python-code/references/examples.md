# Programmatic Examples

Add, configure, and wire the block with `model_edit`. The MATLAB below covers
only what `model_edit` cannot reach: defining symbols on the read-only
`SymbolSpec` handle, which creates the ports. `blk` is the block path.

## Basic: Scalar Input/Output

Symbols (`get_param` handle, mutate in place):

```matlab
ss = get_param(blk, 'SymbolSpec');   % Read-only handle — never set_param back

sym_u = ss.addSymbol('u');
sym_u.Scope = 'Input'; sym_u.Type = 'double'; sym_u.Size = '1';

sym_y = ss.addSymbol('y');
sym_y.Scope = 'Output'; sym_y.Type = 'double'; sym_y.Size = '1';
```

Configure via `model_edit`: `OutputCode = 'y = u * 2.0'`, `SampleTime = '0.1'`.

## Persistent Numeric State (Accumulator)

Symbols:

```matlab
sym_acc = ss.addSymbol('acc');
sym_acc.Scope = 'Persistent'; sym_acc.Type = 'double'; sym_acc.Size = '1';
```

Configure via `model_edit`: `InitializeConditionsCode = 'acc = 0.0'` (runs once),
`OutputCode = sprintf('acc = acc + u\ny = acc')` (the recurrence). Init in
`InitializeConditionsCode`, never `OutputCode`, or state resets each step.

## Parameter Scope + Python Imports

Symbols:

```matlab
sym_gain = ss.addSymbol('gain');
sym_gain.Scope = 'Parameter'; sym_gain.Type = 'double'; sym_gain.Size = '1';
```

Configure via `model_edit`: the `gain` mask value `'3'`,
`InitializeConditionsCode = 'import math'`,
`OutputCode = 'y = math.sqrt(u) * gain'`. `gain` is retunable through a `model_edit`
configure op on the mask value without editing the Python.

## Vector Signals

Symbols:

```matlab
sym_v = ss.addSymbol('vec_in');
sym_v.Scope = 'Input'; sym_v.Type = 'double'; sym_v.Size = '3';

sym_out = ss.addSymbol('vec_out');
sym_out.Scope = 'Output'; sym_out.Type = 'double'; sym_out.Size = '3';
```

Configure via `model_edit`:
`OutputCode = sprintf('import numpy as np\nvec_out = list(np.array(vec_in) * 2)')`.

Vectors arrive as `numpy.ndarray` if numpy is available, else `array.array`.

## PythonObject Persistent — External System

Symbols:

```matlab
sym_sys = ss.addSymbol('system');
sym_sys.Scope = 'Persistent'; sym_sys.Type = 'PythonObject'; sym_sys.Size = '1';
```

Configure via `model_edit`:
`InitializeConditionsCode = sprintf('from my_package import MySystem\nsystem = MySystem(dt=0.01)')`
(construct the instance once), `OutputCode = sprintf('result = system.step(u)\ny = result.output')`
(step it each timestep). `system` persists because it is a `Persistent` symbol;
`MySystem` does not, so it is only usable in init. Put `my_package` on
`sys.path` with a model `InitFcn` callback (see `environment.md`).

## Source Block (No Inputs) — Python Generator

Symbols (output only):

```matlab
sym_y = ss.addSymbol('y');
sym_y.Scope = 'Output'; sym_y.Type = 'double'; sym_y.Size = '1';
sym_g = ss.addSymbol('gen');
sym_g.Scope = 'Persistent'; sym_g.Type = 'PythonObject'; sym_g.Size = '1';
```

Configure via `model_edit`:
`InitializeConditionsCode = sprintf('import my_signals\ngen = my_signals.staircase()')`,
`OutputCode = 'y = next(gen)'`, and an explicit discrete `SampleTime` such as
`'0.5'`. With no inputs, the default `'-1'` resolves to continuous, which the
block rejects when it has persistent variables.

## Multiple Ports

Symbols (use `PortNumber` to order the input ports):

```matlab
sym_a = ss.addSymbol('sensor_a');
sym_a.Scope = 'Input'; sym_a.Type = 'double'; sym_a.Size = '1'; sym_a.PortNumber = 1;

sym_b = ss.addSymbol('sensor_b');
sym_b.Scope = 'Input'; sym_b.Type = 'double'; sym_b.Size = '1'; sym_b.PortNumber = 2;

sym_out = ss.addSymbol('fused');
sym_out.Scope = 'Output'; sym_out.Type = 'double'; sym_out.Size = '1';
```

Configure via `model_edit`: `OutputCode = 'fused = (sensor_a + sensor_b) / 2.0'`.

## Query and Remove Symbols

```matlab
sym = ss.getSymbol('u');
ss.deleteSymbol('u');
```

----

Copyright 2026 The MathWorks, Inc.

----
