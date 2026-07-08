# Data Types & Workspace Resolution API Patterns

Non-obvious patterns for resolving data types and variables in check logic. Assumes familiarity with `get_param(blk, 'OutDataTypeStr')` and compiled port data types.

---

## Alias Type Resolution

Simulink.AliasType wraps another type. Resolve the chain to get the base type:
```matlab
function baseType = resolveAliasType(typeObj)
    while isa(typeObj, 'Simulink.AliasType')
        baseTypeName = typeObj.BaseType;
        if existsInGlobalScope(bdroot, baseTypeName)
            typeObj = getVarFromGlobalScope(bdroot, baseTypeName);
        else
            baseType = baseTypeName;
            return;
        end
    end
    if isa(typeObj, 'Simulink.NumericType')
        baseType = typeObj.DataTypeMode;
    else
        baseType = typeObj;
    end
end
```

---

## Variable Resolution (Global Scope)

These are undocumented but widely-used functions that resolve across base workspace and data dictionaries:

```matlab
% Check if variable exists
if existsInGlobalScope(bdroot(system), varName)
    val = getVarFromGlobalScope(bdroot(system), varName);
end
```
> **Note:** `existsInGlobalScope` and `getVarFromGlobalScope` are undocumented. Safer alternative: `Simulink.findVars` or `evalin('base', ...)`.

---

## slResolve — Resolve in Block Context

Resolves a variable name using the workspace hierarchy visible to a specific block (mask workspace → model workspace → base workspace):
```matlab
val = slResolve(varName, blk);
```

Use when a block parameter contains a variable name (e.g., Gain = `'K'`) and you need the numeric value.

---

## Data Dictionary

```matlab
dictName = get_param(bdroot(system), 'DataDictionary');
if ~isempty(dictName)
    dd = Simulink.data.dictionary.open(dictName);
    sect = getSection(dd, 'Design Data');
    entries = find(sect);
end
```

---

## Simulink.data.DataAccessor — Unified Access

Searches across all data sources (dictionaries + workspaces):
```matlab
da = Simulink.data.DataAccessor.create(bdroot(system));
entry = da.identifyByName(typeName);
val = da.getVariable(entry);
```

