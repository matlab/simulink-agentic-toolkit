## Optional and Variant Members


**Prefer conditional sections over zeroing parameters.** A conditionally absent member contributes zero equations. A member with a zeroed parameter (inertia=0, k=0) still adds equations and may cause singularities.

```ssc
if J > 0
    components
        inertia1 = foundation.mechanical.rotational.inertia(inertia = J);
    end
    connections
        connect(inertia1.I, R)
    end
end
```

**Intermediates inside compile-time conditionals** can switch between parameter and intermediate for the same name, avoiding unnecessary per-step evaluation in the constant case.

```ssc
if use_constant_gain
    intermediates
        g = K;          % compile-time constant — no runtime cost
    end
else
    intermediates
        g = K * f(x);   % runtime cost
    end
end
```

**Conditional sections cannot appear inside for-loops.** However, for-loops can appear inside conditional sections.

----

Copyright 2026 The MathWorks, Inc.

----
