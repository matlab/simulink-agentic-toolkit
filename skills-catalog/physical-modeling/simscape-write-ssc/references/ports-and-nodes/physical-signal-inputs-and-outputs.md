## Physical Signal Inputs and Outputs


Physical signal ports carry causal, directional signals with units. They do not participate in conservation equations.

```ssc
inputs
    cmd = {0, 'Pa'};   % Command:left
end
outputs
    meas = {0, 'A'};   % Current:right
end
```

**Use `inputs` when a quantity is imposed from outside with no back-reaction** -- control setpoints, environmental conditions, or any signal quantity.

**Use `outputs` to expose a measurement or computed result** to the physical signal.

**Vector/matrix signals** use array syntax: `I = {zeros(N,1), 'A'}`. All elements share the same unit. Parameter references are allowed for sizing.

**Untyped inputs/outputs** (declared without value/unit, e.g., `I;`) propagate size and unit from connected ports. When unconnected, they default to `{0, '1'}` (unitless scalar), so the component must handle that case.

**Port label and position are set via an optional trailing comment:** `% Label:side` where optional side is `left`/`right` or `top`/`bottom`. All ports (`nodes`, `inputs`, `outputs`) must share one side pair when defined via the trailing comment; adjacent mixing only via `Side` annotations. Default to basic left/right layout.

----

Copyright 2026 The MathWorks, Inc.

----
