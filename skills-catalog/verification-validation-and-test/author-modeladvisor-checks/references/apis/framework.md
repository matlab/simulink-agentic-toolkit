---
type: api-reference
triggers: [input_parameters, auto_fix, exclusion, result_formatting, ModelAdvisor_Action]
tags: [api, framework, parameters, auto-fix, exclusion, reporting]
related:
  - patterns/standard.md
  - patterns/config-param.md
  - apis/blocks.md
---
# Model Advisor Framework API Patterns

Generic framework APIs for parameterized checks, auto-fix actions, exclusion filtering, and non-block violation reporting. These apply to any check type (blocks, signals, stateflow).

---

## Input Parameters (Parameterized Checks)

### Defining input parameters
```matlab
% In check definition function
inputParam = ModelAdvisor.InputParameter;
inputParam.Name = 'Max allowed gain';
inputParam.Value = '10';
inputParam.Type = 'String';
inputParam.Description = 'Maximum gain value';
rec.setInputParametersLayoutGrid([1 1]);
rec.InputParameters = {inputParam};

% Multiple parameters
param1 = ModelAdvisor.InputParameter;
param1.Name = 'Threshold';
param1.Value = '5';
param1.Type = 'String';

param2 = ModelAdvisor.InputParameter;
param2.Name = 'Check subsystems';
param2.Value = true;
param2.Type = 'Bool';

rec.setInputParametersLayoutGrid([2 1]);
rec.InputParameters = {param1, param2};
```

### Retrieving parameter values in callback
```matlab
mdladvObj = Simulink.ModelAdvisor.getModelAdvisor(system);
inputParams = mdladvObj.getInputParameters;
threshold = str2double(inputParams{1}.Value);

% Or retrieve by name
param = mdladvObj.getInputParameterByName('Threshold');
thresholdVal = str2double(param.Value);
```

---

## Auto-Fix Actions

### Defining an action in check definition
```matlab
act = ModelAdvisor.Action;
act.setCallbackFcn(@actionCallback);
act.Name = 'Fix all violations';
act.Description = 'Automatically fixes the violations';
rec.setAction(act);
```

### Action callback implementation
```matlab
function actionCallback(taskObj)
    mdladvObj = taskObj.Check;
    results = mdladvObj.ResultDetails;
    for i = 1:numel(results)
        sid = results(i).Data;
        h = Simulink.ID.getHandle(sid);
        set_param(h, 'NamePlacement', 'normal');  % example fix
    end
    % Disable button after fix
    mdladvObj = Simulink.ModelAdvisor.getModelAdvisor(bdroot);
    mdladvObj.setActionEnable(false);
end
```

### Edit-time check auto-fix
For edit-time checks, implement the `fix` method on the class:
```matlab
function fix(obj, violation)
    sid = violation.Data;
    h = Simulink.ID.getHandle(sid);
    set_param(h, 'ShowName', 'on');  % example fix
end
```

---

## Exclusion Filtering

Filter blocks per user exclusion settings before reporting violations:
```matlab
mdladvObj = Simulink.ModelAdvisor.getModelAdvisor(system);
filteredBlks = mdladvObj.filterResultWithExclusion(candidateBlks);
```

Call this before creating ResultDetail entries — it removes blocks the user has explicitly excluded from checking.

---

## Result Reporting Utilities

### Report formatting (custom output)
```matlab
p = ModelAdvisor.Paragraph;
p.addItem(ModelAdvisor.Text('Some descriptive text'));
p.addItem(ModelAdvisor.LineBreak());
p.addItem(ModelAdvisor.Text('More details'));
```

### File-based violations (for MATLAB code checks)
Use when reporting violations in MATLAB Function block code or script files:
```matlab
rd = ModelAdvisor.ResultDetail;
ModelAdvisor.ResultDetail.setData(rd, 'FileName', filePath, ...
    'Expression', codeSnippet, ...
    'TextStart', startPos, 'TextEnd', endPos);
rd.Description = 'Violation in MATLAB code';
rd.Status = 'Code issue found';
rd.RecAction = 'Fix the code at the indicated location';
```

### setData type summary

| Type | Syntax | Use for |
|------|--------|---------|
| `'SID'` | `setData(rd, 'SID', blockHandleOrPath)` | Block violations — highlights the block |
| `'Signal'` | `setData(rd, 'Signal', dstPortHandle)` | Signal line violations — highlights the line |
| `'FileName'` | `setData(rd, 'FileName', path, 'Expression', ..., 'TextStart', ..., 'TextEnd', ...)` | MATLAB code violations — highlights code span |
| `'Custom'` | `setData(rd, 'Custom', htmlString)` | Custom HTML content |
| `'Group'` | `setData(rd, 'Group', groupName)` | Grouped subcheck results |

----

Copyright 2026 The MathWorks, Inc.

----
