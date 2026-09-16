## Events and Event Variables

### Declaration

Declare with `variables(Event=true)`. Event variables hold their value between discrete events and update only inside `when` clauses.

**Set the declaration initial value to a physically correct default** because equations read the event variable from t=0 until the first event fires.

**Event variables initialize the same way as continuous variables.** A constant declaration value with no priority is usually enough. Use an initial equation when the event variable's initial condition must be solved simultaneously with differential state initial conditions.

**`initialevent` is the first discrete event**, firing once after continuous initialization finishes. Use it when you need to set an event variable from a condition that may already be true at t=0 (because `edge()` requires a transition).

### Edge and When/Elsewhen

The `events` section contains only `when` clauses that update event variables at discrete instants.

**`edge(b)` fires on false-to-true transitions only.** Use `edge(~b)` for falling edge.

**`edge(x ~= 0)` fires on BOTH rising and falling zero-crossings — a common silent bug.** Use `edge(x > 0)` for rising-only or `edge(x < 0)` for falling-only.

```ssc
events
    when initialevent
        y_held = IC;
    elsewhen edge(T > 0)
        y_held = U;
    end
end
```

**Two `when` blocks cannot write the same event variable — compile error.** Use a single `when/elsewhen` chain instead. First matching branch wins.

**All assignments in a `when` body execute simultaneously.** No default `else` branch — illegal syntax.


### When to Use a Modechart Instead

**Use a modechart when the discrete data is purely a mode whose only purpose is switching equation sets.** The modechart owns the mode state and selects which equations are active — nothing else reads it. If you need the discrete value in equations (as a multiplier, captured sample, or flag), that's an event variable.

----

Copyright 2026 The MathWorks, Inc.

----
