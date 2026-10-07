# Fixing Incompatibilities Reference

## Avoiding Iterative `checkCompatibility()` Passes

`checkCompatibility()` can surface new failures after earlier ones are fixed, because
some checks are gated by prerequisites (e.g., code generation checks only run once
`SystemTargetFile` is correct). To avoid multiple round-trips, bulk-set all required
code generation parameters upfront from
[code_generation_constraints.md](code_generation_constraints.md) before running
`checkCompatibility()`:

```matlab
set_param('<model>', 'SystemTargetFile', 'ert.tlc');
set_param('<model>', 'TargetLang', 'C');
% ... apply all required values from the code_generation_constraints reference
```

Then run `checkCompatibility()` once to catch structural and block-level issues,
rather than iterating one parameter at a time.

----

Copyright 2026 The MathWorks, Inc.

----
