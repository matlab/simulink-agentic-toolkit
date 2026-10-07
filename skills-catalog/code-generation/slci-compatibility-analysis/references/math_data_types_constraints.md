# SLCI Math and Data Types Constraints

This document explains each Math and Data Types constraint that Simulink Code Inspector (SLCI) enforces, with examples showing what triggers the constraint, the generated code implications, why SLCI requires it, and how to fix it.

---

## 1. Implement logic signals as Boolean data (BooleanDataType) — Nonfatal

**Required:** `on`

**Why:** SLCI verifies model-to-code equivalence by tracing each model element to its corresponding code construct. When BooleanDataType is off, logic signals become `real_T` (double), introducing floating-point comparisons for what is inherently Boolean logic. This mismatch means SLCI cannot establish a direct semantic correspondence between the model element (logical output) and the code construct (double arithmetic), and the implicit type conversions break traceability.

**Fix:**
```matlab
set_param(model, 'BooleanDataType', 'on');
```

---

## 2. Use algorithms optimized for row-major array layout (UseRowMajorAlgorithm) — Nonfatal

**Required:** `off`

**Why:** Simulink models define matrix signals using MATLAB's column-major convention, and SLCI's verification logic is designed around column-major semantics. When row-major algorithms are enabled, the code generator reorders loop indices and changes memory access patterns, producing index expressions that no longer correspond to the column-major element ordering SLCI expects. This prevents SLCI from tracing model matrix operations back to generated code array accesses.

**Fix:**
```matlab
set_param(model, 'UseRowMajorAlgorithm', 'off');
```

----

Copyright 2026 The MathWorks, Inc.

----
