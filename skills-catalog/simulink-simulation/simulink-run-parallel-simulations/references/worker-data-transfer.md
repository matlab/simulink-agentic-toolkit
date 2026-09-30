# Getting Data and Dependencies to Workers

Workers do not inherit the client base workspace.

- **Dependencies (referenced models, data files the model points to)** transfer automatically — `ManageDependencies` is `"on"` by default. Files that dependency analysis can't detect (e.g. 3rd party files used by the model) must be listed explicitly in `AttachedFiles`.
- **Model initialization that occurs at load time requires no `SetupFcn`.** When a model defines its parameters through a `PreLoadFcn`, a linked data dictionary, or the model workspace, that initialization is applied on each worker when `parsim` loads the model. Do not add a `SetupFcn` to repeat it, and do not reconstruct the initialization on the client.
- **Use a `SetupFcn` only for initialization that does not occur at load time** — for example, a script the user runs manually when there is no `PreLoadFcn`. The `SetupFcn` executes once per worker. Determine which case applies during discovery. Pass a named function handle, and when the initialization is a script, invoke it with `evalin('base', ...)` so its variables are defined in the worker base workspace.
- Use `setVariable` only for values that vary across runs (see "Setting parameters" in SKILL.md); it is not a substitute for model initialization.

## Reproducibility

For Monte Carlo / random sampling, generate the random values on the client with an explicitly seeded stream at `SimulationInput` construction time, and record the seed — so the exact campaign can be re-run later. Reproducibility comes from the recorded seed regenerating the same values, not from worker RNG state.

```matlab
seed = 42;                                  % record this
s = RandStream('twister', 'Seed', seed);    % or: rng(seed)
vals = rand(s, 1, N);                        % drawn on the client, into the SimulationInput array
```

----

Copyright 2026 The MathWorks, Inc.

----
