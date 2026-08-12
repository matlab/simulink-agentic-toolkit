---
type: api-reference
triggers: [blocks, find_system, get_param, block_properties, SID, compiled]
tags: [api, blocks, find_system, compiled-properties, simulink-id]
related:
  - apis/signals.md
  - apis/framework.md
  - patterns/standard.md
---
# Blocks API Patterns

API patterns for Simulink blocks in Model Advisor check logic. Assumes familiarity with `find_system` and `get_param`.

---

## Compiled Properties (PostCompile Only)

These require `'PostCompile'` callback context:
```matlab
compiledTypes = get_param(blk, 'CompiledPortDataTypes');
% compiledTypes.Inport{1}, compiledTypes.Outport{1}

compiledST = get_param(blk, 'CompiledSampleTime');

% Compiled bus type on a port handle
busType = get_param(portHandle, 'CompiledBusType');
% Returns: 'NON_VIRTUAL_BUS', 'VIRTUAL_BUS', or 'NOT_BUS'

compiledDT = get_param(portHandle, 'CompiledPortDataType');
```

---

## Block Identity — Simulink ID (SID)

```matlab
sid = Simulink.ID.getSID(blk);            % block handle or path -> SID string
handle = Simulink.ID.getHandle(sid);       % SID -> object handle
fullName = Simulink.ID.getFullName(sid);   % SID -> full block path
fullPath = getfullname(blockHandle);       % numeric handle -> full path string
```

---

## Reporting Block Violations

### In standard checks (ResultDetail with SID)
```matlab
ElementResults(1, i) = ModelAdvisor.ResultDetail;
ModelAdvisor.ResultDetail.setData(ElementResults(i), 'SID', violationBlks{i});
ElementResults(i).Description = 'Description of violation';
ElementResults(i).Status = 'Status message';
ElementResults(i).RecAction = 'Recommended action';
```

### In edit-time checks
```matlab
violation = ModelAdvisor.ResultDetail;
ModelAdvisor.ResultDetail.setData(violation, 'SID', Simulink.ID.getSID(blk));
violation.CheckID = obj.checkId;
violation.Title = 'Violation Title';
violation.Description = 'What was violated';
violation.ViolationType = 'warn';
```

----

Copyright 2026 The MathWorks, Inc.

----
