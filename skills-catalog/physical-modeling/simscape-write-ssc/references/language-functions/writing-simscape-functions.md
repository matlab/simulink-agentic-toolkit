## Writing Simscape Functions


Simscape functions are pure functions callable from anywhere in a Simscape component.

**File-based (main) functions live in standalone `.ssc` files; the filename must match the function name.** Place them in a namespace folder for reuse across components.

**Local functions go after the final `end` of a component/domain file.** Use these for single-component helpers to avoid extra files. Local functions take call precedence over main functions of the same name.

**Basic syntax:**

```ssc
function [out1, out2] = myFunc(in1, in2, in3)
definitions
    intermediate = in1^2 + in2;
    out1 = intermediate * in3;
    out2 = if ge(in1, 0), in1 else -in1 end;
end
end
```

**The body uses `definitions`, not MATLAB function syntax.** Inside `definitions`, use the same expression language as `let` blocks: `if-elseif-else` conditionals and intermediate terms are allowed.

**No dynamic operators inside `definitions`.** You cannot use `integ`, `der`, `time`, `delay`, or `edge` -- the function must be purely algebraic.

**Pass all data as explicit arguments.** Simscape functions cannot access nodes, component state, or domain parameters. Long argument lists (12-20+ parameters) are normal and expected. This enables reuse across different port identifiers.

**Arguments carry units.** Unlike MATLAB declaration functions, Simscape function inputs/outputs support physical units. The unit of the result is determined by the expressions in `definitions`.

**Use `let` to capture multiple return values in equations:** `let [m, idx] = myFunc(a, b); in ... end`. This is the only way to bind multiple outputs from a Simscape function inside an `equations` section.

----

Copyright 2026 The MathWorks, Inc.

----
