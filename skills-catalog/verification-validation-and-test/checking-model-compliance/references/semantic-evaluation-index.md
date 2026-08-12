# Uncheckable Guidelines Index — JMAAB/MAB

Guidelines listed here have NO Model Advisor check. Only these guidelines are eligible for the agentic review of uncheckable guidelines. If a guideline has a Model Advisor check, it is NOT in this index — report only the Model Advisor result.

## Decision Index

Apply Quick Rules for obvious cases. Consult Semantic Gap hints for borderline/ambiguous cases.

| ID | Sub ID | Guideline | Quick Rules | Semantic Gap (Calibration) |
|----|--------|-----------|-------------|---------------------------|
| db_0144 | a, b | Functional decomposition | <15 blocks + single function → PASS; **3+ distinct functions in one subsystem → FAIL (absolute, regardless of naming quality)**; generic name + mixed contents → FAIL | Generic name + coherent contents → WARNING (not FAIL). Descriptive name + 3+ functions → still FAIL (name quality cannot override cohesion violation). **Sub b: Atomic subsystem without documented justification → FAIL even if well-named** (atomic must serve a technical need: rate boundary, code generation unit, or fixed-point isolation). |
| jm_0002 | a | Block sizing / icon visibility | All blocks ≥ default size → PASS; area < 40% default → FAIL; 3+ undersized → FAIL | Min width for text: 6×nChars+12 px. Subsystem height: 14px × max(inports,outports). Symbolic param showing -K- is correct (not a violation). |
| jc_0657 | a1, a2 | Conditional value retention | No If/SwitchCase+Merge → PASS (N/A); unconnected If output → FAIL; all conditions covered + Terminators → PASS | Memory block instead of Delay → WARNING (explicit but non-standard). Condition count: 1(if) + count(ElseIf) + ShowElse. Sub a2: Delay feedback loop makes retention explicit. |
| jc_0491 | a | Stateflow data reuse | No charts or no locals → PASS (N/A); counter with identical pattern everywhere → PASS; variable as counter in one state AND result in another → FAIL | Same role type + different formula → WARNING. AND states sharing local → FAIL (per jc_0722). Substates of same parent OR-state → PASS (one logical unit). |
| jc_0711 | a1, a2 | Division in Stateflow | No charts or no division → PASS (N/A); division by constant (/3) → PASS; unguarded /variable → FAIL | Guard in chart (if x~=0) → **WARNING** (a2 satisfied but a1 violated: division shouldn't be in chart). **Transition action division with implicit condition guard (e.g., [count >= N]{result = x/count}) → WARNING** (guard exists but division is in action, not protected inline). max(divisor,eps) clamping → safe for a2. |

----

Copyright 2026 The MathWorks, Inc.

----
