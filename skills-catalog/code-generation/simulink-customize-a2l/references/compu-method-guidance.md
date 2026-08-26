# COMPU_METHOD Conversion Types and Coefficients

## Conversion Types

| ConversionType | Coefficients Property | Direction | A2L Keyword | Formula |
|----------------|----------------------|-----------|-------------|---------|
| `LINEAR` | `[a b]` | INT→PHYS | `COEFFS_LINEAR a b` | PHYS = a×INT + b |
| `RAT_FUNC` | `[a b c d e f]` | **PHYS→INT** | `COEFFS a b c d e f` | INT = (a×PHYS² + b×PHYS + c) / (d×PHYS² + e×PHYS + f) |
| `IDENTICAL` | (none) | — | (no coefficients) | PHYS = INT |
| `TAB_VERB` | (via `CompuVTabValues`) | lookup | `COMPU_TAB_REF` | Verbal table lookup |

## RAT_FUNC: Deriving Coefficients

The critical rule: **COEFFS specifies the PHYS→INT direction.** Calibration tools invert it to display physical values. To derive coefficients:

1. Start with the desired physical formula (what the user wants to see in the calibration tool)
2. Invert algebraically to get INT as a function of PHYS
3. Map to the rational function format: INT = (a×PHYS² + b×PHYS + c) / (d×PHYS² + e×PHYS + f)

### Worked Examples

**Example 1: Temperature conversion (PHYS = 0.5×INT - 40)**

1. Desired: PHYS = 0.5×INT - 40
2. Invert: INT = (PHYS + 40) / 0.5 = 2×PHYS + 80
3. Map: a=0, b=2, c=80, d=0, e=0, f=1
4. `Coefficients = [0 2 80 0 0 1]`

```matlab
cm = coder.asap2.CompuMethod;
cm.Name = 'CM_Temperature';
cm.ConversionType = 'RAT_FUNC';
cm.Coefficients = [0 2 80 0 0 1];
cm.Units = 'degC';
cm.Format = '%8.3';
```

Generated A2L: `COEFFS 0 2 80 0 0 1`

**Example 2: Voltage scaling (PHYS = 1000×INT)**

1. Desired: PHYS = 1000×INT
2. Invert: INT = PHYS / 1000
3. Map: a=0, b=1, c=0, d=0, e=0, f=1000
4. `Coefficients = [0 1 0 0 0 1000]`

**Example 3: Inverse with offset (PHYS = (INT - 100) / 5)**

1. Desired: PHYS = (INT - 100) / 5 = 0.2×INT - 20
2. Invert: INT = 5×PHYS + 100
3. Map: a=0, b=5, c=100, d=0, e=0, f=1
4. `Coefficients = [0 5 100 0 0 1]`

**Example 4: Quadratic sensor (PHYS = 0.001×INT² + 0.5×INT)**

1. Desired: PHYS = 0.001×INT² + 0.5×INT (non-invertible as simple rational)
2. For quadratic conversions where the inverse is not a clean rational function, use LINEAR approximation or TAB_VERB instead

## LINEAR: Direct Conversion

LINEAR is simpler — coefficients go INT→PHYS directly:

```matlab
cm = coder.asap2.CompuMethod;
cm.Name = 'CM_Voltage_mV';
cm.ConversionType = 'LINEAR';
cm.Coefficients = [1000 0];  % PHYS = 1000×INT + 0
cm.Units = 'mV';
cm.Format = '%8.3';
```

Generated A2L: `COEFFS_LINEAR 1000 0`

## TAB_VERB: Verbal Table

For enumeration mappings (integer → string):

```matlab
cm = coder.asap2.CompuMethod;
cm.Name = 'CM_GearState';
cm.ConversionType = 'TAB_VERB';
cm.Units = '';
cm.Format = '%3.0';
cm.CompuVTabValues.Values = [0, 1, 2, 3];
cm.CompuVTabValues.Literals = ["Park", "Reverse", "Neutral", "Drive"];
```

**Type requirement:** `Literals` MUST be a string array. A cell array of char vectors is accepted without error but silently exports 0 elements.

## Assigning to Measurements or Characteristics

After creating and adding a COMPU_METHOD:

```matlab
add(descObj, cm);
set(descObj, 'Measurement', 'signalName', 'CompuMethodName', 'CM_Temperature');
% or
set(descObj, 'Characteristic', 'paramName', 'CompuMethodName', 'CM_Temperature');
```

## Common RAT_FUNC Coefficient Errors

| User Request | Wrong (INT→PHYS) | Correct (PHYS→INT) |
|-------------|-------------------|---------------------|
| PHYS = 0.5×INT - 40 | `[0 0.5 -40 0 0 1]` | `[0 2 80 0 0 1]` |
| PHYS = 1000×INT | `[0 1000 0 0 0 1]` | `[0 1 0 0 0 1000]` |
| PHYS = INT / 3.6 | `[0 1 0 0 0 3.6]` | `[0 3.6 0 0 0 1]` |
| PHYS = 2×INT + 10 | `[0 2 10 0 0 1]` | `[0 0.5 -5 0 0 1]` |

----

Copyright 2026 The MathWorks, Inc.

----
