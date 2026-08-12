---
type: index
title: Author Model Advisor Check References
description: References for the end-to-end Simulink modeling standards enforcement lifecycle — guideline authoring, check implementation, and qualification testing.
---
# Author Model Advisor Check References

## Procedures
- [Author Guideline](procedures/author-guideline.md) — step-by-step guideline authoring workflow
- [Author Check](procedures/author-check.md) — check implementation workflow
- [Test Check](procedures/test-check.md) — test generation and qualification workflow

## Patterns (Check Implementation)
- [Standard](patterns/standard.md) — on-demand batch Model Advisor check with DetailStyle
- [Edit-Time](patterns/edittime.md) — live canvas warning via EdittimeCheck class
- [Config Parameter](patterns/config-param.md) — model configuration parameter validation
- [Format Template](patterns/format-template.md) — custom table/report formatting add-on

## APIs (Element-Specific Logic)
- [Blocks](apis/blocks.md) — find_system, block properties, compiled properties, SID
- [Signals](apis/signals.md) — line handles, signal tracing, Signal-type reporting
- [Stateflow](apis/stateflow.md) — chart traversal, state/transition/junction queries, AST
- [Data Resolution](apis/data-resolution.md) — workspace variables, alias types, data dictionary
- [Code Analysis](apis/code-analysis.md) — mtree parse tree, checkcode, codeIssues
- [System Composer](apis/system-composer.md) — components, ports, connectors, stereotypes
- [Framework](apis/framework.md) — input parameters, auto-fix, exclusions, result formatting

## Templates (Document Formats)
- [Guideline](templates/guideline.md) — guideline document format variants
- [Check Spec](templates/check-spec.md) — check specification format
- [Test Spec](templates/test-spec.md) — test specification format with requirement traceability
- [Test Recipes](templates/test-recipes.md) — portable test class skeleton and helpers (R2023a-R2026a)

## Workflows
- [Legacy Conversion](workflows/legacy-conversion.md) — upgrade StyleOne/Two/Three to DetailStyle

----

Copyright 2026 The MathWorks, Inc.

----
