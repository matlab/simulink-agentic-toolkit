## Composites Member Variable Initialization


Member components are `ExternalAccess=observe`, so their variables do not appear in the top-level block dialog. To let users set initial targets:

```ssc
parameters
    i0 = {0, 'A'}; % Initial inductor current
end
components(ExternalAccess=observe)
    L = foundation.electrical.elements.inductor(...
        l = inductance, i_L = {value = i0, priority = priority.high});
end
```

Dot notation is equivalent: `i_L.value = i0, i_L.priority = priority.high`.

**Suppress subcomponent priorities when the composite owns initialization.** Two `priority.high` targets on the same variable over-constrains initialization and causes solver failures at t=0. Set `priority.none` on subcomponent variables, letting only the composite-level target govern:

```ssc
components(ExternalAccess=observe)
    C = foundation.electrical.elements.capacitor(...
        c = Cf, vc.priority = priority.none);
end

variables
    vc = {value = { 0, 'V' }, priority = priority.high}; % Capacitor voltage
end

equations
    vc == C.vc
end
```

----

Copyright 2026 The MathWorks, Inc.

----
