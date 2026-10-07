# Target-Side Operations

Full procedures for the five operations that mutate state on the target computer itself.
Every one is **Ask First**: surface the side effect in plain language, show the exact call,
and wait for explicit confirmation before executing. The SKILL.md Guardrails list is the
authoritative summary; this file is the detail.

## Summary

| Op | Call | State the side effect before asking |
| --- | --- | --- |
| Change target IP | `tg = setipaddr(tg, addr, netmask);` | Reconfigures the target NIC; target reboots; session disconnects. **Returns a new Target — capture it**; the old `tg` is stale. Also updates the persistent host-side `TargetSettings.address`, so no remove+add follow-up (SKILL.md Step 5). |
| HTTPS / TLS material | `setupTLSCertificate(tg, true, certPath, keyPath);` / `setupTLSCertificate(tg, false);` | Installs or removes SSL material. Target must be idle — no application loaded. |
| Startup application | `setStartupApp(tg, "myApp");` / `getStartupApp(tg);` / `clearStartupApp(tg);` | The app autostarts on every boot, including unattended power cycles. It must already be installed — otherwise route to `simulink-run-real-time-application` first. |
| RTOS update | `update(tg);` | **Erases all applications and data from the target computer** — state the erasure first; it is what the user cannot undo. Long-running; target reboots; an interrupted update can leave it unbootable. |
| Reboot | `reboot(tg);` | Disconnects all sessions; any running application stops. |

## Change the target IP — `setipaddr`

```matlab
tg = setipaddr(tg, "10.0.0.5", "255.255.255.0");
```

Reconfigures the target NIC; the target computer reboots; the current session disconnects.
**Returns a new Target object — capture it.** The old `tg` is stale after this call.

`setipaddr` updates both the target NIC **and** the persistent host-side
`TargetSettings.address` record in MATLAB Settings. No `removeTarget` + `addTarget` follow-up
is needed — the next `tg = slrealtime("<name>")` binds to the new address. Use the remove+add
pattern (SKILL.md Step 5) only when you did not run `setipaddr` yourself (for example, a
colleague reconfigured the box manually), or when changing `name`, credentials, or ports.

Never reach for `setipaddr` to "fix" a connection problem before checking the Windows
firewall and the Public-vs-Private network classification — see `network-setup.md`.

## Install or remove TLS material — `setupTLSCertificate`

```matlab
setupTLSCertificate(tg, true,  certPath, keyPath);  % enable HTTPS
setupTLSCertificate(tg, false);                     % disable HTTPS
```

Installs or removes SSL material on the target computer. The target computer must be idle —
no application loaded. Read the current values through `tg.TargetOptions` first and present
them; the user may have intended a different change. See `target-settings-schema.md` for the
full `TargetOptions` schema.

## Startup application — `setStartupApp`

```matlab
setStartupApp(tg, "myApp");
disp(getStartupApp(tg));   % verify
clearStartupApp(tg);       % undo
```

`setStartupApp` makes an installed application autostart on every boot, including unattended
power cycles. The application must already be installed on the target computer.

This skill does not build, install, or load applications. If the user requests a startup app
that has not already been built and installed on the target, route to
`simulink-run-real-time-application` first.

## RTOS update — `update`

```matlab
update(tg);
```

`update(tg)` reflashes the RTOS image on the target computer. **It erases all applications
and data from the target computer** — every installed real-time application, stored parameter
set, the configured startup application, and any logged or profiler data. MATLAB's own dialog
says "All applications and data will be erased from the target computer." It is also
long-running, the target computer reboots, and an interrupted update can leave it unbootable.

**State the erasure first** when explaining the operation — it is the part the user cannot
undo; the reboot and the interruption risk are secondary. Anything they need to keep must be
re-installed or re-collected afterwards. Confirm explicitly.

Use `update(tg)` after moving to a new MATLAB release, installing a MATLAB release update, or
upgrading Speedgoat target tooling, so the target RTOS image matches the host-side software
stack. Do not call `update` on an unconfirmed target — it might be a coworker's shared rig,
and the call will silently re-image it.

## Reboot — `reboot`

```matlab
reboot(tg);
```

Disconnects all sessions; any running application stops. This is Ask-First, but "ask first"
does **not** mean stay abstract — present the exact `reboot(tg)` call you intend to run
alongside the side-effect warning, then wait for confirmation before executing it. Show the
command, name the consequence, and hold:

> I'll run `reboot(tg)` on `<name>`. This disconnects all sessions and stops any running
> application. Confirm and I'll execute it.

Do not merely describe rebooting in prose without showing the `reboot(tg)` call — the user
needs to see the exact command before approving it. The same applies to `update(tg)`,
`setStartupApp`, `setupTLSCertificate`, and `setipaddr`.

----

Copyright 2026 The MathWorks, Inc.

----
