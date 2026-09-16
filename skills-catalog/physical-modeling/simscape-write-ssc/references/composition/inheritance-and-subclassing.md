## Inheritance and Subclassing


Subclassing extends a base class using `<` syntax. The subclass inherits all public/protected members (nodes, variables, parameters, branches, equations) and adds its own. When reading subclassed code, look at the base class to find inherited nodes, branches, and variables.

**Override defaults on the inheritance line.** Use constructor-argument syntax to set parameter values or variable priorities:

```ssc
component inerter < foundation.translational.branch( v_rel.priority = priority.high )
```

**A subclass cannot add new nodes/ports beyond those in the base.** If you need additional ports, use composition (a composite component) instead of inheritance.

----

Copyright 2026 The MathWorks, Inc.

----
