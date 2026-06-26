# Signals API Patterns

API patterns for signal line checks in Model Advisor. Focuses on reporting distinctions and edge cases — assumes familiarity with `find_system(..., 'Type', 'line')` and line handle properties.

---

## Common Signal Check Pattern

```matlab
if strcmp(get_param(blk, 'BlockType'), 'Outport')
    ports = get_param(blk, 'Ports');
    lh = get_param(blk, 'LineHandles');
    for j = 1:ports(1)
        if lh.Inport(j) ~= -1
            lh_obj = get_param(lh.Inport(j), 'Object');
            if isempty(lh_obj.Name)
                % Signal has no label — violation
            end
        end
    end
end
```

---

## Reporting Signal Violations

**Critical distinction:** Use `'Signal'` type (not `'SID'`) with the **destination port handle** to highlight the signal line on canvas. Using `'SID'` would highlight the block instead.

### In standard checks (report the block that owns the signal)
```matlab
ModelAdvisor.ResultDetail.setData(ElementResults(i), 'SID', blockSID);
```

### In edit-time checks (highlight the signal line)
```matlab
hiliteHandle = get_param(lineHandle, 'DstPortHandle');

violation = ModelAdvisor.ResultDetail;
ModelAdvisor.ResultDetail.setData(violation, 'Signal', hiliteHandle);
violation.CheckID = obj.checkId;
violation.Title = 'Signal Label Missing';
violation.Description = 'Signal does not have a label.';
violation.ViolationType = 'warn';
```

### Bus Element Port detection (common edge case)
```matlab
allsources_parent = get_param(srcPort, 'Parent');
if strcmp(get_param(allsources_parent, 'BlockType'), 'Inport')
    isBusElement = get_param(allsources_parent, 'IsBusElementPort');
else
    isBusElement = 'off';
end
```
