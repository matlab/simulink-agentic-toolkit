# MATLAB Function Block Constraints

SLCI supports a subset of MATLAB Function block language and features for code
inspection. The code inspector verifies the use of the MATLAB Function block
and enforces constraints on the block itself, its data, and its code to ensure
generated C code can be traced back to the MATLAB source. Before code
inspection, the compatibility checker detects and reports violations of MATLAB
Function block constraints.

---

## Supported Features Summary

| Feature | What is Supported |
|---|---|
| **Data type** | Built-in: `boolean`, `int8`, `int16`, `int32`, `int64`, `uint8`, `uint16`, `uint32`, `uint64`, `single`, `double`; Bus; Enumerated types from `Simulink.IntEnumType` |
| **Data dimension/complexity** | Scalar, vector, matrix; Sample-based output; Real data only |
| **Data scope** | Input, Output, Parameter, Data store memory, Persistent variables, Storage classes of supported types |
| **Block setting** | Function packaging (`RTWSystemCode`) set to `Inline` (or `Nonreusable function`/`Reusable function` in supported configurations) |
| **Scalar operations** | Arithmetic (`uminus`, `uplus`, `minus`, `plus`, `*`); Relational (`>`, `>=`, `<`, `<=`, `==`, `~=`); Logical (`&`, `|`, `&&`, `||`, `not`); `ldivide` (`.\`), `rdivide` (`./`); `power`; Transpose (`'`, `.'`); Tilde (`~`) |
| **Vector/matrix operations** | Element-wise operators; Assignment for same-size vectors/matrices; Array subscripting; Colon (`:`) for integer/double with ≤3 operands; Concatenation of nonvariable-size scalar arrays; Matrix multiplication (`*`); Transpose; `ldivide`/`rdivide` for floating-point; Tilde (`~`) |
| **Program statements** | Compound statements; `if`/`elseif`/`else`; `for`; `switch`; `break`; `while` (with constant bounds, constant-initialized iterator, no multiple step sizes) |
| **Built-in functions** | `cast`; Direct cast (`int8`–`double`); `true`/`false`; `zeros`/`ones`; `assert`; Math: `rem`, `abs`, `sqrt`, `size`, `ceil`, `floor`, `fix`, `log`, `log10`, `exp`, `hypot`, `mod`, `round`, `pow2`, `min`, `max`, `sum`, trig functions; `diag`; `eye`; `is*` functions; Bit-wise ops; Logical: `all`, `any`; Array ops: `dot`, `cross`, `length`, `mean`, `numel`, `prod`, `reshape`, `nnz`; `sign`; `deg2rad`; `rad2deg`; `eps`; `norm` |
| **Functions** | Block-level functions; Standalone user-defined functions; Local functions; `coder.inline('always')`/`coder.inline('never')`; `coder.updateBuildInfo`; `coder.const`; `coder.extrinsic`; `coder.nullcopy`; `coder.ceval` |
| **Reporting** | Block-level traceability and verification |
| **Mangled functions** | Verification of mangled function names from division expressions (listed in report for manual body verification) |

---

## 1. MATLAB Function Block Constraints - Mixed Severity

These constraints apply to the MATLAB Function block itself.

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Block names must not contain `*/` or `/*`; must not start or end with `*` | Nonfatal | Check for block names that contain '/*','*/', or start or end with '*' |
| Output signal storage class must be set to `Auto` when block has constant (Inf) sample time | Nonfatal | Check for unsupported usage of storage class |
| Output port must not be testpointed when block has constant (Inf) sample time | Nonfatal | Check for unsupported testpoints |
| Output signal custom storage class must have Type set to `Unstructured` or `FlatStructure` | Nonfatal | Check storage class of block outports |
| Output signal custom storage class must have Data initialization set to a value other than `None` | Nonfatal | (same check) |
| Output signal custom storage class must be one of: `Auto`, `Model Default`, `ExportedGlobal`, `ImportedExtern`, `ImportedExternPointer`, `Volatile`, `ExportToFile`, `ImportFromFile`, `FileScope`, `GetSet`, `Reusable` | Nonfatal | (same check) |
| If Data Scope is `Auto`, storage class must be `Reusable` | Nonfatal | (same check) |
| Output signal must not reference a signal object with a non-empty `InitialValue` | Nonfatal | (same check) |
| Input and output ports must be scalars, vectors, or 2-D matrices | Nonfatal | Check for blocks with greater than two-dimensional inputs or outputs |
| Input and output ports must not use frame-based signals | Nonfatal | Check whether inputs and outputs are not framed |
| MATLAB function must set `Update method` to `Inherited` | Nonfatal | Check that all MATLAB functions set 'Update method' to 'Inherited' |
| Function packaging (`RTWSystemCode`) must be set to `Inline`. If `Nonreusable function` or `Reusable function` is selected, subsystem and model must be in supported configurations | Nonfatal | Identify Subsystems that have unsupported configurations for non-inlined |
| MATLAB function must not use input Trigger signals | Nonfatal | Check that MATLAB functions do not contain input Trigger signals |
| Block that is constant or has tunable parameters must not drive two or more multirate blocks without explicit Rate Transition blocks | Nonfatal | Check that blocks that are constant or whose parameters can be tuned, do not drive two or more multirate blocks without using explicit rate transition blocks |
| Saturate on integer overflow (`SaturateOnIntegerOverflow`) must not be selected (set to `off`) | Nonfatal | Check that all MATLAB functions set 'Saturate on integer overflow' to 'Off' |
| `Treat these inherited Simulink signal types as fi objects` must not be set to `Fixed-point & Integer` | Nonfatal | Check that all MATLAB functions set 'Treat these inherited Simulink signal types as fi objects:' to a value other than 'Fixed-point & Integer' |
| `Support variable-size arrays` must not be selected (set to `off`) | **FATAL** | Check that all MATLAB functions set 'Support variable-size arrays' to 'Off' |

### Constraint Details

#### FATAL: Support variable-size arrays must not be selected

**Severity: FATAL — terminates code inspection entirely.**

##### Why SLCI Requires This

Variable-size arrays generate `_data`/`_size` paired variables with runtime
dimension tracking throughout the function. Loop bounds become data-dependent,
array copies use computed sizes, and size propagation code has no MATLAB source
counterpart. SLCI cannot statically determine array bounds or verify the
dimension tracking logic.

##### Fix

```matlab
set_param('model/MATLAB Function', 'SupportVariableSizeArrays', 'off');
```

#### Update method must be `Inherited`

##### Why SLCI Requires This

When set to `Discrete` or `Continuous`, the MATLAB Function block generates
separate output and update functions with explicit sample time handling. SLCI
expects the MATLAB Function's code to appear inline within the model's step
function at the inherited sample rate. Non-inherited update methods produce
rate-specific function wrappers that SLCI cannot trace.

##### Fix

```matlab
set_param('model/MATLAB Function', 'UpdateMethod', 'Inherited');
```

#### MATLAB function must not use input Trigger signals

##### Why SLCI Requires This

Trigger inputs on MATLAB Function blocks generate edge-detection and
conditional execution code that wraps the entire function body. This trigger
infrastructure has no correspondence in the MATLAB source code inside the
block. SLCI expects the MATLAB code to execute unconditionally within its
parent's execution context.

##### Fix

Remove the trigger port from the MATLAB Function block. Use a Triggered
Subsystem containing the MATLAB Function block instead.

#### SaturateOnIntegerOverflow must not be selected

##### Why SLCI Requires This

Saturation guards insert multi-branch conditional code around every integer
arithmetic operation. The MATLAB source only shows `a + b`, but the generated
code contains overflow-checking `if/else` branches. SLCI cannot trace the
saturation conditions back to the simple arithmetic expression in the MATLAB
source.

##### Fix

```matlab
set_param('model/MATLAB Function', 'SaturateOnIntegerOverflow', 'off');
```

#### Treat inherited Simulink signal types as fi objects must not be `Fixed-point & Integer`

##### Why SLCI Requires This

When set to `Fixed-point & Integer`, integer signals entering the MATLAB
Function are treated as fixed-point `fi` objects internally. This produces
fixed-point scaling, rounding, and overflow code that SLCI's type system does
not support. SLCI requires integer signals to remain as standard integer types
throughout the generated code.

##### Fix

```matlab
set_param('model/MATLAB Function', 'eml_fiaccel', 'Fixed-point');
% Or set to 'None'
```

#### Function packaging (RTWSystemCode) must be `Inline` (or supported non-inline configuration)

##### Why SLCI Requires This

When inlined, the MATLAB Function's generated code appears directly in the
step function with direct variable access. Non-inline configurations produce
separate functions with argument passing or model pointer access. For non-inline
to be supported, the parent subsystem and model must meet specific interface
requirements (void-void for nonreusable, individual arguments for reusable).

##### Fix

```matlab
set_param('model/MATLAB Function', 'RTWSystemCode', 'Inline');
```

### Fix (General)

```matlab
% Configure MATLAB Function block
set_param('model/MATLAB Function', 'SaturateOnIntegerOverflow', 'off');
set_param('model/MATLAB Function', 'SupportVariableSizeArrays', 'off');
set_param('model/MATLAB Function', 'UpdateMethod', 'Inherited');
```

---

## 2. Data in MATLAB Functions - Nonfatal

These constraints apply to data defined within MATLAB Function blocks.

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Data defined in a MATLAB function must be of a supported data type: built-in, bus, or enumerated type inherited from `Simulink.IntEnumType` | Nonfatal | Check that data defined in MATLAB function is of a supported data type |
| Data defined in a MATLAB function must be of a supported dimension: scalar, vector, or matrix | Nonfatal | Check that data defined in MATLAB function is of a supported dimension |
| Data defined in a MATLAB function must be noncomplex | Nonfatal | Check that data defined in MATLAB function is non-complex |

### Constraint Details

#### Data must be of a supported data type

##### Why SLCI Requires This

Unsupported types (fixed-point, custom classes) produce code with scaling or
method-dispatch logic that SLCI cannot trace. The scaling operations have no
corresponding MATLAB assignment.

#### Data must be noncomplex

##### Why SLCI Requires This

Complex data generates paired `.re`/`.im` variables and operations. SLCI
cannot independently verify the real and imaginary components against a single
MATLAB variable assignment.

### Fix

```matlab
% Ensure all variables use supported types
% Replace complex variables with separate real/imaginary variables
% Replace N-D arrays with 2-D matrices or vectors
```

---

## 3. Code in MATLAB Functions - Nonfatal

These constraints apply to the MATLAB code within MATLAB Function blocks.

### 3.1 Function and Variable Constraints

| Constraint | Severity | Compatibility Check |
|---|---|---|
| To use non-inlined user-defined functions with global variables: functions must not be inside a reusable or void-void subsystem; `CodeInterfacePackaging` must be `Nonreusable function` | Nonfatal | Check non-inlined user defined functions with global variables in MATLAB code |
| Function calls in MATLAB code must resolve to a known function definition | Nonfatal | Check that all function calls in MATLAB code resolve to a known function definition |
| MATLAB functions must not have missing data type information | Nonfatal | Check that no code in MATLAB functions has missing data type information |
| MATLAB functions must not have missing dimension information | Nonfatal | Check that no code in MATLAB functions has missing dimension information |
| Model must not define recursive functions in MATLAB code | Nonfatal | Check usage of recursive functions in MATLAB code |
| For MATLAB root functions: either do not specify `coder.inline` directive or set to `always` | Nonfatal | Check that MATLAB root functions and user-defined MATLAB functions use supported coder.inline directives |
| For user-defined MATLAB functions: explicitly set `coder.inline` to `always` or `never` | Nonfatal | (same check) |
| Subfunctions in MATLAB code must not call function call outputs | Nonfatal | Check usage of function call outputs in MATLAB code |
| MATLAB code must not contain the definition of inner function | Nonfatal | Check usage of inner functions in MATLAB code |
| MATLAB functions must not contain unsupported MATLAB code | Nonfatal | Check for unsupported MATLAB code in MATLAB functions |
| MATLAB function must not contain code for function argument validation | Nonfatal | Check for unsupported MATLAB code in MATLAB functions |

### 3.2 Array and Indexing Constraints

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Array subscripting must use a constant index value of 1 for a corresponding dimension of size 1 | Nonfatal | Check that array subscripting in MATLAB code uses a constant index of 1 for a corresponding dimension of size 1 |
| Array indexing must use a subscript that is less than or equal to the array base dimension | Nonfatal | Check that array indexing in MATLAB code uses a subscript that is less than or equal to the array base dimension |
| Identifiers used in assignment, array, function call arguments and function definition arguments must be scalar, vector, or matrix. Identifiers in any other context must be scalar | Nonfatal | Check that code in MATLAB function is of a supported dimension |
| Brackets in MATLAB code must not be empty | Nonfatal | Check for nonempty brackets in MATLAB code |

### 3.3 Operator Constraints

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Operators in MATLAB functions must not have operands with mixed data type | Nonfatal | Check that operators used in MATLAB function do not have operands with mixed data type |
| Operands of the dot power operator must be of `single` or `double` data type | Nonfatal | Check that data defined in MATLAB function is of a double or single data type |
| The colon (`:`) operator must not have more than 3 operands | Nonfatal | Check that colon operators in MATLAB code have no more than 3 operands |
| The colon (`:`) operator must use integer or double data | Nonfatal | Check that colon operators in MATLAB code use only integer and double data |
| The colon (`:`) operator must use scalar operands | Nonfatal | Check that operators and functions in MATLAB code have supported operand dimensions |
| Division operations must use scalar or non-scalar floating-point operands | Nonfatal | Check that operators and functions in MATLAB code have supported operand dimensions or data types |
| When using matrix operations, Loop unrolling threshold must not result in partially unrolled loops in generated code | Nonfatal | Check that the 'Loop unrolling threshold' does not result in partially unrolled loops in the generated code when using matrix operations in MATLAB code |

### 3.4 Statement Constraints

| Constraint | Severity | Compatibility Check |
|---|---|---|
| `for` statements must have index range values that are literal const integers | Nonfatal | Check that for statements in MATLAB code have index range values that are literal const integers |
| `for` statements must have scalar index values | Nonfatal | Check that for statements in MATLAB code have scalar index values |
| `if` statements must use conditions that are scalar | Nonfatal | Check that if statements in MATLAB code use conditions that are scalar |
| `switch` statements must not have case expressions containing a cell array | Nonfatal | Check that switch statements in MATLAB code do not have case expressions containing a cell array |
| `switch` statements must use the same scalar integer type for all switch and case conditions | Nonfatal | Check that switch statements in MATLAB code use the same scalar integer type for all conditions |
| `switch` statements must not have case expressions that use a cell array containing a non-literal or a nested cell array | Nonfatal | Check that switch statements in MATLAB code do not have case expressions containing a cell array with a non-literal or a nested cell array |
| Conditional initialization of a persistent variable must use an `if` statement with a single `isempty(persistent)` or `~isempty(persistent)` condition | Nonfatal | Check that conditional initialization of persistent variables uses an 'if' statement with a single isempty(persistent) or ~isempty(persistent) condition |
| Conditional initialization of a persistent variable must contain only one statement in `if` statement body | Nonfatal | Check that there is only one initialization statement of a persistent variable in 'if' statement body |

### 3.5 Built-in Function Constraints

| Constraint | Severity | Compatibility Check |
|---|---|---|
| `cast` function must be: `cast(A,'newclass')` or `cast(A,'like',p)` | Nonfatal | Check type argument for cast in MATLAB functions |
| Data used in a MATLAB function must be: `boolean`, `int8`, `int16`, `int32`, `int64`, `uint8`, `uint16`, `uint32`, `uint64`, `single`, `double`, or scalar bus | Nonfatal | Check that data used in MATLAB function is of a supported data type |
| A diagonal number specified for `diag` function must be a constant (e.g., `D = diag(v,k)` where `k` is constant) | Nonfatal | Check that diagonal number used in a diag function in MATLAB code is constant |
| Math functions must use integer or floating-point data | Nonfatal | Check that math functions in MATLAB code use only integer and floating-point data |
| `norm` function must only be used to calculate the 2-norm of vectors | Nonfatal | Check usage of 'norm' function in MATLAB code |
| `all` or `any` function dimension argument (`dim`) must be 1 or 2; vector of dimensions (`vecdim`) must be `[1 2]` or `[2 1]` | Nonfatal | Check that 'all' and 'any' functions in MATLAB code use supported dimension arguments |
| `all` and `any` functions must not use colon operator (`:`) in input arguments | Nonfatal | Check that 'all' and 'any' functions in MATLAB code do not use a colon operator (:) in input arguments |
| `isequal` function must compare only two inputs | Nonfatal | Check usage of 'isequal' function in MATLAB code |

### 3.6 coder.ceval Constraints

| Constraint | Severity | Compatibility Check |
|---|---|---|
| `coder.ceval` must not specify the `-global` option | Nonfatal | Check that coder.ceval in MATLAB code does not specify '-global' option |
| `coder.ceval` must not specify the layout option | Nonfatal | Check that coder.ceval in MATLAB code does not specify layout option |
| `coder.ceval` that calls `snprintf` C function must specify `coder.wref` as the first argument | Nonfatal | Check that coder.ceval in MATLAB code does not have unsupported signatures of 'snprintf' |

### Constraint Details

#### Non-inlined user-defined functions with global variables

##### Why SLCI Requires This

Non-inlined user-defined functions that access global variables generate
function calls where global data is accessed without being passed as arguments.
Inside reusable or void-void subsystems, the function's global access pattern
conflicts with the subsystem's data encapsulation model.

##### Fix

Inline the function with `coder.inline('always')`, or ensure the parent
subsystem uses `Nonreusable function` with `CodeInterfacePackaging` set to
`Nonreusable function`.

#### Function calls must resolve to a known function definition

##### Why SLCI Requires This

Unresolved function calls generate code that SLCI cannot verify — if the
function definition is unknown, SLCI cannot determine what code will be
generated for the call.

##### Fix

Ensure all called functions are either local functions within the same MATLAB
Function block, standalone MATLAB files on the path, or supported built-in
functions.

#### Model must not define recursive functions

##### Why SLCI Requires This

Recursive functions produce unbounded call stacks that SLCI cannot statically
verify. The recursion depth depends on runtime data, making it impossible to
determine the complete call tree at analysis time.

##### Fix

Replace recursive algorithms with iterative equivalents using `for` or `while`
loops with constant bounds.

#### coder.inline directives for root vs user-defined functions

##### Why SLCI Requires This

SLCI needs predictable code structure: root functions should be inlined into
`model_step()` to enable direct line-by-line verification. User-defined
functions must explicitly declare their inlining behavior so SLCI knows whether
to expect inline code or a separate function call.

##### Fix

```matlab
% Root function: either omit coder.inline or use 'always'
function y = rootFcn(u)
    coder.inline('always');
    y = u * 2;
end

% User-defined function: must be explicit
function y = helperFcn(u)
    coder.inline('never');  % or 'always'
    y = u + 1;
end
```

#### MATLAB code must not contain inner function definitions

##### Why SLCI Requires This

Inner functions (nested functions with access to parent workspace) generate
closure-like code patterns where local variables are shared between scopes.
SLCI cannot trace variable access across function boundaries when one function
captures another's workspace.

##### Fix

Convert inner functions to local functions (defined at end of file) or
subfunctions that explicitly pass all needed data as arguments.

#### Operators must not have operands with mixed data types

##### Why SLCI Requires This

Mixed data types inject implicit type promotion/conversion casts in the
generated C code. The MATLAB source shows a simple `a + b` but the C code
contains an implicit cast. SLCI cannot trace the cast back to any explicit
MATLAB operation.

##### Fix

```matlab
% Use explicit casts to ensure same types
y = int32(a) + int32(b);
```

#### for statements must have literal const integer index range values

##### Why SLCI Requires This

SLCI requires statically determinable loop trip counts to verify that the
generated loop executes the expected number of iterations. Variable bounds
make the trip count data-dependent, preventing static verification.

##### Fix

```matlab
% Use literal constant integers for loop bounds
for i = 1:10
    y(i) = u(i) * 2;
end
```

#### while statements must have constant bounds and constant-initialized iterator

##### Why SLCI Requires This

SLCI requires provably bounded loops. A `while` loop with variable bounds
or non-constant iterator initialization produces an indeterminate number of
iterations. SLCI needs to statically verify that the loop terminates and
that the iteration pattern matches the MATLAB source.

##### Fix

```matlab
% Use constant-initialized iterator with deterministic termination
i = int32(0);  % constant initialization
while i < int32(10)  % constant bound
    y(i+1) = u(i+1) * 2;
    i = i + int32(1);  % single constant step size
end
```

#### Conditional initialization of persistent variable must use single `isempty` pattern

##### Why SLCI Requires This

SLCI recognizes persistent variable initialization by matching the specific
code pattern: a single `_not_empty` boolean check followed by one assignment.
Complex conditions or multiple initialization statements produce non-standard
patterns that SLCI's persistent-variable recognizer cannot match.

##### Fix

```matlab
persistent count;
if isempty(count)
    count = int32(0);  % single statement only
end
% Initialize other variables in separate if-isempty blocks
```

#### Loop unrolling threshold must not cause partial unrolling with matrix operations

##### Why SLCI Requires This

When matrix operations produce loops that are partially unrolled (some
iterations unrolled, remainder in a loop), SLCI expects either fully unrolled
code or a complete loop. Partial unrolling produces a hybrid pattern that SLCI
cannot map back to the single matrix operation in the MATLAB source.

##### Fix

```matlab
% Adjust loop unrolling threshold to avoid partial unrolling
set_param('model/MATLAB Function', 'LoopUnrollThreshold', '5');
```

#### coder.ceval must not specify the `-global` option

##### Why SLCI Requires This

The `-global` option tells the code generator that the called function may
modify global variables. This produces memory barrier or volatile access
patterns in the generated code that have no MATLAB source correspondence.

##### Fix

```matlab
% Remove -global option from coder.ceval calls
coder.ceval('myFunc', u);
```

#### coder.ceval must not specify the layout option

##### Why SLCI Requires This

Layout options (`-layout:rowMajor`, `-layout:columnMajor`) cause the code
generator to insert data transposition code around the function call to
convert between MATLAB's column-major and the specified layout. This
transposition code has no MATLAB source counterpart.

##### Fix

```matlab
% Remove layout option from coder.ceval calls
coder.ceval('myFunc', u);
```

#### coder.ceval calling snprintf must specify coder.wref as first argument

##### Why SLCI Requires This

`snprintf` writes to a character buffer — the first argument must be a writable
reference. Without `coder.wref`, the code generator may pass the buffer
incorrectly, producing code that SLCI cannot verify against the `coder.ceval`
call in the MATLAB source.

##### Fix

```matlab
coder.ceval('snprintf', coder.wref(buf), int32(bufSize), coder.ref(fmt), val);
```

### Fix (General)

```matlab
% Ensure no mixed-type operators
% Use explicit cast: y = int32(a) + int32(b);  % not: y = a + b;

% Ensure for-loop bounds are literal constants
for i = 1:10  % supported
% for i = 1:N  % NOT supported (N must be literal const integer)

% Use coder.inline correctly
function y = myRootFcn(u)
    coder.inline('always');  % required for root functions
    y = u * 2;
end

function y = mySubFcn(u)
    coder.inline('never');  % or 'always' - must be explicit
    y = u + 1;
end
```

---

## 4. MATLAB Code Analyzer Messages - Nonfatal

| Constraint | Severity | Compatibility Check |
|---|---|---|
| Issues in MATLAB Function block | Nonfatal | Check MATLAB code used in MATLAB Function blocks |
| Issues in called MATLAB functions | Nonfatal | Check called MATLAB functions |

### Why SLCI Requires This

Code Analyzer messages indicate potential issues in the MATLAB code that may
produce unexpected generated code behavior. These issues signal code patterns
that may not translate cleanly to verifiable C code.

### Fix

```matlab
% Open the MATLAB Function block editor and resolve all Code Analyzer
% warnings (orange underlines) and errors (red underlines)
% Common issues: unused variables, unreachable code, shadowed functions
```

---

## FATAL Constraints Summary

Only one MATLAB Function block constraint is **FATAL**:

| Constraint | Severity |
|---|---|
| `Support variable-size arrays` must not be selected (set to `off`) | **FATAL** |

All other constraints are **Nonfatal** - code inspection continues but may not
fully verify the generated code.

---

## Common Patterns Across MATLAB Function Block Constraints

1. **No variable-size arrays** - The single FATAL constraint. Dynamic allocation
   code cannot be statically verified.

2. **No mixed data types in operators** - Applies to all binary operators.
   Implicit type promotions in generated C have no MATLAB source correspondence.

3. **Scalar conditions required** - `if` conditions, `switch` expressions, and
   colon operator operands must be scalar to produce simple conditional code.

4. **Constant loop bounds** - `for` loop index ranges must be literal const
   integers. Variable bounds produce indeterminate trip counts.

5. **Supported storage classes only** - Same set as Simulink blocks: `Auto`,
   `Model Default`, `ExportedGlobal`, `ImportedExtern`, `ImportedExternPointer`,
   `Volatile`, `ExportToFile`, `ImportFromFile`, `FileScope`, `GetSet`,
   `Reusable`.

6. **No saturation on integer overflow** - Conditional clamping code has no
   MATLAB source correspondence.

7. **Function inlining rules** - Root functions: `always` or unspecified.
   User-defined: explicitly `always` or `never`. Ensures predictable code
   structure for SLCI analysis.

8. **Persistent variable initialization pattern** - Must use single
   `if isempty(var)` with one assignment statement. Complex initialization
   patterns produce code that SLCI cannot map to the simple pattern it expects.

---

## Supported coder.ceval Usage

SLCI supports verification of `coder.ceval` in MATLAB Function blocks, which
calls C/C++ functions from generated code. Requirements:

- C/C++ Source file and Header file must be defined in Configuration Parameters
  under **Code Generation > Custom Code > Insert custom C code in generated**
- The compatibility check "Check code generation settings" will fail with a
  non-fatal warning (expected behavior)
- SLCI verifies these models despite the non-fatal constraint
- You must manually review the external C/C++ files listed under the **Utils
  Verification** section of the SLCI Report

Restrictions:
- Must not use `-global` option
- Must not use layout option
- When calling `snprintf`, must specify `coder.wref` as first argument


----

Copyright 2026 The MathWorks, Inc.

----
