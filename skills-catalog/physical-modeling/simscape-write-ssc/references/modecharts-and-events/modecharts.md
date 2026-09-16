## Modecharts

```ssc
modecharts (ExternalAccess = observe)
    mc = modechart
        modes
            mode FREE
                equations
                    f == 0;
                end
            end
            mode LOCKED
                equations
                    v == 0;
                end
            end
        end
        transitions
            FREE -> LOCKED : v < v_tol && f_applied > 0;
            LOCKED -> FREE : abs(f) > f_break;
        end
        initial
            LOCKED : start_locked;
        end
    end
end
```

**Every mode must have the same number of equation expressions and dimensionality.** `assert` expressions do not count.

**If `initial` is omitted, the first mode listed is active at start.** Rely on declaration order by default — only add an `initial` block when a parameter must select the starting mode at configuration time.

### Structure

**One modechart per coherent state space.** Split independent mechanisms into separate modecharts (N + M states vs. N × M).

**Name modes for their physical state** — `FREE`, `CONTACT`, `LOCKED`, not `MODE1`/`MODE2`.

**Use an INITIAL mode to resolve directional ambiguity at t=0** when the discriminating signal may be zero at startup.

### Transitions

**Listing order is priority order.** First matching transition from the same source wins.

### State Reset (Compound Transitions)

Use compound transitions for instantaneous state reinitialization (collisions, bouncing). The middle mode is instantaneous — it executes one event iteration (entry + equations) then immediately proceeds to the third mode without advancing time.

**`entry` captures values at the instant of mode entry.** LHS must be an event variable; RHS is evaluated immediately before entering the mode.

```ssc
mode IMPACT
    entry
        v_old = v;
    end
    equations
        v == -cor * v_old;
    end
end
transitions
    FREE -> IMPACT -> FREE : x <= lower_bnd && v < 0;
    FREE -> IMPACT -> FREE : x >= upper_bnd && v > 0;
end
```

**The instantaneous mode must invalidate the predicate.** If it doesn't, the system re-enters the compound transition infinitely. Include a directional guard (`&& v < 0`) so that when the instantaneous mode flips velocity sign, the predicate becomes false.

**Only one instantaneous mode per transition — max three modes in the chain.**

### When to Use Events Instead

**Use events when discrete data is needed beyond equation switching** — latched values, captured samples, counters, or flags read by continuous equations. A modechart's only job is to select which equation set is active; if you need discrete data for anything else, use an event variable. Both can coexist in the same component.

----

Copyright 2026 The MathWorks, Inc.

----
