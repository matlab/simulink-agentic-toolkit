# Configuration Parameter Check Pattern

## Overview
Validates Simulink **model configuration parameters** (solver, diagnostics, code generation settings) against required values. Uses standard check structure with `get_param(system, paramName)` / `set_param(system, paramName, value)`.

## When to Use
- User wants to enforce specific config parameter values
- User mentions "config parameters", "model settings", "solver settings"
- The check uses `get_param(model, '<ConfigParam>')`, NOT block-level properties

## Key Differences from Block-Level Checks

| Aspect | Block-Level Check | Config Parameter Check |
|--------|-------------------|----------------------|
| What it checks | `get_param(block, ...)` | `get_param(model, ...)` |
| `setData` call | `setData(rd, 'SID', blockSID)` | `setData(rd, 'Model', system, 'Parameter', paramName, 'CurrentValue', curVal, 'RecommendedValue', fixVal, 'ConstraintID', id)` |
| Fix approach | `set_param(blockHandle, ...)` | `set_param(system, paramName, value)` |
| Callback context | `'None'` or `'PostCompile'` | `'None'` (always structural) |

## Template

```matlab
function define<CheckName>
rec = ModelAdvisor.Check('com.<company>.<area>.<checkname>');
rec.Title = '<Human-readable check title>';
rec.TitleTips = '<Short tooltip>';
rec.setCallbackFcn(@<CheckName>Callback, 'None', 'DetailStyle');

myAction = ModelAdvisor.Action;
myAction.setCallbackFcn(@<CheckName>ActionCB);
myAction.Name = 'Modify Settings';
myAction.Description = 'Update model configuration parameters to required values.';
rec.setAction(myAction);

mdladvRoot = ModelAdvisor.Root;
mdladvRoot.publish(rec, '<Group Name>');
end

% -------------------------------------------------------------------------
function <CheckName>Callback(system, CheckObj)
mdladvObj = Simulink.ModelAdvisor.getModelAdvisor(system);

%% Define expected parameter values.
%  Each row: {paramName, expectedValue, fixValue, description}
paramSpecs = {
    '<ParamName1>', '<ExpectedValue1>', '<FixValue1>', '<Description>';
    '<ParamName2>', '<ExpectedValue2>', '<FixValue2>', '<Description>';
};

%% Check each parameter.
violations = {};
for k = 1:size(paramSpecs, 1)
    actualVal = get_param(system, paramSpecs{k, 1});
    if ~strcmp(actualVal, paramSpecs{k, 2})
        violations{end+1} = paramSpecs(k, :); %#ok<AGROW>
    end
end

%% Report results.
if isempty(violations)
    ElementResults = ModelAdvisor.ResultDetail;
    ElementResults.Description = '<What this check validates>';
    ElementResults.ViolationType = 'Passed';
    ElementResults.Status = 'All configuration parameters are set correctly.';
else
    for i = 1:numel(violations)
        ElementResults(1, i) = ModelAdvisor.ResultDetail;
    end
    for i = 1:numel(violations)
        paramName = violations{i}{1};
        currentVal = get_param(system, paramName);
        fixVal = violations{i}{3};
        ModelAdvisor.ResultDetail.setData(ElementResults(i), 'Model', system, ...
            'Parameter', paramName, ...
            'CurrentValue', currentVal, ...
            'RecommendedValue', fixVal, ...
            'ConstraintID', i);
        ElementResults(i).Description = violations{i}{4};
        ElementResults(i).Status = sprintf('Parameter ''%s'' is set to ''%s'', expected ''%s''.', ...
            paramName, currentVal, violations{i}{2});
        ElementResults(i).RecAction = sprintf('Set ''%s'' to ''%s''.', paramName, fixVal);
    end
    mdladvObj.setActionEnable(true);
end
CheckObj.setResultDetails(ElementResults);
end

% -------------------------------------------------------------------------
function result = <CheckName>ActionCB(taskObj)
mdladvObj = taskObj.MAObj;
checkObj = taskObj.Check;
resultDetailObjs = checkObj.ResultDetails;
system = bdroot(mdladvObj.SystemName);

%% Apply fixes.
paramFixes = {
    '<ParamName1>', '<FixValue1>';
    '<ParamName2>', '<FixValue2>';
};
fixMap = containers.Map(paramFixes(:,1), paramFixes(:,2));

for i = 1:numel(resultDetailObjs)
    paramName = resultDetailObjs(i).Data.Parameter;
    if fixMap.isKey(paramName)
        set_param(system, paramName, fixMap(paramName));
    end
end

result = ModelAdvisor.Text('Updated model configuration parameters to required values.');
mdladvObj.setActionEnable(false);
end
```

## Checking for Unwanted Values

For parameters that should NOT have a specific value, invert the comparison:
```matlab
unwantedVal = 'none';
actualVal = get_param(system, 'UnconnectedInputMsg');
if strcmp(actualVal, unwantedVal)
    % Violation
end
```

## sl_customization.m

```matlab
function sl_customization(cm)
cm.addModelAdvisorCheckFcn(@define<CheckName>);
end
```
