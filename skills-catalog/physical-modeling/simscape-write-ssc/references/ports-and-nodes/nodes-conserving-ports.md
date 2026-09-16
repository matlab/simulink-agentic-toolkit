## Nodes Conserving Ports


A `nodes` section declares conserving ports that enforce Kirchhoff-type balance laws. Each node is assigned a domain type, which determines its Across and Through variables. Nodes can only connect to other nodes of the same domain.

```ssc
nodes
    p = foundation.electrical.electrical;           % +:left
    n = foundation.electrical.electrical;           % -:left
    R = foundation.mechanical.rotational.rotational; % R:right
end
```

**The domain path is the full namespace path from the top-level `+folder`.** For example, `foundation.mechanical.rotational.rotational` corresponds to `+foundation/+mechanical/+rotational/rotational.ssc`.

**Port label and position are set via an optional trailing comment:** `% Label:side` where optional side is `left`/`right` or `top`/`bottom`. All ports (`nodes`, `inputs`, `outputs`) must share one side pair when defined via the trailing comment; adjacent mixing only via `Side` annotations. Default to basic left/right layout.

**Every declared conserving node must be connected** — either inside the component or by the parent (a composite component or Simulink model). An unconnected node contributes Across variables with no governing equations. If a node is conditionally hidden or otherwise unused, ground it with `connect(node, *)`.

----

Copyright 2026 The MathWorks, Inc.

----
