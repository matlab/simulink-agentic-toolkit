# Spec Types Guide

## Spec Differentiation

| Spec Type | Primary Question | When |
|-----------|------------------|------|
| **System** | What are we building and why? | Always first |
| **Detailed** | What is the precise contract? | Before architecture, if something must be precisely defined |
| **Architecture** | How is it structured and why? | After system spec |
| **Implementation Plan** | How do we build it? | After architecture |
| **Test Plan** | How do we verify it? | With implementation plan |
| **Component** | How does this complex thing work? | Rarely, after architecture |

## Flow Between Specs

```
System Spec → [Detailed Spec] → Architecture → Implementation Plan + Test Plan
     │              │                │
     │   Only if    │                │
     │   needed     │                │
     ▼              ▼                ▼
WHAT & WHY     PRECISE CONTRACT   HOW IT'S BUILT
```

## When to Create Each

### System Spec
**Always create first.** Captures problem, goals, user scenarios, interaction design.

### Detailed Spec
**Create when:** Architecture is blocked without precise definition of something.
- Data formats multiple components share
- Protocols between subsystems
- Algorithms that span components

**Skip when:** You can design architecture without it.

### Architecture Spec
**Always create.** Captures components, interfaces, data flow, key decisions.

**Should NOT include:** Implementation code, internal component details.

### Implementation Plan
**Always create.** Captures phases, dependencies, parallel work opportunities.

### Test Plan
**Always create with implementation plan.** Test cases derived from architecture behaviors.

### Component Spec
**Rarely create.** Only when architecture description isn't sufficient for a complex component.
