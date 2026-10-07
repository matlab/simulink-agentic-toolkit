# Upgrade Advisor for Legacy Simulink Real-Time Models

Load this when a model predates the current Simulink Real-Time target files, or when the user asks to
bring an older model up to date. `SKILL.md` names the two valid check IDs inline; this file carries the
trigger list, the handling order, and the migration caveats.

## When to Run Upgrade Advisor

Run it when any of these is true:

- The model was created in an older MATLAB release.
- The model reports migration errors after opening in a newer release.
- The model's `SystemTargetFile` is `slrealtime.tlc`, `slrt.tlc`, `slrtert.tlc`, `xpctarget.tlc`, or
  `xpctargetert.tlc`.
- The model carries old xPC Target or pre-R2026a Simulink Real-Time settings.
- The user explicitly asks to upgrade a Simulink Real-Time model.
- The model has obsolete blocks, obsolete configuration parameters, or unsupported Simulink Real-Time
  logging options.

Open the advisor for the model:

```matlab
upgradeadvisor(model);
```

## Handling Order

Run the advisor **before** changing `SystemTargetFile`. Upgrading after a manual STF patch can leave the
model in a state neither the legacy nor the current target file describes.

1. Open the model.
2. Inspect the current STF and solver settings.
3. Run Upgrade Advisor, because the model is legacy.
4. Apply automatic fixes only when the user has authorized changes.
5. Review the remaining manual actions with the user.
6. Save the upgraded model only after the user-approved upgrade actions are complete.
7. Re-run the main configuration workflow in `SKILL.md` after the upgrade.

## Migration Caveats

Switching the STF or applying advisor fixes can migrate or discard legacy configuration — obsolete
logging options, removed parameters, and settings the current target file does not expose. Tell the user
this before applying fixes, not after. An upgrade that silently drops settings the user depended on is a
worse outcome than a build error that explains itself.

Do not try to build directly from a legacy target file. Upgrade first, then configure for the current
target platform.

## Scripted Check IDs

The only Simulink Real-Time check IDs this skill names are `mathworks.design.slrealtimeUpgrades` and
`mathworks.design.slrealtimeLoggingUpgrades`. Do not invent others — advisor check IDs are internal and
guessing a `ModelAdvisor.*.check_*` name produces a call that fails or, worse, silently matches nothing.
If a scripted API for a specific check is unavailable, open the advisor with `upgradeadvisor(model)` and
tell the user which checks or categories to run.

----

Copyright 2026 The MathWorks, Inc.

----
