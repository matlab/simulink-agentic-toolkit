---
type: pattern
triggers: [edit_time, live_warning, real_time, canvas_warning, EdittimeCheck]
tags: [check-pattern, edit-time, live, canvas, BLKITER, ACTIVEGRAPH]
related:
  - patterns/standard.md
  - apis/blocks.md
  - apis/stateflow.md
---
# Edit-Time Check Pattern (Live Canvas Warnings)

## Overview
An edit-time check runs continuously as the user edits the model and shows violations directly on the canvas. It requires:
1. A **registration function** (uses `CallbackHandle` instead of `setCallbackFcn`).
2. A **class** that inherits from `ModelAdvisor.EdittimeCheck`.

## Performance Constraint
Must execute in **under 500ms**. After 3 timeouts across different models, the check is automatically disabled.

## Traversal Types

| Type | Constant | When to Use |
|------|----------|-------------|
| Block iteration | `edittimecheck.TraversalTypes.BLKITER` | Check each block individually (independent checks) |
| Active graph | `edittimecheck.TraversalTypes.ACTIVEGRAPH` | Need context from sibling blocks (positions, relationships) |

## Class Methods

| Method | Required | Purpose |
|--------|----------|---------|
| Constructor | Yes | Call superclass constructor, set `traversalType` |
| `blockDiscovered(obj, blk)` | Yes | Called per block. Return `ModelAdvisor.ResultDetail` or `[]` |
| `finishedTraversal(obj)` | Yes | Called after traversal. Use for aggregate checks or cleanup. Return violation or `[]` |
| `fix(obj, violation)` | No | Auto-fix. `violation.Data` contains the SID. Return `true` on success |

## Key Differences from Standard Checks

| Aspect | Standard Check | Edit-Time Check |
|--------|---------------|-----------------|
| Callback | Function via `setCallbackFcn` | Class via `CallbackHandle` |
| Results | Stored via `CheckObj.setResultDetails()` | Returned from `blockDiscovered()` / `finishedTraversal()` |
| Auto-fix | `ModelAdvisor.Action` callback | `fix(obj, violation)` method |
| Performance | No strict limit | < 500ms |

## Template: Registration Function

```matlab
function define<CheckName>
rec = ModelAdvisor.Check('<com.company.area.checkname>');
rec.Title = '<Human-readable check title>';
rec.CallbackHandle = '<PackageName.ClassName>';
mdladvRoot = ModelAdvisor.Root;
mdladvRoot.publish(rec, '<Group Name>');
end
```

## Template: BLKITER (basic)

```matlab
classdef <ClassName> < ModelAdvisor.EdittimeCheck
    methods
        function obj = <ClassName>(checkId)
            obj = obj@ModelAdvisor.EdittimeCheck(checkId);
            obj.traversalType = edittimecheck.TraversalTypes.BLKITER;
        end

        function violation = blockDiscovered(obj, blk)
            violation = [];
            %% --- CHECK LOGIC ---
            % If violation found:
            % violation = ModelAdvisor.ResultDetail;
            % ModelAdvisor.ResultDetail.setData(violation, 'SID', Simulink.ID.getSID(blk));
            % violation.CheckID = obj.checkId;
            % violation.Title = '<Short title>';
            % violation.Description = '<What was violated>';
            % violation.ViolationType = 'warn';
            %% --- CHECK LOGIC END ---
        end

        function violation = finishedTraversal(obj)
            violation = [];
        end
    end
end
```

## Template: BLKITER with auto-fix

```matlab
classdef <ClassName> < ModelAdvisor.EdittimeCheck
    methods
        function obj = <ClassName>(checkId)
            obj = obj@ModelAdvisor.EdittimeCheck(checkId);
            obj.traversalType = edittimecheck.TraversalTypes.BLKITER;
        end

        function violation = blockDiscovered(obj, blk)
            violation = [];
            %% --- CHECK LOGIC: detect violation, create ResultDetail with 'SID' ---
        end

        function violation = finishedTraversal(obj)
            violation = [];
        end

        function success = fix(obj, violation)
            success = true;
            %% violation.Data contains the SID set during blockDiscovered.
            % set_param(violation.Data, '<Param>', '<FixedValue>');
        end
    end
end
```

## Template: ACTIVEGRAPH (cross-block comparison)

```matlab
classdef <ClassName> < ModelAdvisor.EdittimeCheck
    properties
        %% Accumulate state during traversal
    end

    methods
        function obj = <ClassName>(checkId)
            obj = obj@ModelAdvisor.EdittimeCheck(checkId);
            obj.traversalType = edittimecheck.TraversalTypes.ACTIVEGRAPH;
        end

        function violation = blockDiscovered(obj, blk)
            violation = [];
            %% Gather data into properties. Do NOT create violations here.
        end

        function violation = finishedTraversal(obj)
            violation = [];
            %% Compare accumulated data and create violation if needed.
            %% Reset properties for next traversal.
        end
    end
end
```

## Example: Trigger Block Position (ACTIVEGRAPH)

```matlab
classdef TriggerBlockPosition < ModelAdvisor.EdittimeCheck
    properties
        TriggerBlock = [];
        position = [];
    end

    methods
        function obj=TriggerBlockPosition(checkId)
            obj=obj@ModelAdvisor.EdittimeCheck(checkId);
            obj.traversalType = edittimecheck.TraversalTypes.ACTIVEGRAPH;
        end

        function violation = blockDiscovered(obj, blk)
            violation = [];
            if strcmp(get_param(blk,'BlockType'),'TriggerPort')
                obj.TriggerBlock = blk;
            else
                h = get_param(blk,'Position');
                obj.position = [obj.position, h(2)];
            end
        end

        function violation = finishedTraversal(obj)
            violation = [];
            if isempty(obj.TriggerBlock)
                return;
            end
            triggerPosition = get_param(obj.TriggerBlock,'Position');
            if min(obj.position) < triggerPosition(2)
                violation = ModelAdvisor.ResultDetail;
                ModelAdvisor.ResultDetail.setData(violation,'SID',...
                    Simulink.ID.getSID(obj.TriggerBlock));
                violation.CheckID = obj.checkId;
                violation.title = 'Trigger Block Position';
                violation.Description = 'Trigger Block should be top block in subsystem';
                violation.ViolationType = 'warn';
            end
            obj.TriggerBlock = [];
            obj.position = [];
        end
    end
end
```

## ResultDetail.setData Type Options

| Type | Use For | Example |
|------|---------|---------|
| `'SID'` | Blocks | `setData(v, 'SID', Simulink.ID.getSID(blk))` |
| `'Signal'` | Signal lines | `setData(v, 'Signal', dstPortHandle)` |

----

Copyright 2026 The MathWorks, Inc.

----
