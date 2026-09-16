## Arrays of Nodes

Node arrays provide element-wise connections between parametric-sized component arrays, potentially in different composite blocks. Declared via for-loop like components.

```ssc
for i = 1:Ncells
    nodes
        H(i) = foundation.thermal.thermal; % H array
    end
end
```

### Connections

Element-wise connections use for-loops. Slicing is supported for shifted/polygon wiring. Scalar expansion is **not** supported — use a for-loop to connect a scalar node (including `*`) to each node array element.

```ssc
for i = 1:Ncells
    connections
        connect(battery_cell(i).H, H(i));   % element-wise: component array to RF
    end
end

connections
    connect(p(1:end-1), n(2:end));  % slicing: p(1)->n(2), p(2)->n(3), ...
    connect(p(end), n(1));          % close the polygon
end

for i = 1:N
    connections
        connect(c.p, p(i));  % scalar port to each node array element
        connect(n(i), *);    % node array element to implicit reference (also scalar)
    end
end
```

----

Copyright 2026 The MathWorks, Inc.

----
