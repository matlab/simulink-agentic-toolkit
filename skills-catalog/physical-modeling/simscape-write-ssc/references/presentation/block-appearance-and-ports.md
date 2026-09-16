## Block Appearance and Ports


### Block Name and Description

The first comment line after `component name` becomes the block name displayed on the icon and dialog. Subsequent comment lines become the block description.

```ssc
component spring
% Rotational Spring
% This block implements a simple rotational spring
% with configurable stiffness and damping.
```

**Icon scaling and rotation** can be appended to the block-name comment: `% Rotational Spring : 0.5 : fixed`. Scale is a numeric literal (default shortest side = 40px). Rotation is `rotates` (default) or `fixed` (icon stays upright when block is rotated).

### Annotations Section

All entries are optional; mix and match as needed.

```ssc
annotations
  [R] : ExternalAccess = modify;
  UILayout = [UIGroup('Electrical', R)];
  Icon = 'resistor.svg';
  p : Side = left;
  n : Side = right;
  R : UnitDropdown = common;
  power : LoggingUnit = 'W';
  Faults = Fault(Name = 'Open', Switch = enable_fault);
end
```

| Entry | Purpose | Values |
|-------|---------|--------|
| `[id] : ExternalAccess = v` | dialog visibility of params/vars | `modify`, `observe`, `none` |
| `UILayout = [UIGroup(...) ...]` | group parameters into dialog tabs | `UIGroup('Title', p1, p2)` |
| `Icon = 'file'` | custom block icon | image filename |
| `port : Side = v` | port placement | `left`, `right`, `top`, `bottom` |
| `param : UnitDropdown = common` | prepopulate the unit dropdown | `common` |
| `var : LoggingUnit = 'unit'` | preferred logging unit | must be commensurate |
| `Faults = Fault(...)` | fault interface (R2024b+) | see below |

----

Copyright 2026 The MathWorks, Inc.

----
