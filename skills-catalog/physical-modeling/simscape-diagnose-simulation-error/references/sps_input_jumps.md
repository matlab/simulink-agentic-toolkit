# S-PS input jumps

Finds an S-PS converter input that **steps even though its sample time is
continuous** (`[0 0]`). For example, a Data Store written by a discrete
controller makes the signal jump at the controller's sample times, but the S-PS
input still compiles as `[0 0]`. Use it for a mid-simulation failure when the
compiled sample times (Discontinuous Inputs path, Step 3) don't explain it.

`simscape.agentic.spsInputJumps` turns on signal logging at each S-PS input,
re-runs the simulation to `tFail + window`, and returns the largest one-step
jump of each input shortly before the failure. It restores the logging settings
afterwards.

> **It re-runs the simulation up to the failure.** This takes about as long as
> the failing run.

```matlab
% TEMPLATE — not executable
tFail = <failure time from the error message>;
[result, simError] = simscape.agentic.spsInputJumps(modelName, tFail);
```

An optional third argument, `window`, sets how many seconds before `tFail` to
search (default 1). A few controller sample periods is usually enough.

`result` has one row per S-PS converter:

| Column  | Meaning                                                              |
|---------|----------------------------------------------------------------------|
| `Block` | S-PS converter                                                       |
| `Unit`  | input unit of the converter                                          |
| `Jump`  | largest change between two consecutive samples in `[tFail - window, tFail]` |
| `Time`  | time of the sample after that change                                 |
| `Range` | max minus min of the input over the same interval                    |

`simError` holds the simulation error message (`""` if the run reached
`tFail + window` without an error).

## Reading the output

Look for a jump in one sample that is large for what the signal represents,
just before `tFail`. A `Jump` that is a sizable fraction of `Range` means the
input steps rather than varies smoothly. That input is the likely cause: trace
it upstream to the block that makes it step (e.g. a Data Store written by a
discrete controller), smooth it (Steps 4–5), and re-run.

----

Copyright 2026 The MathWorks, Inc.

----
