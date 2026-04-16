# Algorithm Guidance — Quick Reference

> **Usage note:** This is an optional human-facing reference for MBD algorithm spec authors.
> Do NOT copy this content verbatim into specs. The agent should use `web_search`
> for domain-specific algorithm details, interface standards, and calibration strategies
> rather than relying on this file.

---

## Domain Research Checklist

When specifying an algorithm in an unfamiliar domain, investigate:

- [ ] **Standard algorithm architectures** — What are the established architectures for this problem? (e.g., cascade control, observer-based estimation, model predictive control, voting/redundancy schemes)
- [ ] **Interface conventions and standards** — What bus definitions or interface standards apply? (e.g., AUTOSAR software component ports, ARINC 429 labels, CAN signal definitions)
- [ ] **Existing reference implementations** — Are there MathWorks examples, reference architectures, or industry reference designs to build from?
- [ ] **Calibration strategy** — Which parameters are tunable at runtime? What is the tuning approach (auto-tune, manual calibration, scheduled gains)?
- [ ] **Code generation constraints** — What is the target hardware, execution timing budget, and compliance standard? (e.g., MISRA, DO-178C, ISO 26262)
- [ ] **Validation approach** — What are the acceptance criteria sources? Are there standard test scenarios, conformance suites, or certification test cases?

---

## Parameter Table Schema

Use this column format for all parameter tables in algorithm specs:

| Parameter | Symbol | Value | Unit | Source | Calibratable | Conditions | Block Path |
|-----------|--------|-------|------|--------|--------------|------------|------------|
| Proportional gain | Kp | 2.5 | — | Tuned via Simulink Design Optimization | Yes | Nominal operating point | Controller/PID/Kp |

---

## Preferred Sources for Domain Research

When researching algorithm design and interface conventions, prefer (in order):

1. **Standards bodies** — ISO, SAE, ARINC, IEC for interface definitions, safety requirements, and compliance criteria
2. **MathWorks documentation** — Reference architectures, toolbox examples, and application-specific design guides
3. **Textbooks** — Domain-specific, widely cited references (e.g., Åström for PID control, Isermann for engine control)
4. **Peer-reviewed papers** — For specialized algorithms or novel estimation/control approaches
5. **Component datasheets** — For hardware-interfacing algorithms (sensor characteristics, actuator response curves)

Avoid unvetted blog posts, forum answers, or AI-generated content as primary design sources.
