# Disconnected Workflow — No Target Reachable
The preferred path is `tg.configureModelForTargetPlatform(model)`, which calls `getSTFName(tg)` against a connected target. When `connect(tg)` fails — no target computer on the network, no support package install yet, hardware powered off — fall back to this workflow. **Do not guess the STF.**

## Step 1 — Confirm Disconnection

```matlab
tg = slrealtime;
try
    connect(tg);
    connected = true;
catch
    connected = false;
end
```

If `connected` is true, abandon this workflow and follow the main Workflow in SKILL.md.

## Step 2 — Ask the User Which Target should be used

Pick exactly one before proceeding. The user must be the source of truth here — the agent cannot detect this from the model alone.

Question to the user: **"Which Simulink Real-Time target should be used?"**

| User answers…                            | Use STF                                                                                                                       |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Most Speedgoat target computers          | `speedgoat.tlc`                                                                                                               |
| Speedgoat Pulse                          | `speedgoat_aarch64.tlc`                                                                                                       |
| slrtlinux, Linux x86-64 target           | `slrtlinux_x64.tlc`                                                                                                           |
| None / not sure                          | Check installed support tools to narrow the candidates, present the narrowed list, and ask the user to pick. Do not write the STF until they do. |
Cross-check with `references/stf-by-target.md` if the user gives a different answer.

If the user identifies the hardware only as Speedgoat, use `speedgoat.tlc` without requiring additional model-specific confirmation. Use `speedgoat_aarch64.tlc` only when the hardware is identified as a Speedgoat Pulse.

**Installed support establishes capability, not intent.** A successful `speedgoat.version`, or the presence of the Speedgoat Add-On in `ver`, tells you the environment *can* build for Speedgoat — it does not tell you the user's hardware *is* Speedgoat. Many installations carry support for hardware the user is not currently targeting.

So when the user is unsure or has not stated their hardware: use the installed-support probe to propose candidates, name them explicitly as proposals, and wait for confirmation before writing `SystemTargetFile`. For example — *"The Speedgoat Add-On is installed and `speedgoat.version` runs, so this environment can build for Speedgoat hardware. Confirm that the target is Speedgoat and I'll use `speedgoat.tlc`; if it is a Speedgoat Pulse, tell me so I can use `speedgoat_aarch64.tlc` instead."* Applying the write first and asking for confirmation afterward does not satisfy this gate; by then the model has already been changed.

If `speedgoat.version` is unavailable or errors, do not propose Speedgoat at all.

## Step 3 — Set the STF and SolverType

**Before writing anything, confirm the support package that provides the Step 2 STF is
installed.** If it is not, stop — go to *Required support package absent* below and do not
make either change here. Writing `SolverType` on its own leaves the model half-configured,
which is worse than leaving it untouched. This check comes first because both writes below
depend on it.

`configureModelForTargetPlatform` is unavailable when disconnected, so make these model configuration changes:

- `SystemTargetFile` — the STF chosen in Step 2.
- `SolverType` — `Fixed-step`.

## Step 4 — Verify the Toolchain Auto-Selected Correctly

Setting `SystemTargetFile` should select the appropriate toolchain and production hardware device type for the target family. Verify `SystemTargetFile`, `SolverType`, `Toolchain`, and `ProdHWDeviceType` after the write.

Expected pairings:

| STF                       | Toolchain                                                | ProdHWDeviceType                    |
|---------------------------|----------------------------------------------------------|-------------------------------------|
| `speedgoat.tlc`           | `Simulink Real-Time Toolchain`                           | `Intel->x86-64 (Linux 64)`          |
| `speedgoat_aarch64.tlc`   | `Simulink Real-Time aarch64 Toolchain`                   | `ARM Compatible->ARM 64-bit (LP64)` |
| `slrtlinux_x64.tlc`       | `Simulink Real-Time Linux x64 Remote Build Toolchain`    | `Intel->x86-64 (Linux 64)`          |

If the readback differs, report this to the user; do not patch the toolchain manually.

## Step 5 — Set FixedStep, Solver, BuildConfiguration

These are not set by the STF callback. Continue with steps 5–7 of the main Workflow in SKILL.md.

## Required support package absent

**Precondition — the user has already named the hardware family.** If they have not, you are still in
Step 2: ask. Do not probe which STFs happen to be installed in order to work out what to write, and do
not attempt a write just to see what the error says. Both amount to choosing the target yourself, which
the Never list forbids, and asking for consent *after* attempting the write does not satisfy the gate.

Once the family is known: if the required support package is not installed on this machine, the
`SystemTargetFile` write cannot succeed. `speedgoat.tlc` and `speedgoat_aarch64.tlc` come from the
Speedgoat Add-On, and `slrtlinux_x64.tlc` from the Embedded Coder Support Package for Real-Time Linux.

**A missing support package ends this workflow.** Without the STF the model cannot be configured for the
target platform, and a config set carrying real-time solver settings but no Simulink Real-Time STF is not
a partial success — it is a model that still has to be configured from scratch once the package arrives.
So stop here: name the exact STF value that belongs to the family the user gave you, name the specific
add-on or support package that provides it and where it comes from (the Speedgoat Add-On ships from
Speedgoat, not through Add-On Explorer), and tell the user to install it and re-run this workflow. Do not
attempt the write, do not apply a partial configuration, and do not save the model.

Do **not** infer the hardware family from which packages happen to be installed; that inference is on
the Never list in SKILL.md. This section applies only once the user has stated the family.

----

Copyright 2026 The MathWorks, Inc.

----
