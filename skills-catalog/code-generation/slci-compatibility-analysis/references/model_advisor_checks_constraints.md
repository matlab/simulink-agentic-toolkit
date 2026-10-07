# Model Advisor Checks Constraints

Use Simulink Code Inspector Model Advisor checks to configure your model for
code inspection. A subset of checks support edit-time checking, though
edit-time checking does not flag all constraint violations.

---

## Chapter 6: Simulink Code Inspector Checks

### 1. Check for unsupported Code Mappings settings

**Check ID:** `mathworks.slci.CodeMappingDefaults`

**Verifies:** Default storage class is used for each model element category on the Data Defaults tab.

**Severity:** Nonfatal

**Key finding if fails:** Category-wide storage class overrides prevent SLCI from verifying per-element configuration intent.

**Fix:**
```matlab
cm = coder.mapping.api.get(model);
setDataDefault(cm, 'Inports', 'StorageClass', 'Default');
setDataDefault(cm, 'Outports', 'StorageClass', 'Default');
setDataDefault(cm, 'Signals', 'StorageClass', 'Default');
setDataDefault(cm, 'ModelParameters', 'StorageClass', 'Default');
setDataDefault(cm, 'LocalData', 'StorageClass', 'Default');
```

---

### 2. Check for unsupported usage of signals in Code Mappings editor

**Check ID:** `mathworks.slci.CodeMappingSignals`

**Verifies:** Signal identifiers match signal names; signals use supported storage classes.

**Severity:** Nonfatal

**Key finding if fails:** Code variable names don't match model signal labels, breaking name-based traceability.

**Fix:**
```matlab
cm = coder.mapping.api.get('myModel');
setSignal(cm, signalHandle, 'Identifier', 'ctrl_error');
setSignal(cm, signalHandle, 'StorageClass', 'ExportedGlobal');
```

---

### 3. Check model for compiled and graphical block sorted order

**Check ID:** `mathworks.slci.BlockSortedOrder`

**Verifies:** Blocks in the compiled block list follow graphical sorted order.

**Severity:** Nonfatal

**Key finding if fails:** Block comment sequence in code does not match visual diagram layout, breaking SLCI's one-to-one correspondence verification.

---

### 4. Verify 'Generate an example main program' setting of multirate models

**Check ID:** `mathworks.slci.MultirateModel`

**Verifies:** Generate an example main program is selected for multirate models.

**Severity:** Nonfatal

**Key finding if fails:** Generated code lacks rate scheduling context SLCI needs to verify step function invocation and rate transition protection.

**Fix:**
```matlab
set_param('myModel', 'GenerateSampleERTMain', 'on');
```

---

### 5. Check model for void_void subsystems that use the same function name

**Check ID:** `mathworks.slci.VVSubSystemName`

**Verifies:** Noninlined subsystems with void-void function call interfaces use unique function names.

**Severity:** FATAL

**Key finding if fails:** SLCI cannot unambiguously trace a function to a single subsystem when names collide.

**Fix:**
```matlab
set_param('model/Subsystem1', 'FunctionName', 'controller_step');
set_param('model/Subsystem2', 'FunctionName', 'monitor_step');
```

---

### 6. Check n-D Lookup Table blocks for incompatible breakpoint data type

**Check ID:** `mathworks.slci.LookupndBreakpointsDataType`

**Verifies:** Breakpoint data type and input data type of n-D Lookup Table blocks are the same.

**Severity:** Nonfatal

**Key finding if fails:** Type mismatch inserts a cast before comparison, breaking SLCI's expected binary search pattern verification.

**Fix:**
```matlab
set_param('model/1-D Lookup Table', 'BreakpointsForDimension1DataTypeStr', ...
    'Inherit: Same as corresponding input');
```

---

### 7. Check model for reusable subsystems that use the same function interfaces

**Check ID:** `mathworks.slci.ReuseSubSystemLibrary`

**Verifies:** Reusable subsystems with the same function interface are from the same library blocks.

**Severity:** Nonfatal

**Key finding if fails:** SLCI cannot determine which library block a shared function implements when sources differ.

---

### 8. Check for usage of shared synthesized local data stores

**Check ID:** `mathworks.slci.SharedSynthLocalDSM`

**Verifies:** No signal objects in model workspace used as synthesized local data stores.

**Severity:** Nonfatal

**Key finding if fails:** Generated code contains a global variable with no visible graphical block to trace to.

---

### 9. Check usage of Source blocks

**Check ID:** `mathworks.slci.SourcesBlocksUsage`

**Verifies:** Inport, Constant, and Ground blocks meet SLCI compatibility rules.

**Severity:** Nonfatal

**Key conditions:** Variable-size signal, complex signal type, frame-based sampling, bus object without nonvirtual output, latch input by delaying, non-Auto storage class, empty/nonfinite/complex constant values.

**Edit-Time Checking:** Supported (partial).

---

### 10. Check usage of Signal Routing blocks

**Check ID:** `mathworks.slci.SignalRoutingBlocksUsage`

**Verifies:** Bus Creator, Bus Selector, Bus Assignment, Data Store Memory/Read/Write, From/Goto, Merge, Switch, Multiport Switch, Mux, Demux, Selector, State Reader/Writer, Vector Concatenate blocks.

**Severity:** Nonfatal

**Key conditions:** Input name mismatches, complex/nonfinite/string data stores, Write After Write not error, discontinuous selection, unequal port widths in Merge, data type mismatches in Switch/Multiport Switch, unsupported index options in Selector.

**Edit-Time Checking:** Supported (partial).

---

### 11. Check usage of Math Operation blocks

**Check ID:** `mathworks.slci.MathOperationsBlocksUsage`

**Verifies:** Abs, Bias, Gain, Math, Product, Sum, Trigonometry, MinMax, Rounding, Reshape, Sign, Sqrt, Assignment, Polynomial, Dot Product, Unary Minus blocks.

**Severity:** Nonfatal

**Key conditions:** Input/output data type mismatches, empty/nonfinite/complex parameter values, unsupported rounding modes (must be Zero or Floor), unsupported multiplication types, constant sample time, unsupported functions.

**Edit-Time Checking:** Supported (partial).

---

### 12. Check usage of Signal Attribute blocks

**Check ID:** `mathworks.slci.SignalAttributesBlocksUsage`

**Verifies:** Data Type Conversion, Data Type Duplicate/Propagation, Signal Specification/Conversion, Rate Transition, Probe, Width, Unit Conversion, IC blocks.

**Severity:** Nonfatal

**Key conditions:** Unsupported rounding, constant sample time, variable-size/complex/frame-based signals, Rate Transition without data integrity/determinism, missing initial conditions.

**Edit-Time Checking:** Supported (partial).

---

### 13. Check usage of Logic and Bit Operation blocks

**Check ID:** `mathworks.slci.LogicalandBitOperationsBlocksUsage`

**Verifies:** Relational Operator, Logical Operator, Bitwise Operator, Shift Arithmetic, Combinatorial Logic, Extract Bits blocks.

**Severity:** Nonfatal

**Key conditions:** Non-boolean/enum outputs, mismatched input types, isInf/isNaN/isFinite operators, OOR diagnostic not Error, binary points not 0, unsupported input types for Extract Bits.

**Edit-Time Checking:** Supported (partial).

---

### 14. Check usage of Lookup Table blocks

**Check ID:** `mathworks.slci.LookupTablesBlocksUsage`

**Verifies:** Lookup Table, Lookup Table Dynamic, Prelookup, Interpolation Using Prelookup blocks.

**Severity:** Nonfatal (Dynamic is FATAL)

**Key conditions:** Breakpoints spec not Explicit values, interpolation not Linear point-slope, extrapolation not Clip/Linear, index search not Binary/Linear, tunable table size, source set to Input port, index not uint32 for Prelookup.

**Edit-Time Checking:** Supported (partial).

---

### 15. Check usage of User-Defined Function blocks

**Check ID:** `mathworks.slci.UserDefinedFunctionBlocksUsage`

**Verifies:** C Caller, Function Caller, Simulink Function, S-Function blocks.

**Severity:** Nonfatal

**Key conditions:** Unsupported data types for ports, S-Function not created with Legacy Code Tool, non-scalar/fixed-vector arguments, more than one dwork, complex/nonfinite parameters.

**Edit-Time Checking:** Supported (partial).

---

### 16. Check usage of Port and Subsystem blocks

**Check ID:** `mathworks.slci.PortsandSubsystemsBlocksUsage`

**Verifies:** Enable, Model, Subsystem, Trigger, Action Port, If, Function-Call Generator/Split, Switch Case, For/While/For Each Iterator, Event Listener blocks.

**Severity:** Nonfatal

**Key conditions:** Non-boolean enable signals, protected model mode, export-function model references, variant ports mismatch, masked reusable with nonreusable, function packaging restrictions, constant source with inlined parameters.

**Edit-Time Checking:** Supported (partial).

---

### 17. Check usage of Discontinuity blocks

**Check ID:** `mathworks.slci.DiscontinuitiesBlocksUsage`

**Verifies:** Saturate, Relay, Dead Zone blocks.

**Severity:** Nonfatal

**Key conditions:** Input/output type mismatch, empty/nonfinite/complex limit values, saturate on integer overflow for Dead Zone.

**Edit-Time Checking:** Supported (partial).

---

### 18. Check usage of Sink blocks

**Check ID:** `mathworks.slci.SinksBlocksUsage`

**Verifies:** Outport and Terminator blocks.

**Severity:** Nonfatal

**Key conditions:** Variable-size signal, complex signal type, frame-based sampling, non-empty root initial output, source of initial output not Dialog, non-Auto storage class.

**Edit-Time Checking:** Supported (partial).

---

### 19. Check usage of Discrete blocks

**Check ID:** `mathworks.slci.DiscreteBlocksUsage`

**Verifies:** Discrete Derivative, Discrete Filter, Discrete Transfer Fcn, Unit Delay, Discrete-Time Integrator, Delay, Discrete FIR Filter, Rate Limiter, Weighted Sample Time Math blocks.

**Severity:** Nonfatal

**Key conditions:** Non-single/double inputs, unsupported filter structures, rounding not Floor/Zero, lock scale selected, frame-based input processing, empty/nonfinite/complex initial conditions, int64 type mismatches, string type ports, continuous sample time mode.

**Edit-Time Checking:** Supported (partial).

---

### 20. Check usage of String blocks

**Check ID:** `mathworks.slci.StringBlocksUsage`

**Verifies:** ASCII to String, String Length, String Compare, To String, String Constant, String Concatenate, Compose String blocks.

**Severity:** Nonfatal

**Key conditions:** Language set to C++ (must be C), buffer size issues, case sensitive not selected for String Compare, escape sequences in format strings.

**Edit-Time Checking:** Supported (partial).

---

### 21. Check usage of Stateflow blocks

**Check ID:** `mathworks.slci.StateflowBlocksUsage`

**Verifies:** Function packaging is Inline, Nonreusable function, or Reusable function.

**Severity:** Nonfatal

---

### 22. Check usage of Stateflow charts

**Check ID:** `mathworks.slci.chartsSFObjsUsage`

**Verifies:** Chart configuration and structural constraints.

**Severity:** Nonfatal

**Key conditions:** Atomic Boxes or Simulink-based states present, atomic subchart packaging set to Auto/Reusable, non-unique names in MATLAB action language, Create output for monitoring selected, Update method not Inherited, missing default transitions, Enable Super Step Semantics/Execute at initialization/Export chart level functions/Saturate on integer overflow selected, State Machine Type set to Moore, variable-size arrays, linked atomic subcharts, junctions merging transitions.

**Edit-Time Checking:** Supported (partial).

---

### 23. Check usage of Stateflow MATLAB action language

**Check ID:** `mathworks.slci.MATLABactionlanguageSFObjsUsage`

**Verifies:** MATLAB action language in Stateflow charts follows the same constraints as MATLAB Function blocks, except `while`, `break`, and tilde (`~`) are NOT supported in chart MATLAB code.

**Severity:** Nonfatal

**Additional restrictions:** Temporal logic operators other than `at` and `after` in state actions or transition paths.

---

### 24. Check usage of Stateflow transitions

**Check ID:** `mathworks.slci.transitionsSFObjsUsage`

**Verifies:** Transition actions, conditions, array indexing, data types, and function calls.

**Severity:** Nonfatal

**Key conditions:** Unsupported operations, multi-dim array indexing, non-int32 array indices, non-boolean conditions, context-sensitive constants, custom data access, enum arithmetic, event triggers, argument type/size mismatches, transition actions present, induction variable reuse, unsupported loop constructs, mixed-type binary operators, time access, variant transitions, temporal logic with explicit events.

---

### 25. Check usage of Stateflow junctions

**Check ID:** `mathworks.slci.junctionsSFObjsUsage`

**Verifies:** Junction structure and control flow patterns.

**Severity:** Nonfatal

**Key conditions:** Outgoing transitions jumping outside loop, non-terminating junctions without exactly one unconditional exit, history junctions, unsupported header junctions, terminating junctions tracing to state, unstructured control flows, unconditional transition not last in order.

---

### 26. Check usage of Stateflow data

**Check ID:** `mathworks.slci.dataSFObjsUsage`

**Verifies:** Data scope, types, initialization, and dimensions.

**Severity:** Nonfatal

**Key conditions:** Constant scope, InitializeMethod set to Parameter for Local/Output, data defined in states/boxes, non-builtin/enum/bus types, array of buses, enum default not 0, First Index not empty/0, size mismatches with workspace, complex data.

---

### 27. Check usage of Stateflow events

**Check ID:** `mathworks.slci.eventsSFObjsUsage`

**Verifies:** Event scope and triggers.

**Severity:** Nonfatal

**Key conditions:** Scope not Output or Local, trigger not function-call, unused data/events/messages/functions.

---

### 28. Check usage of Stateflow states

**Check ID:** `mathworks.slci.statesSFObjsUsage`

**Verifies:** State actions, control flow, and configuration.

**Severity:** Nonfatal

**Key conditions:** Control flow cycles, unsupported operations, multi-dim array indexing, non-int32 indices, missing default transitions for substates, enum operations, InlineOption set to Auto/Function, recursive send calls, Leaf state activity monitoring, time access, unstructured control flows, Log self activity + Test point both selected, temporal logic operators.

**Edit-Time Checking:** Supported (partial).

---

### 29. Check usage of Stateflow graphical functions

**Check ID:** `mathworks.slci.graphicalfunctionsSFObjsUsage`

**Verifies:** Graphical function structure and configuration.

**Severity:** Nonfatal

**Key conditions:** Control flow cycles, InlineOption set to Auto, non-inlined packaging not Nonreusable function, non-unique names, recursive functions, unstructured control flows, calls to MATLAB functions.

---

### 30. Check usage of Stateflow truth tables

**Check ID:** `mathworks.slci.truthtablesSFObjsUsage`

**Verifies:** Truth table structure and configuration.

**Severity:** Nonfatal

**Key conditions:** Control flow cycles, InlineOption set to Auto/Function, recursive functions, unstructured control flows, calls to MATLAB functions.

---

### 31. Check usage of Stateflow atomic subcharts

**Check ID:** `mathworks.slci.atomicsubchartsSFObjsUsage`

**Verifies:** Atomic subchart configuration.

**Severity:** Nonfatal

**Key conditions:** Code generation function packaging set to Auto/Reusable Function, Create output for monitoring selected, temporal logic `at`/`after` in state/transition actions.

---

### 32. Check usage of Truth Table blocks

**Check ID:** `mathworks.slci.TruthTableBlocksSFObjsUsage`

**Verifies:** Truth Table block configuration.

**Severity:** Nonfatal

**Key conditions:** Update method not Inherited, Saturate on integer overflow selected, Support variable-size arrays selected.

---

### 33. Check usage of Stateflow ports

**Check ID:** `mathworks.slci.portsSFObjsUsage`

**Verifies:** No entry or exit ports on atomic subcharts.

**Severity:** Nonfatal

**Edit-Time Checking:** Supported.

---

### 34. Check usage of root Outport blocks

**Check ID:** `mathworks.slci.RootOutportBlocksUsage`

**Verifies:** Root Outport blocks are not constant; bus outports pass as structures.

**Severity:** Nonfatal

**Key finding if fails:** Constant outports produce no code in `model_step()`, leaving nothing to verify. Bus outports without "Output as nonvirtual bus" may insert hidden Signal Conversion blocks.

**Fix:**
```matlab
set_param('myModel/Out1', 'SampleTime', '-1');
```

---

### 35. Check usage of shared utilities

**Check ID:** `mathworks.slci.SharedUtils`

**Verifies:** Code generation symbols, language standard, code style, and expression folding settings are compatible with shared utility verification.

**Severity:** Nonfatal

**Key finding if fails:** SLCI cannot match generated shared utility code against known reference implementations (binsearch_u32d, intrp1d_l, etc.) when naming, language, or style settings deviate from expected patterns.

**Fix:**
```matlab
set_param(model, 'CustomSymbolStrTmpVar', '$N$M');
set_param(model, 'CustomSymbolStrUtil', '$N$C');
set_param(model, 'TargetLangStandard', 'C89/C90 (ANSI)');
set_param(model, 'ParenthesesLevel', 'Nominal');
set_param(model, 'CastingMode', 'Standards');
set_param(model, 'ExpressionFolding', 'on');
```

---

## Chapter 8: Model Compatibility Checks

### 36. Check code generation settings

**Check ID:** `mathworks.slci.CodeGenerationSettings`

**Verifies:** ERT-based code generation with required formatting conventions (comments, column-major layout, no custom code, standard C, no variable-size signals).

**Severity:** Nonfatal (FATAL for: variable-size signals, Include comments off, Header files with $U token)

**Key finding if fails:** Generated code follows patterns SLCI cannot parse — missing comments removes traceability, custom code injects unverifiable statements, non-standard constructs break the parser.

**Fix:**
```matlab
set_param(model, 'SystemTargetFile', 'ert.tlc');
set_param(model, 'TargetLangStandard', 'C89/C90 (ANSI)');
set_param(model, 'GenerateAllocFcn', 'off');
set_param(model, 'UtilityFuncGeneration', 'Shared location');
set_param(model, 'CustomSourceCode', '');
set_param(model, 'CustomHeaderCode', '');
set_param(model, 'CustomInitializer', '');
set_param(model, 'CustomTerminator', '');
set_param(model, 'ArrayLayout', 'Column-major');
set_param(model, 'GenerateComments', 'on');
set_param(model, 'PreserveIfCondition', 'on');
set_param(model, 'CombineOutputUpdateFcns', 'on');
set_param(model, 'EfficientFloat2IntCast', 'on');
set_param(model, 'EfficientMapNaN2IntZero', 'off');
set_param(model, 'MatFileLogging', 'off');
set_param(model, 'BooleansAsBitfields', 'off');
set_param(model, 'SuppressErrorStatus', 'on');
set_param(model, 'CreateSILPILBlock', 'None');
set_param(model, 'CodeExecutionProfiling', 'off');
set_param(model, 'RateTransitionBlockCode', 'Inline');
```

---

### 37. Check data import/export settings

**Check ID:** `mathworks.slci.DataImportSettings`

**Verifies:** Model is not configured to load initial states from workspace.

**Severity:** Nonfatal

**Key finding if fails:** State variables initialized from workspace data at runtime cannot be resolved statically by SLCI for verification.

**Fix:**
```matlab
set_param('myModel', 'LoadInitialState', 'off');
```

---

### 38. Check diagnostic settings

**Check ID:** `mathworks.slci.DiagnosticsSettings`

**Verifies:** All required diagnostics are set to error (multitask, algebraic loop, bus, data type, Stateflow) and initialization detection is Simplified.

**Severity:** Nonfatal (FATAL for: Bus signal treated as vector, Non-bus signals treated as bus signals)

**Key finding if fails:** Model compiles with unresolved issues producing workaround code (iterative solvers, protective buffers, ambiguous type handling) that SLCI cannot trace to model semantics.

**Fix:**
```matlab
set_param(model, 'MultiTaskDSMMsg', 'error');
set_param(model, 'MultiTaskRateTransMsg', 'error');
set_param(model, 'MultiTaskCondExecSysMsg', 'error');
set_param(model, 'AlgebraicLoopMsg', 'error');
set_param(model, 'UnderspecifiedInitializationDetection', 'Simplified');
set_param(model, 'StrictBusMsg', 'error');
set_param(model, 'NonBusSignalsTreatedAsBus', 'error');
set_param(model, 'IntegerOverflowMsg', 'error');
set_param(model, 'ParameterDowncastMsg', 'error');
set_param(model, 'ParameterOverflowMsg', 'error');
set_param(model, 'ParameterUnderflowMsg', 'error');
set_param(model, 'ParameterTunabilityLossMsg', 'error');
```

---

### 39. Check hardware implementation settings

**Check ID:** `mathworks.slci.HardwareImplementationSettings`

**Verifies:** Known fixed bit widths for all primitive types (char=8, short=16, int=32, float=32, double=64, pointer=32), integer division rounds to zero, signed right-shift is arithmetic.

**Severity:** Nonfatal

**Key finding if fails:** SLCI cannot verify C type declarations match model types, or hardware settings cause code generator to insert conditional correction code (e.g., division rounding) that SLCI cannot trace to model operations.

**Fix:**
```matlab
set_param(model, 'ProdHWDeviceType', 'Generic->32-bit x86 compatible');
set_param(model, 'ProdIntDivRoundTo', 'Zero');
set_param(model, 'ProdShiftRightIntArith', 'on');
set_param(model, 'ProdEqTarget', 'on');
```

---

### 40. Check math and data types settings

**Check ID:** `mathworks.slci.MathandDataTypesSettings`

**Verifies:** Logic signals implemented as Boolean data; row-major algorithm optimization off.

**Severity:** Nonfatal

**Key finding if fails:** Logic blocks using double instead of boolean produce floating-point comparison patterns that don't match expected boolean block semantics. Row-major algorithms produce transposed loop structures.

**Fix:**
```matlab
set_param(model, 'BooleanDataType', 'on');
set_param(model, 'UseRowMajorAlgorithm', 'off');
```

---

### 41. Check solver settings

**Check ID:** `mathworks.slci.SolverSettings`

**Verifies:** Fixed-step discrete solver, unconstrained sample time, no automatic rate transition, no concurrent tasking.

**Severity:** Nonfatal

**Key finding if fails:** Variable-step solvers inject adaptive step-size logic, continuous solvers add integration routines, auto rate transitions insert hidden buffer blocks — all produce code with no model block counterpart.

**Fix:**
```matlab
set_param(model, 'SolverType', 'Fixed-step');
set_param(model, 'Solver', 'FixedStepDiscrete');
set_param(model, 'SampleTimeConstraint', 'Unconstrained');
set_param(model, 'AutoInsertRateTranBlk', 'off');
set_param(model, 'ConcurrentTasks', 'off');
```

---

### 42. Check system target file setting

**Check ID:** `mathworks.slci.SystemTargetFileSettings`

**Verifies:** System target file is ert.tlc or ERT-derived.

**Severity:** FATAL

**Key finding if fails:** GRT generates code routed through SimStruct pointers and mdl* callbacks. SLCI's verification algorithms require ERT's direct assignments, typed variables, and traceable block comments. GRT's pointer indirection makes data flow untraceable.

**Fix:**
```matlab
set_param('myModel', 'SystemTargetFile', 'ert.tlc');
```

---

### 43. Check Treat each discrete rate as a separate task setting

**Check ID:** `mathworks.slci.EnableMultiTasking`

**Verifies:** Multirate models use "Treat each discrete rate as a separate task."

**Severity:** Nonfatal

**Key finding if fails:** Single-tasking merges all rates into one function with conditional TID guards and rate counter logic that has no model-level block counterpart, making block-to-code traceability ambiguous.

**Fix:**
```matlab
set_param('myModel', 'EnableMultiTasking', 'on');
```

---

### 44. Check usage of buses

**Check ID:** `mathworks.slci.BusUsage`

**Verifies:** No automatic virtual-to-nonvirtual bus conversion; no Merge on virtual buses or Bus Assignment on nonvirtual buses.

**Severity:** FATAL (for auto-conversion and wrong bus operations)

**Key finding if fails:** Hidden Signal Conversion blocks generate code (`HiddenBuf_InsertedFor_...`) with no graphical counterpart. Wrong bus type for operations produces ambiguous data flow.

---

### 45. Check detect non-reused custom storage classes setting

**Check ID:** `mathworks.slci.DetectNonReuseOfRSC`

**Verifies:** Diagnostic set to error when model uses Reusable storage class.

**Severity:** Nonfatal

**Key finding if fails:** Reusable variable not actually reused causes code generator to silently fall back to a different storage pattern, contradicting the declared storage class SLCI expects.

**Fix:**
```matlab
set_param('myModel', 'DetectNonReuseOfRSC', 'error');
```

---

### 46. Check usage of global data stores

**Check ID:** `mathworks.slci.GlobalDSM`

**Verifies:** Global Data Store Memory blocks have inlined parameters and non-tunable initial values.

**Severity:** Nonfatal

**Key finding if fails:** Tunable initial values produce calibration infrastructure (parameter structures, pointer access) with no fixed value to verify against.

**Fix:**
```matlab
set_param('myModel', 'DefaultParameterBehavior', 'Inlined');
```

---

### 47. Check for usage of fixed-point instrumentation

**Check ID:** `mathworks.slci.MinMaxLogging`

**Verifies:** Block reduction and MinMaxOverflowLogging are not both active.

**Severity:** Nonfatal

**Key finding if fails:** Instrumentation code references blocks that have been eliminated by block reduction, producing orphaned logging statements unmappable to model blocks.

**Fix:**
```matlab
set_param('myModel', 'MinMaxOverflowLogging', 'ForceOff');
```

---

### 48. Check for root Outport blocks that have non-auto storage class

**Check ID:** `mathworks.slci.PassReuseOutputArgsAs`

**Verifies:** Root outports in referenced models with non-auto storage classes use "Individual arguments" passing.

**Severity:** Nonfatal

**Key finding if fails:** Storage class declares global placement while struct-based output passing bundles the variable into a struct — SLCI cannot reconcile both.

**Fix:**
```matlab
set_param('myModel', 'PassReuseOutputArgsAs', 'Individual arguments');
```

---

### 49. Check loop unrolling threshold setting

**Check ID:** `mathworks.slci.RollThreshold`

**Verifies:** Loop unrolling threshold won't produce partially unrolled loops.

**Severity:** Nonfatal

**Key finding if fails:** Hybrid pattern (some unrolled statements followed by a loop) cannot be matched to the block's vector operation semantics by SLCI.

**Fix:**
```matlab
set_param('myModel', 'RollThreshold', '5');
```

---

### 50. Check for sample times in the model

**Check ID:** `mathworks.slci.SampleTimesUsage`

**Verifies:** No continuous, explicit discrete partition, data driven, union, or variable sample times; no explicit partitions.

**Severity:** FATAL

**Key finding if fails:** Non-discrete sample times produce solver/scheduler infrastructure code with no model block counterpart. SLCI fundamentally cannot parse solver-generated integration code.

---

### 51. Check destinations of If and Switchcase blocks

**Check ID:** `mathworks.slci.SeparateOutputAndUpdate`

**Verifies:** Action subsystems connected to same If/Switch Case use consistent output/update combining strategy.

**Severity:** Nonfatal

**Key finding if fails:** Mixed strategies produce inconsistent calling patterns (some actions inline, others generate separate functions) that SLCI cannot uniformly verify.

---

### 52. Check model arguments for storage classes

**Check ID:** `mathworks.slci.StructureStorageClass`

**Verifies:** Model arguments have no storage class.

**Severity:** Nonfatal

**Key finding if fails:** Storage class forces the argument into a global memory location, conflicting with the function-parameter passing mechanism. SLCI cannot resolve which location is authoritative.

**Fix:**
```matlab
Kp = Simulink.Parameter(2.0);
Kp.CoderInfo.StorageClass = 'Auto';
```

---

### 53. Check for unsupported usage of 64-bit integer data types

**Check ID:** `mathworks.slci.Supported64BitDataTypeUsage`

**Verifies:** int64/uint64 usage has Support long long enabled or long=64.

**Severity:** Nonfatal

**Key finding if fails:** No native 64-bit C type available — code generator must emulate with struct or truncate, producing patterns SLCI cannot verify.

**Fix:**
```matlab
set_param('myModel', 'ProdLongLongMode', 'on');
```

---

### 54. Check for unsupported usage of string data type

**Check ID:** `mathworks.slci.SupportedStringDataTypeUsage`

**Verifies:** String data type usage with Language set to C (not C++).

**Severity:** Nonfatal

**Key finding if fails:** C++ generates std::string with method calls and heap allocation that SLCI cannot trace to block semantics.

**Fix:**
```matlab
set_param('myModel', 'TargetLang', 'C');
```

---

### 55. Check for usage of synthesized local data stores

**Check ID:** `mathworks.slci.SynthLocalDSM`

**Verifies:** No signal objects used as synthesized local data stores.

**Severity:** Nonfatal

**Key finding if fails:** Implicit data store variable in code has no visible Data Store Memory block for traceability.

---

### 56. Check for unconnected objects in the model

**Check ID:** `mathworks.slci.UnconnectedObjects`

**Verifies:** No unconnected lines, input ports, or output ports.

**Severity:** Nonfatal

**Key finding if fails:** Unconnected ports produce implicit ground values (constant 0) in code with no corresponding Source block — SLCI cannot verify origin.

**Edit-Time Checking:** Supported.

---

### 57. Check for unsupported blocks

**Check ID:** `mathworks.slci.UnsupportedBlocks`

**Verifies:** All blocks in the model are on SLCI's supported list.

**Severity:** Nonfatal

**Key finding if fails:** Unsupported blocks produce code patterns SLCI has no verification algorithm for.

**Edit-Time Checking:** Supported.

---

### 58. Check storage class for workspace variables

**Check ID:** `mathworks.slci.WorkspaceVarUsage`

**Verifies:** Workspace variables use supported storage classes (Unstructured/FlatStructure custom type, supported built-in classes, reusable if Auto scope).

**Severity:** Nonfatal

**Key finding if fails:** Unsupported classes (BitField, Struct, nested custom) produce complex or platform-specific declarations SLCI cannot verify.

**Fix:**
```matlab
Kp = Simulink.Parameter(2.0);
Kp.CoderInfo.StorageClass = 'Custom';
Kp.CoderInfo.CustomStorageClass = 'ExportToFile';
```

---

### 59. Check model for commented out blocks

**Check ID:** `mathworks.slci.CommentedBlocks`

**Verifies:** No commented-out blocks in the model.

**Severity:** Nonfatal

**Key finding if fails:** Commented-out blocks appear in model structure but have no code counterpart, creating a mismatch in block-to-code mapping.

**Fix:**
```matlab
commentedBlocks = find_system(model, 'Commented', 'on');
for i = 1:numel(commentedBlocks)
    delete_block(commentedBlocks{i});
end
```

---

### 60. Check data type replacement names

**Check ID:** `mathworks.slci.DataTypeReplacementName`

**Verifies:** Replacement names use Simulink Names or Simulink.AliasType (not Simulink.NumericType).

**Severity:** Nonfatal

**Key finding if fails:** NumericType objects carry scaling/bias properties that may produce complex type handling code SLCI cannot verify.

**Fix:**
```matlab
Speed_T = Simulink.AliasType('double');
```

---

### 61. Check for export-function model settings

**Check ID:** `mathworks.slci.ExportFcnModelSettings`

**Verifies:** Export-function models use single sample time and have no S-functions, Simulink functions, or Merge blocks at top level.

**Severity:** Nonfatal

**Key finding if fails:** Multiple sample times produce rate-scheduling code conflicting with caller-controlled execution. Top-level unsupported blocks generate infrastructure outside any function-call subsystem.

---

## Summary of FATAL Incompatibilities (from Model Advisor Checks)

1. **System target file** not ert.tlc or ERT-derived (`mathworks.slci.SystemTargetFileSettings`)
2. **Sample times** using continuous, explicit discrete partition, data driven, union, or variable (`mathworks.slci.SampleTimesUsage`)
3. **Support: variable-size signals** selected (`mathworks.slci.CodeGenerationSettings`)
4. **Include comments** not selected (`mathworks.slci.CodeGenerationSettings`)
5. **Header files** containing $U token (`mathworks.slci.CodeGenerationSettings`)
6. **Bus signal treated as vector** not set to error (`mathworks.slci.DiagnosticsSettings`)
7. **Non-bus signals treated as bus signals** not set to error (`mathworks.slci.DiagnosticsSettings`)

---

## See Also

- "Run Model Advisor Checks"
- "Simulink Checks"
- "Model Advisor Checks" (Simulink Coder)

----

Copyright 2026 The MathWorks, Inc.

----
