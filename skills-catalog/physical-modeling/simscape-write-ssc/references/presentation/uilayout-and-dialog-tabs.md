## UILayout and Dialog Tabs


Each `UIGroup` produces exactly one dialog tab -- no nesting, no collapsing. Plan one group per coherent physical concern.

```ssc
annotations
    UILayout = [UIGroup("Electrical", Ra, La, Kv)
                UIGroup("Mechanical", J, lam, speed0)
                UIGroup("Thermal Port", thermal_mass, T0)]
end
```

**Rules:**
- `UILayout` can appear only once per component.
- Each `UIGroup` needs a title string and a non-empty parameter list.
- A parameter cannot belong to more than one group (compile error).
- Parameters not listed in any group appear at the end of the first tab.
- List conditionally hidden parameters in their logical group so they appear in the correct tab when promoted to visible.
- Variables are always on a separate Variables

**With UIGroup, declaration order is independent of dialog order.** Arrange declarations for code clarity; control the dialog separately via `UILayout`.

----

Copyright 2026 The MathWorks, Inc.

----
