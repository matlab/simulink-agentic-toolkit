# Quick-Start Patterns

Copy-ready patterns for the most common target-management tasks. Each one is the
same API surface documented in the SKILL.md API Signature Reference — these are
shortcuts, not alternatives. The Ask-First rules in the SKILL.md Guardrails
apply to every pattern here.

## Connect to the default target

```matlab
tg = slrealtime;
connect(tg);
disp(isConnected(tg));
```

## Add a new target and make it the default

Speedgoat factory defaults are username `slrt`, user password `slrt`, and root
password `root`; confirm with the user before relying on them.

**The `setDefaultTargetName` line is only correct because the request explicitly
included making the new target the default.** If the user only asked you to add
a target, stop after `addTarget` and ask before touching the default.

```matlab
ts = slrealtime.TargetSettings( ...
    "name",         "lab-rig-3", ...
    "address",      "192.168.7.5", ...
    "username",     "slrt", ...
    "userPassword", userPwd, ...
    "rootPassword", rootPwd);

my_tgs = slrealtime.Targets();
addTarget(my_tgs, ts);
setDefaultTargetName(my_tgs, "lab-rig-3");

tg = slrealtime;
connect(tg);
```

## Read the target's overall lifecycle state

```matlab
tg = slrealtime;
[state, appName] = status(tg);  % auto-connects; 'stopped' | 'loaded' | 'running' | ...
```

## Validate end to end after configuration

```matlab
tg = slrealtime;
connect(tg);
slrealtime.testSetup(tg);
```

## Inspect settings without contacting the target

```matlab
tg = slrealtime;
ts = tg.TargetSettings;   % no connect — host-side data only
fprintf("%s @ %s:%d  xcp %d  user %s\n", ...
    ts.name, ts.address, ts.sshPort, ts.xcpPort, ts.username);
```

## Verify after any change

```matlab
my_tgs = slrealtime.Targets();
disp(getTargetNames(my_tgs));
disp(getDefaultTargetName(my_tgs));

tg = slrealtime;
connect(tg);
disp(isConnected(tg));
disp(status(tg));            % overall lifecycle state
ts = tg.TargetSettings;      % host-side record
fprintf("%s @ %s  user %s\n", ts.name, ts.address, ts.username);
disp(tg.TargetOptions);      % requires connect
```

For a full connectivity confidence test, run `slrealtime.testSetup(tg)`. On any
failure, see `network-setup.md` for the failure-to-cause mapping.

----

Copyright 2026 The MathWorks, Inc.

----
