# Code Replacement Libraries Constraints

SLCI verifies model-to-code equivalence by ensuring that every function call
and operator in the generated code can be traced to a model element or a known
library replacement. Code Replacement Libraries (CRLs) allow users to substitute
standard math functions and operators with custom implementations. SLCI supports
only a specific subset of CRL functions and operators, and requires specific
configuration to maintain traceability.

---

## Supported Functions and Operations in Code Replacement Libraries - Nonfatal

SLCI performs a single check for code replacement library compatibility. The
check verifies that all of the following conditions are met. If any condition
is not satisfied, SLCI reports a nonfatal compatibility finding.

### Conditions

1. Only supported functions and operators are used in the CRL
2. Each function is defined in a library only once (no duplicate entries)
3. Each function or operator is defined in a single library (no cross-library duplicates)
4. Libraries specify implementation file paths
5. Target language is set to C
6. Memory function arguments match the conceptual representation

---

### Supported Math Functions

| | | | |
|---|---|---|---|
| abs | acos | acosh | asin |
| asinh | atan | atan2 | atanh |
| ceil | cos | cosh | exp |
| fix | floor | hypot | log |
| log10 | max | min | mod/fmod |
| pow | rem | round | saturate |
| signpow | sin | sincos | sinh |
| sqrt | tan | tanh | |

### Supported Memory Functions

| Function |
|----------|
| memset |
| memcpy |

### Supported Operators

| Operator | Key | Scalar Inputs | Nonscalar Inputs |
|----------|-----|:-------------:|:----------------:|
| Multiplication (*) | RTW_OP_MUL | — | Yes |
| Matrix right division (/) | RTW_OP_RDIV | — | Yes |
| Matrix left division (\\) | RTW_OP_LDIV | — | Yes |
| Matrix inversion (inv) | RTW_OP_INV | — | Yes |
| Transposition (.') | RTW_OP_TRANS | — | Yes |

**Notes:**
1. Matrix division and inversion are supported for Simulink code generation
   only (not for Stateflow or MATLAB Coder code generation).

---

## Condition Details

### Condition 1: Use only supported functions and operators

**Condition:** Code replacement libraries must only replace functions and
operators from the supported lists above.

#### Why SLCI Requires This

SLCI maintains an internal table of recognized CRL function keys (sin, cos, sqrt,
etc.). When it encounters a non-standard function call in the generated code, it
looks up the function name in the CRL registry to determine which mathematical
operation it implements. If the replaced function is not in the supported list,
SLCI has no mapping entry and cannot trace the call back to a model block.

#### Fix

Remove unsupported functions from the CRL, or set CodeReplacementLibrary to
`None` and let the code generator use standard math calls:

```matlab
set_param('myModel', 'CodeReplacementLibrary', 'None');
```

---

### Condition 2: Each function defined in a library only once

**Condition:** Each supported function must have exactly one entry within a
given code replacement library.

#### Why SLCI Requires This

SLCI resolves CRL function calls by looking up the function key (e.g., `sin`)
in the library registry. If the same key appears multiple times within a library,
the mapping becomes ambiguous — SLCI cannot determine which implementation
entry corresponds to a given block, and cannot verify that the correct
replacement was selected for each call site.

#### Fix

Audit the code replacement library definition and ensure each function key
(`sin`, `cos`, `sqrt`, etc.) has exactly one entry. If duplicates exist, remove
the redundant entry so that SLCI has an unambiguous mapping from function key
to implementation name.

---

### Condition 3: Each function or operator defined in a single library

**Condition:** If using multiple CRLs, each supported function or operator
must appear in only one library.

#### Why SLCI Requires This

When multiple libraries each define a replacement for the same function key,
the code generator uses priority to select one. However, SLCI cannot replicate
this priority-based selection logic during verification — it needs a single,
unambiguous library-to-function mapping. Multiple definitions across libraries
create uncertainty about which library "owns" the replacement.

#### Fix

Consolidate all function replacements into a single library, or ensure each
function key appears in only one of the configured libraries:

```matlab
% Incorrect: two libraries both define sin
set_param('myModel', 'CodeReplacementLibrary', 'FastMath, PreciseMath');

% Correct: one library defines sin, the other defines sqrt
set_param('myModel', 'CodeReplacementLibrary', 'FastMath');
% FastMath has: sin, cos, tan
% PreciseMath has: sqrt, exp, log (no overlap)
```

---

### Condition 4: Libraries configured with implementation file paths

**Condition:** Each CRL entry must specify the implementation header file and
source file, with their paths included in the build configuration.

#### Why SLCI Requires This

SLCI verifies that the replacement function's signature (return type, argument
types, argument count) matches the expected mathematical operation. To perform
this verification, SLCI must locate and parse the implementation header file.
Without the path information, SLCI cannot find the file and cannot confirm that
the replacement function is a valid substitute for the standard operation.

#### Fix

For each CRL entry, ensure that `ImplementationHeaderFile` and
`ImplementationSourceFile` are specified, and their containing directories are
listed in `AdditionalIncludePaths` and `AdditionalSourcePaths` respectively.
If using the Code Replacement Tool GUI, set these in the **Build Information**
tab for each replacement entry.

---

### Condition 5: Target language is set to C

**Condition:** The target language must be set to C
(`set_param(model, 'TargetLang', 'C')`).

#### Why SLCI Requires This

SLCI's CRL verification only supports C function call syntax. C++ constructs
(namespaces, templates, overloading) cannot be resolved to CRL registry entries.
The CRL registry maps plain function names to mathematical operations, and C++
qualified names like `MathLib::sin()` cannot be matched against the registry.

#### Fix

```matlab
set_param('myModel', 'TargetLang', 'C');
```

---

### Condition 6: Memory function arguments match conceptual representation

**Condition:** For memory function replacements (memcpy, memset), the
implemented function must have the same number and type of arguments as the
conceptual representation defined in the library customization file.

#### Why SLCI Requires This

SLCI verifies memory operations by matching the generated function call arguments
to the conceptual memcpy/memset semantics (destination, source, size). If the
replacement function has additional arguments (DMA channel, alignment hints) or
different argument types, SLCI cannot determine which argument corresponds to
destination, source, or byte count, breaking its ability to verify the memory
operation maps correctly to the model's data assignment.

#### Fix

Ensure the replacement function signature exactly matches the conceptual
representation:

```matlab
% Define replacement with matching signature
hEnt = RTW.TflCFunctionEntry;
hEnt.setTflCFunctionEntryParameters( ...
    'Key', 'memcpy', ...
    'ImplementationName', 'dma_copy', ...
    'ImplementationHeaderFile', 'dma_utils.h', ...
    'ImplementationSourceFile', 'dma_utils.c');

% Implementation must be: void dma_copy(void *dst, const void *src, size_t n)
% NOT: void dma_copy(int ch, void *dst, const void *src, size_t n)
```

---

## Supported Operator Details

### Matrix Multiply Replacement (RTW_OP_MUL)

#### Why SLCI Requires This

SLCI's operator replacement verification only supports nonscalar (matrix)
operations for multiplication, division, inversion, and transposition. Scalar
operations replaced via CRL produce function calls where SLCI expects inline
arithmetic expressions (`a * b`). Only matrix operations naturally produce
function calls in generated code, making them verifiable as CRL replacements.

---

## Configuration Requirements for Code Inspection

To inspect generated code that uses a code replacement library, configure the
library as follows:

### Interactive Configuration (Code Replacement Tool)

If you create a library interactively using the Code Replacement Tool (Embedded
Coder), specify the implementation source and header files and their paths in
the **Build Information** tab.

Example: For a `sin` function replacement using `sin_dbl.h` and `sin_dbl.c`:
- Implementation Header File: `sin_dbl.h`
- Implementation Source File: `sin_dbl.c`
- Additional Include Paths: path to your header files (e.g., `fullfile(pwd, 'source_files', 'header')`)
- Additional Source Paths: path to your source files (e.g., `fullfile(pwd, 'source_files', 'src')`)

### Programmatic Configuration

If you create a library programmatically, specify the implementation header and
source files and their paths using `setTflCFunctionEntryParameters`:

```matlab
hEnt.setTflCFunctionEntryParameters( ...
    'Priority', 100, ...
    'ImplementationHeaderFile', 'sin_dbl.h', ...
    'ImplementationSourceFile', 'sin_dbl.c', ...
    'AdditionalIncludePaths', { ...
        fullfile(pwd, 'source_files', 'header')}, ...
    'AdditionalSourcePaths', { ...
        fullfile(pwd, 'source_files', 'src')});
```

### After Updating an Existing Library

If you update an existing code replacement library for code inspection:
1. Reconfigure the library
2. Validate the library
3. Save the library
4. Refresh your MATLAB session
5. Generate code
6. Run inspection

---

## See Also

- "Code Replacement" (Embedded Coder)
- "Math Function Code Replacement" (Embedded Coder)
- "Memory Function Code Replacement" (Embedded Coder)
- "Function Replacement" (Embedded Coder)
- "Operator Replacement" (Embedded Coder)
- "Quick Start Library Development" (Embedded Coder)

----

Copyright 2026 The MathWorks, Inc.

----
