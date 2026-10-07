# API Signature Reference

These are the **only** forms this skill uses. Do not invent variants. Method calls accept
either dot-form or function-form: `connect(tg)` and `tg.connect()` are equivalent. Use the
form shown.

| Operation | Exact form |
| --- | --- |
| Construct host-side target list | `my_tgs = slrealtime.Targets();` |
| Construct settings (name-value) | `ts = slrealtime.TargetSettings("name", n, "address", a, "username", u, ...);` |
| Add a target | `addTarget(my_tgs, ts);` |
| Remove a target | `removeTarget(my_tgs, "name");` |
| List target names | `getTargetNames(my_tgs);` |
| Default target — read | `getDefaultTargetName(my_tgs);` |
| Default target — set | `setDefaultTargetName(my_tgs, "name");` |
| Get a single target | `tg = slrealtime("name");` (preferred) or `getTarget(my_tgs, "name");` |
| Get settings (single) | `ts = slrealtime("name").TargetSettings;` (no `Targets` object needed) |
| Get settings (all) | `tsArray = getTargetSettings(my_tgs);` (`Targets` object only) |
| Construct target object | `tg = slrealtime;` (default) or `tg = slrealtime("name");` |
| Connect / disconnect | `connect(tg);` / `disconnect(tg);` |
| Connection predicate | `isConnected(tg);` |
| Lifecycle state (rollup) | `[state, appName] = status(tg);` |
| Confidence test (8 tests) | `slrealtime.testSetup(tg);` |
| Read host-side settings | `tg.TargetSettings` |
| Read live target-side options | `tg.TargetOptions` (requires `connect`) |
| Change target IP (target-side) | `tg = setipaddr(tg, "10.0.0.5", "255.255.255.0");` (returns a new `tg`; capture it) |
| Install/remove TLS material | `setupTLSCertificate(tg, true, certPath, keyPath);` / `setupTLSCertificate(tg, false);` |
| Reboot target | `reboot(tg);` |
| Update RTOS image (erases all apps and data) | `update(tg);` |
| Startup app | `setStartupApp(tg, "appName");` / `getStartupApp(tg);` / `clearStartupApp(tg);` |

## `status(tg)` return values

`'stopped' | 'loading' | 'loaded' | 'running' | 'terminating' | 'modelError' | 'targetError'`

`status` is a **function**, not a property: call `status(tg)` (or `tg.status()`), never read
`tg.Status`. It auto-connects. `'targetError'` indicates a target-side fault; see
`network-setup.md` and consider `slrealtime.getCrashStack`.

`isConnected(tg)` is the boolean for "is it connected"; `status(tg)` is the rollup for "what
is the target doing". Do not substitute one for the other, and do not invent
`tg.isconnected` or `tg.connectionState`.

----

Copyright 2026 The MathWorks, Inc.

----
