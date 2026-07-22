# `Simulink.sdi.createRun` Signatures

The four sources, side by side. All available from R2011b; return values verified on R2023a and R2026a.

## Signature table

| Source | Signature | Return value | When to use |
|---|---|---|---|
| Empty | `runID = Simulink.sdi.createRun(name)` | scalar `int32` | Only when you plan to add signals one-by-one with `runObj.add`. Rare. |
| `'file'` | `runIDs = Simulink.sdi.createRun(name,"file",path)` | scalar `int32` for MAT/CSV; `1xN int32` for N-sheet Excel | Data lives in `.mat`, `.csv`, or `.xlsx`. First choice for file inputs. |
| `'vars'` | `runID = Simulink.sdi.createRun(name,"vars",var1,var2,...)` | scalar `int32` | Workspace variables already have the names you want (via `.Name` for `timeseries`, column names for `timetable`, or Dataset element names). |
| `'namevalue'` | `runID = Simulink.sdi.createRun(name,"namevalue",names,values)` | scalar `int32` | Bare arrays or unnamed data needing explicit signal names. See caveat below. |

## Name-value options for `'file'`

| Option | Applies to | Purpose |
|---|---|---|
| `reader=name` | Any format with a custom reader registered | Pick a specific reader (e.g., a custom `io.reader` class). List candidates with `io.reader.getSupportedReadersForFile(path)`. |
| `sheets=names` | Excel only | Restrict import to named sheets; return vector is trimmed accordingly. |
| `model=name` | Any format that references user-defined data types | Point the reader at a model that defines needed bus types. |

## Extra return values

Signature form (not runnable — `___` stands in for any valid argument list from the table above):

```
[runID, runIndex, sigIDs] = Simulink.sdi.createRun(___)
```

- `runIndex` — position of the new run in the SDI run list (1-based).
- `sigIDs` — signal IDs for every signal imported. Handy for programmatic plot configuration.

Concrete example:

```matlab
% TEMPLATE — not executable
[runID, runIndex, sigIDs] = Simulink.sdi.createRun("bench","file","data/bench_run.csv");
```

## Gotchas

- **`'namevalue'` and `timeseries.Name`.** When a value is a `timeseries` with `.Name` set, `.Name` overrides the corresponding entry in `names`. Set `ts.Name` first and use `'vars'` if you want the caller's name to win.
- **CSV time-column header.** SDI's built-in CSV reader requires the time column to be named `time` (case-insensitive). Any other header — `time_s`, `t`, `Timestamp`, `Time (s)` — causes `SDI:sdi:ImportError`. Fall back to `readtable` + `table2timetable` + `'vars'`.
- **Excel return type.** Even for a single-sheet workbook, `createRun(...,"file",xlsx)` returns an `int32` — of size 1 for one sheet, `1xN` for N sheets. Treat the return as a vector.
- **Excel run names.** Every run returned from a single `createRun(...,"file",xlsx)` call inherits the **base `name`** you passed — they are not auto-renamed per sheet. To label each run by its sheet, rename in place with `Simulink.sdi.getRun(runIDs(k)).Name = sheets(k)`. Do not `deleteRun` and re-import per sheet — that violates the one-call `'file'` convention.
- **`timetable` value passed to `'namevalue'`.** Warned "not supported" and returns a value that crashes `getRun`. Pass `timetable` values via `'vars'` instead.

----

Copyright 2026 The MathWorks, Inc.

----
