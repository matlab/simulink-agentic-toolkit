---
type: template
triggers: [test_class, test_skeleton, recipes, runCheck, portable_test]
tags: [template, test-recipes, portable, R2023a, R2026a, unittest]
related:
  - procedures/test-check.md
  - templates/test-spec.md
---
# Test Generation Recipes

Self-contained recipes for generating Model Advisor check tests. Each generated test
carries its own helpers as **local functions** — no base class or helper `.m` is shipped.

All recipes are portable **R2023a-R2026a** using runtime shape checks (`isfield`/`isprop`).

## Compatibility Matrix

| Feature | R2023a-R2024a | R2024b+ (incl. R2026a) |
|---------|---------------|------------------------|
| `ModelAdvisor.run` returns cell of `SystemResult` | Yes | Yes |
| `SystemResult.CheckResultObjs` (cell) | Yes | Yes (alias) |
| `SystemResult.CheckResults` (array) | No | Yes |
| `CheckResult.getResultDetails()` for custom checks | No (returns empty) | Yes (structs) |
| `getModelAdvisor` -> `getCheckObj` -> `.ResultDetails` | Yes (objects) | Yes |
| `ViolationType` property/field | Yes | Yes |
| `IsViolation` property | Yes | removed R2026a+ |
| "Passed" detail `ViolationType` in R2023a | May show `'Warning'` (framework override) | `'Passed'` |
| struct `Violation` field | -- | SID char (not boolean) |
| struct `Data` field for block target | -- | struct with `.SID` |
| `Status` field in struct | -- | No (not present) |
| auto-fix via `getTaskNode` | No | No |
| auto-fix via `selectCheck`+`runAction(id,task)` | Yes | Yes |

**R2026a struct fields:** `Violation`, `ViolationType`, `Description`, `RecAction`, `Data`, `ID`, `Justification`.

---

## Generated Test Skeleton

```matlab
classdef TestMyCheck < matlab.unittest.TestCase
    properties (Constant)
        CheckID = 'com.example.mycheck';
    end
    properties
        Folder
    end
    properties (Access = private)
        LoadedModels string = string.empty
    end

    methods (TestMethodSetup)
        function useCleanWorkingFolder(tc)
            tc.Folder = tc.createTemporaryFolder();
            tc.addTeardown(@cd, pwd);
            cd(tc.Folder);
        end
    end

    methods (TestMethodTeardown)
        function closeModels(tc)
            for m = tc.LoadedModels
                if bdIsLoaded(m); close_system(m, 0); end
            end
            tc.LoadedModels = string.empty;
        end
    end

    methods (Test)
        % One method per confirmed test-plan case
    end

    methods (Access = private)
        % runCheck / runCheckAndFix
    end
end
% ---- local functions ----
```

Include **only** the helpers the emitted test methods actually call.

**Working folder strategy.** `createTemporaryFolder()` (R2022a+) provides a fresh temp
directory per test method, stored in the `Folder` property. The setup then `cd`s into it
so that `ModelAdvisor.run` writes its `modeladvisor/` and `slprj/` artifacts into the temp
folder instead of polluting the test directory. `addTeardown(@cd, pwd)` restores the
original working directory after each test method regardless of pass/fail. The framework
removes temp folders automatically when the test case scope ends. Models load by full path
(`fullfile(fileparts(mfilename('fullpath')), ...)`) so the `cd` doesn't affect model resolution.

---

## Recipe 1 — Run a check (portable, registration-guarded)

`ModelAdvisor.run` returns a **cell** array of `SystemResult`. The registration guard
reports **Incomplete** if the check isn't registered.

**R2023a note:** `CheckResult.getResultDetails()` returns empty for custom DetailStyle
checks in R2023a-R2024a. Use the interactive API fallback:
`Simulink.ModelAdvisor.getModelAdvisor(model)` -> `getCheckObj(checkID)` -> `.ResultDetails`.

```matlab
function details = runCheck(tc, modelName)
    modelName = string(modelName);
    if ~bdIsLoaded(modelName)
        load_system(fullfile(fileparts(mfilename('fullpath')), char(modelName)));
        tc.LoadedModels(end+1) = modelName;
    end
    try
        ModelAdvisor.run(char(modelName), {char(tc.CheckID)});
    catch err
        tc.assumeFail(sprintf(['Check "%s" is not registered — cannot run.\n' ...
            'Author it and register via an sl_customization.m + ' ...
            'Advisor.Manager.refresh_customizations.\n(%s)'], tc.CheckID, err.message));
    end
    details = tc.resultDetails(modelName);
end
```

```matlab
function details = resultDetails(tc, modelName)
    % Primary path (R2024b+): CheckResult.getResultDetails() returns structs.
    % Fallback path (R2023a-R2024a): getModelAdvisor -> getCheckObj -> ResultDetails.
    %
    % In R2023a, CheckResult.getResultDetails() returns empty for custom
    % DetailStyle checks even though results were set via setResultDetails.
    % The interactive API (Simulink.ModelAdvisor.getModelAdvisor) retains them
    % as ModelAdvisor.ResultDetail objects.
    ma = Simulink.ModelAdvisor.getModelAdvisor(char(modelName));
    checkObj = ma.getCheckObj(char(tc.CheckID));
    tc.assumeNotEmpty(checkObj, sprintf( ...
        'Check "%s" not found via getCheckObj — not registered?', tc.CheckID));
    details = checkObj.ResultDetails;
end
```

Pass input parameters: `ModelAdvisor.run(modelName, {char(tc.CheckID)}, 'InputParameters', {name, value})`.

---

## Recipe 2 — Detect a violation (portable)

**Do NOT treat `Violation` as a boolean** — on R2024b+ it holds the SID string.
Discriminate on `ViolationType` case-insensitively.

**R2023a quirk:** The framework may override `ViolationType` to `'Warning'` even for
the "Passed" summary detail emitted when no violations exist. A true violation always
has a non-empty `Data` field (SID target). Guard on `isempty(rd.Data)` first.

```matlab
function tf = isViolation(rd)
    % Guard: in R2023a the "Passed" summary detail may have ViolationType
    % overridden to 'Warning'. True violations always carry a non-empty Data
    % field (the SID of the flagged element).
    if (isfield(rd, 'Data') || isprop(rd, 'Data')) && isempty(rd.Data)
        tf = false;
    elseif isfield(rd, 'ViolationType') || isprop(rd, 'ViolationType')
        tf = ~any(strcmpi(rd.ViolationType, ...
                  {'pass', 'passed', 'informer', 'info', 'information'}));
    elseif isprop(rd, 'IsViolation')
        tf = rd.IsViolation;
    else
        tf = false;
    end
end

function v = violations(details)
    if isempty(details); v = details; return; end
    v = details(arrayfun(@isViolation, details));
end
```

**Assertions:**

| Case | Code |
|------|------|
| TC-Pass | `tc.verifyEmpty(violations(details))` |
| TC-Viol | `tc.verifyNotEmpty(violations(details))` |
| TC-Count | `tc.verifyNumElements(violations(details), N)` |

---

## Recipe 3 — Identify the target (block / signal / param)

Target location differs by release:
- **R2024b+ struct:** `Data` field — struct with `.SID`, or bare handle, or SID char
- **R2023a-R2024a object:** `Type` selects `SID`/`SignalName`/`ParameterName`

```matlab
function p = targetBlock(rd)
    p = "";
    if (isfield(rd, 'Data') || isprop(rd, 'Data')) && ~isempty(rd.Data)
        d = rd.Data;
        if isstruct(d) && isfield(d, 'SID')
            try; p = string(Simulink.ID.getFullName(d.SID)); catch; p = ""; end
        elseif ischar(d) || isstring(d)
            try; p = string(Simulink.ID.getFullName(char(d))); catch; p = string(d); end
        elseif isnumeric(d) && ishandle(d)
            try; p = string(getfullname(d)); catch; p = ""; end
        end
    elseif isprop(rd, 'Type')
        switch lower(char(rd.Type))
            case 'sid';    p = string(getfullname(Simulink.ID.getHandle(rd.SID)));
            case 'signal'; p = string(rd.SignalName);
        end
    end
end

function tf = hasViolationOnBlock(details, blockPath)
    want = string(blockPath);
    v = violations(details);
    if isempty(v); tf = false; return; end
    tf = any(arrayfun(@(rd) targetBlock(rd) == want, v));
end
```

| Case | Code |
|------|------|
| TC-Target | `tc.verifyTrue(hasViolationOnBlock(details, 'model/Block1'))` |
| TC-FP | `tc.verifyFalse(hasViolationOnBlock(details, 'model/GoodBlock'))` |

**Signal / config-param targets:** verify by violation count on purpose-built models
rather than inspecting the target string (struct shape has no stable `Type` field).

---

## Recipe 4 — Metadata (inline, no helper)

```matlab
v = violations(details);
tc.verifyTrue(all(arrayfun(@(rd) ...
    ~isempty(rd.Description) && ~isempty(rd.RecAction), v)));
```

On R2023a-R2024a (object shape) `Status` exists; on R2024b+ (struct) it does not.
Only assert `Description` and `RecAction` for portable tests.

---

## Recipe 5 — Auto-fix

Drive the fix through `Simulink.ModelAdvisor` interactive API:

```matlab
function details = runCheckAndFix(tc, modelName)
    modelName = string(modelName);
    tc.runCheck(modelName);
    ma = Simulink.ModelAdvisor.getModelAdvisor(char(modelName));
    ma.deselectCheckAll();
    ma.selectCheck(char(tc.CheckID));
    ma.runCheck();
    checkObj = ma.getCheckObj(char(tc.CheckID));
    if ~isempty(checkObj) && ~isempty(checkObj.Action) ...
            && ~isempty(checkObj.Action.CallbackHandle)
        task = ModelAdvisor.Task;
        task.MAObj = ma;
        task.Check = checkObj;
        ma.runAction(char(tc.CheckID), task);
    end
    details = tc.runCheck(modelName);
end
```

| Case | Code |
|------|------|
| TC-Fix | `tc.verifyEmpty(violations(tc.runCheckAndFix('violating_model')))` |
| TC-Fix-Values | After fix: `tc.verifyEqual(get_param('model','Param'), 'Expected')` |

---

## Recipe 6 — Edit-time checks

**Integration** (recommended): identical to Recipe 1 — `ModelAdvisor.run` drives traversal.

**Optional BLKITER unit test** — call callback directly (only when signature is known):

```matlab
result = <checkCallback>(<blockHandleOrContext>);
tc.verifyNotEmpty(result);
```

If callback signature can't be determined confidently, emit only the integration test.

----

Copyright 2026 The MathWorks, Inc.

----
