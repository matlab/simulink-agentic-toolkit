# Simulink Real-Time Options Pane

The Simulink Real-Time Options pane appears under Configuration Parameters only after a Simulink
Real-Time system target file is selected. `SKILL.md` carries the authorized parameter names; this file
carries the per-option guidance and the exposure rule.

## Authorized Parameters

| Dialog option                        | Parameter name           | Type    |
|--------------------------------------|--------------------------|---------|
| RTOS system log level                | `SLRTLogLevel`           | enum    |
| Force polling mode                   | `SLRTForcePollingMode`   | boolean |
| Maximum retained file log runs       | `SLRTFileLogMaxRuns`     | int     |
| Build optimization preset            | `BuildConfiguration`     | enum    |
| Compile with GCC `-ffast-math`       | `UseGCCFastMath`         | boolean |

These are the **only** Simulink Real-Time Options parameter names this skill names. For anything else,
inspect the available model parameters before guessing.

## Confirm Exposure Before Writing

Before setting one of these programmatically, verify the parameter is exposed on the active config set by
reading its current value. A parameter the current STF does not expose cannot be written — if the read
fails or the parameter is absent, report the mismatch to the user and confirm the STF is one that exposes
it. Do not attempt the write anyway.

## Per-Option Guidance

**`UseGCCFastMath`** — enable only when the user explicitly requests performance-oriented compilation and
accepts that numerical behavior may differ. `-ffast-math` relaxes IEEE-754: no NaN/Inf checking, and
fused multiply-add reordering. Never enable it by default. See `compiler-options.md`.

**`BuildConfiguration`** — use the product presets (`Faster Runs`, `Faster Builds`, `Debug`, or
`Specify`) instead of editing `CustomToolchainOptions` directly. Read `compiler-options.md` before using
`Specify` or any custom compiler-flag path.

**`SLRTForcePollingMode`** — enable only when the user asks for polling mode or the hardware workflow
requires it. Some configurations enable it automatically; check the readback rather than assuming your
write is what set it.

**`SLRTLogLevel`, `SLRTFileLogMaxRuns`** — inspect and set these only when the user asks about RTOS
logging verbosity or how many file-log runs to retain.

## Do Not Override Target-Managed Settings

Do not manually change target-language, make-command, or toolchain parameters that the selected Simulink
Real-Time target file manages automatically. If they look wrong after the STF is set, treat that as a
configuration-callback or installation problem rather than something to patch by hand. See
`compiler-options.md` for the full list of locked settings.

----

Copyright 2026 The MathWorks, Inc.

----
