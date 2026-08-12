---
type: template
triggers: [check_spec, check_specification, requirements]
tags: [template, check-spec, requirements, bridge]
related:
  - procedures/author-check.md
  - templates/guideline.md
---
# Check Specification Template

This template defines the format for the check specification document generated in Step 2 of the orchestrator workflow.

The check spec serves as the bridge between the high-level guideline and the check implementation. It is also the primary input to the testing skill (test-modeladvisor-check).

---

## Template

```markdown
# Check Specification: <check_id>

## Overview

| Field | Value |
|-------|-------|
| Check ID | <fully qualified check ID, e.g., mathworks.custom.trial_0003> |
| Title | <human-readable check title> |
| Context | PreCompile / PostCompile |
| Style | Detail Style |

## Source Guideline

| Field | Value |
|-------|-------|
| Guideline ID | <guideline_id> |
| Title | <guideline title> |
| Guideline File | <path to guideline document> |

## Requirements

| ID | Statement | Inspection Targets | Priority | Notes |
|----|-----------|-------------------|----------|-------|
| <ID>.REQ.<ASPECT> | The check shall... | <list of block types / elements inspected> | Must Have / Nice to Have | |
| <ID>.IP.<PARAM> | The check shall provide an input parameter to... | N/A | Must Have / Nice to Have | Default: <value> |

## Functional Design

<High-level step-by-step description of how the check works>
```

---

## Requirement ID Convention

IDs follow the pattern: `<GUIDELINE_ID>.<DOMAIN>.<ASPECT>`

| Segment | Meaning | Examples |
|---------|---------|----------|
| `<GUIDELINE_ID>` | The guideline this requirement traces to | `TRIAL_0003`, `HISL_0070` |
| `<DOMAIN>` | The functional area | `REQ` (functional), `IP` (input parameter), `FIX` (auto-fix) |
| `<ASPECT>` | The specific aspect within that domain | `INPORT_MATCH`, `MAX_LINKS`, `PREFIX` |

**Common domain codes:**

| Code | Meaning |
|------|---------|
| `REQ` | Functional requirement — what the check SHALL flag |
| `IP` | Input Parameter — configurable option on the MACE |
| `FIX` | Auto-fix requirement — what the fix action SHALL do |
| `EXEMPT` | Exemption — what the check shall NOT flag |
| `VALIDATE_IP` | Input validation — check shall flag invalid parameter values |

## Writing Requirement Statements

Every requirement statement:
- Starts with "The check shall..."
- Describes ONE atomic behavior
- Lists Inspection Targets (block types / element types the check examines) when applicable
- Input parameter requirements specify the Default value

**Functional requirement pattern:**
```
The check shall flag <elements> that <violation condition>.

Inspection Targets:
- <Block type 1>
- <Block type 2>
```

**Input parameter pattern:**
```
The check shall provide an input parameter to configure <what>.
Default: <value>
```

**Auto-fix pattern:**
```
The check shall provide an auto-fix action that <corrective action>.
```

**Exemption pattern:**
```
The check shall not flag <elements> when <exemption condition>.
```

**Input validation pattern:**
```
The check shall flag when invalid values are provided for <parameter> input parameters.
```

## User-Facing Summary Format

When presenting the check spec at the review gate, show this compact summary (not the full document):

```
## Check Specification: <check_name>
| Field | Value |
|-------|-------|
| Check ID | <id> |
| Title | <human-readable check title> |
| Check Type | standard / edit-time / config-param |
| Context | PreCompile / PostCompile |
| Auto-Fix | yes / no |

### Requirements Summary
| ID | Statement | Priority |
|----|-----------|----------|
| <id>.REQ.X | The check shall... | Must Have |
| <id>.IP.Y | The check shall provide... | Must Have |
| <id>.FIX.Z | The check shall fix... | Nice to Have |

Spec saved to: <path>
```

## Example: Port-Signal Name Consistency (trial_0003)

```markdown
# Check Specification: trial_0003

## Overview

| Field | Value |
|-------|-------|
| Check ID | trial_0003 |
| Title | Port and Signal Name Consistency |
| Context | PreCompile |
| Style | Detail Style |

## Source Guideline

| Field | Value |
|-------|-------|
| Guideline ID | trial_0003 |
| Title | Port and signal name consistency |
| Guideline File | guideline_trial_0003/guideline_trial_0003.md |

## Requirements

| ID | Statement | Inspection Targets | Priority | Notes |
|----|-----------|-------------------|----------|-------|
| TRIAL_0003.REQ.INPORT | The check shall flag Inport blocks whose name does not match the signal name connected to its output port. | Inport | Must Have | Empty signal name = violation |
| TRIAL_0003.REQ.OUTPORT | The check shall flag Outport blocks whose name does not match the signal name connected to its input port. | Outport | Must Have | Empty signal name = violation |
| TRIAL_0003.REQ.BUS_ELEMENT | The check shall flag Bus Element Port blocks whose name does not match the signal name connected to it. | InBusElement, OutBusElement | Must Have | Block name = bus/element name shown in label |
| TRIAL_0003.REQ.EMPTY_SIGNAL | The check shall flag port blocks connected to unnamed (empty) signal lines. | Inport, Outport, InBusElement, OutBusElement | Must Have | Always a violation regardless of prefix setting |
| TRIAL_0003.EXEMPT.UNCONNECTED | The check shall not flag port blocks that have no connected signal line. | Inport, Outport | Must Have | Unconnected ports are not in scope |
| TRIAL_0003.IP.PREFIX | The check shall provide an input parameter to require IN_/OUT_ prefix on Inport/Outport block names. When enabled, the port name must start with IN_ or OUT_ and the signal must match the full prefixed name. | N/A | Must Have | Default: false |
| TRIAL_0003.IP.VALIDATE | The check shall flag when invalid values are provided for input parameters. | N/A | Must Have | |
| TRIAL_0003.FIX.SIGNAL_RENAME | The check shall provide an auto-fix action that renames the signal line to match the port block name. | N/A | Nice to Have | Only when port name is valid |

## Functional Design

1. Find all Inport, Outport, InBusElement, and OutBusElement blocks in the system
2. For each port block:
   a. Get the block name
   b. Get the connected signal line (output for Inport, input for Outport)
   c. If no signal line is connected, skip (exempt)
   d. If signal line has empty name, flag as violation (TRIAL_0003.REQ.EMPTY_SIGNAL)
   e. If IP.PREFIX is enabled:
      - For Inport: verify block name starts with IN_ and signal matches full name
      - For Outport: verify block name starts with OUT_ and signal matches full name
   f. Compare block name to signal name — if mismatch, flag as violation
3. For Bus Element Ports: compare the element label to the connected signal name
4. Report violations with SID, description, and recommended action
```

----

Copyright 2026 The MathWorks, Inc.

----
