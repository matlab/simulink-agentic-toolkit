# STF (System Target File) by Target

The Simulink Real-Time TLC name is **support-package–driven**. There is no single canonical TLC. Each support package overrides the `getSTFName(tg)` method on the `TargetImpl` class to return its own STF.

**Always prefer `getSTFName(tg)` or `tg.configureModelForTargetPlatform(model)`.** This table is the fallback for the disconnected workflow only — when no target is reachable.

## Lookup Table

| Hardware / workflow                    | Support package      | STF returned by `getSTFName(tg)` |
| -------------------------------------- | -------------------- | -------------------------------- |
| Most Speedgoat target computers       | Speedgoat Add-On     | `speedgoat.tlc`                  |
| Speedgoat Pulse                        | Speedgoat Add-On     | `speedgoat_aarch64.tlc`          |
| Linux x86-64, slrtlinux                | Embedded Coder Support Package for Real-Time Linux | `slrtlinux_x64.tlc` |


## How `getSTFName` Resolves at Runtime

`tg = slrealtime` returns a `slrealtime.Target` object whose `TargetImpl` is chosen by which support package is installed:

- **Most Speedgoat target computers** with the Speedgoat Add-On installed → returns `speedgoat.tlc`.
- **Speedgoat Pulse** with the Speedgoat Add-On installed → returns `speedgoat_aarch64.tlc`.
- **slrtlinux installed, Linux x86-64 target** → returns `slrtlinux_x64.tlc`.


Calling `getSTFName(tg)` runs the right override automatically. That is why this skill avoids hard-coding the STF — the same MATLAB call returns a different string on a Speedgoat-equipped install vs. a base install.

## Disconnected Workflow

If `connect(tg)` fails or no Target is reachable, see `disconnected-workflow.md`. Do not guess the STF — ask the user which support package is installed and look it up in the table above.

----

Copyright 2026 The MathWorks, Inc.

----
