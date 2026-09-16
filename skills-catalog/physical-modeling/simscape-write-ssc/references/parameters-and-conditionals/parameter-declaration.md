## Parameter Declaration


Parameters are declared in `parameters` blocks with a value-unit pair and an optional trailing comment that becomes the block dialog label:

```ssc
parameters
    k = {10, 'N*m/rad'};   % Spring rate
    n_cells = {6, '1'};    % Number of cells
end
```

**Trailing `%` comment sets the dialog label:** `k = {10, 'N*m/rad'}; % Spring rate`.

**Unitless parameters** can use `{value, '1'}` or bare `value` (both are equivalent).

**Default to a physically typical value.** Use `{1e4, 'N/m'}` for a spring, not `{1, 'N/m'}`. Exceptions: zero for optional additive physics, one for dimensionless scale factors, unit amplitude for generic sources.

**Choose units for the user, not the solver.** Declare in the unit engineers naturally use (e.g., `'mm'` for bore, `'deg'` for crank angles). The Simscape compiler handles all unit conversions and will error if an expression units are not commensurate.

**Temperature difference parameters** need the block attribute `parameters(Conversion=relative)`. Without it, a parameter set to 5 degC is treated as absolute (278.15 K instead of 5 K). Separate absolute and relative temperature parameters into different `parameters` blocks.

----

Copyright 2026 The MathWorks, Inc.

----
