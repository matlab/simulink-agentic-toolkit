## For-Loop Component Arrays


Use a for-loop array when the member count is governed by a parameter, all members are the same class, and wiring follows index arithmetic. Use explicit named declarations when members have distinct roles.

**For-loop arrays vs vector parameters.** Use for-loop arrays when elements need conserving-port connections between them (e.g., series pipe segments connected port-to-port). Use vector parameters when elements have distinct values but share equations, or when the equations consume the whole array at once (e.g., a lookup table, thermal RC ladder with matrix math).

```ssc
parameters
    N = 3;
    total_length = {10, 'cm'}
end
for i = 1:N
    components(ExternalAccess=observe)
        seg(i) = my_pkg.pipe_segment(length = total_length / N);
    end
end
for i = 1:N-1
    connections
        connect(seg(i).B, seg(i+1).A)
    end
end
connections
    connect(seg(1).A, A)
    connect(seg(end).B, B)
end
```

**Guard connection loops with `if N > 1`** when the parameter can legitimately be 1, since empty arrays are not supported.

**In nested loops, the inner range cannot reference the outer iterator.** `for j=1:i` inside `for i=1:N` is invalid. Both dimensions must have sizes known at parametrization time.

**Component declaration must list all loop iterators.** In nested loops: `resistor(i,j) = ...`.

**Distribute extensive parameters by dividing, intensive unchanged.** When splitting into N segments, divide length/mass/capacity by N. Pass roughness/shape factor/hydraulic diameter unchanged. Series springs invert: each of N springs gets stiffness `N*k`.

**Derive loop count from vector length** when a data vector defines model order. Place the derived count in `parameters(Access=private)` to prevent inconsistency.

```ssc
parameters
    R_data = {[0.0016 0.0043 0.0013], 'K/W'};
end
parameters(Access=private)
    N = length(R_data);
end
```

----

Copyright 2026 The MathWorks, Inc.

----
