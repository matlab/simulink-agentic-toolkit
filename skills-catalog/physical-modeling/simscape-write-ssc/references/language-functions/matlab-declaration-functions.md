## MATLAB Declaration Functions

Declaration functions are ordinary MATLAB `.m` functions called inside `parameters` and `variables` blocks to compute derived values. They cannot be called from `equations`.

**Inputs and outputs must be unitless.** Use `value(p, 'unit')` to extract a scalar before passing to a declaration function, and `{expr, 'unit'}` to reattach units to the result.

```ssc
parameters(Access = private)
    pd = {my_fcn(value(p, 'm')), 'm/s'};
end
```

**Use `Access = private` for derived parameters** unless all arguments are literal constants.

**Run-time compatibility:** If any input parameter is designated Run-time in the block dialog, the declaration function is evaluated at run-time and must be MATLAB Coder compatible. Set `MATLABEvaluation = compiletime` to prevent accidental run-time evaluation of non-codegen functions.

**Multiple return values** follow MATLAB conventions; use `~` to skip unwanted outputs.

----

Copyright 2026 The MathWorks, Inc.

----
