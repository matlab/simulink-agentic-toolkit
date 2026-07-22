# Agentic Review of Uncheckable Guidelines

Evaluate JMAAB/MAB guidelines that Model Advisor cannot fully verify — guidelines where structural checks exist but semantic judgment is required, or no check exists at all.

## When This Runs

- Standard is JMAAB, JMAAB_V6, or MAB → runs automatically after the deterministic compliance report
- Does NOT run for MISRA, ISO 26262, DO-178C, or any other standard

## Scope Restriction

**Only** evaluate guidelines listed in `references/semantic-evaluation-index.md`. These are guidelines that have NO Model Advisor check. Do NOT perform LLM-based evaluation on any guideline that has a Model Advisor check — for those, report only the Model Advisor result.

## Procedure

1. Load `references/semantic-evaluation-index.md`
2. From the Model Advisor results, identify which checked guidelines appear in the index
3. For those guidelines only, extract model data using MCP tools (model_overview, model_read, model_query_params)
4. Apply the Quick Rules for each applicable guideline
5. For borderline cases, use the Semantic Gap column to calibrate judgment
6. Present results using the output template below

## Output Template

Append after the deterministic Compliance Report with a `---` divider:

```
---

### Agentic Review of Uncheckable Guidelines (LLM-based — not deterministic)

> **Note:** This is a semantic evaluation performed by an AI agent, not a deterministic Model Advisor check. It assesses modeling quality criteria that Model Advisor cannot fully verify. Review these findings with engineering judgment before acting on them.

**Model:** <model_name>
**Judgment:** PASS | WARNING | FAIL
**Confidence:** 0.XX

#### Critical (must fix)
| Guideline | Blocks | Fix Type | Action | Confidence |
|-----------|--------|----------|--------|------------|
| <id> | <affected> | arch/param/naming/scope | <what to change> | 0.XX |

#### Warnings (should fix)
| Guideline | Blocks | Fix Type | Action | Confidence |
|-----------|--------|----------|--------|------------|

### Evidence
[2-3 sentences citing specific model data (block names, parameter values, state names)]

### Recommendation
[Top 3-5 prioritized actions, or "No action required."]
```

## Formatting Rules

- `**Judgment:**` and `**Confidence:**` MUST appear as separate labeled lines
- Overall Judgment = worst verdict across findings (FAIL > WARNING > PASS)
- Always include Confidence (0.0-1.0)
- Fix Types: `arch` (restructure), `param` (block parameter), `naming` (rename), `scope` (data scope)

## Confidence Scoring

| Range | Meaning |
|-------|---------|
| 0.9-1.0 | Deterministic — block name or parameter exactly matches/violates a rule |
| 0.7-0.8 | Strong signal — multiple indicators align |
| 0.5-0.6 | Judgment call — subjective, context-dependent |
| <0.5 | Low confidence — flag for human review, do not issue FAIL |

