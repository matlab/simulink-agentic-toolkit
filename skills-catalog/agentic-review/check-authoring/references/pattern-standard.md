# Standard Check Pattern (Batch / Model Advisor)

## Overview
A standard check runs on demand from Model Advisor. It scans the model, finds violations,
reports them using `ModelAdvisor.ResultDetail`, and optionally provides an auto-fix action.

For custom report formatting (tables with named columns, grouped subchecks, reference links),
use `ModelAdvisor.FormatTemplate` alongside ResultDetail. See [pattern-format-template.md](pattern-format-template.md).

## Structure
A standard check lives in a single `.m` file containing:
1. **Definition function** (top-level) -- creates the `ModelAdvisor.Check` object, sets properties, optionally adds an action, and publishes it.
2. **Check callback** -- the logic that finds violations and populates `ModelAdvisor.ResultDetail`.
3. **Action callback** (optional) -- auto-fix logic triggered from Model Advisor UI.

## Template

```matlab
function define<CheckName>
%% Create the check object with a unique reverse-domain ID.
rec = ModelAdvisor.Check('com.<company>.<area>.<checkname>');
rec.Title = '<Human-readable check title>';
rec.TitleTips = '<Short tooltip describing what the check does>';

%% Set the callback function.
%  Second argument is the callback context:
%    'None'        — no compilation needed (structural properties only)
%    'PostCompile' — model is compiled first (needed for resolved data types,
%                    sample times, signal dimensions, port widths, etc.)
rec.setCallbackFcn(@<CheckName>Callback, 'None', 'DetailStyle');

%% (Optional) Create an auto-fix action.
% Only include this block if the violation is programmatically fixable.
myAction = ModelAdvisor.Action;
myAction.setCallbackFcn(@<CheckName>ActionCB);
myAction.Name = '<Button label for the fix>';
myAction.Description = '<Tooltip for the fix button>';
rec.setAction(myAction);

%% Publish the check to a Model Advisor group.
mdladvRoot = ModelAdvisor.Root;
mdladvRoot.publish(rec, '<Group Name>');
end

% -------------------------------------------------------------------------
% Check callback -- finds violations and reports results.
% Must use DetailStyle. NEVER use StyleOne, StyleTwo, or StyleThree.
% -------------------------------------------------------------------------
function <CheckName>Callback(system, CheckObj)
mdladvObj = Simulink.ModelAdvisor.getModelAdvisor(system);

%% --- CHECK LOGIC START ---
% Use find_system or other APIs to locate violating elements.
% Refer to the references/ docs for element-specific patterns.
violationBlks = find_system(system, <search parameters>);
%% --- CHECK LOGIC END ---

%% Report results
if isempty(violationBlks)
    % Pass case
    ElementResults = ModelAdvisor.ResultDetail;
    ElementResults.Description = '<What this check looks for>';
    ElementResults.ViolationType = 'Passed';
    ElementResults.Status = '<All-clear message>';
else
    % Violation case
    for i = 1:numel(violationBlks)
        ElementResults(1, i) = ModelAdvisor.ResultDetail;
    end
    for i = 1:numel(ElementResults)
        ModelAdvisor.ResultDetail.setData(ElementResults(i), 'SID', violationBlks{i});
        ElementResults(i).Description = '<What this check looks for>';
        ElementResults(i).Status = '<Violation summary message>';
        ElementResults(i).RecAction = '<Recommended action to fix>';
    end
    mdladvObj.setActionEnable(true);
end
CheckObj.setResultDetails(ElementResults);
end

% -------------------------------------------------------------------------
% (Optional) Action callback -- applies the auto-fix.
% -------------------------------------------------------------------------
function result = <CheckName>ActionCB(taskObj)
mdladvObj = taskObj.MAObj;
checkObj = taskObj.Check;
resultDetailObjs = checkObj.ResultDetails;

for i = 1:numel(resultDetailObjs)
    block = Simulink.ID.getHandle(resultDetailObjs(i).Data);
    %% --- FIX LOGIC ---
    % Apply the fix using set_param or other APIs.
    % set_param(block, '<Param>', '<Value>');
    %% --- FIX LOGIC END ---
end

result = ModelAdvisor.Text('<Description of what was fixed>');
mdladvObj.setActionEnable(false);
end
```

## Key APIs

| API | Purpose |
|-----|---------|
| `ModelAdvisor.Check(id)` | Create a check with unique ID |
| `rec.setCallbackFcn(@cb, context, 'DetailStyle')` | Set the check callback. **Always use `'DetailStyle'`. NEVER use `'StyleOne'`, `'StyleTwo'`, or `'StyleThree'`** |
| `ModelAdvisor.Action` | Create an auto-fix action |
| `ModelAdvisor.Root.publish(rec, group)` | Register check under a group |
| `Simulink.ModelAdvisor.getModelAdvisor(system)` | Get the MA object in callback |
| `ModelAdvisor.ResultDetail` | Create a result entry |
| `ModelAdvisor.ResultDetail.setData(rd, 'SID', sid)` | Attach a Simulink ID to a result |
| `CheckObj.setResultDetails(results)` | Store results in the check object |
| `Simulink.ID.getHandle(sid)` | Resolve SID to block handle (in action CB) |

## Full Example

```matlab
function defineDetailStyleCheck
rec = ModelAdvisor.Check('com.mathworks.sample.detailStyle');
rec.Title = 'Check whether block names appear below blocks';
rec.TitleTips = 'Check position of block names';
rec.setCallbackFcn(@DetailStyleCallback,'None','DetailStyle');

myAction = ModelAdvisor.Action;
myAction.setCallbackFcn(@ActionCB);
myAction.Name='Make block names appear below blocks';
myAction.Description='Click the button to place block names below blocks';
rec.setAction(myAction);

mdladvRoot = ModelAdvisor.Root;
mdladvRoot.publish(rec, 'Demo');
end

function DetailStyleCallback(system, CheckObj)
mdladvObj = Simulink.ModelAdvisor.getModelAdvisor(system);
violationBlks = find_system(system, 'Type','block',...
    'NamePlacement','alternate',...
    'ShowName', 'on');
if isempty(violationBlks)
    ElementResults = ModelAdvisor.ResultDetail;
    ElementResults.Description = 'Identify blocks where the name is not displayed below the block.';
    ElementResults.ViolationType = 'Passed';
    ElementResults.Status = 'All blocks have names displayed below the block.';
else
    for i=1:numel(violationBlks)
        ElementResults(1,i) = ModelAdvisor.ResultDetail;
    end
    for i=1:numel(ElementResults)
        ModelAdvisor.ResultDetail.setData(ElementResults(i), 'SID',violationBlks{i});
        ElementResults(i).Description = 'Identify blocks where the name is not displayed below the block.';
        ElementResults(i).Status = 'The following blocks have names that do not display below the block:';
        ElementResults(i).RecAction =  'Change the location such that the block name is below the block.';
    end
    mdladvObj.setActionEnable(true);
end
CheckObj.setResultDetails(ElementResults);
end

function result = ActionCB(taskObj)
mdladvObj = taskObj.MAObj;
checkObj = taskObj.Check;
resultDetailObjs = checkObj.ResultDetails;
for i=1:numel(resultDetailObjs)
    block=Simulink.ID.getHandle(resultDetailObjs(i).Data);
    set_param(block,'NamePlacement','normal');
end
result = ModelAdvisor.Text('Changed the location such that the block name is below the block.');
mdladvObj.setActionEnable(false);
end
```

---

## sl_customization.m Registration

`sl_customization.m` is the entry point that registers all custom Model Advisor checks.

### Rules
- Must be named `sl_customization.m` exactly.
- A folder can have only **one** `sl_customization.m`.
- One file can register **multiple** checks via repeated `cm.addModelAdvisorCheckFcn()` calls.
- After adding or modifying, run `Advisor.Manager.refresh_customizations` to reload.

### Template

```matlab
function sl_customization(cm)
%% Register custom Model Advisor checks.
%  This file must be on the MATLAB path.
%  Run Advisor.Manager.refresh_customizations after changes.

cm.addModelAdvisorCheckFcn(@define<CheckName>);
% Add more checks below:
% cm.addModelAdvisorCheckFcn(@defineAnotherCheck);
end
```
