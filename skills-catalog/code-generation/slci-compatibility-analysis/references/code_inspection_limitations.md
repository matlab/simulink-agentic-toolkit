# Code Inspection Limitations

SLCI has known limitations where the compatibility checker cannot detect
incompatibilities, or where code inspection fails despite a compatible model.
These are not constraint violations — they are edge cases and known issues
that require awareness during model design and inspection.

## 1. Limitations of Compatibility Checker to Check Model Compatibility

These are cases where the compatibility checker does NOT detect the
incompatibility, but code inspection still fails.

### 1.1 Non-ASCII Characters in Model Element or Folder Names

**Limitation:** When model element names or folder names contain non-ASCII
characters, code inspection fails. The compatibility checker does not flag this.

**Why:** SLCI's traceability engine parses generated code comments and file paths
to match model elements to code. Non-ASCII characters produce encoding mismatches
between the model's internal SID references and the generated code file
paths/comments.

**Examples:**
- `model_iter.slx` — model name contains `e` (non-ASCII)
- `C:/Modeles/mymodel.slx` — folder path contains `e`

**Fix:** Use only ASCII characters for all model names, element names (blocks,
signals, ports), and folder paths.

### 1.2 Optimize Block Operation Order Set to Improved Code Execution Speed

**Limitation:** When `Optimize block operation order in generated code` is set to
`Improved Code Execution Speed`, code inspection fails due to block operation
order mismatch. The compatibility checker does not detect this.

**Why:** This optimization reorders block execution in the generated code to
maximize buffer reuse and cache performance. The reordering means the execution
sequence no longer matches the simulation execution order, so SLCI cannot
establish the one-to-one mapping.

**Fix:**

```matlab
set_param(model, 'OptimizeBlockOrder', 'off');
```

### 1.3 Enumerated Type Default Value Not 0 in Referenced Model

**Limitation:** In a referenced model, if the initial conditions of an enumerated
type do not have a default value of 0, code inspection fails.

**Why:** SLCI assumes that enumerated type initialization in generated code uses
the zero-value as default. When a referenced model's enumerated type has a
non-zero default, SLCI's equivalence checker cannot reconcile the generated
initialization code with the model's default state representation.

**Fix:** Ensure enumerated types use 0 as the default value:

```matlab
classdef MyEnum < Simulink.IntEnumType
    enumeration
        Off(0)    % default value is 0
        On(1)
    end
end
```

### 1.4 Boolean-to-Int Conversion Feeding Math Operation Block

**Limitation:** If a model contains a block from the Math Operation library that
takes an int input signal converted from a Boolean signal, code inspection fails.

**Why:** When a Boolean signal is cast to an integer before entering a Math
Operation block, the code generator produces a type cast expression with no direct
model-level element, breaking traceability.

**Fix:** Avoid Boolean-to-int conversion before Math Operation blocks. Use a
consistent integer type from the source, or restructure the signal path.

### 1.5 Self-Modifiable Masked Subsystem

**Limitation:** If a model has a self-modifiable masked subsystem that adds or
deletes blocks, the compatibility checker can have unintended behavior.

**Why:** Self-modifiable masked subsystems dynamically change the model structure
through mask initialization or callback code. The model structure that the
compatibility checker sees may differ from what exists during code generation,
making check results unreliable.

**Fix:** Avoid self-modifiable masked subsystems. Use variant subsystems or
configurable subsystems for dynamic model structure.

### 1.6 Step Function with Real-Time Model Function Argument

**Limitation:** A model that contains a step function with a function argument
real-time model is not compatible. A step function with a simplified call
interface IS compatible.

**Why:** When the step function takes the full real-time model (rtM) structure as
an argument, the generated code includes pointer-based access to timing and
runtime infrastructure that SLCI cannot trace back to specific model elements. The
simplified call interface produces a direct `model_step()` function that SLCI can
verify.

**Fix:**

```matlab
set_param(model, 'CombineOutputUpdateFcns', 'on');
set_param(model, 'IncludeMdlTerminateFcn', 'off');
% Configure function prototype to use simplified interface
```

### 1.7 Eliminated Blocks with Non-Auto Storage Class

**Limitation:** If blocks eliminated during model compilation have non-auto storage
class and are not testpointed, code inspection fails.

**Why:** Block reduction optimization removes redundant blocks during compilation.
If a removed block had a non-auto storage class (e.g., `ExportedGlobal`), the code
generator still produces a global variable declaration but no code writes to it.
SLCI finds a variable in code with no corresponding active model element.

**Fix:**

```matlab
% Set signal storage class to Auto so eliminated block produces no code
ph = get_param('model/Gain1', 'PortHandles');
set_param(ph.Outport(1), 'StorageClass', 'Auto');
```

### 1.8 Separate Output and Update Functions

**Limitation:** If models generate code with separate output and update functions,
Code Inspector fails to verify the generated code.

**Why:** SLCI expects a combined `model_step()` function where output computation
and state update occur in sequence. Separate `model_output()` and `model_update()`
functions split the execution flow, making verification impossible.

**Fix:**

```matlab
set_param(model, 'CombineOutputUpdateFcns', 'on');
```

### 1.9 coder.ceval with Custom Code Configuration

**Limitation:** When using `coder.ceval` in MATLAB Function blocks with C/C++
source and header files defined in Code Generation > Custom Code, the
compatibility check "Check code generation settings" fails with a nonfatal warning.
However, SLCI CAN verify these models — this is a false positive from the checker.

**Why:** The compatibility checker flags any custom code configuration as
potentially incompatible because it cannot analyze external C files. However, SLCI
actually supports `coder.ceval` verification. The external C/C++ files appear in
the "Utils Verification" section of the SLCI Report for manual review.

**Action:** Ignore the nonfatal warning. After inspection, manually review the
external C/C++ files listed under Utils Verification in the SLCI Report.

### 1.10 Tunable Parameter Expressions

**Limitation:** If a model contains blocks with tunable parameter expressions or
uses tunable expressions as mask parameters, code inspection fails. The
compatibility checker does not detect this.

**Why:** Tunable parameter expressions (e.g., `2*K+1` where `K` is tunable)
generate runtime expression evaluation code that has no single corresponding model
element. SLCI cannot map the expression back to a model element.

**Fix:** Replace tunable expressions with direct parameter values or pre-computed
constants.

```matlab
% Use direct value instead of expression
set_param('model/Gain', 'Gain', 'K');  % Single tunable, no expression
```

### 1.11 Models Containing a Test Harness

**Limitation:** Models containing a test harness are not compatible with SLCI. The
compatibility checker does not detect these models as incompatible.

**Why:** Test harnesses add auxiliary blocks that generate additional code with no
correspondence to the actual model logic. SLCI cannot distinguish
harness-generated code from model-generated code, causing traceability failures.

**Fix:** Remove or close the test harness before running code inspection.

```matlab
sltest.harness.close('model', 'HarnessName');
% Or delete it
sltest.harness.delete('model', 'HarnessName');
```

### 1.12 Transpose in MATLAB Function Block (Constant or Combined Operator)

**Limitation:** The transpose operator (`.'`) in a MATLAB Function block is not
compatible if the operand is a constant or if the transpose operator is combined
with another operator (e.g., inside a loop).

**Why:** When transpose operates on a constant, the code generator may fold the
result at compile time, producing no runtime transpose operation. When combined
with other operators in loops, operations may be fused, breaking the one-to-one
mapping.

**Fix:** Assign the transpose result to a variable outside of combined expressions
and avoid transposing constants.

```matlab
function y = fcn(u)
    temp = u.';  % standalone transpose, not on a constant
    y = temp;
end
```

### 1.13 Stateflow Graphical Functions with while/do-while Loop Patterns

**Limitation:** Stateflow graphical functions that implement while or do-while-loop
patterns by combining connective junctions and transitions are not compatible. The
compatibility checker does not detect this.

**Why:** When graphical functions use junctions and transitions to create iterative
loop patterns, the code generator produces `while` or `do-while` loops. SLCI's
verification engine expects Stateflow control flow to map to structured if-else
patterns. Loop constructs from junction/transition patterns have no direct
structural correspondence to graphical elements.

**Fix:** Replace junction-based loop patterns with MATLAB Function blocks that
contain explicit while-loops meeting SLCI's conditions, or restructure as
state-based iteration.

### 1.14 while-Loops in MATLAB Function Blocks (Non-Conforming)

**Limitation:** while-loops in MATLAB Function blocks that do not meet ALL of these
conditions are not compatible. The compatibility checker does not detect them.

**Conditions for compatibility:**
1. Loop condition uses less than (`<`) or less than or equal (`<=`) with a constant
   upper bound
2. Iterator is initialized by a constant lower bound
3. Loop does not have multiple step sizes for the index variable

**Why:** SLCI verifies loops by confirming bounded iteration — it must prove the
loop terminates and maps to a known iteration count. Multiple step sizes make
iteration count data-dependent. Non-constant bounds prevent range verification.

**Fix:** Restructure to use a single step size with constant bounds:

```matlab
function y = fcn(u1)
    y = u1(1);
    for i = 1:10           % fixed iteration, single step
        y = y + u1(i);
    end
end
```

### 1.15 while-Loop with break Resulting in do-while

**Limitation:** If a while-loop in a MATLAB Function block containing `break`
statements results in a do-while-loop in the generated code, SLCI might fail.

**Why:** The code generator may optimize a while-loop with an early `break` into a
`do-while` structure when the loop body always executes at least once. This
structural transformation means the generated code's control flow does not match
the model's, and SLCI cannot establish equivalence.

**Fix:** Restructure to avoid `break` statements, or use a flag variable for
loop exit condition.

### 1.16 Buffer for Reusable Subsystems (BufferReusableBoundary)

**Limitation:** When `Buffer for reusable subsystems` is set to `on`, Simulink may
insert hidden Signal Conversion blocks at the subsystem interface during
compilation, causing inspection failures.

**Why:** The hidden buffer blocks generate `memcpy` or assignment statements in
code that have no visible model element. SLCI cannot trace this invisible buffer
code back to any block in the model.

**Fix:** Either set `Buffer for reusable subsystems` to `off`, or enable advanced
loop verification by using the Code Inspector toolstrip or
`setApplyAdvancedLoopSupport` function.

```matlab
set_param(model, 'BufferReusableBoundary', 'off');
% Or enable advanced loop support:
% config = slci.Configuration(model);
% config.setApplyAdvancedLoopSupport(true);
```

## 2. Limitations of Verifying Generated Code with Certain Properties

These are cases where the generated code has properties that prevent SLCI
from verifying it, even though the model may pass compatibility checks.

### 2.1 Initialize Function Passes Timing Information to Referenced Model

**Limitation:** When the initialize function passes timing information to a
referenced model, SLCI fails to verify the initialize function.

**Why:** The timing bridge structure (`TimingBridge`) is runtime infrastructure
that coordinates sample time execution between parent and referenced models. It
has no corresponding model element, so SLCI cannot map the timing bridge
initialization code to any block.

**Workaround:** Avoid multi-rate referenced models that require timing
coordination, or accept that the initialize function will not be verified.

### 2.2 Initialize Function Passes Stop Request to Referenced Model

**Limitation:** If the initialize function passes a stop request signal to a Stop
Simulation block in a referenced model, SLCI does not verify the code.

**Why:** The stop request signal is runtime infrastructure for coordinating
simulation termination across model boundaries. The generated code has no
model-level element that SLCI can trace to.

**Workaround:** Avoid Stop Simulation blocks in referenced models, or accept that
the initialize function will not be verified.

### 2.3 Local Data Exceeds Maximum Stack Size

**Limitation:** If local model data exceeds the maximum stack size, the code
generator implements local variables as global data with global initialization.
SLCI fails to verify this code.

**Why:** SLCI expects local computation variables as stack-allocated locals within
functions. When promoted to globals due to stack size limits, SLCI cannot trace
global variable initialization to in-function computation corresponding to block
execution.

**Fix:**

```matlab
set_param(model, 'MaxStackSize', 'Inf');
```

### 2.4 Stateflow Cyclic Control Flow Resulting in while/do-while

**Limitation:** When Stateflow cyclic control flow results in a `while` or
`do-while` in the generated code, SLCI fails to verify it.

**Why:** Cyclic control flow occurs when graphical functions call each other
recursively. The code generator converts recursion into an iterative loop to avoid
stack overflow. This changes the code structure from recursive function calls to a
flat loop with no structural correspondence to the Stateflow chart.

**Workaround:** Restructure Stateflow charts to avoid recursive/cyclic function
call patterns. Use explicit state-based iteration instead.

## 3. Limitations Due to Modeling Patterns and Elimination of Redundant Functionality

The code generator eliminates redundant model elements during optimization.
When eliminated elements still have side effects or declarations, SLCI cannot
verify the resulting code.

### 3.1 Unused Stateflow Objects

**Limitation:** If a model contains unused Stateflow objects (local variables or
parameters defined in chart scope but not used), code inspection fails.

**Why:** The code generator optimizes out unused Stateflow local variables —
they produce no code. However, SLCI sees these as defined model elements and
expects corresponding code. When no code exists for a model element, traceability
fails.

**Fix:** Remove unused local variables, parameters, and data objects from
Stateflow charts.

### 3.2 Unused Inport to Reusable Subsystem

**Limitation:** If there is an unused inport to a reusable subsystem inside a
subsystem, code inspection fails.

**Why:** When an inport is unused, the code generator may eliminate the
corresponding function parameter. SLCI sees the inport in the model but cannot
find matching code that reads from it, breaking the model-to-code mapping.

**Fix:** Remove unused inports from reusable subsystems.

### 3.3 Unused Graphical Function Inputs

**Limitation:** SLCI does not support verification of unused graphical function
inputs because the code generator optimizes them out.

**Why:** When a graphical function declares an input argument but never uses it,
the code generator removes that parameter from the generated C function signature.
SLCI sees the input in the definition but finds no corresponding parameter in code.

**Fix:** Remove unused input arguments from graphical functions.

### 3.4 Constant Blocks with Matrix Data and Constant Sample Time

**Limitation:** Constant blocks that use constant sample times and matrix data can
trigger optimizations that eliminate blocks during code generation.

**Why:** The code generator can fold constant matrix values directly into
expressions, eliminating the Constant block from the generated code. SLCI expects
each Constant block to produce identifiable code — when folded away, the model
element has no code counterpart.

**Fix:** Avoid matrix-valued Constant blocks with constant sample time, or make
the parameter tunable to prevent folding:

```matlab
set_param('model/Constant', 'SampleTime', '-1');  % inherited sample time
```

## 4. Model Patterns That Can Result in Code Verification Failures

These are specific structural patterns that cause inspection failure.

### 4.1 Model Block with Terminated Outport

**Limitation:** If a model contains a Model block with one outport that is
terminated AND function prototype control is used (defining the terminated outport
as a return port), code verification might fail.

**Why:** When function prototype control designates a terminated outport as the
function return value, no model-level signal drives it. SLCI finds a function
return value in code with no corresponding signal flow in the model.

**Workaround:** Remove the terminated outport or do not use function prototype
control with terminated ports.

### 4.2 Stateflow Objects with Unstructured Control Flow

**Limitation:** Stateflow charts with unstructured control flow (where execution
can skip over portions of the flow graph) fail code inspection.

**Why:** Unstructured control flow occurs when transitions allow bypassing
intermediate junctions. This produces code with complex nested conditionals that
cannot be mapped back to a clean structured path through the junctions.

**Fix:** Restructure Stateflow charts to ensure all paths pass through the same
junction sequence (structured control flow). The compatibility check "Check that
control flows are structured" detects this pattern.

### 4.3 Stateflow Objects with Control Flow Cycles

**Limitation:** Control flows in charts, graphical functions, or states that include
recursive flow cycles are called control flow cycles. Code inspection fails when
the model contains control flow cycles.

**Why:** Infinite recursion can occur if transition conditions are not defined
properly. The code generator converts recursive graphical function calls into
iterative loops, producing code with no structural correspondence to the Stateflow
chart.

**Fix:** Restructure Stateflow charts to avoid recursive/cyclic function call
patterns. The subcheck **Check that control flows do not have cycles** detects this
constraint.

### 4.4 Stateflow Transitions Reusing Induction Variables

**Limitation:** If a Stateflow transition reuses an induction variable outside of
its loop, SLCI does not support it.

**Why:** An induction variable (loop counter) has meaning only within its loop
scope. When reused outside the loop in a transition action, the code generator
produces code that assigns to the same variable in two contexts. SLCI cannot
reconcile the dual usage in a single traceability mapping.

**Fix:** Use separate variables for transition actions — do not reuse loop
induction variables outside their loops. The compatibility check **Check usage of
Stateflow transitions** detects this constraint.

### 4.5 Stateflow Graphical Functions Using while-Loop and do-while-Loop Patterns

**Limitation:** If a model uses graphical functions that implement `while` or
`do-while` loops by combining connective junctions and transitions, code inspection
might fail. The compatibility checker does not flag the pattern as incompatible.

**Why:** When graphical functions use junctions and transitions to create iterative
loop patterns, the code generator produces `while` or `do-while` loops. SLCI's
verification engine expects Stateflow control flow to map to structured if-else
patterns. Loop constructs from junction/transition patterns have no direct
structural correspondence to graphical elements.

**Fix:** Replace junction-based loop patterns with MATLAB Function blocks that
contain explicit while-loops meeting SLCI's conditions, or restructure as
state-based iteration.

### 4.6 MATLAB Function Blocks Using while-Loops

**Limitation:** If MATLAB Function blocks in your model contain `while`-loops that
do not meet one of these conditions, the model might fail code inspection:

- The loop condition is less than or less than or equal to a constant upper bound.
- The iterator is initialized by a constant lower bound.
- The loop does not have multiple step sizes for index.

The model compatibility check does not flag the `while`-loop as unsupported, but
the code inspection fails.

**Why:** SLCI verifies loops by confirming bounded iteration — it must prove the
loop terminates and maps to a known iteration count. Multiple step sizes make
iteration count data-dependent. Non-constant bounds prevent range verification.

**Fix:** Restructure to use a single step size with constant bounds.

## 5. Other Limitations

### 5.1 Model Simulation Returns an Error

**Limitation:** If simulation of a model returns an error, code inspection fails.

**Why:** SLCI relies on successful simulation to establish execution order,
compiled types, and signal dimensions. Without it, SLCI has no reference behavior
to compare against the generated code.

**Fix:** Fix all simulation errors before running code inspection.

### 5.2 Model Modified Without Regenerating Code (SID Mismatch)

**Limitation:** If you modify a model by replacing blocks and inspect code without
regenerating it, inspection fails due to SID mismatch.

**Why:** Every block has a unique Simulink Identifier (SID). When you replace a
block, the new block gets a new SID. Previously generated code still references
the old SID, so SLCI's traceability comparison fails.

**Fix:** Always regenerate code after modifying model blocks before running
inspection.

```matlab
slbuild(model);  % Regenerate code
```

### 5.3 Very Large Signal Size (Stack Exhaustion)

**Limitation:** If a signal size is very large, it can exhaust the machine stack,
resulting in a segmentation violation during code inspection.

**Why:** Very large signal arrays produce correspondingly large code structures
that can overflow the analysis engine's stack during recursive code traversal.

**Fix:** Reduce signal sizes, increase system stack limit, or set
`MaxStackSize` to `Inf`.

```matlab
set_param(model, 'MaxStackSize', 'Inf');
```

### 5.4 Submodel Incompatibilities Affecting Top Model Global Data

**Limitation:** If incompatibilities in a submodel impact global data and data
initialization in the top model, SLCI fails to verify the top model.

**Why:** Referenced models share global data structures with their parent model.
Incompatible patterns in submodels produce unexpected global variable declarations
that propagate into the top model's generated code, with no corresponding blocks
in the top model.

**Fix:** Fix all incompatibilities in all referenced submodels before inspecting
the top model.

```matlab
c = slci.Configuration('submodel');
c.checkCompatibility();
c.fixIncompatibilities();
```

### 5.5 Execution Order Mismatch

**Limitation:** Code inspection might fail when:
- Model execution order does not match generated code execution order
- Code compilation order does not match model compilation order

These mismatches often occur due to optimization.

**Why:** SLCI's structural equivalence checking verifies that statements appear in
the same order as corresponding block executions. Code optimizations can reorder
statements for efficiency, breaking the order-based mapping.

**Fix:**

```matlab
set_param(model, 'OptimizeBlockOrder', 'off');
set_param(model, 'OptimizeBlockIOStorage', 'off');
```

## 6. Limitations of PDF and Word Reports

### 6.1 Table Headers Not Repeated Across Pages

**Limitation:** If a table splits into multiple pages in PDF/Word reports, pages
after the first do not contain table headers.

**Why:** The report generation engine uses standard document formatting that does
not repeat table headers across page breaks.

### 6.2 No Hyperlinks in PDF and Word Reports

**Limitation:** PDF and Word reports do not contain hyperlinks to models, model
objects, and inspected generated code files.

**Why:** Hyperlinks to MATLAB/Simulink objects are only functional within the
MATLAB environment. Use HTML reports for interactive navigation.

## 7. Traceability Matrix Limitations

### 7.1 Windows Only

**Limitation:** Traceability matrix generation works only on Microsoft Windows.

**Why:** The traceability matrix generation uses Windows-specific COM automation
to interface with Microsoft Excel/Word.

### 7.2 No Support for Referenced Model Contents

**Limitation:** When generating a traceability matrix for a model with referenced
models, only the Model block itself appears — not the contents of the referenced
model.

**Why:** Each referenced model generates its own code files independently. The
traceability matrix operates on a single model/code-file pair.

**Workaround:** Generate a separate traceability matrix for each referenced model.

### 7.3 Classic Call Interface (GRTInterface) Not Supported

**Limitation:** Does not support models using `Classic call interface`.

**Why:** Classic call interface (GRT) generates a different code structure with
`SimStruct`-based APIs that the traceability matrix generator cannot parse.

**Fix:**

```matlab
set_param(model, 'GRTInterface', 'off');
```

### 7.4 Non-Unique Comment Identification

**Limitation:** When comments cannot be uniquely identified, the traceability
matrix includes the text: "Row is not unique: comment"

**Why:** If multiple code lines have identical traceability comments, the matrix
cannot determine which model element corresponds to which code line.

**Workaround:** Ensure unique block names across the model to avoid duplicate
traceability comments.

### 7.5 Requirement Links to Annotations Outside DocBlock

**Limitation:** If a requirement is linked to an annotation not contained in a
DocBlock block, the traceability matrix does not include the requirement link.

**Why:** Free annotations do not generate code and are not part of the
model-to-code mapping.

**Fix:** Put annotations in DocBlock blocks to include requirement links in the
traceability matrix.

## See Also

- "Code Inspection Overview"
- "Model Compatibility Checks"
- "Fatal Incompatibilities"
- "Model Patterns That Can Result in Code Verification Failures"
- "Stateflow Graphical Functions Using while-Loop and do-while-Loop Patterns"
- "MATLAB Function Blocks Using while-Loops"
- "Tunable Expression Limitations" (Simulink Coder)

Copyright 2026 The MathWorks, Inc.
