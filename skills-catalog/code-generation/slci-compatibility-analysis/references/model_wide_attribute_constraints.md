# SLCI Model-Wide Attribute Constraints

## 1. Unconnected Objects — Nonfatal

**Constraint:** There must not be unconnected lines, input ports, or output ports in the model.

**Why:** Unconnected ports cause Simulink to insert hidden Ground or Terminator blocks that produce code with no visible model element. This breaks traceability and introduces dead code that cannot be verified.

**Fix:**
```matlab
% Find and remove unconnected lines
lines = find_system(modelName, 'FindAll', 'on', 'Type', 'line');
for i = 1:numel(lines)
    if get_param(lines(i), 'DstPortHandle') == -1
        delete_line(lines(i));
    end
end
```

---

## 2. Unsupported Blocks — Nonfatal

**Constraint:** The model must not contain blocks that are not supported by Simulink Code Inspector.

**Why:** Unsupported blocks produce code patterns that SLCI cannot systematically trace to model elements. Without a known code generation template, SLCI cannot guarantee faithful implementation of block semantics.

**Fix:**
```matlab
% Check which blocks are unsupported
c = slci.Configuration(modelName);
results = c.checkCompatibility();
% Inspect results.CheckResults for unsupported block entries,
% then replace unsupported blocks with supported equivalents.
```

---

## 3. Storage Classes for Workspace Variables — Nonfatal

**Constraint:** Custom storage class Type must be Unstructured or FlatStructure, must be a supported built-in type, and if Data Scope is Auto, must be reusable. Supported: Global, Const, Volatile, ConstVolatile, Define, ImportedDefine, ExportToFile, GetSet, ImportFromFile, Reusable.

**Why:** Unsupported storage classes produce code patterns that SLCI cannot reliably map to model parameters. Structured classes create nested data hierarchies that break one-to-one traceability. Auto-scoped non-reusable variables produce ambiguous code placement.

**Fix:**
```matlab
% Change storage class to a supported type
myParam = Simulink.Parameter(2.0);
myParam.CoderInfo.StorageClass = 'Custom';
myParam.CoderInfo.CustomStorageClass = 'ExportToFile';

% Or use a simple built-in storage class
myParam.CoderInfo.StorageClass = 'ExportedGlobal';
```

---

## 4. GetSet Custom Storage Classes for Workspace Variables — Nonfatal

**Constraint:** Must have a header file defined. The data type must not be bus or struct.

**Why:** Without a header file, SLCI cannot confirm that the get/set interface is properly declared. Bus or struct types produce complex accessor patterns that create multi-level indirection SLCI cannot reliably inspect.

**Fix:**
```matlab
myParam = Simulink.Parameter(5.0);
myParam.CoderInfo.StorageClass = 'Custom';
myParam.CoderInfo.CustomStorageClass = 'GetSet';
myParam.CoderInfo.CustomAttributes.HeaderFile = 'myParam_access.h';
myParam.DataType = 'double';  % Must be primitive, not bus
```

---

## 5. Usage of Sample Times — FATAL

**Constraint:** The model cannot use continuous, explicit discrete partition, data driven, union, or variable sample times.

**Why:** Continuous sample times require ODE solvers whose infrastructure code cannot be traced to individual blocks. Variable and data-driven sample times produce conditional execution logic that cannot be statically inspected. The solver dominates the code architecture, making block-level inspection impossible.

**Fix:**
```matlab
set_param(modelName, 'SolverType', 'Fixed-step');
set_param(modelName, 'Solver', 'FixedStepDiscrete');
set_param([modelName '/MyBlock'], 'SampleTime', '0.01');
```

---

## 6. Explicit Partitions — FATAL

**Constraint:** The model must not contain explicit partitions.

**Why:** Explicit partitions create scheduling infrastructure and inter-partition communication code that has no corresponding model block. SLCI cannot trace rate-transfer buffers and synchronization logic to any visible element.

**Fix:**
```matlab
% Remove explicit partitions; use rate-based multirate modeling instead
set_param(modelName, 'EnableMultiTasking', 'on');
```

---

## 7-8. Automatic Insertion of Blocks During Model Compilation and Code Generation — Nonfatal

**Constraint:** Automatic insertion of Signal Conversion, Rate Transition, Data Type Conversion, Delay, or Unit Delay blocks on signals entering block inports during model compilation (7) or code generation (8) is not supported.

**Why:** Automatically inserted hidden blocks produce code with no corresponding block in the diagram. Rate Transition blocks create buffer code, Signal Conversion blocks create data copies, and Unit Delay blocks create state variables -- all invisible to the reviewer, breaking traceability.

**Fix:**
```matlab
% Explicitly add the required blocks to the model
add_block('simulink/Signal Attributes/Signal Conversion', ...
    [modelName '/SignalConversion1']);
set_param([modelName '/SignalConversion1'], 'ConversionOutput', 'Signal copy');
set_param([modelName '/SignalConversion1'], 'OverrideOpt', 'on');
% For Rate Transition or Data Type Conversion, add similarly:
add_block('simulink/Signal Attributes/Rate Transition', ...
    [modelName '/RateTransition1']);
add_block('simulink/Signal Attributes/Data Type Conversion', ...
    [modelName '/DTC1']);
```

---

## 9. Fixed-Point Instrumentation and Block Reduction Both Selected — Nonfatal

**Constraint:** Simultaneous use of fixed-point instrumentation (overflow logging) and block reduction is not supported.

**Why:** Block reduction removes redundant blocks from code while fixed-point instrumentation adds logging code that references those same blocks. When both are active, reduced blocks have no code to instrument, creating an inconsistent mapping.

**Fix:**
```matlab
% Disable one of the two features:
set_param(modelName, 'BlockReduction', 'off');
% or
set_param(modelName, 'MinMaxOverflowLogging', 'UseLocalSettings');
```

---

## 10. Root Outport Block Sample Times — Nonfatal

**Constraint:** Root Outport blocks must not have constant sample time.

**Why:** When a root outport has constant sample time, its assignment moves to the initialize function rather than the step function. SLCI expects output assignments in the step function where block execution is verified.

**Fix:**
```matlab
set_param([modelName '/Out1'], 'SampleTime', '0.01');
```

---

## 11. Root Output Block Bus Passing Method — Nonfatal

**Constraint:** A root Outport block that passes a bus to a parent model must pass the bus as a structure (BusOutputAsStruct selected).

**Why:** When a bus is passed as individual elements, the function interface does not reflect the bus definition visible in the model. Structure passing preserves bus hierarchy in code, enabling SLCI to map struct fields directly to the bus object definition.

**Fix:**
```matlab
set_param([modelName '/Out1'], 'BusOutputAsStruct', 'on');
```

---

## 12. Root Outport Block with Non-Auto Storage Classes — Nonfatal

**Constraint:** When root outports have non-auto storage classes, "Pass reusable subsystem outputs as" must be set to "Individual arguments."

**Why:** Non-auto storage classes define explicit code placement for outport variables. When outputs are bundled into a struct via "Structure reference," this conflicts with the explicit storage class. SLCI cannot reconcile the declared storage class with the actual code generation pattern.

**Fix:**
```matlab
set_param(modelName, 'PassReuseOutputArgsAs', 'Individual arguments');
```

---

## 13. Automatic Virtual to Nonvirtual Bus Conversion — FATAL

**Constraint:** Automatic conversion between virtual and nonvirtual buses is not supported. It creates a hidden Signal Conversion block.

**Why:** Automatic conversion inserts a hidden Signal Conversion block that performs a memory copy from scattered signals into a contiguous struct. This hidden block produces code with no corresponding visible element, fundamentally altering the data flow architecture.

**Fix:**
```matlab
% Option 1: Make the Bus Creator output nonvirtual
set_param([modelName '/BusCreator1'], 'NonVirtualBus', 'on');

% Option 2: Add explicit Signal Conversion block visible in model
add_block('simulink/Signal Attributes/Signal Conversion', ...
    [modelName '/BusConversion']);
```

---

## 14. Block Operations on a Bus — FATAL

**Constraint:** Merge block must not operate on a virtual bus. Bus Assignment block must not operate on a nonvirtual bus.

**Why:** Merge blocks on virtual buses produce element-wise conditional assignments rather than clean structure copies, making tracing impossible. Bus Assignment on nonvirtual buses requires partial structure writes that break traceability. The wrong combination produces fundamentally unverifiable code.

**Fix:**
```matlab
% For Merge blocks: use nonvirtual buses
set_param([modelName '/BusCreator1'], 'NonVirtualBus', 'on');

% For Bus Assignment: use virtual buses
set_param([modelName '/BusCreator1'], 'NonVirtualBus', 'off');
```

---

## 15. Data Type Replacement — Nonfatal

**Constraint:** Replacement names in Data Type Replacement table must be Simulink Names or of type Simulink.AliasType.

**Why:** Simulink.AliasType creates a verifiable typedef chain from the replacement name to the base type. Arbitrary replacement strings produce type names that SLCI cannot resolve or validate, breaking type equivalence verification.

**Fix:**
```matlab
MY_FLOAT_TYPE = Simulink.AliasType;
MY_FLOAT_TYPE.BaseType = 'double';
```

---

## 16. Sample Times for Model Used as Model Reference Target — Nonfatal

**Constraint:** A model used as a model reference target must not have multiple sample times.

**Why:** Multiple sample times in a referenced model create multiple step functions and rate-transition logic. SLCI cannot trace the rate-scheduling infrastructure to model elements. Single-rate models produce one step function with a clear block-to-code mapping.

**Fix:**
```matlab
% Ensure all blocks in the referenced model use the same sample time
set_param([refModelName '/Block1'], 'SampleTime', '0.01');
set_param([refModelName '/Block2'], 'SampleTime', '0.01');
```

---

## 17. Commented-Out Blocks — Nonfatal

**Constraint:** The model must not contain commented-out blocks.

**Why:** Commented-out blocks are visible model elements with no code counterpart, creating an incomplete mapping. Their presence introduces ambiguity about intended functionality and makes equivalence checking fail.

**Fix:**
```matlab
commentedBlocks = find_system(modelName, 'Commented', 'on');
for i = 1:numel(commentedBlocks)
    delete_block(commentedBlocks{i});
end
```

---

## 18. Function Names for Noninlined Subsystems with Void-Void Function Call Interfaces — FATAL

**Constraint:** Noninlined subsystems with void-void function call interfaces must use unique function names.

**Why:** SLCI traces each function in generated code to exactly one subsystem. Duplicate function names make this mapping ambiguous. Void-void interfaces have no argument signatures to disambiguate, so the name is the only identifier.

**Fix:**
```matlab
set_param([modelName '/Subsystem_A'], 'RTWFcnName', 'subsystem_a_func');
set_param([modelName '/Subsystem_B'], 'RTWFcnName', 'subsystem_b_func');
```

---

## 19. Synthesized Local Data Stores — Nonfatal

**Constraint:** Must not use signal objects referenced as synthesized local data stores by Data Store Read/Write blocks.

**Why:** Synthesized data stores have no corresponding Data Store Memory block in the model. SLCI requires every variable declaration to trace to a visible model element. Signal objects used as synthesized data stores create implicit state that appears in code but not in the diagram.

**Fix:**
```matlab
add_block('simulink/Signal Routing/Data Store Memory', ...
    [modelName '/DSMemory']);
set_param([modelName '/DSMemory'], 'DataStoreName', 'mySignalObj');
```

---

## 20. Reusable Subsystems — Nonfatal

**Constraint:** Reusable subsystems with the same function interface must come from the same library blocks.

**Why:** Reusable subsystems share a single generated function. If subsystems have the same interface but potentially different internal logic (because they are not library links), the shared function may not correctly represent all instances. Library blocks guarantee identical internal structure.

**Fix:**
```matlab
% Create a library block and use it for all instances,
% or make each subsystem non-reusable:
set_param([modelName '/Subsystem_Copy1'], ...
    'TreatAsAtomicUnit', 'on', ...
    'RTWSystemCode', 'Nonreusable function');
```

---

## 21. Code Mappings Settings — Nonfatal

**Constraint:** In Code Mappings Editor, each model element category must use the Default storage class setting.

**Why:** Non-default category settings apply storage classes implicitly to all elements in that category. This prevents SLCI from verifying per-element configuration intent, because the code pattern comes from a category rule rather than an explicit element-level decision.

**Fix:**
```matlab
cm = coder.mapping.api.get(modelName);
categories = getDataCategories(cm);
for i = 1:numel(categories)
    setDataDefault(cm, categories{i}, 'StorageClass', 'Default');
end
```

---

## 22. Signals in the Code Mappings Editor — Nonfatal

**Constraint:** Signal identifiers must match signal names. Signals must use supported storage classes: Auto, Model Default, ExportedGlobal, ImportedExtern, ImportedExternPointer, Volatile, ExportToFile, ImportFromFile, FileScope, GetSet, Reusable.

**Why:** SLCI traces signals by name between model and code. Mismatched identifiers break this link. Only supported storage classes produce code patterns SLCI knows how to verify.

**Fix:**
```matlab
cm = coder.mapping.api.get(modelName);
setSignal(cm, signalHandle, 'Identifier', 'sig_a');
setSignal(cm, signalHandle, 'StorageClass', 'ExportedGlobal');
```

---

## 23. Graphical Sorted Order — Nonfatal

**Constraint:** The compiled block list of a model must match the graphical block sorted order.

**Why:** SLCI verifies code statement order against the model's visual block layout. If compiled execution order differs from graphical sorted order, code appears in an unexpected sequence relative to the diagram, preventing deterministic correspondence.

**Fix:**
```matlab
% Display sorted execution order:
% Simulink Editor > Display > Blocks > Sorted Execution Order
% Rearrange blocks so graphical layout matches execution order
```

---

## 24. Code Generation Symbols Settings for Shared Utilities — Nonfatal

**Constraint:** Local temporary variables must use format `$N$M`. Shared utilities identifier must use format `$N$C`.

**Why:** `$N$M` for locals ensures block name and port mapping are embedded in variable names. `$N$C` for shared utilities includes the checksum for unique identification. Custom formats prevent SLCI from reliably matching code symbols to model elements.

**Fix:**
```matlab
set_param(modelName, 'CustomSymbolStrTmpVar', '$N$M');
set_param(modelName, 'CustomSymbolStrUtil', '$N$C');
```

---

## 25. Library Standard Setting for Shared Utilities — Nonfatal

**Constraint:** Language standard must be C89/C90 (ANSI) or C99 (ISO).

**Why:** SLCI's code analysis engine supports C89/C90 and C99 patterns. C11 and later standards introduce constructs (e.g., `_Generic`, `alignas`) that SLCI's parser does not recognize.

**Fix:**
```matlab
set_param(modelName, 'TargetLangStandard', 'C89/C90 (ANSI)');
% or
set_param(modelName, 'TargetLangStandard', 'C99 (ISO)');
```

---

## 26. Code Style Settings for Shared Utilities — Nonfatal

**Constraint:** Parentheses level must be Nominal, Standards, or Maximum. Casting modes must be Standards Compliant.

**Why:** Minimum parenthesization relies on operator precedence rules, making expression parsing ambiguous. Standards-compliant casting ensures all type conversions are explicit and verifiable. SLCI needs deterministic, unambiguous code style.

**Fix:**
```matlab
set_param(modelName, 'ParenthesesLevel', 'Nominal');
set_param(modelName, 'CastingMode', 'Standards Compliant');
```

---

## 27. Model Arguments — Nonfatal

**Constraint:** Model arguments must not have a storage class.

**Why:** Model arguments are passed from parent to referenced model through the model interface. A storage class forces the parameter into a specific memory location, creating a conflict with the argument-passing mechanism that SLCI cannot resolve.

**Fix:**
```matlab
Kp = Simulink.Parameter(1.0);
Kp.CoderInfo.StorageClass = 'Auto';  % Must be Auto for model arguments
```

---

## 28. Shared Embedded Coder Dictionary Configuration — FATAL

**Constraint:** Model must not be linked to a shared Embedded Coder Dictionary with a service code interface configuration.

**Why:** Service code interface configurations generate middleware abstraction code (e.g., Rte_Read, Rte_Write). SLCI cannot trace service API calls back to standard Simulink inport/outport blocks because the code paradigm is entirely different from direct memory access.

**Fix:**
```matlab
% Option 1: Remove dictionary link
set_param(modelName, 'DataDictionary', '');

% Option 2: Use a dictionary without service interface (set to 'Default')
```

---

## 29. Usage of 64-bit Integer Data Types — Nonfatal

**Constraint:** Models using int64/uint64 must have "Support long long" selected OR "Number of bits: long" set to 64 in hardware settings.

**Why:** Without `long long` support or 64-bit `long`, the target may not have a native 64-bit integer type. SLCI cannot verify correct behavior of 64-bit operations if the generated type definition does not actually provide 64 bits.

**Fix:**
```matlab
set_param(modelName, 'ProdLongLongMode', 'on');
```

---

## 30. Usage of String Data Types — Nonfatal

**Constraint:** Models using string data types must have Language set to C.

**Why:** SLCI supports string data type inspection only for C language code generation. C generates character array operations that SLCI can verify. C++ uses std::string with operator overloading and heap allocation patterns that SLCI cannot trace.

**Fix:**
```matlab
set_param(modelName, 'TargetLang', 'C');
```

---

## 31. Usage of Code Replacement Libraries (CRLs) — Nonfatal

**Constraint:** CRLs must only replace supported math functions, memory functions, and operators.

**Why:** SLCI understands code replacement patterns for standard math functions, memory functions, and basic operators. For these, SLCI can verify that replacement semantics match the original block operation. Custom replacements for unsupported operations produce unmappable code.

**Fix:**
```matlab
% Only use CRLs for supported categories:
% Math: sin, cos, tan, sqrt, abs, exp, log, pow, etc.
% Memory: memcpy, memset, memcmp
% Operators: +, -, *, /, shift, cast
set_param(modelName, 'CodeReplacementLibrary', 'None');
```

---

## 32. Lookup Table Dynamic — FATAL

**Constraint:** Models must not use unsupported Lookup Table Dynamic blocks.

**Why:** Lookup Table Dynamic blocks accept table data and breakpoints as runtime inputs rather than fixed parameters. SLCI cannot statically verify lookup operations when the table structure varies at runtime. The generated interpolation code uses complex algorithmic patterns outside SLCI's verification capability.

**Fix:**
```matlab
% Replace Lookup Table Dynamic with standard n-D Lookup Table
% that uses fixed (parameter) breakpoint and table data
add_block('simulink/Lookup Tables/n-D Lookup Table', ...
    [modelName '/LUT']);
```

---

## 33. Usage of Export-Function Model — Nonfatal

**Constraint:** Export-function models must not use multiple sample times, S-functions, Simulink functions, or Merge blocks at the top level.

**Why:** Multiple sample times require rate scheduling logic with no model representation. S-functions generate opaque wrapper code. Simulink functions and Merge blocks at the top level create interfaces and data flows outside SLCI's verification scope.

**Fix:**
```matlab
% Use single sample time across all function-call subsystems
set_param([modelName '/Subsystem2'], 'SampleTime', '0.01');

% Remove S-functions and top-level Merge blocks
% Move Simulink functions inside subsystems
```

----

Copyright 2026 The MathWorks, Inc.

----
