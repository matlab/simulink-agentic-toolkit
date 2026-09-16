## Conditional Sections and Hiding Members


A conditional section is a top-level `if` guarded by a parameter expression, resolved at compile time. Any section block can appear inside it.

**Only parameters may guard structural sections.** A variable in a predicate produces a compile-time error. Predicates may not depend on parameters of embedded components or domain parameters.

**Members declared inside are forced `Access=private`.** Interface items (nodes, parameters, variables exposed to the user) must be declared unconditionally and controlled with annotations. Implementation items should prefer conditional declaration:

```ssc
if include_friction
    intermediates
        f_friction = mu * N;
    end
    equations
        f == f_applied - f_friction;
    end
else
    equations
        f == f_applied;
    end
end
```

### Hiding and Revealing Members

Declare optional items with `ExternalAccess=none`, then promote the active subset via `annotations` inside a compile-time `if`. Ground unused conserving nodes with `connect(node, *)` or the solver sees an unconstrained node.

Boolean predicate — hiding parameters:

```ssc
parameters
    use_lookup = false; % Use lookup table
end
parameters(ExternalAccess=none)
    kt_const = {0.15, '1'};
    pitch_angle_TLU = {[0 5 10], 'deg'};
end

if use_lookup
    annotations
        pitch_angle_TLU : ExternalAccess = modify;
    end
else
    annotations
        kt_const : ExternalAccess = modify;
    end
end
```

Enum predicate — hiding a port and related parameters:

```ssc
parameters
    thermal_port = simscape.enum.thermaleffects.omit; % Thermal port
end
nodes(ExternalAccess=none)
    H = foundation.thermal.thermal; % H
end

if thermal_port == simscape.enum.thermaleffects.model
    annotations
        [H, temperature, thermal_mass] : ExternalAccess = modify;
    end
    branches
        heat_flow : H.Q -> *;
    end
else
    connections
        connect(H, *)
    end
end
```

**Promote port and related parameters together** so users see all related controls only when the feature is active.

----

Copyright 2026 The MathWorks, Inc.

----
