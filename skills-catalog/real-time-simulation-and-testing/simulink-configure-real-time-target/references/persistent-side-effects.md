# Persistent Side Effects

Most methods in this skill mutate state that survives the MATLAB session — MATLAB Settings on the development computer, files on the target computer, target NIC config, target-side startup config. Before the agent calls one, it must surface the side effect to the user in plain language and get confirmation. This file is the reference catalogue.

## Catalogue

| Method                                      | Side effect                                                                       | Reversible from MATLAB? | Requires `connect(tg)`? | Confirmation required |
|---------------------------------------------|------------------------------------------------------------------------------------|--------------------------|--------------------------|------------------------|
| `addTarget(my_tgs, ts)`                     | Writes target record into MATLAB Settings (`s.slrealtime.targets.<name>.*`)        | Yes — `removeTarget`     | No                       | Show `TargetSettings`; confirm credentials |
| `removeTarget(my_tgs, name)`                | Deletes target record from MATLAB Settings                                         | No (re-add to recreate)  | No (target must be **disconnected**) | Confirm; cannot remove last target |
| `setDefaultTargetName(my_tgs, name)`        | Writes `s.slrealtime.defaultTargetName` in MATLAB Settings                         | Yes                      | No                       | Future `tg = slrealtime` calls bind to a different machine |
| `setipaddr(tg, addr, netmask)`              | Reconfigures target NIC; target reboots; current session disconnects; also updates persistent host-side `TargetSettings.address` | Only by another `setipaddr` | Yes (precondition checked, then `disconnect`) | Long-running; target reboots; capture the returned Target — old `tg` is stale |
| `setupTLSCertificate(tg, true, cert, key)`  | Copies SSL material to target; updates `~/.slrt/TargetOptions.env` SSL paths       | Yes — `setupTLSCertificate(tg, false)` | Yes (target must be **idle** — not loaded) | Installs SSL material on the target |
| `setupTLSCertificate(tg, false)`            | Disables HTTPS; clears SSL paths in env file                                       | Yes — re-enable          | Yes (target idle)        | Confirm                |
| `setStartupApp(tg, appName)`                | Writes target-side startup script so the app autostarts on every boot              | Yes — `clearStartupApp`  | Yes                      | App runs on every reboot, including unattended ones |
| `clearStartupApp(tg)`                       | Removes target-side startup script                                                 | Yes — `setStartupApp`    | Yes                      | Confirm                |
| `update(tg)`                                | **Erases all applications and data from the target** (installed apps, parameter sets, startup app, logged/profiler data); reflashes RTOS image; target reboots; can brick if interrupted | **No — erased data is not recoverable** | Yes (target idle) | **State the erasure first**; long-running; target reboots; do not interrupt |
| `reboot(tg)`                                | Power-cycles the target; running app stops; sessions disconnect                    | N/A (target restarts)    | Yes                      | Disconnects all sessions; running app stops |
| `setTargetTimezone(tg, zone)`               | Writes the target computer's timezone; `setTargetTime(tg, ...)` writes its clock     | Yes — set it back        | Yes                      | Changes target-side config; log timestamps shift. See "Connect-Time Timezone Offer" |

## Connect-required vs. Not

**Do not require `connect(tg)`** (operate on host-side data only):

- All `slrealtime.Targets` collection methods: `addTarget`, `removeTarget`, `getTarget`, `getTargetNames`, `getNumTargets`, `getTargetSettings`, `getDefaultTargetName`, `setDefaultTargetName`.
- Constructing `tg = slrealtime` or `tg = slrealtime('name')`.
- Reading `tg.TargetSettings`.

**Require `connect(tg)`** (touch the target):

- `setipaddr`, `setupTLSCertificate`.
- `setStartupApp`, `getStartupApp`, `clearStartupApp`.
- `update`, `reboot`.
- Reading `tg.TargetOptions` (dependent property — pulls from target's `tc`).
- `slrealtime.testSetup(tg)`.

The agent can verify this boundary cheaply by calling `isConnected(tg)` before any connect-required op.

## Notable Preconditions

- **`removeTarget`** raises `slrealtime:targets:targetMustBeDisconnected` if the target has an active session, and `slrealtime:targets:cannotRemoveLastTarget` if it's the only target. Auto-promotes the next target to default if removing the current default.
- **`setupTLSCertificate`** raises `slrealtime:target:updateTargetNotIdle` if an application is loaded. Stop and unload before calling.
- **`update`** does not lock against a loaded application but the workflow is to stop/unload first; an interrupted update can leave the target in an unbootable state. It also **erases all applications and data from the target computer** — MATLAB's confirmation dialog says "All applications and data will be erased from the target computer." Report that erasure to the user before asking for confirmation; it is the part that cannot be undone.

## Connect-Time Timezone Offer

When the development computer cannot read the target's timezone, Simulink Real-Time warns and
offers a **clickable one-click remedy** in its own message text (R2026a
`resources/slrealtime/en/target.xml`, `getTimezoneError`):

```
Unable to get the target computer timezone: <reason>
Set target computer timezone to 'Universal': [Fix it]
```

The `Fix it` link runs `slrealtime('<name>').setTargetTimezone('Universal')`. A related warning,
`timezoneMismatch`, fires when a supplied timezone differs from the target's: "The timezone
provided (X) does not match the target computer timezone (Y). To change the timezone, use the
`setTargetTimezone` function."

**Treat this exactly like the `update(tg)` link: an offer, not an instruction.**
`setTargetTimezone` is a target-side write with the same standing as any other entry in the
catalogue above — it changes the target computer's configuration and shifts the timestamps on
logged data and profiler output. Do not take the remedy because MATLAB surfaced it:

- Report the warning to the user and name the remedy (`setTargetTimezone(tg, zone)`).
- Ask which timezone they want. `'Universal'` is MATLAB's suggestion, not necessarily the
  user's intent — a rig whose logs are correlated against local wall-clock time may need
  `'America/New_York'`-style zone instead.
- Read the current value with `getTargetTimezone(tg)` first and present it.
- A timezone warning on `connect` is **not** a connection failure. If the user asked only to
  connect or to read status, surface the warning and stop there; do not fix it unasked.

Related read/write methods on `slrealtime.Target` (verified in R2026a): `getTargetTimezone`,
`setTargetTimezone`, `getTargetTime`, `setTargetTime`.

## Host-Side Files Written

Two host-side files can be touched by lifecycle ops:

- **MATLAB Settings** — every `Targets` mutation. Path: `prefdir`/MATLABSettings file (managed by `setting.matlab.slrealtime.*`).
- **`~/.netrc`** on the development computer — the target computer's first connection writes credentials here when `TargetOptions.useNetrc == true`. The user should know this is happening; it affects future SSH from this development computer to this target computer's IP.

## Target-Side Files Written

- `~/.slrt/TargetImpl.json` — read by `tg = slrealtime; connect(tg)`; created on first connect if missing.
- `~/.slrt/TargetOptions.env` — touched by `setupTLSCertificate` and any direct `writeConfigFile` calls.
- Target NIC configuration (distro-specific path) — touched by `setipaddr`.
- `~/startup/start-app.sh` — touched by `setStartupApp` / `clearStartupApp`.

## Operations to Avoid

- **Target-shell command workarounds for first-class Simulink Real-Time APIs** — bypass validation and break across hardware variants. Use `setipaddr`, `setupTLSCertificate`, `setStartupApp`, `update`, or `reboot` instead.
- **Direct writes to `setting.matlab.slrealtime.*`** — `addTarget` validates against duplicates and IP collisions; raw setting writes do not.
- **`update(tg)` over a flaky network** — interruption mid-flash can brick the target. If the connection is intermittent, fix that first. Note that a *healthy* link is not a reason to proceed unprompted: `update` erases all applications and data on the target regardless of link quality, so it still needs explicit confirmation.

----

Copyright 2026 The MathWorks, Inc.

----
