---
name: simulink-configure-real-time-target
description: Manage Simulink Real-Time target computers from MATLAB — list available targets, check whether a target is connected, read its lifecycle status, add/remove/rename targets, set IP addresses and credentials, choose the default target, install TLS material, configure a startup application, and run target lifecycle ops (connect, reboot, RTOS update). Use whenever the user asks "which targets are available", "is my target connected", "what's the status of the target", "add a Speedgoat", "switch default target", "change the target IP", "reboot the box", "update the target", or works with `slrealtime.Targets`, `tg = slrealtime`, `addTarget`, `removeTarget`, `getTargetNames`, `getDefaultTargetName`, `setDefaultTargetName`, `connect`, `isConnected`, `status(tg)`, `setipaddr`, `setupTLSCertificate`, `setStartupApp`, `reboot`, `update`, or `slrealtime.testSetup`. Covers Speedgoat target computers and Simulink Real-Time Linux devices.
license: https://www.mathworks.com/content/dam/mathworks/license/pmrl/license.md
metadata:
  author: MathWorks
  version: "1.0"
---

# Configuring Simulink Real-Time Targets

Manage **target computer definitions** for Simulink Real-Time — the development-computer
records that name a target and store its IP and credentials — plus the ops that act on the
target computer itself (connect, reboot, RTOS update, startup app).

> **Release compatibility:** Designed and validated for MATLAB R2026a and later. Not
> recommended for earlier releases: APIs, system target files, and workflows differ.

## When to Use

- Adding, removing, or switching target computer definitions, and selecting the default (`slrealtime.Targets`, `setDefaultTargetName`)
- Setting target IP, ports, or credentials (`TargetSettings`, `setipaddr`), or target-side runtime options (`TargetOptions`, `setupTLSCertificate`)
- Connecting and verifying a target, and reading its lifecycle state (`connect`, `isConnected`, `status`, `slrealtime.testSetup`)
- Target lifecycle ops: autostart on boot (`setStartupApp`), RTOS image update (`update`), reboot (`reboot`)

## When NOT to Use

If the task crosses one of these lines, **STOP and load the named skill first** before writing any code, then come back.

- **Model configuration** — system target file, fixed-step solver, Simulink Real-Time options → `simulink-configure-real-time-model`.
- **Application build, run, and tuning** — `slbuild`, `load(tg, app)`, `start`, `stop`, `tg.Stimulation`, `setStopTime`, `getparam`, `setparam`, `getsignal`, runtime parameters, recording, file logs, live streaming → `simulink-run-real-time-application`.
- **Signal capture** — `slrealtime.Instrument`, `addForFileLog`, `addForSDI`, `addForMATLAB` → `simulink-instrument-real-time-application`.
- **Model-level tests** — Gherkin `.feature` files, `model_test` → `testing-simulink-models`. `slrealtime.testSetup` here is a connectivity check, not a model test.
- **I/O networks on the target** (CAN, EtherCAT) — application-level.

## Prerequisites

- MATLAB **R2026a or newer**, with Simulink Real-Time installed (`ver` lists "Simulink Real-Time")
- The support package for the hardware: **Speedgoat** → Speedgoat Add-On; **Linux x86-64** → Embedded Coder Support Package for Real-Time Linux (requires Embedded Coder). Missing Speedgoat tooling mimics a network fault; probe with `which("speedgoat.version")`, not `exist` (`references/network-setup.md`).
- Target powered on and reachable for any operation requiring `connect(tg)` — see `references/persistent-side-effects.md` for the connect-required catalogue

## Workflow

| Step | Purpose | Asks first? |
| --- | --- | --- |
| 1. Inventory and status | List targets, default, connection and lifecycle state | No (read-only) |
| 2. Read target-side options | Show live `TargetOptions` before any change | No (read-only) |
| 3. Add a target | Register a new target from user-supplied name and IP | Yes |
| 4. Set the default | Change which target `slrealtime` binds to | Yes |
| 5. Update settings | Change credentials, ports, or host-side address | Yes |
| 6. Target-side options | HTTPS/TLS and ports | Yes |
| 7. Connect and verify | `connect`, `status`, `slrealtime.testSetup` | No |
| 8. Target-side operations | `setipaddr`, TLS, startup app, `update`, `reboot` | Yes |
| 9. Remove a target | Delete a target record | Yes |

**Use only the documented forms** in `references/api-reference.md` (every call this skill
makes, plus `status(tg)` return values) and the examples below. Dot-form and function-form
are equivalent (`connect(tg)` = `tg.connect()`). Copy-ready starting points:
`references/quick-start-patterns.md`.

**There is no in-place mutation API for `TargetSettings`.** To change name/address/credentials/ports, the only path is `disconnect → removeTarget → addTarget` (Step 5). Do not invent `setTargetSettings`, `updateTarget`, `tg.TargetSettings.address = ...`, etc. — those will not persist.

**A target name is NOT its address.** An existing name (e.g. `TargetPC1`) may point at a completely different IP than the one the user gave you. Before connecting to a target the user identified by IP, you **MUST** read `slrealtime("<name>").TargetSettings.address` and confirm it equals the user's IP. On a mismatch, STOP and ask — never connect on the assumption they are the same; a mismatched connect just burns a ~120 s ping timeout. See Step 3.

### 1. Inventory and Status (read-only)

Read which targets exist, the default, and target state, changing nothing. Covers *"which
targets are available"*, *"is my target connected"*, *"what's the status of the target"*.
Do not invent `tg.getTargets`, `tg.connectionStatus`, or similar.

```matlab
my_tgs      = slrealtime.Targets();
defaultName = getDefaultTargetName(my_tgs);
allNames    = getTargetNames(my_tgs);          % every registered target, by name

ts          = slrealtime("lab-rig-3").TargetSettings;   % one target: name, address, ports, username
allSettings = getTargetSettings(my_tgs);       % array of TargetSettings, one per target

tg = slrealtime("lab-rig-3");
connect(tg);
disp(isConnected(tg));          % true/false — NOT tg.isconnected, NOT tg.connectionState
[state, appName] = status(tg);  % 'stopped' | 'loaded' | 'running' | ... (references/api-reference.md)
```

`isConnected(tg)` answers "is it connected"; `status(tg)` answers "what's the status". Use
both, and do not invent `tg.status` as a property — it is the **function** `status(tg)`
(dot-form `tg.status()` also works). Only `status(tg)` needs a connection, and it
auto-connects.

If the user did not specify a target, operations proceed against the default. Surface the
default name and IP before any destructive op so the user can correct an unintended binding.

### 2. Read Live Target-Side Options Before Changing Them

On a connected target, `opts = tg.TargetOptions;` returns the live options (REST port, HTTPS
toggle, TLS material, netrc flag). If the user asks you to "fix" something, read and present
the current values first — they may have intended a different change.

### 3. Add a New Target

**REQUIRED USER INPUT — never a best-guess operation.** Before constructing
`TargetSettings` you **MUST** have the user supply:

1. **`name`** — **never invent a name** like `"lab-rig-3"`, `"newTarget"`, `"target1"`, or
   any placeholder. If the user did not give one, stop and ask.
2. **`address`** — the target computer's IP. **Never guess**; a wrong IP can collide with
   another machine. If the user did not give one, stop and ask.
3. **`username`, `userPassword`, `rootPassword`** — Speedgoat factory defaults are `slrt` /
   `slrt` / `root`; otherwise prompt.

Show the full proposed `TargetSettings` and **wait for confirmation** before calling
`addTarget`. Confirmed factory defaults may be shown plainly; mask user-specific secrets.

**Construct `TargetSettings` in a single call, passing every field as a name-value
argument** — the only supported form. `name` and `address` must be constructor arguments,
never assignments on a pre-built object.

```matlab
ts = slrealtime.TargetSettings( ...
    "name",         userProvidedName, ...
    "address",      userProvidedAddress, ...
    "sshPort",      22, ...
    "xcpPort",      5555, ...
    "username",     userProvidedUser, ...
    "userPassword", userPwd, ...
    "rootPassword", rootPwd);

addTarget(my_tgs, ts);
```

Refuse two anti-patterns, because neither persists: default-constructing
`slrealtime.TargetSettings` and then assigning `ts.name` / `ts.address` (or mutating a copy
of an existing settings object); and describing the settings in prose without calling the
constructor. After confirmation, actually **execute** the constructor and `addTarget` — the
proposed-settings summary is the confirmation step, not a substitute for running the code.
Field reference: `references/target-settings-schema.md`.

**If the intended name is already registered** (or `addTarget` fails on a duplicate), do
**not** assume the existing target is what the user wants and do **not** connect blindly:

```matlab
existing = slrealtime("TargetPC1").TargetSettings;
disp(existing.address);   % compare to the address the user gave you
```

- **Addresses match** → already configured; skip `addTarget` and proceed.
- **Addresses differ** → surface both and ask: update this target's address (Step 5, or
  `setipaddr` in Step 8) or use a different name.

### 4. Set or Change the Default Target (Ask First — explicit confirmation required)

**The default target is sticky and silent.** It persists across MATLAB sessions, and every
future `tg = slrealtime` (no name argument), in every user script, binds to it.

**You MUST NOT call `setDefaultTargetName` unless the user explicitly asked to change the
default.** Adding a target does **not** imply "make it the default." After `addTarget`, ask:
*"Do you want me to set `<name>` as the default target? Your current default is
`<currentDefault>`."*

```matlab
% Only after explicit confirmation that this target should become the new default:
setDefaultTargetName(my_tgs, userConfirmedName);
```

### 5. Update Credentials, Ports, or Address

There is no in-place mutation API: disconnect, remove, and re-add.

```matlab
disconnect(tg);
removeTarget(my_tgs, "lab-rig-3");
addTarget(my_tgs, newTs);
```

**The existing `tg` is now stale — never read the change back through it.** A `Target`
captures its `TargetSettings` at construction time. Clear it and verify through a **fresh**
construction — no connection needed:

```matlab
clear tg
ts = slrealtime("lab-rig-3").TargetSettings;
fprintf("%s @ %s  user %s\n", ts.name, ts.address, ts.username);
```

`connect` again only as a separate, deliberate step — never as part of the verification.

If only the **target IP** is changing and the target is reachable, prefer `setipaddr`
(Step 8) — it reconfigures the NIC and updates the host-side record. Use remove+add when the
IP changed outside MATLAB and you only need to refresh the host record.

### 6. Configure Target-Side Options

Write target-side options through dedicated APIs, not by editing the env file: HTTPS / TLS
goes through `setupTLSCertificate` (Step 8). The XCP and REST API ports have no programmatic
API in R2026a — use Simulink Real-Time Explorer → Target Properties. Schema:
`references/target-settings-schema.md`.

### 7. Connect and Verify

```matlab
tg = slrealtime;
connect(tg);
assert(isConnected(tg), "Failed to connect to %s", tg.TargetSettings.name);
[state, appName] = status(tg);
```

Call `status(tg)` before any op that needs to know whether an app is loaded or running.
`'targetError'` indicates a target-side fault; see `references/network-setup.md` and consider
`slrealtime.getCrashStack`.

`slrealtime.testSetup(tg);` is the confidence test — ping, SSH, FTP, MQTT, REST, and a basic
build/load/run cycle. On failure see `references/network-setup.md`; the usual cause is
Windows firewall classification (Public vs. Private).

### 8. Target-Side Operations (Ask First)

`setipaddr`, `setupTLSCertificate`, `setStartupApp`, `update`, and `reboot` mutate state on the
target computer itself. For each: state the side effect, **show the exact call** (not a prose
description), and hold for confirmation. The side effect of each op is in the **Ask first**
list under Guardrails; the summary table and full procedures are in
`references/target-side-operations.md`.

### 9. Remove a Target (Ask First — explicit confirmation required)

**You MUST NOT remove a target unless the user has named the exact target to remove.** Do
not "clean up", do not "remove the old one", do not pick from the list yourself. Removing a
target deletes its credentials and IP record from MATLAB Settings — there is no undo. If the
named target **is the current default**, removing it auto-promotes some other target to
default, chosen by `slrealtime.Targets` rather than by the user.

Before calling `removeTarget`:

1. Confirm the user named a specific target (echo the name back).
2. Read `getDefaultTargetName(my_tgs)` and surface whether the named target is the default.
3. If it is, say so **before** removing, along with what the next default will be (or that you
   cannot tell without removing), and ask the user to confirm or set a different default
   first.

```matlab
disconnect(tg);
removeTarget(my_tgs, userConfirmedName);
```

The target must be disconnected, and the only target cannot be removed. If the removed target
was default, surface the newly auto-promoted default.

## Verification

After any change, read state back and confirm it landed — see the "Verify after any change"
pattern in `references/quick-start-patterns.md`.

## Guardrails

Always:

- Read current settings (`getTargetSettings`, `tg.TargetOptions`) before changing them.
- When the user identifies a target by IP, read that name's on-record `.TargetSettings.address` and confirm it matches **before** `connect`; on a mismatch, stop and ask (see "A target name is NOT its address").
- Verify the default (`getDefaultTargetName`) before target-binding ops with no explicit name.
- Confirm `isConnected(tg)` before any method that needs a live connection (`references/persistent-side-effects.md`).
- **Never `connect` while an Ask-First op awaits confirmation** — it acts before consent, and an unreachable target burns a multi-minute timeout before you can even ask.
- **If the user says connecting already failed, diagnose from the host record** — `slrealtime("<name>").TargetSettings` is host-side; do not re-run the failing `connect`.
- Surface the side effect in plain language for any op in `references/persistent-side-effects.md` before calling it.
- Capture the returned `tg` from `setipaddr` — the prior one is stale. It also updates the persistent host-side `TargetSettings.address`, so no `removeTarget`/`addTarget` follow-up is needed.
- `clear tg` after a `removeTarget` + `addTarget` settings change, and never read the change back through the pre-change object — it is a construction-time snapshot. Verify via a fresh `slrealtime(name).TargetSettings` (Step 5).

Ask first:

- **`addTarget` — the user MUST supply `name` and `address`.** Never invent placeholder names (`"lab-rig-3"`, `"target1"`, `"newTarget"`) and never guess IPs. Show the full proposed `TargetSettings`, passwords masked, and wait for explicit confirmation.
- **`setDefaultTargetName` — only when the user explicitly asked to change the default.** `addTarget` does not imply "make it the default." If the user is silent, leave the default alone and ask whether they want to switch.
- **`removeTarget` — only when the user named the exact target.** Do not "clean up" or pick a target yourself. If the named target is the current default, surface that and confirm again.
- **`setipaddr`** — reconfigures the NIC and reboots the target; session disconnects; capture the returned `tg`. The persistent host record updates automatically.
- **`setupTLSCertificate(tg, true, ...)`** — installs SSL material on the target computer; target must be idle (no application loaded).
- **`setStartupApp`** — the app autostarts on every boot, including unattended reboots. It must already be installed — otherwise route to `simulink-run-real-time-application` first.
- **`update(tg)`** — **erases all applications and data from the target computer**; long-running; target reboots; can brick on interruption. Tell the user about the erasure before asking for confirmation.
- **`reboot(tg)`** — disconnects all sessions; running app stops. Show the exact call, then hold for confirmation.

Never:

- **Invent function names, property names, or argument forms absent from `references/api-reference.md`, examples, or reference files.** Refuse: `setTargetSettings`, `tg.updateTarget`, `tg.setIP`, `tg.TargetSettings.address = newAddr` (none persist — use `removeTarget` + `addTarget`, or `setipaddr`); `tg.reconnect()` (use `disconnect` + `connect`); `tg.Status` as a property (it's the function `status(tg)`); `start(tg, ...)` / `stop(tg)` (those belong to `simulink-run-real-time-application`).
- **Invent a target `name` or `address` for `addTarget`** — both come from the user; if absent, stop and ask.
- **Call `removeTarget` on the existing default without explicit confirmation** — being asked to add a target is not permission to delete the default.
- **Call `setDefaultTargetName` as a side effect of `addTarget`.**
- Hard-code credentials in scripts the user keeps — prompt, or read a `.env`-style file they control.
- Call `update(tg)` or `reboot(tg)` on a target the user has not explicitly named — it might be a coworker's shared rig.
- Call `setipaddr` to "fix" a connection problem before checking the firewall and Public-vs-Private network classification (`references/network-setup.md`).
- Use target-shell workarounds to bypass a first-class Simulink Real-Time API — target IP, TLS, startup-app, update, and reboot all have supported APIs.
- Bypass `slrealtime.Targets` to write `setting.matlab.slrealtime.*` directly — `addTarget` validates duplicates and IP collisions; raw setting writes do not.

## Task Routing

| Task | Reference |
| --- | --- |
| Every API form this skill uses; `status(tg)` return values | `references/api-reference.md` |
| Copy-ready patterns for common tasks | `references/quick-start-patterns.md` |
| `setipaddr`, TLS, startup app, `update`, `reboot` — summary table and procedures | `references/target-side-operations.md` |
| `TargetSettings` / `TargetOptions` field reference | `references/target-settings-schema.md` |
| `slrealtime.testSetup` failures, firewall, static IP | `references/network-setup.md` |
| Which methods mutate persistent state, connect-required boundary | `references/persistent-side-effects.md` |
| Model system target file, fixed-step solver, Simulink Real-Time options | `simulink-configure-real-time-model` |
| Build, load, start, stop, tune, read signals, record, stream | `simulink-run-real-time-application` |
| Instrument-specific signal capture workflows | `simulink-instrument-real-time-application` |

----

Copyright 2026 The MathWorks, Inc.

----
