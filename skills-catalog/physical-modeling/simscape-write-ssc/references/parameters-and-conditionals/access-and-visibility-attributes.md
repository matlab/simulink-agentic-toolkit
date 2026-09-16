## Access and Visibility Attributes


These two attributes are independent axes: `Access` controls code-level scope, `ExternalAccess` controls UI/logging visibility.

| Combination | Code scope | Dialog/Logging |
|---|---|---|
| `Access=public, ExternalAccess=modify` | All | Visible, user-settable (default for parameters) |
| `Access=public, ExternalAccess=observe` | All | Visible read-only |
| `Access=public, ExternalAccess=none` | All | Hidden from UI |
| `Access=protected, ExternalAccess=observe` | Subclasses only | Visible read-only |
| `Access=private, ExternalAccess=none` | This component only | Fully hidden |

**Defaults when omitted:** `public` defaults to `ExternalAccess=modify`; `protected` and `private` default to `ExternalAccess=observe`.

**ExternalAccess=none does not eliminate the variable from compiled equations** -- use compile-time `if` blocks for dead-code elimination.

**Three-tier pattern for variables:** (1) Public for user-meaningful states (ICs, logged outputs). (2) Private + `ExternalAccess=observe` for component data that should be logged but not user-settable. (3) Private + `ExternalAccess=none` for pure implementation artifacts.

----

Copyright 2026 The MathWorks, Inc.

----
