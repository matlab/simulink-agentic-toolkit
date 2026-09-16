## Enumerations


Enum parameters produce dropdown menus in the block dialog.

**Enum classes must inherit from `int32`**:

```matlab
classdef damping < int32
    enumeration
        direct  (0)
        derived (1)
    end
    methods(Static)
        function map = displayText()
            map = containers.Map;
            map('direct') = 'By damping value';
            map('derived') = 'By no-load current';
        end
    end
end
```

**Never use plain integers for mode selection.** Integer parameters produce unreadable conditionals.

**Default to the simplest variant** -- the member requiring fewest additional parameters (`off`, `omit`, `fixed`, `constant`). Fidelity is opt-in.

**Place enum classes in a `+enum` folder of your library namespace** (e.g., `+mylib/+enum/`).

**Enum members evaluate to their int32 value in expressions.** This enables numeric comparisons like `mode >= 1` in predicates.

----

Copyright 2026 The MathWorks, Inc.

----
