# Plant Model Guidance — Quick Reference

> **Usage note:** This is an optional human-facing reference for plant model spec authors.
> Do NOT copy this content verbatim into specs. The agent should use `web_search`
> for domain-specific physics, equations, solver details, and validation criteria
> rather than relying on this file.

---

## Domain Research Checklist

When specifying a plant model in an unfamiliar domain, investigate:

- [ ] **Decomposition pattern** — What is the standard subsystem breakdown for this domain? (e.g., actuator → plant dynamics → sensors)
- [ ] **States and governing equations** — What are the typical state variables and their differential equations?
- [ ] **Validation maneuvers and acceptance criteria** — What are the standard test inputs and pass/fail metrics? Are there ISO/MIL/industry standards?
- [ ] **Reference parameters and sources** — What are the key physical parameters, their typical ranges, and where to find reliable values?
- [ ] **Solver considerations** — Is the system stiff? Are there algebraic loops? Does it involve switching or DAEs?
- [ ] **Fidelity levels** — What levels of modeling detail are available (behavioral / average / high-fidelity), and what are the simulation cost trade-offs?

---

## Parameter Table Schema

Use this column format for all parameter tables in specs:

| Parameter | Symbol | Value | Unit | Source | Uncertainty | Conditions | Block Path |
|-----------|--------|-------|------|--------|-------------|------------|------------|
| Vehicle mass | m | 1700 | kg | Rajamani (2012), Table 2.1 | ±5% | Curb weight, no passengers | Plant/Chassis/VehicleMass |

---

## Preferred Sources for Domain Research

When researching plant model physics and parameters, prefer (in order):

1. **Standards bodies** — ISO, SAE, MIL-STD, IEC for validation procedures and acceptance criteria
2. **Textbooks** — Peer-reviewed, widely cited references (e.g., Rajamani for vehicle dynamics, Krause for electric machines)
3. **MathWorks documentation** — Reference architectures, Simscape examples, and application-specific toolbox docs
4. **Peer-reviewed papers** — For specialized parameters or novel modeling approaches
5. **Component datasheets** — For electrical, thermal, and mechanical component parameters

Avoid unvetted blog posts, forum answers, or AI-generated content as primary parameter sources.
