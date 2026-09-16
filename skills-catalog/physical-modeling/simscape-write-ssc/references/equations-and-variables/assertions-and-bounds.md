## Assertions and Bounds


**Use `assert` in `equations` for parameter validation and runtime guards.** `assert` accepts any logical condition and an optional message string:

```ssc
assert(R > 0)
assert(d_i < d_o, 'Inner diameter must be less than outer')
```
**Default action is error (stops simulation).** Use `Action = simscape.enum.assert.action.warn` for soft bounds on runtime variables that may transiently exceed limits. Use an enumerated parameter to let the block user control the action.

**`assert` is not counted toward branch equation count** and can appear in any `if` branch without affecting balance.

----

Copyright 2026 The MathWorks, Inc.

----
