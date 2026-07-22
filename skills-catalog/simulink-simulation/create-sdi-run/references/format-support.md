# File Format Support in SDI

What the built-in `Simulink.sdi.createRun(...,"file",...)` reader handles vs. what needs a toolbox or a conversion step. Verified against R2023a and R2026a documentation.

## Native reader — no extra toolbox

| Format | Extensions | Notes |
|---|---|---|
| MAT | `.mat` | Any variable SDI understands: `timeseries`, `timetable`, `Simulink.SimulationData.Dataset`, logsout, legacy struct-with-time. |
| CSV | `.csv` | Time column **must be named `time`** (case-insensitive). See [createrun-signatures.md](createrun-signatures.md) gotcha and the CSV fallback pattern in SKILL.md. |
| Microsoft Excel | `.xlsx`, `.xls` | Reader returns a `1xN int32` vector — one run per sheet. Restrict with `sheets=[...]`. |

## Needs a specific toolbox

| Format | Extensions | Toolbox | Notes |
|---|---|---|---|
| MDF | `.mdf`, `.mf4`, `.mf3`, `.data`, `.dat` | Vehicle Network Toolbox (native SDI reader ships in R2023a+; toolbox provides `mdfDatastore` for larger workflows) | This skill does not carry MDF examples — trial data was not available in the source assessment. Users with `.mf4` and the toolbox can still use `createRun(...,"file",path)`. |
| ULG (PX4 flight logs) | `.ulg` | UAV Toolbox | Reader added after R2023a. |
| ROS bag | `.bag`, `.db3` | ROS Toolbox | Reader added after R2023a. Convert to `timetable` via toolbox APIs if not available. |

## No native reader — needs conversion

| Format | Extensions | Approach |
|---|---|---|
| CAN log | `.blf`, `.asc` | Vehicle Network Toolbox: `blfread` / `canMessageImport`, then build a `timetable` and use `'vars'`. |
| HDF5 | `.h5`, `.hdf5` | `h5read` + build a `timetable` (or `timeseries`), then use `'vars'`. |
| JSON, plain text logs | anything | Parse to a `timetable` and use `'vars'`. |

## Rule of thumb

- If the extension is `.mat`, `.csv`, `.xlsx`, or `.xls` — try the `'file'` source first.
- If the extension is something else — check `io.reader.getSupportedReadersForFile(path)` before writing conversion code. If it returns only `"built-in"` for a truly unsupported format, or is empty, fall back to a workspace-variable import.
- Never invent readers or extensions. If unsure, tell the user which toolbox handles the format and stop.

----

Copyright 2026 The MathWorks, Inc.

----
