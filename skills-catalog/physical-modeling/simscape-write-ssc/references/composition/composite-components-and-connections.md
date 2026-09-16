## Composite Components and Connections


A composite component assembles existing components (members) and wires their ports together. It declares members in `components` blocks, wires them in `connections` blocks, and optionally exposes selected member parameters at the top level. Composites can also contain their own `equations` section for additional physics, coordination, or coupling that doesn't belong inside any single member.

**When to use composite vs monolithic.** Use a composite when the device is physically composed of distinct subsystems that already exist as validated Simscape components. Stay monolithic when equations are tightly coupled through shared state variables or no appropriate subcomponents exist.

**Members must use fully qualified namespace paths.** Reference a member component by its namespace path from the top-level namespace folder: `foundation.mechanical.rotational.spring`.

**ExternalAccess on components blocks must be `observe` or `none`.** Use `observe` for physically meaningful subelements users may want to log; use `none` for internal infrastructure.

**Parameterize members inline.** Pass top-level parameters to members in the declaration. Unassigned member parameters keep their defaults.

```ssc
parameters
    R_val = {10, 'Ohm'};
end
components(ExternalAccess=observe)
    r1 = foundation.electrical.elements.resistor(R = R_val);
end
```

### Connection Rules

**Conserving connections accept two or more arguments.** `connect(A, B, C)` creates a single physical node joining all listed ports. All must belong to the same domain. Argument order does not matter.

**Physical signal connections are directional.** Signal connections between `inputs`/`outputs` ports use the same `connect()` syntax, but the first argument must be the source. A destination cannot connect to multiple sources.

**Ground to implicit reference with `connect(node, *)`.** Sets all Across variables to zero for any domain. Use when an element must interact with a fixed frame.

**Star connect for junctions; pairwise for series chains.** Use multi-argument connect when ports share a physical node. Use pairwise `connect(A.B, B.A)` in series chains and loops.

### Re-exposing Member Quantities

Members with `ExternalAccess=none` are invisible to logging. To surface their quantities, assign to a parent-level variable or intermediate.

```ssc
intermediates (Access = public)
    energyStoredKinetic = Mass.energyStoredKinetic;
end
```

----

Copyright 2026 The MathWorks, Inc.

----
