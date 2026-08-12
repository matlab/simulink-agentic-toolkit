---
type: template
triggers: [guideline_document, guideline_format, write_guideline]
tags: [template, guideline, document-format, high-level]
related:
  - procedures/author-guideline.md
---
# Guideline Document Template

Guidelines are HIGH-LEVEL documents. They state WHAT the rule is and WHY it exists. They do NOT describe HOW to implement or check it.

**Rules: 2-3 maximum.** Each rule is one atomic, high-level principle. Configurable parameters, block subtypes, edge cases, and empty-name checks belong in the check spec — NOT here.

**No Description section.** Go directly from Guideline ID to Rules. The rules themselves convey the scope.

## Format Variants

| Guideline Type | Rule Format | When to Use |
|---------------|-------------|-------------|
| Block/Signal behavior | Bullet list + Exceptions | Naming, connections, parameters, consistency |
| Prohibited usage | Shall-not + bullet list | Things that are banned |
| Multi-aspect | Separate ### Sub ID sections | Truly distinct facets of one topic |

---

## Variant 1: Block/Signal Behavior (Bullet List + Exceptions)

Use for rules about model elements (blocks, signals, ports, parameters) with potential exceptions.

```markdown
# <id>: <title>

**Guideline ID:** <id>

## Rules

- <Rule statement 1 using "shall">
- <Rule statement 2 using "shall">

<!-- ONLY include Exceptions section if user explicitly stated exceptions. NEVER invent exceptions. Omit this entire block if user provided none. -->
### Exceptions

- <Exception explicitly stated by user>

## Rationale

- <Why reason 1>
- <Why reason 2>

## Verification

Model Advisor check: <Check name> (<Toolbox or Custom>)

## Example — Correct

<Brief text describing what makes this compliant>

![Compliant model](example_correct.png)

## Example — Incorrect

<Brief text describing what violates the rule>

![Violating model](example_incorrect.png)
```

---

## Variant 2: Prohibited Usage

Use when the rule lists things that shall NOT be done or blocks that shall NOT be used.

```markdown
# <id>: <title>

**Guideline ID:** <id>

## Rules

These <elements> shall not be used:
- <Prohibited item 1>
- <Prohibited item 2>

<Optional: what to use INSTEAD>

## Rationale

- <Why reason 1>
- <Why reason 2>

## Verification

Model Advisor check: <Check name> (<Toolbox or Custom>)

## Example — Correct

<Brief description>

![Compliant model](example_correct.png)

## Example — Incorrect

<Brief description of what's wrong>

![Violating model](example_incorrect.png)
```

---

## Variant 3: Multi-Aspect (Sub ID Sections)

Use ONLY when the guideline has truly distinct, independent aspects that each need their own examples.

```markdown
# <id>: <title>

**Guideline ID:** <id>

### Sub ID a

<Rule statement using "shall">

### Rationale

<Why this specific sub-rule exists>

### Example — Correct

![Correct Example](example_a_correct.png)

### Example — Incorrect

![Incorrect Example](example_a_incorrect.png)

### Sub ID b

<Rule statement using "shall">

### Rationale

<Why>

### Example — Correct

![Correct Example](example_b_correct.png)

### Example — Incorrect

![Incorrect Example](example_b_incorrect.png)

## Verification

Model Advisor check: <Check name> (<Toolbox or Custom>)
```

**When to use Sub IDs vs bullets:**
- Sub IDs: each aspect needs its OWN examples and rationale
- Bullets: aspects share the same rationale and can share examples

---

## Writing Rules

- Use imperative language: "shall match", "shall not be used", "shall conform"
- Each rule is ONE atomic, verifiable requirement
- Title describes the SCOPE, not the rule: Good: `jc_0602: Consistency in model element names`. Bad: `jc_0602: Names must match`
- No Description section — go directly from Guideline ID to ## Rules

**What does NOT belong in rules:**
- Configurable parameters (belongs in check spec)
- Block-type-specific edge cases (belongs in check spec)
- Auto-fix behavior (belongs in check spec)
- API details (belongs in check implementation)

## Examples

- **Only include screenshots when the violation is visually distinguishable on the canvas** (naming, connections, layout, prohibited blocks)
- **Skip screenshots for parameter-focused guidelines** (DataType, PortDimensions, SampleTime, config params) — use a text table showing parameter values per block instead
- Brief text caption explaining what's correct/incorrect
- If screenshots are included: `print('-sModel', '-dpng', '-r150', path)`


----

Copyright 2026 The MathWorks, Inc.

----
