# Plant Model Implementation Plan Template

# [Plant Model Name] Implementation Plan

## Status: [Not Started | In Progress | Complete]
**Last Updated:** [Date]  
**Architecture Spec:** [Link]  
**Test Plan:** [Link]

---

## 1. Progress Summary

*Quick view of current state. Update as phases complete.*

| Phase | Status | Subsystems |
|-------|--------|------------|
| Phase 0: Interface Contract & Stubs | ✅ Complete | All |
| Phase 1: [Name] | 🔄 In Progress | [Subsystems — parallel] |
| Phase 2: [Name] | 🔲 Not Started | [Subsystems] |
| Phase 3: [Name] | 🔲 Not Started | [Subsystems] |

---

## 2. Model Hierarchy

*Subsystem nesting within the .slx file. Shows how the plant model is organized.*

```
[PlantModelName].slx (root)
├── [Subsystem1]          # [Physics domain / purpose]
│   ├── [SubSubsystem1a]  # [Detail]
│   └── [SubSubsystem1b]  # [Detail]
├── [Subsystem2]          # [Physics domain / purpose]
└── [Subsystem3]          # [Physics domain / purpose]
```

*For Subsystem References or Model References, note the separate file:*
```
[PlantModelName].slx (root)
├── [Subsystem1]                    # Subsystem (inline)
├── [Subsystem2] → Sub2.slx        # Subsystem Reference
└── [Subsystem3] → Sub3Model.slx   # Model Reference
```

*Model References enable the strongest parallel development since they are separate .slx files with independent compilation.*

---

## 3. Dependencies

### 3.1 MATLAB Toolbox Dependencies

| Toolbox | Required For | Required? |
|---------|-------------|-----------|
| Simulink | All | Yes |
| [Toolbox — e.g., Simscape Electrical] | [Which subsystems] | [Yes/No] |
| [Toolbox] | [Subsystems] | [Yes/No] |

---

## 4. Workstream Graph

*Shows what can be built in parallel vs what must be sequential. Interface contract is upstream of all parallel work; integration is downstream.*

```
                    Phase 0: Interface Contract & Stubs
                    (freeze ports, create stubs, root skeleton compiles)
                                    │
               ┌────────────────────┼────────────────────┐
               │                    │                    │
        ┌──────▼──────┐     ┌──────▼──────┐     ┌──────▼──────┐
        │ [Subsystem1] │     │ [Subsystem2] │     │ [Subsystem3] │
        │  Build + Test│     │  Build + Test│     │  Build + Test│
        └──────┬──────┘     └──────┬──────┘     └──────┬──────┘
               │                    │                    │
               └────────────────────┼────────────────────┘
                                    │
                    Phase 2: Integration
                    (wire subsystems, resolve coupling, open-loop validation)
                                    │
                    Phase 3: Controller Integration
                    (closed-loop wiring, rate transitions, closed-loop validation)
```

*Subsystems at the same level can be built and tested in parallel by separate agents once the interface contract is frozen.*

---

## 5. Build Phases

### Phase 0: Interface Contract & Stubs
**Goal:** *Freeze all interfaces and create a compilable root model with stub subsystems*  
**Duration:** [X hours]  
**This phase gates all parallel work — it must complete first.**

| Step | Operation | Details |
|------|-----------|---------|
| 0.1 | Freeze port interfaces | Finalize port list, signal names, units, data types, sample times per architecture spec §3-4 |
| 0.2 | Define sign conventions | Document positive directions for all effort/flow variables |
| 0.3 | Create bus objects (if needed) | Define bus types for multi-signal interfaces |
| 0.4 | Create parameter container | Workspace script or Data Dictionary with all parameters from §7 |
| 0.5 | Create stub subsystems | Empty subsystem/model reference per component with final ports + placeholder dynamics (passthrough or first-order lag) |
| 0.6 | Create root model skeleton | Root .slx with stubs wired together — must compile and run |

**Verification:**
- Root model compiles without errors
- `model_overview` — verify hierarchy matches §2
- `model_read` — verify all ports present on each stub
- Stub model runs to completion (placeholder dynamics, no physics validation)

**Checkpoint 0:** Root model with stubs compiles and runs; all interfaces documented and frozen.

---

### Phase 1: Parallel Subsystem Implementation
**Goal:** *Build subsystem internals and write subsystem-level validation tests — in parallel*  
**Duration:** [X hours]  
**Subsystems:** [List — these can be built concurrently]

| Builder Agent | Tester Agent (parallel) |
|---------------|------------------------|
| **[Subsystem 1]**: Implement dynamics blocks, wire connections, set parameters, add nonlinearities per architecture spec | Write open-loop Gherkin scenarios per test plan §2 |
| **[Subsystem 2]**: [Build tasks] | Write tests per test plan §2 |
| **[Subsystem 3]**: [Build tasks] | Write tests per test plan §2 |

*Tightly coupled subsystems (e.g., inverter↔motor, tire↔chassis) may need coordinated building rather than fully independent parallel work. Note these in the table and assign to the same agent or add explicit coordination points.*

**Verification per subsystem:**
- `model_read` — verify block topology matches architecture
- `model_query_params` — spot-check key parameter values
- Open-loop test per test plan §2

**Checkpoint 1:** [Criteria — e.g., "Each subsystem's open-loop step response matches expected behavior within acceptance criteria"]

---

### Phase 2: Integration
**Goal:** *Wire real subsystems together, resolve coupling issues, validate integrated plant*  
**Duration:** [X hours]

| Builder Agent | Tester Agent (parallel) |
|---------------|------------------------|
| Replace stubs with real subsystems, wire connections per architecture signal flow, resolve algebraic loops, add w inputs and z outputs, configure solver | Write integrated tests per test plan §3 |

**Verification:**
- `model_read` — verify complete signal path u → dynamics → y
- `model_overview` — verify subsystem hierarchy matches §2
- Integrated open-loop test per test plan §3

**Checkpoint 2:** [Criteria — e.g., "Complete plant open-loop response matches reference within acceptance criteria"]

---

### Phase 3: Controller Integration
**Goal:** *Wire plant to controller for closed-loop simulation*  
**Duration:** [X hours]

| Builder Agent | Tester Agent (parallel) |
|---------------|------------------------|
| Connect plant↔controller, add rate transitions, set initial conditions, configure simulation | Write closed-loop and sensitivity tests per test plan §4, §8, §9 |

**Verification:**
- Closed-loop test per test plan §4
- `model_read` — verify closed-loop signal path
- Parameter sensitivity tests per test plan §8
- Numerical robustness tests per test plan §9

**Checkpoint 3:** [Criteria — e.g., "Closed-loop simulation runs without errors, controller achieves setpoint tracking, sensitivity tests pass"]

---

## 6. Parameter Table

*Central reference for all model parameters. Every parameter must have a documented source.*

| Parameter | Symbol | Value | Unit | Source | Uncertainty | Block Path |
|-----------|--------|-------|------|--------|-------------|------------|
| [Name] | [sym] | [val] | [unit] | [Reference / datasheet / measured] | [±X%] | [Plant/Subsystem/Block] |
| [Name] | [sym] | [val] | [unit] | [Source] | [±X%] | [Path] |

---

## 7. Sync Points

*What happens at each checkpoint.*

After each phase:
1. `model_read` — verify block topology matches architecture spec
2. `model_query_params` — spot-check parameter values against parameter table
3. Run validation test for that phase (from test plan)
4. Review against specs
5. Note any deviations from architecture spec
6. Update Progress Summary
7. Proceed only when checkpoint criteria met

**If physics deviation found:** Update architecture spec equations, re-run review gate before proceeding.

**If interface mismatch found during integration:** Stop, update architecture spec interfaces, re-stub, and re-verify affected subsystems before continuing.

---

## 8. Definition of Done

### Interface Contract Complete (Phase 0)
- [ ] Port interfaces frozen (names, units, data types, sample times)
- [ ] Sign conventions documented
- [ ] Bus objects created (if applicable)
- [ ] Parameter container created with all parameters
- [ ] Stub subsystems created with correct ports
- [ ] Root model compiles and runs with stubs

### Subsystem Complete (Phase 1)
- [ ] All blocks placed per architecture spec
- [ ] Ports match architecture interface exactly (names, units, types)
- [ ] Parameters set from parameter table
- [ ] Nonlinearities implemented per architecture spec §6
- [ ] Test harness exists with defined input signals
- [ ] Open-loop test passes acceptance criteria
- [ ] Units and sign conventions verified against interface contract

### Plant Model Complete (Phase 2)
- [ ] All subsystems integrated (stubs replaced)
- [ ] Signal flow matches architecture spec §3.3
- [ ] Solver configured per architecture spec §7.1
- [ ] Integrated open-loop tests pass
- [ ] No algebraic loop warnings
- [ ] Energy/power conservation checks pass (where applicable)

### Closed-Loop Complete (Phase 3)
- [ ] Plant wired to controller
- [ ] Rate transitions handled
- [ ] Initial conditions set
- [ ] Closed-loop tests pass
- [ ] Parameter sensitivity tests pass
- [ ] Numerical robustness tests pass

---

## 9. Risk Mitigation

| Risk | Mitigation |
|------|------------|
| [Domain-specific risk] | [Mitigation] |

---

## Appendix A: Solver Configuration

| Setting | Value | Rationale |
|---------|-------|-----------|
| Solver type | [Variable-step / Fixed-step] | [Why] |
| Solver | [ode45 / ode15s / ode23t / etc.] | [Why — see architecture §7.1] |
| Max step size | [value] | [Based on fastest dynamics] |
| Relative tolerance | [value] | [Accuracy requirement] |
| Stop time | [value] | [From test plan scenarios] |
