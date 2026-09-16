## Branches


The `branches` section declares which nodal conservation (KCL-like) equations a Through variable participates in, and with what sign. Each node in a network accumulates a sum-to-zero equation from all branches connected to it. A branch `var : p.i -> n.i` adds `+var` to node `p`'s equation and `-var` to node `n`'s. When components are connected, the solver assembles one conservation equation per shared node.

### Node Participation Patterns

| Pattern | Effect | Use case |
|---------|--------|----------|
| `var : A.i -> B.i` | Through in both nodes' conservation | Balanced two-port (any domain) |
| `var : A.i -> *` | Through in one node only | Storage, single-port |
| `connect(node, *)` | Across = 0, no Through variable | Grounding unused/conditional ports |
| No branch, no connect | Reads Across only, transparent | Across sensor (`out == p.v - n.v`) |
| Branch + zero Across drop | Through flows, zero drop | Through sensor (`out == i`, `p.v - n.v == 0`) |

```ssc
% Balanced two-port (e.g., restriction, valve)
branches
    mdot : A.mdot -> B.mdot;
end

% Storage two-port (e.g., compressible volume)
branches
    mdot_A : A.mdot -> *;
    mdot_B : B.mdot -> *;
end
equations
    der(m) == mdot_A + mdot_B;
end
```

### Sign Convention

**Passive sign convention: a positive Through variable flowing into the positive (first) Across terminal is power INTO the component.** Declare the branch so that positive Through into the `+` node (`p`, `B`, `A`) corresponds to power delivered to the component. Get this backwards and the component sources energy instead of absorbing it — physically wrong, but it compiles and runs.

| Domain | Ports | Branch | Convention |
|--------|-------|--------|------------|
| Electrical | `p`, `n` | `p.i -> n.i` | Current into + terminal |
| Mech. rotational | `R`, `C` or `B`, `F` | `R.t -> C.t` or `B.t -> F.t` | Rod to case / base to follower |
| Mech. translational | `R`, `C` or `B`, `F` | same pattern | Same convention |
| Fluid | `A`, `B` | `A.mdot -> B.mdot` or per-port `-> *` | Depends on mass storage |

**For multi-domain converters, keep each domain's natural convention and express power balance in the equation:**

```ssc
branches
    i : p.i -> n.i;
    t : R.t -> C.t;
end
equations
    v == K*w;
    t == -K*i;   % Power balance: v*i + t*w == 0
end
```

**Through variables on the node (`p.i`, `n.i`) can only appear in `branches` statements.** Everywhere else, reference only the local branch variable (`i`).

----

Copyright 2026 The MathWorks, Inc.

----
