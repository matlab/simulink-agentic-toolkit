# Assessment Format

## Critical Invariant

Every signal alias referenced in an assessment `Expression` or `Condition` MUST have a corresponding entry in `LoggedSignals`. Unlogged signals cause silent vacuous passes — the assessment will report "Passed" without actually checking anything.

When calling `test_edit`, ALWAYS pass `LoggedSignals` and `Assessments` together. The tool rebuilds the full assessment JSON on each call — passing `Assessments` alone drops the symbol mappings.

---

## LoggedSignals

Configure these first. Maps aliases to signals that will be logged during simulation.

### Harness mode (unit-scope test cases)

Maps aliases to output port indices on the harness SUT block:

```matlab
LoggedSignals = struct( ...
    'Alias', {"signal_a", "signal_b"}, ...
    'PortIndex', {1, 2}, ...
    'ElementPath', {"", ""})
```

### BlockPath mode (model-scope test cases)

Maps aliases to output ports on arbitrary blocks anywhere in the model:

```matlab
LoggedSignals = struct( ...
    'Alias', {"q_safe", "IAS"}, ...
    'BlockPath', {"AutopilotControlSystem/SensorConditioning/DynPressureFaultMitigation", ...
                  "AutopilotControlSystem/Navigation/IAS_Estimate"}, ...
    'PortIndex', {1, 1}, ...
    'ElementPath', {"", ""})
```

### Fields

- `Alias` — name used in assessment expressions (must match exactly)
- `PortIndex` — 1-based index into the block's outports
- `BlockPath` — (model-scope only) full path to the block whose outport to log. When present, the signal is logged from this block instead of the harness SUT block.
- `ElementPath` — (optional) for bus outports, path to a specific element within the bus

Both modes can coexist in a single `LoggedSignals` array (entries with `BlockPath` use BlockPath mode; entries without use harness mode).

---

## Assessments

Pass a struct array to `test_edit`. Aliases in `Expression`/`Condition` must match `LoggedSignals.Alias` exactly.

```matlab
Assessments = struct( ...
    'Name', {"BoundsCheck", "SettledResponse"}, ...
    'Type', {"always", "conditional"}, ...
    'Expression', {"signal_a >= -30 & signal_a <= 30", "signal_b >= 50"}, ...
    'Condition', {"", "t >= 5"})
```

### Types

- **always**: expression must hold for the entire simulation
- **conditional**: whenever Condition is true, Expression must be true

### Fields

- `Name` — unique identifier for the assessment
- `Type` — `"always"` or `"conditional"`
- `Expression` — MATLAB expression using logged signal aliases (must evaluate to true to pass)
- `Condition` — (conditional only) when this is true, Expression must also be true

---

## Expression Syntax

Assessment expressions operate on **timeseries data** (element-wise). They follow a restricted subset of MATLAB syntax.

### Supported Operators

| Category | Operators | Notes |
|----------|-----------|-------|
| Logical | `&` (AND), `|` (OR), `~` (NOT) | Element-wise only. `&&` and `||` are **NOT supported**. |
| Relational | `<`, `<=`, `==`, `~=`, `>=`, `>` | Avoid `==`/`~=` on floating-point — use `abs(x - target) < tol` instead. |
| Arithmetic | `+`, `-`, `*` | `*` is **scalar constants only** (e.g., `2 * x`). No signal × signal. |

### Supported Functions

| Function | Purpose |
|----------|---------|
| `abs` | Absolute value — use for tolerance checks |
| `single`, `double` | Floating-point cast |
| `uint8`, `uint16`, `uint32` | Unsigned integer cast |
| `int8`, `int16`, `int32` | Signed integer cast |
| `logical` | Logical cast |

### Special Symbols

- `t` — automatically bound to simulation time. Can be used in conditions (e.g., `t >= 5`). Cannot be used as `min-time` or `max-time` parameter.

### Restrictions

- **No short-circuit operators**: `&&` and `||` are unsupported. Use `&` and `|`.
- **No functional forms**: `and(a,b)`, `plus(a,b)`, `or(a,b)` etc. are unsupported. Use operator syntax.
- **Multiplication**: scalar constants only (`2 * x` is ok, `x * y` where both are signals is not).
- **Data type matching**: all operands in an expression must be the same type. Use cast operators to resolve mismatches.
- **Bus/multidimensional signals**: symbols must map to a single element (use `ElementPath`).
- **Fixed-point types**: not supported in assessments.
- **`string` type**: not supported.
- **Event-based signals**: not supported.

### Floating-Point Comparison

Using `==` or `~=` on floating-point data may produce warnings or false failures. Prefer tolerance-based checks:

```matlab
% BAD — fragile with floating-point
x == 5.0

% GOOD — tolerance-based
abs(x - 5.0) < 0.001
```

---

## Common Patterns

```matlab
% Saturation check (signal bounded within limits)
"x >= -30 & x <= 30"

% Tolerance band (signal within ±tol of target)
"abs(x - 100) < 5"

% Non-negative check
"x >= 0"

% Time-gated response (after settling, signal must meet criteria)
Type="conditional", Condition="t >= 5", Expression="speed >= 50"

% Comparison with cast (mixed types)
"double(sensor_raw) >= 0 & double(sensor_raw) <= 255"
```
