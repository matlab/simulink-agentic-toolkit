# Data Import/Export Configuration Parameter Constraints

SLCI verifies model-to-code equivalence by ensuring that every aspect of model behavior is fully captured in the generated code. The Data Import/Export category contains parameters that, if enabled, introduce external runtime data that cannot be represented in generated code.

---

## 1. Initial State (LoadInitialState) — Nonfatal

**Required:** `off`

**Why:** When LoadInitialState is enabled, initial state values reside in a MATLAB workspace variable rather than in the model file. SLCI has no mechanism to incorporate arbitrary workspace data into the equivalence proof, and because the variable can change between sessions the initialization behavior is non-deterministic from the model artifact alone. This breaks the model-to-code equivalence guarantee for initialization.

**Fix:**
```matlab
set_param('model_name', 'LoadInitialState', 'off');
```

----

Copyright 2026 The MathWorks, Inc.

----
