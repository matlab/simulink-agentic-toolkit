# `TargetSettings` Field Reference

**`slrealtime.TargetSettings`** is host-side identity (name, address, ports, credentials). It is what `slrealtime.Targets.addTarget` validates and persists into MATLAB Settings.

The target also has live target-side options for XCP, REST, HTTPS/TLS, and related runtime settings. Read those from a connected target with `tg.TargetOptions`, but do not edit backing files or internal classes directly. Use the supported APIs and UI routes described below.

Constructor takes name-value arguments or a copy-source `TargetSettings`.

| Property        | Type             | Default     | Validator / range                                         | Notes                                                                  |
|-----------------|------------------|-------------|-----------------------------------------------------------|------------------------------------------------------------------------|
| `name`          | string           | `''`        | `mustBeTextScalar`                                        | Required for `addTarget`. Used by `getTarget`, `setDefaultTargetName`. |
| `address`       | string           | `''`        | IPv4 dotted-quad (errId `slrealtime:target:badipaddr`)    | Required for `connect(tg)`.                                            |
| `sshPort`       | positive integer | `22`        | `mustBeInteger`, `mustBePositive`                         | Standard SSH port; only override when target SSH is reconfigured.      |
| `xcpPort`       | integer          | `5555`      | `[1, 65535]` (errId `slrealtime:target:badxcpport`)       | Must match the target-side `XCP_PORT`. Change via Simulink Real-Time Explorer to keep the development computer and the target computer in sync.|
| `username`      | string           | `'slrt'`    | (no validator)                                            | SSH user used for app deploy and SSH commands.                         |
| `userPassword`  | string           | `'slrt'`    | (no validator)                                            | Stored in MATLAB Settings — see "Credential Hygiene" below.            |
| `rootPassword`  | string           | `'root'`    | (no validator)                                            | Used by `update(tg)`, `setipaddr`, and `slrealtime.testSetup` for root SSH ops.|

**Construction:**

```matlab
ts = slrealtime.TargetSettings( ...
    'name',         'lab-rig-3', ...
    'address',      '192.168.7.5', ...
    'username',     'slrt', ...
    'userPassword', '<from-prompt>', ...
    'rootPassword', '<from-prompt>');

my_tgs = slrealtime.Targets();
addTarget(my_tgs, ts);
```

`addTarget` calls `validateTarget(ts)` which checks duplicate names, missing required fields, and IP collisions against existing targets. **Always populate the settings object first, then `addTarget` once** — there is no `setTargetSettings` API to mutate a target after it's been added.

**Reading current settings:**

```matlab
tsOne = slrealtime("lab-rig-3").TargetSettings;          % single target — no Targets collection needed
%   equivalent: tg = slrealtime("lab-rig-3"); tsOne = tg.TargetSettings;

tsAll = getTargetSettings(my_tgs);                       % array of TargetSettings for every target
```

`getTargetSettings` only accepts a `Targets` object; calling it on a single `Target` throws "Incorrect number or types of inputs or outputs." For one target, read the `TargetSettings` property on a `Target` object — either inline via `slrealtime("<name>").TargetSettings` or by constructing `tg = slrealtime("<name>")` first.

## Target-Side Runtime Options

**Read the live values from a connected target before changing target-side settings:**

```matlab
opts = tg.TargetOptions;
```

**HTTPS / TLS:** use `setupTLSCertificate(tg, true, certPath, keyPath)` to install certificate material and `setupTLSCertificate(tg, false)` to remove it. Do not copy certificate files or edit target-side runtime configuration by hand.

**XCP port:** the host-side `TargetSettings.xcpPort` and the target-side listener must agree. R2026a does not expose a programmatic API that updates both atomically; use **Simulink Real-Time Explorer** → Target Properties so the two stay in sync.

**REST API port and HTTPS toggle:** use **Simulink Real-Time Explorer** → Target Properties. Programmatic edits through target-side files or SSH service restarts are out of scope for this skill.

## Credential Hygiene

`TargetSettings.userPassword` and `TargetSettings.rootPassword` are persisted **in plaintext** into MATLAB Settings (`s.slrealtime.targets.<name>.userPassword.PersonalValue`, etc.). Implications:

- Treat any script that constructs `TargetSettings` with hard-coded credentials as a credential leak. Prompt the user (`inputdlg`, `getpass`) or read from a `.env`-style file the user controls.
- For shared CI development computers, consider a per-user MATLAB Settings file (`prefdir`) and document the path; do not rely on environment variables alone.
- Note that `disp(tg.TargetSettings)` lists all seven fields and prints both passwords as stored — verified on R2026a. That is the object's display behavior, not something to work around here.

## Worked Example — Speedgoat on `192.168.7.5`

```matlab
% Prompt for credentials so they don't end up in version control
creds = inputdlg({'Simulink Real-Time user password','Simulink Real-Time root password'}, ...
                 'Credentials', 1, {'',''}, 'on');
userPwd = creds{1};
rootPwd = creds{2};

ts = slrealtime.TargetSettings( ...
    'name',         'lab-rig-3', ...
    'address',      '192.168.7.5', ...
    'sshPort',      22, ...
    'xcpPort',      5555, ...
    'username',     'slrt', ...
    'userPassword', userPwd, ...
    'rootPassword', rootPwd);

my_tgs = slrealtime.Targets();
addTarget(my_tgs, ts);
setDefaultTargetName(my_tgs, 'lab-rig-3');

tg = slrealtime;
connect(tg);
disp(tg.TargetOptions);
```

----

Copyright 2026 The MathWorks, Inc.

----
