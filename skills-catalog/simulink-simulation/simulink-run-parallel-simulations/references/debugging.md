# Debugging Parallel Simulations

- Use `out(k).SimulationMetadata.TimingInfo` to profile individual runs when investigating slow simulations.
- Check worker diary via `out(k).SimulationMetadata.ExecutionInfo.Diary` for errors that occurred on parallel workers.
- If models or files are not found on workers, check dependency management options in `help parsim`.
- If simulations are slow to initialize, consider `UseFastRestart` for tunable-only sweeps.
- **Memory**: estimate per-run output size (logged signals × time steps × runs) up front. If it is large, use `postSimFcn` to return only the required metrics — otherwise the campaign can exhaust memory. Do not wait for an out-of-memory failure.
- If you encounter stale build artifact errors (slprj version mismatch, .slxc cache errors), delete both `slprj/` and `*.slxc` files in the project directory.
- If referenced models have config parameter mismatches, inform the user and suggest using `setModelParameter` on `SimulationInput` to align settings non-destructively rather than modifying the model.

----

Copyright 2026 The MathWorks, Inc.

----
