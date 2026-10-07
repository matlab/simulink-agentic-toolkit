# Stateflow Object Constraints

SLCI supports a subset of Stateflow objects for code inspection. The code
inspector verifies the use of supported objects and enforces constraints that
ensure generated code can be traced one-to-one back to the Stateflow model
elements. Before code inspection, the compatibility checker detects and reports
violations of Stateflow constraints.

SLCI supports the following Stateflow objects:
- Boxes
- Charts
- Data and Events
- Graphical functions
- Junctions
- Subcharts
- Simulink functions
- States
- Transitions
- Stateflow truth tables
- Truth Table blocks
- State Transition Table blocks
- Entry and exit ports
- MATLAB functions

Supported temporal logic operators (in state actions or transition path actions
for implicit events):
- `at`
- `after`

Code inspection supports both **C** and **MATLAB** as the action language for
charts. For MATLAB code in a chart, the same constraints as MATLAB Function
blocks apply.

---

## 1. Stateflow Blocks - Nonfatal

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Function packaging (`RTWSystemCode`) must be set to `Inline`. If `Nonreusable function` or `Reusable function` is selected, the subsystem and model must be in supported configurations (see Supported Block Constraints for subsystem rules) | Nonfatal | Check usage of Stateflow blocks |

### Constraint Details

#### Function packaging (`RTWSystemCode`) must be set to `Inline`

##### Why SLCI Requires This

When a Stateflow block's function packaging is `Inline`, the chart's generated code is placed directly in the model's step function, producing a flat, linear code structure that SLCI can verify statement-by-statement. With `Nonreusable function` or `Reusable function`, the chart generates a separate function with its own calling interface -- SLCI can only verify these if the subsystem and model meet the same structural requirements as Simulink subsystems.

##### Fix

```matlab
set_param('model/Chart', 'RTWSystemCode', 'Inline');
```

---

## 2. Stateflow Charts - Mixed Severity

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Chart must not contain Atomic Boxes or Simulink based states | **FATAL** | Check Stateflow charts |
| Atomic subcharts in charts must have Code generation function packaging set to `Inline` | Nonfatal | Check usage of atomic subchart 'Code generation function packaging' setting |
| A chart that uses MATLAB action language must have unique names for Simulink functions, MATLAB functions, graphical functions, and truth tables | Nonfatal | Check name usage in a Stateflow chart that uses MATLAB action language |
| Chart property `Create output for monitoring` must not be selected | Nonfatal | Check that all charts unselect 'Create output for monitoring' option |
| Chart property `Update method` must be set to `Inherited` | Nonfatal | Check that all charts specify 'Inherited' as their update method |
| States and atomic subcharts in a chart must have default transitions | Nonfatal | Check that states, substates, or atomic subcharts have default transitions |
| Chart property `Enable Super Step Semantics` must not be selected | Nonfatal | Check that all charts unselect 'Enable Super Step Semantics' option |
| Chart property `Execute (enter) chart at initialization` must not be selected | Nonfatal | Check that no charts execute at initialization |
| Chart property `Export chart level functions` must not be selected | Nonfatal | Check that no charts export chart level functions |
| Chart property `Saturate on integer overflow` must not be selected | Nonfatal | Check that no charts specify saturation on overflow for integer operations |
| Chart property `State Machine Type` must not be set to `Moore` | Nonfatal | Check usage of State Machine Type |
| Chart property `Support variable-size arrays` must not be selected | **FATAL** | Check that no charts support variable-size arrays |
| The control flow must not have more than 1 default transition | Nonfatal | Check that all control flows have unique default transitions |
| Charts must not contain linked atomic subcharts | **FATAL** | Check usage of Stateflow charts containing linked atomic subcharts |
| Chart must not contain a junction that merges multiple transitions and has a transition originating from it | Nonfatal | Check for junctions in charts that merge multiple transitions |
| MATLAB code in a chart using MATLAB action language must follow MATLAB Function block constraints (except: `while` statement, `break` function, and tilde `~` are NOT supported in charts) | Nonfatal | Check usage of Stateflow MATLAB action language |
| Chart must not use temporal logic operators other than `at` and `after` in state or transition actions | Nonfatal | Check usage of Stateflow MATLAB action language |

### Constraint Details

#### Chart must not contain Atomic Boxes or Simulink based states -- FATAL

##### Why SLCI Requires This (FATAL)

Atomic Boxes encapsulate opaque logic that SLCI cannot decompose into individual states and transitions. Simulink-based states contain embedded Simulink subsystems whose code generation mixes Stateflow state-machine logic with subsystem step-function logic -- these hybrid constructs produce code structures that cannot be mapped to either paradigm.

##### Fix

Replace Atomic Boxes with equivalent state hierarchies. Replace Simulink-based states with separate subsystems outside the chart, connected via function calls.

#### Support variable-size arrays must not be selected -- FATAL

##### Why SLCI Requires This (FATAL)

Variable-size arrays in charts generate `_data`/`_size` paired variables with runtime dimension tracking. SLCI cannot statically determine array bounds or verify dimension propagation logic.

##### Fix

```matlab
ch.SupportVariableSizeArrays = false;
```

#### Charts must not contain linked atomic subcharts -- FATAL

##### Why SLCI Requires This (FATAL)

Linked atomic subcharts reference external library charts. SLCI requires full access to the chart content for decomposition and verification. Linked subcharts may resolve to different implementations or be unavailable at inspection time.

##### Fix

Break the library link and embed the subchart content directly in the chart.

#### Atomic subcharts in charts must have Code generation function packaging set to `Inline`

##### Why SLCI Requires This

When an atomic subchart's function packaging is `Inline`, its generated code is placed directly in the chart's step function for statement-by-statement verification. With `Nonreusable function` or `Reusable function`, the subchart generates a separate C function -- SLCI can only verify these non-inlined configurations if the subsystem and model meet the same structural requirements as Simulink subsystems. `Inline` is the safest choice for guaranteed SLCI compatibility.

##### Fix

```matlab
% Set atomic subchart to Inline
subchart = ch.find('-isa', 'Stateflow.AtomicSubchart', 'Name', 'mySubchart');
subchart.CodeGenerationFunctionPackaging = 'Inline';
```

#### A chart that uses MATLAB action language must have unique names for Simulink functions, MATLAB functions, graphical functions, and truth tables

##### Why SLCI Requires This

In MATLAB action language charts, all function types generate C functions. If two functions share the same name, the code generator must mangle one name to avoid symbol conflicts. SLCI identifies functions by their Stateflow name -- a mangled name cannot be traced back to its definition. Unique names ensure a one-to-one mapping.

##### Fix

Rename functions within the chart so that all Simulink functions, MATLAB functions, graphical functions, and truth tables have distinct names.

#### Chart property `Create output for monitoring` must not be selected

##### Why SLCI Requires This

This option creates a hidden output port that exposes the chart's active state as a signal. The generated code writes the current state ID to an output variable that has no explicit modeling in the chart's logic -- a diagnostic output with no corresponding state action.

##### Fix

```matlab
ch.HasOutputData = false;
```

#### Chart property `Update method` must be set to `Inherited`

##### Why SLCI Requires This

Non-inherited update methods (`Discrete`, `Continuous`) generate separate rate-specific execution functions with sample time management. SLCI expects chart code to appear in the model's step function at the inherited rate. Other methods produce scheduling infrastructure that SLCI cannot trace.

##### Fix

```matlab
ch.UpdateMethod = 'INHERITED';
```

#### States and atomic subcharts must have default transitions

##### Why SLCI Requires This

Without default transitions, the chart's initial state is undefined when the parent state is first entered. SLCI requires deterministic initialization -- default transitions ensure the generated code has a clear initial state assignment that SLCI can verify.

##### Fix

Add a default transition to one child state in every state that contains substates or atomic subcharts.

#### Chart property `Enable Super Step Semantics` must not be selected

##### Why SLCI Requires This

Super Step allows multiple state transitions within a single time step until the chart reaches a stable state. This generates a while-loop with a data-dependent termination condition. SLCI cannot statically verify the loop bound or predict how many transitions will execute in a single step.

##### Fix

```matlab
ch.EnableSuperStepSemantics = false;
```

#### Chart property `Execute (enter) chart at initialization` must not be selected

##### Why SLCI Requires This

This option generates code that executes the chart's entry actions during `model_initialize()`. SLCI's chart verification focuses on the periodic step function -- initialization-time chart execution produces state-machine code in `model_initialize()` that SLCI's step-focused analysis cannot verify.

##### Fix

```matlab
ch.ExecuteAtInitialization = false;
```

#### Chart property `Export chart level functions` must not be selected

##### Why SLCI Requires This

Exported chart functions generate additional function definitions callable from outside the chart. These create cross-model dependencies and calling patterns that SLCI cannot trace from the chart's isolated scope.

##### Fix

```matlab
ch.ExportChartFunctions = false;
```

#### Chart property `State Machine Type` must not be set to `Moore`

##### Why SLCI Requires This

Moore machines separate output computation from transition logic, producing a two-pass code pattern (first compute transitions, then compute outputs). SLCI expects the standard Mealy machine code pattern where actions execute inline with transitions.

##### Fix

Set State Machine Type to `Mealy` (default).

#### Chart must not contain a junction that merges multiple transitions and has a transition originating from it

##### Why SLCI Requires This

A junction that receives multiple incoming transitions and has outgoing transitions creates an implicit OR condition. This implicit merging produces code where the same branch is reachable from multiple conditions, creating ambiguous traceability between transitions and generated if-else branches.

##### Fix

Restructure the chart to avoid merge junctions with outgoing transitions. Use separate junctions or combine conditions explicitly.

#### The control flow must not have more than 1 default transition

##### Why SLCI Requires This

A control flow region must have exactly one default transition to define the unambiguous initial state. When multiple default transitions exist, the code generator produces an if-else chain whose evaluation order depends on geometric position. SLCI cannot determine which branch corresponds to which default transition arrow. A single unconditional default produces a direct assignment -- unambiguously traceable.

##### Fix

Remove extra default transitions so that each state hierarchy level has exactly one default transition entering one substate.

#### MATLAB code in a chart using MATLAB action language must follow MATLAB Function block constraints

##### Why SLCI Requires This

When a chart uses MATLAB as its action language, all MATLAB code is compiled through the same Embedded MATLAB code generation path as MATLAB Function blocks. The same constraints apply identically. Additionally, charts using MATLAB action language do **not** support `while` statements, the `break` function, or the tilde `~` operator for ignoring outputs.

##### Fix

Review all MATLAB code in chart actions against the MATLAB Function block constraints. Replace unsupported constructs:
- Replace `while` loops with `for` loops with known bounds
- Remove `break` statements -- restructure loop conditions instead
- Replace `~` (unused outputs) with named variables

#### Chart must not use temporal logic operators other than `at` and `after` in state or transition actions

##### Why SLCI Requires This

Temporal logic operators other than `at` and `after` (such as `every`, `before`, `temporalCount`, `elapsed`, `duration`) generate complex timer infrastructure with cyclic counters, reset logic, or continuous-time integration. SLCI supports only `at` and `after` because these produce a simple monotonic counter with a single threshold comparison that SLCI can map directly to the temporal expression.

##### Fix

```matlab
% Replace unsupported temporal operators with supported patterns
% Instead of: every(5, tick) -> use after(5, tick) with self-transition
% Instead of: before(n, event) -> use after with inverted logic
% Instead of: elapsed(sec) -> use explicit counter variable
```

---

## 3. Stateflow Data and Events - Nonfatal

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Chart must not define Stateflow data with `Constant` scope | Nonfatal | Check that the chart does not define Stateflow data with Constant scope |
| `InitializeMethod` for Local or Output scope Stateflow data must not be set to `Parameter` | Nonfatal | Check usage of Stateflow data Initialize Method |
| Chart data types must be builtin, enumerated, or bus | Nonfatal | Check that Stateflow data is of a supported data type |
| If chart data type is bus and chart uses C action language: data must not be arrays of buses or have elements that are arrays of buses | Nonfatal | (same check) |
| If chart data type is bus and chart uses MATLAB action language: arrays of buses are supported | N/A | (same check) |
| If chart data type is enumerated: default value must be 0 | Nonfatal | (same check) |
| The `First Index` property for Stateflow data must be empty or `0` | Nonfatal | Check that the 'First Index' of Stateflow data are empty or 0 |
| Size of Stateflow parameter data must be the same in Stateflow and the base workspace | Nonfatal | Check that Stateflow parameter data sizes in Stateflow and the base workspace match |
| Chart must not use complex data | Nonfatal | Check that the chart uses only non-complex data |
| Stateflow states and boxes must not define Stateflow data | Nonfatal | Check that states and boxes do not define Stateflow data |
| Event scope must be `Output` or `Local` | Nonfatal | Check that the chart uses only events of scope Local or Output |
| Event trigger must be a function-call | Nonfatal | Check that the chart uses only function-call events |
| Chart must not contain unused data, events, messages, and functions | Nonfatal | Check for unused data, events, messages, and functions in charts |

### Constraint Details

#### Chart must not define Stateflow data with `Constant` scope

##### Why SLCI Requires This

Constant-scope data is resolved at compile time and may be folded directly into expressions, eliminating the named variable from the generated code. SLCI requires each data element to appear as a traceable variable -- when constants are inlined, there is no variable to trace.

##### Fix

Change scope to `Parameter` (produces a traceable variable in the parameter structure):

```matlab
data.Scope = 'Parameter';
```

#### `InitializeMethod` for Local or Output scope Stateflow data must not be set to `Parameter`

##### Why SLCI Requires This

When `InitializeMethod` is `Parameter`, the initial value comes from the model's parameter structure and may be tunable at runtime. SLCI expects Local and Output data initialization to use expression-based or constant values resolvable at analysis time.

##### Fix

```matlab
data.Props.InitializeMethod = 'Expression';
```

#### The `First Index` property for Stateflow data must be empty or `0`

##### Why SLCI Requires This

C arrays are zero-indexed. When `First Index` is set to a non-zero value, the code generator introduces index offset arithmetic in array accesses. SLCI verifies array indexing by matching index expressions to the Stateflow action -- offset adjustments produce additional arithmetic with no action-level counterpart.

##### Fix

```matlab
data.Props.Array.FirstIndex = '0';
```

#### Stateflow states and boxes must not define Stateflow data

##### Why SLCI Requires This

Data defined inside states or boxes creates locally-scoped variables only valid within that state's execution context. The generated code must manage lifetime based on state activation, producing scope-guarded variable accesses that SLCI cannot map to a globally visible data element. Chart-level data produces globally traceable variables.

##### Fix

Move data definitions to the chart level. Use chart-level Local data instead of state-scoped data.

#### Event scope must be `Output` or `Local`

##### Why SLCI Requires This

Input-scoped events require external triggering infrastructure that generates event-dispatching code. SLCI only supports Output events (function-call generation) and Local events (internal signaling) because these produce deterministic, traceable function-call code patterns.

##### Fix

```matlab
event.Scope = 'Local';  % or 'Output'
```

#### Event trigger must be a function-call

##### Why SLCI Requires This

Non-function-call events (edge-triggered, rising, falling) generate edge-detection code with previous-value storage and comparison logic. Function-call events generate simple `submodel_fcn()` calls that SLCI can directly trace.

##### Fix

```matlab
event.Trigger = 'Function Call';
```

#### Chart must not contain unused data, events, messages, and functions

##### Why SLCI Requires This

Unused elements may still generate variable declarations, function stubs, or initialization code. SLCI expects every code element to trace back to a used model element. Dead declarations clutter the generated code with untraceable artifacts.

##### Fix

Remove unused data, events, messages, and functions from the chart using the Stateflow editor or Model Explorer.

#### Chart data types must be builtin, enumerated, or bus

##### Why SLCI Requires This

Builtin types map directly to C primitives, enumerated types map to C enums, and bus types map to C structures. Custom or user-defined types that don't fall into these categories may produce opaque type definitions that SLCI cannot decompose into verifiable primitive operations.

##### Fix

Change data type to a supported builtin, enumerated, or bus type.

#### If chart data type is bus and chart uses C action language: data must not be arrays of buses or have elements that are arrays of buses

##### Why SLCI Requires This

In C action language charts, arrays of buses generate arrays of C structures with combined array indexing and structure member access. The code generator may linearize this into pointer arithmetic or generate intermediate temporaries. SLCI cannot reliably decompose these combined access patterns back to the Stateflow action's bus-array notation. In MATLAB action language charts, a different code generation approach preserves traceability.

##### Fix

For C action language charts, flatten the bus array into individual bus elements, or restructure to use separate arrays for each bus field.

#### If chart data type is enumerated: default value must be 0

##### Why SLCI Requires This

When the default is 0, this matches C's default zero-initialization for static variables. A non-zero default requires explicit initialization code -- SLCI expects enum initialization to follow C's zero-initialization pattern.

##### Fix

```matlab
data.Props.Type.EnumType = 'MyEnum';
% Ensure the enumeration class defines 0 as the default member
```

#### Size of Stateflow parameter data must be the same in Stateflow and the base workspace

##### Why SLCI Requires This

SLCI verifies parameter data accesses by matching array dimensions in generated code to the Stateflow data definition. If sizes differ, the code generator may produce implicit reshaping or truncation code that SLCI cannot trace.

##### Fix

Ensure the Stateflow data `Size` property matches the dimensions of the corresponding workspace variable.

#### Chart must not use complex data

##### Why SLCI Requires This

Complex data generates paired real/imaginary storage and arithmetic operations. Every complex operation expands to multiple real-valued operations with no single corresponding Stateflow action. SLCI cannot map these expanded operations back to the original complex expression.

##### Fix

Replace complex data with separate real and imaginary components as individual Stateflow data elements.

---

## 4. Stateflow MATLAB Functions - Nonfatal

| Constraint | Severity | Compatibility Check |
|---|---|---|
| MATLAB function property `Function Inline Option` (`InlineOption`) must be set to `Inline` or `Function` | Nonfatal | Check 'Function inline option' for Stateflow MATLAB functions |
| MATLAB function property `Saturate on integer overflow` must be cleared (set to `off`) | Nonfatal | Check 'Saturate on integer overflow' for Stateflow MATLAB functions |
| MATLAB code in MATLAB functions must follow the same constraints as code in MATLAB Function blocks | Nonfatal | Check usage of Code in MATLAB Functions |
| MATLAB code in MATLAB functions must follow the same data type constraints as MATLAB Function blocks | Nonfatal | Check usage of Data in MATLAB Functions |
| Transitions must not use MATLAB functions with different actual and expected argument data types | Nonfatal | Check data type of MATLAB Function argument |
| Transitions must not use MATLAB functions with different actual and expected argument sizes | Nonfatal | Check dimension of MATLAB Function argument |
| States must not use MATLAB functions with different actual and expected argument data types | Nonfatal | Check data type of MATLAB Function argument |
| States must not use MATLAB functions with different actual and expected argument sizes | Nonfatal | Check dimension of MATLAB Function argument |

### Why SLCI Requires This

SLCI verifies that MATLAB function calls in states and transitions produce generated code whose argument types and sizes match the function signature. Type or size mismatches cause implicit conversions or reshaping in generated code that have no corresponding model element. Saturation on overflow inserts conditional clamping code that breaks the direct mapping between MATLAB operators and C operators.

### Fix

```matlab
% Set MATLAB function properties
mlFcn = ch.find('-isa', 'Stateflow.EMFunction', 'Name', 'myFunc');
mlFcn.InlineOption = 'Inline';  % or 'Function'
mlFcn.SaturateOnIntegerOverflow = false;
```

---

## 5. Stateflow Graphical Functions - Mixed Severity

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Graphical function must not contain control flow cycles | **FATAL** | Check that control flows do not have cycles |
| Graphical function property `Function Inline Option` (`InlineOption`) must be `Inline` or `Function` | Nonfatal | Check usage of InlineOption setting |
| For a graphical function with `InlineOption` set to `Function`, `CodeInterfacePackaging` must be set to `Nonreusable function` | Nonfatal | Check configuration for models with non-inlined graphical functions |
| Non-inlined graphical functions must have unique function names | Nonfatal | Check non-inlined graphical function names |
| Graphical function must not be recursive | Nonfatal | Check usage of recursive Stateflow function |
| Graphical function must not contain unstructured control flow | **FATAL** | Check that control flows are structured |
| State must not have graphical function calls with different actual and expected argument data types | Nonfatal | Check data type of Graphical Function arguments |
| State must not have graphical function calls with different actual and expected argument sizes | Nonfatal | Check dimensions of Graphical Function arguments |
| Transition must not have graphical function calls with different actual and expected argument data types | Nonfatal | Check data type of Graphical Function arguments |
| Transition must not have graphical function calls with different actual and expected argument dimensions | Nonfatal | Check dimensions of Graphical Function arguments |
| Graphical function must not call MATLAB functions | Nonfatal | Check that graphical functions do not call MATLAB functions |

### Constraint Details

#### Graphical function must not contain control flow cycles -- FATAL

##### Why SLCI Requires This (FATAL)

Control flow cycles within a graphical function's junction/transition network produce loop code whose iteration count depends on runtime data. SLCI cannot statically verify termination or prove equivalence between the graphical cycle and the generated loop. This is FATAL because the entire function body becomes unverifiable.

##### Fix

Restructure the graphical function to eliminate backward-flowing transitions. Use explicit for-loop patterns with deterministic bounds instead.

#### Graphical function must not contain unstructured control flow -- FATAL

##### Why SLCI Requires This (FATAL)

Unstructured control flow (transition paths that cannot be reduced to nested if-else/switch statements) generates goto-based code. SLCI's analysis engine requires structured C constructs -- goto-based code cannot be decomposed into the hierarchical control flow tree that SLCI uses for verification.

##### Fix

Restructure the junction/transition graph so that all paths form proper if-else or switch-case trees without cross-branch transitions.

#### Graphical function property `Function Inline Option` (`InlineOption`) must be `Inline` or `Function`

##### Why SLCI Requires This

When set to `Auto`, the code generator decides whether to inline based on heuristics. This produces unpredictable code structure -- SLCI needs to know in advance whether to expect inline code or a separate function call. Explicit `Inline` or `Function` gives SLCI a deterministic code pattern.

##### Fix

```matlab
gf.InlineOption = 'Inline';  % or 'Function'
```

#### For a graphical function with `InlineOption` set to `Function`, `CodeInterfacePackaging` must be set to `Nonreusable function`

##### Why SLCI Requires This

With `Nonreusable function` packaging, the model uses a single static data structure instance, so the graphical function's data accesses resolve to fixed global references that SLCI can trace. With `Reusable function` packaging, data is passed via an instance pointer, and accesses become indirect pointer dereferences that SLCI cannot statically resolve.

##### Fix

```matlab
set_param('model', 'CodeInterfacePackaging', 'Nonreusable function');
```

#### Non-inlined graphical functions must have unique function names

##### Why SLCI Requires This

SLCI identifies graphical functions in generated code by their function names. Duplicate names produce symbol conflicts or force name mangling. Unique names ensure a one-to-one mapping between Stateflow graphical functions and generated C functions.

##### Fix

Ensure each graphical function in the chart has a distinct name.

#### Graphical function must not be recursive

##### Why SLCI Requires This

Recursive graphical functions produce unbounded call stacks. SLCI cannot statically determine recursion depth or verify termination. Each recursive call produces the same function body code with different data, making it impossible to match code execution to a specific invocation.

##### Fix

Replace recursive logic with iterative patterns using junction-based loops with explicit bounds.

#### Graphical function must not call MATLAB functions

##### Why SLCI Requires This

MATLAB functions use a different code generation paradigm (Embedded MATLAB codegen) than graphical functions (Stateflow C codegen). Calling a MATLAB function from a graphical function mixes two code generation paths, producing code at the call boundary that neither verifier can fully trace.

##### Fix

Convert the MATLAB function to a graphical function equivalent, or restructure so that both are called independently from state actions.

---

## 6. Stateflow Simulink Functions - Nonfatal

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Simulink function calls in states must have the same argument data type as the inports and outports in the defining Function-Call Subsystem | Nonfatal | Check data type of Simulink Function arguments |
| Simulink function calls in states must have the same argument size as the inports and outports in the defining Function-Call Subsystem | Nonfatal | Check dimensions of Simulink Function arguments |
| Simulink function calls in transitions must have the same argument data type as the inports and outports in the defining Function-Call Subsystem | Nonfatal | Check data type of Simulink Function arguments |
| Simulink function calls in transitions must have the same argument size as the inports and outports in the defining Function-Call Subsystem | Nonfatal | Check dimensions of Simulink Function argument |
| Function packaging (`RTWSystemCode`) of Simulink functions must be set to `Inline`. If `Nonreusable function` or `Reusable function` is selected, the function properties and model must be in supported configurations (see Supported Block Constraints for subsystem rules) | Nonfatal | Check Subsystem blocks |

### Why SLCI Requires This

Simulink functions embedded in Stateflow charts generate Function-Call Subsystem code. SLCI must verify that the calling interface (data types, sizes) in the state/transition action matches the function definition exactly. Mismatches produce implicit conversion code at call boundaries that cannot be traced to any model element.

---

## 7. Stateflow Junctions - Mixed Severity

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Junctions must not have outgoing transitions jumping outside of a loop | Nonfatal | Check that Stateflow junctions do not have outgoing transitions jumping outside of the loop |
| Non-terminating junctions must have exactly one unconditional transition exiting them | **FATAL** | Check that non-terminating junctions have exactly one unconditional exiting transition |
| Chart must not contain a history junction | Nonfatal | Check that the chart uses no history junctions |
| Header junctions must have two incoming and two outgoing transitions | Nonfatal | Check that control flows do not have loops with unsupported header junctions |
| Terminating junctions must not trace back to a Stateflow state | Nonfatal | Check usage of terminating Stateflow junctions |
| Unconditional transition must be last in order of execution | **FATAL** | Check that unconditional transitions execute last in execution order |
| Chart must not contain unstructured control flow | Nonfatal | Check that control flows are structured |

### Constraint Details

#### Junctions must not have outgoing transitions jumping outside of a loop

##### Why SLCI Requires This

Junction-based loops generate C `for` or `while` loops. An outgoing transition that exits the loop mid-iteration generates a `break` or `goto` statement. SLCI expects loop structures to complete normally (condition-based termination only).

##### Fix

Restructure the loop so that exit conditions are expressed as loop termination conditions rather than mid-loop transitions jumping to states outside the loop.

#### Non-terminating junctions must have exactly one unconditional transition exiting them -- FATAL

##### Why SLCI Requires This (FATAL)

Non-terminating junctions are decision points that must always route execution forward. Without exactly one unconditional exit, execution could reach a dead-end or be ambiguous. The single unconditional exit becomes the `else` clause in generated code, guaranteeing complete control flow coverage. Missing this makes the entire junction network unverifiable.

##### Fix

Add exactly one outgoing transition without a condition to every non-terminating junction.

#### Chart must not contain a history junction

##### Why SLCI Requires This

History junctions remember which substate was last active when a parent state is re-entered. This generates a hidden state variable that stores the previous substate ID and produces conditional entry logic based on this remembered value. SLCI cannot trace the history variable and its update logic to any explicit chart element.

##### Fix

Remove history junctions. Use explicit state variables to track previous state and add conditional transitions based on those variables.

#### Header junctions must have two incoming and two outgoing transitions

##### Why SLCI Requires This

Header junctions form the top of junction-based loop structures. SLCI recognizes the loop pattern only when the header has exactly two incoming transitions (initial entry and loop back) and two outgoing transitions (continue loop and exit loop). Deviations produce non-standard loop code that SLCI's loop recognizer cannot match.

##### Fix

Restructure the junction network so that loop headers conform to the standard two-in/two-out pattern.

#### Terminating junctions must not trace back to a Stateflow state

##### Why SLCI Requires This

Terminating junctions mark the end of a transition path. If a terminating junction traces back to a state, this creates an implicit cycle. SLCI expects terminating junctions to truly terminate execution along that path without creating backward references.

##### Fix

Ensure terminating junctions are genuine endpoints. Redirect any backward-flowing paths through proper state transitions instead.

#### Unconditional transition must be last in order of execution -- FATAL

##### Why SLCI Requires This (FATAL)

In generated code, transitions are evaluated in execution order as an if-elseif-else chain. The unconditional transition becomes the `else` clause. If it's not last, it would always execute (being unconditional), making all subsequent transitions unreachable dead code. SLCI requires the unconditional transition last to produce valid C if-else semantics.

##### Fix

Set the unconditional transition's execution order to be last among its sibling transitions (use the Stateflow editor's execution order numbering).

#### Chart must not contain unstructured control flow

##### Why SLCI Requires This

Unstructured control flow (junction networks that cannot be reduced to nested if-else/switch/loop structures) requires goto-based code generation. SLCI's verification engine only supports structured C constructs.

##### Fix

Restructure the junction/transition network to eliminate cross-branch transitions and ensure all paths form proper if-else trees.

---

## Shared Action Constraints (States and Transitions)

The following constraints apply identically to both state actions and transition
actions. They are listed here once; Sections 8 and 9 reference this section for
these items.

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Action must be for one of these supported operations: `:=`, `=`, `+`, `+=`, `-`, `-=`, `*`, `*=`, `/`, `/=`, `&`, `&&`, `&=`, `|`, `||`, `|=`, `<<`, `>>`, `cast()`, `^`, `^=`, `%%`, `<`, `<=`, `==`, `~=`, `!=`, `<>`, `>`, `>=`, `~` | Nonfatal | Check that actions do not have unsupported operations |
| Arrays of more than one dimension must not use indexing | Nonfatal | Check for indexing in arrays that are more than one dimension |
| Arrays must use index of data type `int32` | Nonfatal | Check that all arrays use index of type 'int32' |
| Action must not access context-sensitive constants | Nonfatal | Check that no actions access context-sensitive constants |
| Action must not access custom data | Nonfatal | Check that no actions access custom data |
| Math functions in actions must have: single/double args for `acos`, `asin`, `atan`, `ceil`, `cos`, `cosh`, `exp`, `fabs`, `floor`, `fmod`, `ldexp`, `log`, `log10`, `pow`, `sin`, `sinh`, `sqrt`, `tan`, `tanh`; non-boolean args for `abs`, `max`, `min`; integer arg for `labs` | Nonfatal | Check that no actions contain a function whose argument is of an invalid data type |
| Action must not contain a binary operator with mixed data type operands | Nonfatal | Check that no actions contain a binary operator whose operands are of mixed data type |
| Functions must not have more than 2 arguments | Nonfatal | Check that no Stateflow functions / transitions have a function with more than 2 arguments |
| Actions must not access time (`t`) | Nonfatal | Check that no actions access time (t) |
| Actions must not contain XOR operator with boolean operands when `Casting modes` is `Standards` | Nonfatal | Check that no actions contain an xor operator with boolean operands |
| Charts must not have graphical function calls with unassigned outputs | Nonfatal | Check unassigned graphical function outputs |
| Actions must not use temporal logic operator `at` for explicit events | Nonfatal | Check that actions do not use temporal logic operator 'at' for explicit events |
| Actions must not use temporal logic operator `after` for explicit events | Nonfatal | Check that actions do not use temporal logic operator 'after' for explicit events |
| Actions must not use temporal logic operator `after` for time-based events with a variable or expression as an argument | Nonfatal | Check that actions do not use temporal logic operator 'after' for time-based events |

### Constraint Details

#### Action must be for one of these supported operations

SLCI verifies actions by matching each operation in the generated C code to a corresponding operator in the Stateflow action text. Unsupported operations (e.g., increment `++`, decrement `--`, comma operator, ternary `?:`) may generate code patterns with internal transformations that don't structurally match any single Stateflow operator. Only the listed operations have guaranteed one-to-one mappings.

**Fix:** Rewrite actions using only supported operators. For example, replace `x++` with `x = x + 1`.

#### Arrays of more than one dimension must not use indexing

Multi-dimensional array indexing generates linearized offset calculations (e.g., `arr[row * stride + col]`). The linearization arithmetic has no direct counterpart in the Stateflow action, which uses `arr[row][col]` notation. One-dimensional arrays produce direct index accesses that SLCI can trace.

**Fix:** Flatten multi-dimensional arrays into one-dimensional arrays with explicit index calculation in the action, or use separate one-dimensional arrays.

#### Action must not access context-sensitive constants

Context-sensitive constants (e.g., `eps`, `pi`, `intmax`) are evaluated at compile time and substituted as literal values. The generated code contains a numeric literal with no reference to the original constant name. SLCI cannot trace an anonymous literal back to a named constant in the action text.

**Fix:** Define the constant as a Stateflow `Parameter` data element with an explicit value instead of using MATLAB context-sensitive constants.

#### Action must not access custom data

Custom data generates code through user-defined storage class mechanisms. The resulting variable access patterns (pointer dereferences, structure member access, or macro expansions) depend on the storage class implementation and may not match the simple variable reference in the Stateflow action.

**Fix:** Replace custom data with standard Stateflow data (Local, Input, Output, or Parameter scope).

#### Functions must not have more than 2 arguments

With more than 2 arguments, the code generator may pass arguments via a structure pointer rather than as individual parameters, making it impossible for SLCI to trace each argument back to its Stateflow function definition.

**Fix:** Refactor functions with more than 2 arguments into multiple functions or use Stateflow data (local/input) to pass additional values instead of function arguments.

#### Actions must not access time (`t`)

Accessing the simulation time `t` generates code that reads a runtime timer variable maintained by the simulation engine infrastructure. This timer variable has no explicit Stateflow model element. SLCI cannot trace timer reads to any action element.

**Fix:** Use explicit counter variables incremented in actions instead of directly accessing simulation time.

#### Actions must not contain XOR operator with boolean operands when Casting modes is Standards

In `Standards` casting mode, XOR (`^`) with boolean operands generates platform-specific code because C does not define `^` for `_Bool` type. The generated code may cast booleans to integers, apply XOR, and cast back -- producing conversion code with no Stateflow action counterpart.

**Fix:** Use `~=` instead of `^` for logical XOR on boolean operands, or change Casting modes to `Simplified`.

#### Charts must not have graphical function calls with unassigned outputs

When a graphical function returns a value that is not assigned to a variable, the code generator may compute the function and discard the result, or optimize the call away entirely. SLCI requires every function call to have a corresponding assignment in both the action and the generated code.

**Fix:** Assign the graphical function's return value to a local variable, or remove the function call if the result is not needed.

#### Actions must not use temporal logic operator `at` or `after` for explicit events

Temporal logic operators for explicit events generate event-counting infrastructure (counter variables, increment logic, and threshold comparisons) that tracks how many times a specific event has occurred. Unlike time-based temporal logic, explicit-event counting produces runtime counters whose increment depends on asynchronous event arrivals -- SLCI cannot statically verify this.

**Fix:** Replace `at(n, eventName)` or `after(n, eventName)` with explicit counter variables incremented in transition conditions triggered by the event.

#### Actions must not use temporal logic operator `after` for time-based events with a variable or expression as an argument

When `after` uses a variable or expression as its argument, the timeout threshold is not a compile-time constant. The generated code produces a comparison against a runtime-evaluated expression, making SLCI unable to verify the temporal logic statically.

**Fix:** Use a constant literal as the `after` argument, or replace with an explicit counter variable compared against the threshold variable.

---

## 8. Stateflow States - Mixed Severity

In addition to the constraints below, all [Shared Action Constraints](#shared-action-constraints-states-and-transitions) apply to state actions.

| Constraint | Severity | Compatibility Check |
|---|---|---|
| States must not contain control flow cycles | **FATAL** | Check that control flows do not have cycles |
| Substates and atomic subcharts in a state must have default transitions | Nonfatal | Check that states, substates, or atomic subcharts have default transitions |
| State must not use unsupported operations on enumeration type operands: `+`, `+=`, `-`, `-=`, `*`, `*=`, `/`, `/=`, `&`, `&=`, `|`, `|=`, `^`, `^=`, `%%` | Nonfatal | Check that actions do not have unsupported operations on enumeration type operands |
| Stateflow states must not have recursive send function calls | Nonfatal | Check usage of States with recursive send function calls |
| State property `Function Inline Option` must not be `Auto` or `Function` | Nonfatal | Check usage of Stateflow state InlineOption |
| State property `Create output for monitoring` must not be selected for Leaf state activity | Nonfatal | Check that states are not configured to monitor 'Leaf state activity' |
| States must not contain unstructured control flow | Nonfatal | Check that control flows are structured |
| The control flow must not have more than 1 default transition | Nonfatal | Check that all control flows have unique default transitions |
| Paths from a state must be: inner transition to substate/atomic subchart/same source state, or outer transition to sibling/direct parent/direct substate/same source state | Nonfatal | Check state transition paths |
| Stateflow states must not have entry or exit ports | Nonfatal | Check that the states have no entry or exit ports |
| Stateflow states must not have `Log self activity` and `Test point` properties selected | Nonfatal | Check that states do not have the 'Log self activity' and 'Test point' properties selected |
| Stateflow states must not contain statements that are not explicitly defined in actions | Nonfatal | Check that statements in states are explicitly defined in actions |

### Constraint Details

#### States must not contain control flow cycles -- FATAL

##### Why SLCI Requires This (FATAL)

Control flow cycles within a state's internal junction/transition network produce while-loop code with data-dependent termination. SLCI cannot statically verify loop bounds or prove equivalence between the graphical cycle and the generated loop. This makes the entire state unverifiable.

##### Fix

Replace cyclic junction networks with acyclic decision trees or use explicit for-loop patterns with deterministic bounds.

#### State property Function Inline Option must not be `Auto` or `Function`

##### Why SLCI Requires This

States with `Auto` or `Function` inline options may be generated as separate functions. SLCI expects state actions to be inlined for direct line-by-line verification. When states generate separate functions, the calling pattern introduces overhead that SLCI cannot trace.

##### Fix

```matlab
state = ch.find('-isa', 'Stateflow.State', 'Name', 'myState');
state.InlineOption = 'Inline';
```

#### Stateflow states must not have entry or exit ports

##### Why SLCI Requires This

Entry and exit ports create additional transition entry points that bypass the normal state hierarchy. The generated code produces extra conditional branches for port-based entry/exit that don't follow the standard parent-to-child entry pattern SLCI expects.

##### Fix

Remove entry and exit ports from states. Use standard transitions between states instead.

#### Stateflow states must not have Log self activity and Test point properties selected

##### Why SLCI Requires This

Logging and test points generate additional output signals that expose the state's active status. These create hidden output assignments with no corresponding state action -- diagnostic infrastructure that SLCI cannot trace.

##### Fix

Deselect `Log self activity` and `Test point` in the state properties.

#### Stateflow states must not have recursive send function calls

##### Why SLCI Requires This

Recursive `send()` calls generate re-entrant event dispatching code where a state's action triggers an event that causes the same state to re-execute. SLCI's verification traces each action linearly -- recursive event dispatching creates nested call sequences that SLCI cannot unroll or match to a single action execution path.

##### Fix

Replace recursive `send()` with explicit data flags that are checked in subsequent step executions.

#### State property `Create output for monitoring` must not be selected for Leaf state activity

##### Why SLCI Requires This

Leaf state activity monitoring generates a hidden output signal encoding which leaf state is currently active. This output is updated automatically with no corresponding explicit action. SLCI cannot trace these implicit output assignments to any model element.

##### Fix

Deselect `Create output for monitoring` for `Leaf state activity` in the state properties dialog.

#### Paths from a state must be: inner transition to substate/atomic subchart/same source state, or outer transition to sibling/direct parent/direct substate/same source state

##### Why SLCI Requires This

Transitions that skip hierarchy levels or cross non-adjacent boundaries generate complex parent-exit/child-entry sequences that SLCI cannot decompose into verifiable transition paths.

##### Fix

Restructure transitions to target only: substates (inner), siblings, direct parent, or direct substates (outer). Avoid transitions that skip hierarchy levels.

#### Stateflow states must not contain statements that are not explicitly defined in actions

##### Why SLCI Requires This

Stateflow may implicitly generate code for statements not written in the state's actions (e.g., implicit data initialization on state entry or implicit event broadcasts). SLCI verifies generated code against the explicit action text -- any implicitly generated statements produce untraceable code.

##### Fix

Make all logic explicit in state entry/during/exit actions. Avoid relying on implicit Stateflow behaviors.

#### States must not contain unstructured control flow

##### Why SLCI Requires This

Unstructured control flow within a state's junction/transition network forces the code generator to emit goto-based code. SLCI's verification engine requires that all code within a state maps to a hierarchical decision tree. Goto statements create non-local jumps that break the one-to-one correspondence.

##### Fix

Restructure the state's internal junction/transition network so that all paths form proper nested if-else trees. Eliminate cross-branch transitions that converge at shared junctions from different decision levels.

#### The control flow must not have more than 1 default transition

##### Why SLCI Requires This

Each state containing substates must have exactly one default transition to define the unambiguous initial child state. When multiple default transitions exist, the code generator produces an if-else chain whose branch order depends on geometric position. SLCI cannot determine which branch traces to which default transition arrow. A single unconditional default produces a direct assignment -- unambiguously traceable.

##### Fix

Remove extra default transitions so that each state with substates has exactly one default transition pointing to one child state.

#### Substates and atomic subcharts in a state must have default transitions

##### Why SLCI Requires This

Without a default transition, when a state containing substates is entered, the active child state variable remains uninitialized. The generated code either produces an uninitialized state variable read (undefined behavior) or implicit initialization logic with no corresponding chart element. SLCI requires deterministic, explicit initialization.

##### Fix

Add a default transition to one child state in every state that contains substates or atomic subcharts:

```matlab
% In the Stateflow editor, draw a default transition arrow
% to the intended initial substate within the parent state.
```

---

## 9. Stateflow Transitions - Nonfatal

In addition to the constraints below, all [Shared Action Constraints](#shared-action-constraints-states-and-transitions) apply to transition actions.

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Transition condition must be of Boolean data type | Nonfatal | Check that all transition conditions are of boolean data type |
| Transition must not use unsupported operations on enumeration type operands: `+`, `+=`, `-`, `-=`, `*`, `*=`, `/`, `/=`, `&`, `&=`, `|`, `|=`, `^`, `^=`, `%%`, `~`, `||`, `&&`, `>`, `<`, `<=`, `>=`, `~=`, `<>`, `>>`, `<<` | Nonfatal | Check that conditions and actions do not have unsupported operations on enumeration type operands |
| Transition must not have an event trigger | Nonfatal | Check that no transitions have event triggers |
| Transition must not have a transition action | Nonfatal | Check that transitions do not have transition actions |
| Stateflow transitions must not reuse induction variables outside of a loop | Nonfatal | Check that Stateflow transitions do not reuse induction variables outside of a loop |
| Stateflow loops must not have unsupported step in transitions | Nonfatal | Check that transitions do not have an unsupported loop step |
| Stateflow loops must not have an unsupported body in transitions | Nonfatal | Check that transitions do not have an unsupported loop body |
| Stateflow loops must not have an unsupported condition in transitions | Nonfatal | Check that transitions do not have an unsupported loop condition |
| Stateflow loops must have a valid induction variable in transition that defines loop condition | Nonfatal | Check for valid induction variable in transition that defines loop condition |
| Stateflow loops must not have unsupported initialization actions in transitions | Nonfatal | Check that transitions do not have unsupported loop induction variable initialization |
| Charts must not contain transitions configured as variant transitions | Nonfatal | Check that Stateflow transitions are not configured as variant transitions |

### Constraint Details

#### Transition condition must be of Boolean data type

##### Why SLCI Requires This

Non-boolean transition conditions require implicit conversion to boolean in the generated `if` statement (e.g., `if ((int32_T)x != 0)` instead of `if (x)`). The implicit `!= 0` comparison has no explicit counterpart in the Stateflow transition condition. Boolean conditions produce a direct `if (condition)` that SLCI can trace one-to-one.

##### Fix

Use explicit boolean expressions in transition conditions:
```matlab
% Instead of: [x]
% Use: [x > 0] or [x ~= 0]
```

#### Transition must not have an event trigger

##### Why SLCI Requires This

Event-triggered transitions generate event-dispatching infrastructure: the chart maintains an event queue, and transitions are evaluated only when specific events fire. This produces event-checking code that wraps the transition condition. SLCI expects transitions to be evaluated unconditionally (guard-condition only) in the step function.

##### Fix

Remove event triggers from transitions. Use guard conditions that check equivalent state variables instead.

#### Transition must not have a transition action

##### Why SLCI Requires This

Transition actions execute between source state exit and destination state entry. In generated code, this produces statements interleaved between the exit action block and entry action block. SLCI maps code to individual model elements, but transition action code appears in a position that's neither "transition condition" nor "state action," creating an ambiguous mapping.

##### Fix

Move transition action code to the destination state's entry action or the source state's exit action.

#### Stateflow transitions must not reuse induction variables outside of a loop

##### Why SLCI Requires This

When a junction-based loop's induction variable is reused in transitions outside the loop body, the generated code shares a loop counter variable across multiple scopes. SLCI expects induction variables to be scoped to their loop -- reuse outside creates variable aliasing that prevents clean mapping.

##### Fix

Use separate variables for loop induction and non-loop computations.

#### Stateflow loops must have valid induction variable, supported step, condition, and body

##### Why SLCI Requires This

SLCI recognizes junction-based loop patterns by matching them against standard C `for` loop components. If any component doesn't fit the standard pattern, SLCI cannot produce a verifiable `for` loop mapping. Invalid patterns generate while-loops or unstructured code that SLCI cannot verify.

##### Fix

Ensure junction-based loops follow the standard pattern:
- One transition initializes the induction variable
- One transition tests the loop condition
- One transition increments with a constant step
- The loop body uses standard supported operations

#### Charts must not contain transitions configured as variant transitions

##### Why SLCI Requires This

Variant transitions are conditionally included based on variant conditions, producing either compile-time `#if` guards or runtime variant checks around the transition code. SLCI expects all transitions to be unconditionally present in the generated code for verification.

##### Fix

Resolve variant conditions at update-diagram time or remove variant configuration from transitions.

---

## 10. Stateflow Truth Tables - Mixed Severity

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Control flows must not have cycles | **FATAL** | Check that control flows do not have cycles |
| Truth table property `Function Inline Option` (`InlineOption`) must not be `Auto` or `Function` | Nonfatal | Check usage of InlineOption setting |
| Truth table must not be recursive | Nonfatal | Check usage of recursive Stateflow function |
| Control flows must be structured | **FATAL** | Check that control flows are structured |
| States must not specify truth tables with different actual and expected argument data types | Nonfatal | Check data type of truth table arguments |
| States must not specify truth tables with different actual and expected argument sizes | Nonfatal | Check dimensions of truth table arguments |
| Transitions must not specify truth tables with different actual and expected argument data types | Nonfatal | Check data type of truth table arguments |
| Transitions must not specify truth tables with different actual and expected argument sizes | Nonfatal | Check dimensions of truth table arguments |
| Truth tables must not call MATLAB functions | Nonfatal | Check that truth tables do not call MATLAB functions |

### Why SLCI Requires This

Truth tables generate decision logic as nested if-else or switch-case code. Control flow cycles produce loop code that cannot be statically verified. Unstructured control flow produces goto-based code patterns. Recursive truth tables create unbounded call stacks. MATLAB function calls from truth tables mix two code-generation paradigms that SLCI cannot jointly verify.

### Fix

```matlab
% Set truth table inline option
tt = ch.find('-isa', 'Stateflow.TruthTable', 'Name', 'myTruthTable');
tt.InlineOption = 'Inline';

% Remove recursion by restructuring truth table logic
% Remove MATLAB function calls - use graphical function equivalents
```

---

## 11. Truth Table Blocks - Mixed Severity

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Block parameter `Saturate on integer overflow` must not be selected | Nonfatal | Check that no truth tables specify saturation on overflow for integer operations |
| Block parameter `Support variable-size arrays` must not be selected | **FATAL** | Check that no truth tables support variable-size arrays |
| Block parameter `Update method` must be set to `Inherited` | Nonfatal | Check Truth Table blocks |

### Why SLCI Requires This

Truth Table blocks are Simulink blocks containing truth table logic. The same rationale applies as for charts: saturation injects conditional overflow code, variable-size arrays require dynamic allocation, and non-inherited update methods alter execution scheduling.

### Fix

```matlab
set_param('model/TruthTable', 'SaturateOnIntegerOverflow', 'off');
set_param('model/TruthTable', 'SupportVariableSizeArrays', 'off');
set_param('model/TruthTable', 'UpdateMethod', 'Inherited');
```

---

## 12. State Transition Table Blocks - Mixed Severity

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Block parameter `Execute (enter) State Transition Table at initialization` must not be selected | Nonfatal | Check that no state transition tables execute at initialization |
| Block parameter `Saturate on integer overflow` must not be selected | Nonfatal | Check that no state transition tables specify saturation on overflow for integer operations |
| Block parameter `Update method` must be set to `Inherited` | Nonfatal | Check that all state transition tables specify 'Inherited' as their update method |
| Block parameter `Support variable-size arrays` must not be selected | **FATAL** | Check that no state transition tables support variable-size arrays |
| Block parameter `Create output for monitoring` must not be selected | Nonfatal | Check that all state transition tables unselect 'Create output for monitoring' option |
| Block parameter `Enable Super Step Semantics` must not be selected | Nonfatal | Check that all state transition tables unselect 'Enable Super Step Semantics' option |
| Block parameter `State Machine Type` must not be set to `Moore` | Nonfatal | Check usage of State Machine Type |

### Why SLCI Requires This

State Transition Table blocks present state machine logic in tabular form. The same fundamental constraints apply as for charts: initialization execution produces one-shot code outside the periodic path, saturation adds conditional clamping, variable-size arrays need dynamic allocation, monitoring outputs create hidden signals, and Super Step/Moore semantics alter execution order.

### Fix

```matlab
set_param('model/STT', 'ExecuteAtInitialization', 'off');
set_param('model/STT', 'SaturateOnIntegerOverflow', 'off');
set_param('model/STT', 'UpdateMethod', 'Inherited');
set_param('model/STT', 'SupportVariableSizeArrays', 'off');
set_param('model/STT', 'HasOutputData', 'off');
set_param('model/STT', 'EnableSuperStepSemantics', 'off');
```

---

## 13. Stateflow Atomic Subcharts - Nonfatal

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Atomic subcharts must not have Code generation function packaging set to `Auto` or `Reusable Function` | Nonfatal | Check Stateflow atomic subcharts |
| Atomic subcharts must not have `Create output for monitoring` property selected | Nonfatal | Check that atomic subcharts unselect 'Create output for monitoring' option |
| Atomic subcharts must not use the `at` temporal logic operator | Nonfatal | Check usage of temporal logic operator 'at' in atomic subcharts |
| Atomic subcharts must not use the `after` temporal logic operator | Nonfatal | Check usage of temporal logic operator 'after' in atomic subcharts |

### Constraint Details

#### Atomic subcharts must not have Code generation function packaging set to `Auto` or `Reusable Function`

##### Why SLCI Requires This

`Auto` allows the code generator to choose packaging unpredictably. `Reusable Function` generates a shared function called from multiple contexts with instance-specific data -- SLCI cannot independently verify each invocation because the data context differs. `Inline` or `Nonreusable function` produces deterministic, context-specific code.

##### Fix

```matlab
subchart.CodeGenerationFunctionPackaging = 'Nonreusable function';
% or 'Inline'
```

#### Atomic subcharts must not have `Create output for monitoring` property selected

##### Why SLCI Requires This

Monitoring outputs generate hidden state-ID output assignments with no corresponding subchart action.

##### Fix

```matlab
subchart.HasOutputData = false;
```

#### Atomic subcharts must not use the `at` or `after` temporal logic operator

##### Why SLCI Requires This

Temporal logic operators in atomic subcharts generate timer counter variables within the subchart's execution context. Since atomic subcharts may execute within different parent state contexts, the timer infrastructure can conflict with parent timing or produce duplicate counter management code that SLCI cannot attribute to a specific temporal expression.

##### Fix

Remove temporal logic from atomic subcharts. Implement timing logic in the parent chart using explicit counter variables.


##### Fix

Remove entry and exit ports from atomic subcharts. Use standard transitions to/from the subchart's parent state hierarchy instead.

---

## FATAL Constraints Summary

| Object | Constraint | Severity |
|---|---|---|
| Charts | Must not contain Atomic Boxes or Simulink based states | FATAL |
| Charts | `Support variable-size arrays` must not be selected | FATAL |
| Charts | Must not contain linked atomic subcharts | FATAL |
| Graphical Functions | Must not contain control flow cycles | FATAL |
| Graphical Functions | Must not contain unstructured control flow | FATAL |
| Junctions | Non-terminating junctions must have exactly one unconditional exiting transition | FATAL |
| Junctions | Unconditional transition must be last in execution order | FATAL |
| States | Must not contain control flow cycles | FATAL |
| Truth Tables | Control flows must not have cycles | FATAL |
| Truth Tables | Control flows must be structured | FATAL |
| Truth Table Blocks | `Support variable-size arrays` must not be selected | FATAL |
| State Transition Table Blocks | `Support variable-size arrays` must not be selected | FATAL |

---

## Common Patterns Across Stateflow Constraints

1. **No variable-size arrays** - Applies to: Charts, Truth Table Blocks, State
   Transition Table Blocks. Dynamic allocation code cannot be statically verified.

2. **No saturation on integer overflow** - Applies to: Charts, MATLAB functions,
   Truth Table Blocks, State Transition Table Blocks. Conditional clamping code
   has no model-element correspondence.

3. **No control flow cycles** - Applies to: Graphical Functions, States, Truth
   Tables. Unbounded loops cannot be statically verified for termination.

4. **Structured control flow required** - Applies to: Graphical Functions,
   Junctions, States, Truth Tables. Unstructured (goto-like) patterns cannot be
   mapped to verifiable C constructs.

5. **No mixed data type operands** - Applies to: States, Transitions. Implicit
   type conversions in generated code have no model-element correspondence.

6. **Function argument types/sizes must match** - Applies to: MATLAB functions,
   Graphical functions, Simulink functions, Truth tables (called from states or
   transitions). Mismatches inject conversion code.

7. **Temporal logic restricted to `at`/`after` for implicit events only** -
   Applies to: Charts, States, Transitions, Atomic subcharts. Other temporal
   operators or explicit-event usage generates untraceable timer infrastructure.

8. **`Update method` must be `Inherited`** - Applies to: Charts, Truth Table
   Blocks, State Transition Table Blocks. Non-inherited methods alter execution
   scheduling.

9. **`InlineOption` must be `Inline` (or `Function` for some objects)** - Applies
   to: MATLAB functions, Graphical functions, Truth tables, States. `Auto`
   setting produces unpredictable code organization.


----

Copyright 2026 The MathWorks, Inc.

----
