## Intermediates and Let


**Use `intermediates` for runtime expressions; use `parameters(Access=private)` for parameter-only expressions.** If the expression references any port variable, input, or state, it must be an intermediate. If it depends only on parameters, declare it as a private parameter (evaluated once at compile time).

**Prefer `intermediates` over `let`.** Intermediates can be logged (to disable logging, change ExternalAccess from observe to none), reused across multiple equation blocks, and referenced from enclosing composite components. A `let` variable is locally scoped to a single `let...in...end` block.

```ssc
intermediates
    rho_avg = (rho_A + rho_B) / 2;
end
```

**`let` syntax:** `let declarations in equations end`. Declarations are order-independent and acyclic. Use for genuinely single-use shorthands where logging will never be needed.

----

Copyright 2026 The MathWorks, Inc.

----
