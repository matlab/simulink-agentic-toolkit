# Block Support Constraints: Discontinuities

Blocks in this category implement discontinuous signal transformations including dead zones, relays, and saturation limits.

---

## 22. Dead Zone — Nonfatal

**Block:** simulink/Discontinuities/Dead Zone

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | No block-specific constraints | N/A |
| Block Parameters | Saturate on integer overflow (`SaturateOnIntegerOverflow`) must be cleared (set to `off`) | Nonfatal |
| Block Parameters | Start of dead zone (`LowerValue`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |
| Block Parameters | End of dead zone (`UpperValue`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |

### Constraint Details

#### SaturateOnIntegerOverflow must be cleared

**Why:** When saturation is enabled for integer overflow, the code generator inserts overflow detection and clamping logic around arithmetic operations. This produces conditional checks against `MAX_int32_T`/`MIN_int32_T` that have no corresponding model element. SLCI cannot trace saturation guard code back to any single block.

**Fix:**
```matlab
set_param('model/Dead Zone', 'SaturateOnIntegerOverflow', 'off');
```

#### LowerValue and UpperValue must not be empty, nonfinite, or complex

**Why:** SLCI resolves the Dead Zone parameters at analysis time to verify the comparison values in the generated code. Empty, nonfinite (Inf/NaN), or complex values cannot be mapped to concrete C comparison constants, preventing SLCI from verifying the if/else structure.

**Fix:**
```matlab
set_param('model/Dead Zone', 'LowerValue', '-5');
set_param('model/Dead Zone', 'UpperValue', '5');
```

---

## 65. Relay — Nonfatal

**Block:** simulink/Discontinuities/Relay

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | Switch on point (`OnSwitchValue`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |
| Block Parameters | Switch off point (`OffSwitchValue`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |
| Block Parameters | Output when on (`OnOutputValue`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |
| Block Parameters | Output when off (`OffOutputValue`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |

### Constraint Details

#### All Relay parameters must not be empty, nonfinite, or complex

**Why:** SLCI must resolve all four Relay parameters (switch on/off points, output on/off values) at analysis time to verify the comparison thresholds and output assignments in the generated code. Empty, nonfinite, or complex values cannot be represented as concrete C literals.

**Fix:**
```matlab
set_param('model/Relay', 'OnSwitchValue', '3.0');
set_param('model/Relay', 'OffSwitchValue', '1.0');
set_param('model/Relay', 'OnOutputValue', '1.0');
set_param('model/Relay', 'OffOutputValue', '0.0');
```

---

## 68. Saturation — Nonfatal

**Block:** simulink/Discontinuities/Saturation

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input and output ports must have the same data type | Nonfatal |
| Block Parameters | Upper limit (`UpperLimit`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |
| Block Parameters | Lower limit (`LowerLimit`) must not be empty, nonfinite, complex, or use range selection/variable indexing on MATLAB structures | Nonfatal |
| Block Parameters | Integer rounding mode (`RndMeth`) must be set to `Zero` or `Floor` | Nonfatal |

### Constraint Details

#### Input and output ports must have the same data type

**Why:** When input and output data types differ, the code generator inserts implicit type casts in the saturation output assignments. SLCI cannot distinguish whether the cast is from the Saturation block or from a separate Data Type Conversion, since type casts introduce code that has no counterpart in the block's configuration.

**Fix:**
```matlab
set_param('model/Saturation', 'OutDataTypeStr', 'Inherit: Same as input');
```

#### UpperLimit and LowerLimit must not be empty, nonfinite, or complex

**Why:** SLCI must resolve the saturation limits at analysis time to verify the comparison values in the generated code's if/else structure. The upper and lower limits appear as literal constants in the comparison conditions. Empty, nonfinite, or complex values cannot be represented as C comparison literals.

**Fix:**
```matlab
set_param('model/Saturation', 'UpperLimit', '10.0');
set_param('model/Saturation', 'LowerLimit', '-10.0');
```

#### Integer rounding mode must be `Zero` or `Floor`

**Why:** When the Saturation block produces output that requires integer rounding, non-standard rounding modes (`Nearest`, `Ceiling`, `Convergent`) insert conditional correction code. This rounding logic has no corresponding model element since the Saturation block defines only clamping, not rounding behavior.

**Fix:**
```matlab
set_param('model/Saturation', 'RndMeth', 'Zero');
```

----

Copyright 2026 The MathWorks, Inc.

----
