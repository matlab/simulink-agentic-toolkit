# Inspection Checklist

Inspect the Simulink model, its requirements, and all verification artifacts against this checklist.
Record **Pass**, **Fail**, or **N/A** with a brief justification for each item.

---

## 1 — Requirements & Traceability

> *Ref: ISO 26262-8 §6.4, INCOSE Guide for Writing Requirements, Simulink Requirements Traceability Matrix*

1.1. Is each requirement **unambiguous and verifiable** — with testable acceptance criteria (thresholds, timing, or logical conditions)?

1.2. Does every functional requirement trace to **at least one model element** and **at least one test case**?

1.3. Are there any **orphan requirements** (no implementation or test) or **unlinked model elements** (potential unintended functionality)?

---

## 2 — Model Design & Robustness

> *Ref: MAB/JMAAB Modeling Guidelines, ISO 26262-6 §8.4.5 Table 6, Simulink Check Model Advisor*

2.1. Does the implementation **functionally satisfy each linked requirement**?

2.2. Are all internal states **initialized to safe/known values**, and is **defensive design** applied (input range checks, division-by-zero guards, overflow protection)?

2.3. Do signal calculations use **consistent units**, and are parameter **min/max/default ranges** sensible?

2.4. Does the model pass **Model Advisor checks** with no unresolved failures? (Review `model_advisor_results.json`)

---

## 3 — Test Results & Coverage

> *Ref: Simulink Test, Simulink Coverage, ISO 26262-6 §9–§10, DO-178C §6.4*

3.1. Is there at least one **test case per functional requirement**, covering nominal, boundary, and fault scenarios?

3.2. Are **pass/fail criteria explicitly defined** for every test, and do all MIL tests pass? (Review `mil_test.json`)

3.3. Is **model coverage** (decision, condition, MC/DC) at or above the project threshold, with gaps justified? (Review `coverage_results.json`)

3.4. Does the **SIL back-to-back** comparison confirm MIL vs. SIL equivalence within tolerances? (Review `sil_results.json`)
