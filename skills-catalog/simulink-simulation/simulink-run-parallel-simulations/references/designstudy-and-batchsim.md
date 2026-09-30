# DesignStudy and batchsim API

See the comparison tables in SKILL.md ("Choosing How to Run") for when to use each. Key API details:

- **`DesignStudy`** — build with `simulink.multisim.DesignStudy(model, combination)`. The combination (`simulink.multisim.Exhaustive` / `simulink.multisim.Sequential`) takes an **array** of parameter objects: `simulink.multisim.Variable` (workspace variables), `simulink.multisim.ModelParameter` (model configuration parameters), `simulink.multisim.BlockParameter` (block dialog parameters), `simulink.multisim.ExternalInput` (top-level input data). `parsim(designStudy)` returns a Future — call `fetchOutputs` to get results. Verify syntax with `help simulink.multisim.DesignStudy`.
- **Fixed model settings go in via `simulink.multisim.ModelParameter`** — put them in the same combination array as the swept `Variable`s. A single-valued `ModelParameter` applies to every run and does not grow the grid. This is how a `DesignStudy` captures root-Outport metrics (`SaveOutput='on'`) without editing the model:

```matlab
combo = simulink.multisim.Exhaustive([ ...
    simulink.multisim.Variable('Kq', kqValues), ...
    simulink.multisim.Variable('Ka', kaValues), ...
    simulink.multisim.ModelParameter('SaveOutput', 'on'), ...
    simulink.multisim.ModelParameter('OutputSaveName', 'yout'), ...
    simulink.multisim.ModelParameter('SaveFormat', 'Dataset')]);
d   = simulink.multisim.DesignStudy(model, combo);
out = fetchOutputs(parsim(d));
```

- **Mapping results to the grid** — a `postSimFcn` on a `DesignStudy` receives `simIn`; use the matching `simIn` accessor (`getVariable`, `getBlockParameter`, `getModelParameter`) to tag each run's metrics with its swept values. See `simulation-callbacks.md`.
- **`batchsim`** — `simjob = batchsim(in)` (or `batchsim(cluster, in)`); retrieve later with `fetchOutputs(simjob)`. Accepts the same `SimulationInput` array or `DesignStudy`. See `help batchsim`.

----

Copyright 2026 The MathWorks, Inc.

----
