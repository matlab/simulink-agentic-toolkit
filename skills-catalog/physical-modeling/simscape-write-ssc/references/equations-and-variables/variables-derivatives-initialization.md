## Variables and State

### Variable Declaration

A `variables` section declares continuous solver unknowns as value-with-unit pairs. (For discrete variables updated only at events, see `variables(Event=true)` in [events-and-event-variables](../modecharts-and-events/events-and-event-variables.md).)

```ssc
variables
    w = {0, 'rad/s'};   % Angular velocity
    x = {value = {0, 'm'}, priority = priority.high}; % Deformation
end
```

- **The trailing comment becomes the variable name in the block dialog.** Always provide one for any public variable.
- **Set `priority.high` on differential states** (variables where `der(variable)` appears in the equations section), or use an initial equation instead when the initial condition depends on another variable or on `der()` at t=0.
- **Choose a physically meaningful starting value, never a naive 0 for a quantity that appears in a denominator or `log`.** Use realistic anchors: `{298.15, 'K'}` for temperature, `{0.101325, 'MPa'}` for pressure, `{1.2, 'kg/m^3'}` for gas density.

#### Optional Fields

- **variable declaration fields** (any order):

  ```ssc
  variables
      T = {value = {300, 'K'}, priority = priority.high, imin = {0, 'K'}, nominal = {300, 'K'}};
  end
  ```

  | Field | Purpose |
  |-------|---------|
  | `priority` | `priority.high`, `priority.low`, or `priority.none` (default) |
  | `imin` / `imax` | Open-range initialization bounds — solver enforced regardless of priority. Use to exclude nonphysical solutions. Block user cannot change these. |
  | `nominal` | Override model-level scaling. Use only when a variable always operates at a scale vastly different from the unit's default. |

- **Temperature difference variables** need the block attribute `variables(Conversion=relative)`. Without it, a variable set to 5 degC is treated as absolute (278.15 K instead of 5 K). Separate absolute and relative temperature variables into different `variables` blocks.

### Derivatives and State

- **`der(x)`** is the time derivative of `x` (unit: operand's unit over seconds; 0 for parameters/constants, 1 for `time`).

- **Use the function form `der(x)`, not the deprecated method form `x.der`.** Older library source may still shows `x.der`; write `der(x)` in new components.

- **When a variable is conditionally differential, make its priority conditional too.** If a parameterization disables the `der(x)` equation, the variable becomes algebraic; `priority.high` on an algebraic variable over-constrains initialization. Use a conditional parameter to control it:

  ```ssc
  if use_dynamics
      parameters (Access = private)
          x_priority = priority.high;
      end
      equations
          tau * der(x) == u - x;
      end
  else
      parameters (Access = private)
          x_priority = priority.none;
      end
      equations
          x == u;
      end
  end
  variables (Access = private)
      x = {value = x0, priority = x_priority};
  end
  ```

- **`integ(expr)`** creates an anonymous state — use only when you need neither an initial condition nor logging (a declared variable with `der` gets both). Optional second arg `t_L` gives a lower limit for moving-window integration: `avg == integ(u, T)/T`.

### Initial Equations

Use `equations(Initial=true)` when the initial condition depends on another variable or on `der()` at t=0. Use `priority.high` for constant or parameter-based starting values.

**Never combine both on the same variable.** Each consumes one initialization degree of freedom — using both over-constrains initialization.

**Steady-state startup — set `der(x) == 0` in initial equations:**

```ssc
equations
    der(x) == a*x + u;
end

equations(Initial=true)
    der(x) == 0;
end
```

`der(x)` in initial equations is treated as an unknown solved during initialization, not evaluated from a time derivative.

----

Copyright 2026 The MathWorks, Inc.

----
