# MBD Algorithm Implementation Plan Template

# [Algorithm Name] Implementation Plan

## Status: [Not Started | In Progress | Complete]
**Last Updated:** [Date]  
**Architecture Spec:** [Link]  
**Test Plan:** [Link]

---

## 1. Progress Summary

*Quick view of current state. Update as phases complete.*

| Phase | Status | Components |
|-------|--------|------------|
| Phase 0: Interface Contract & Stubs | ✅ Complete | All |
| Phase 1: [Name] | 🔄 In Progress | [Components — parallel] |
| Phase 2: [Name] | 🔲 Not Started | [Components] |
| Phase 3: [Name] | 🔲 Not Started | [Components] |
| Phase 4: Code Generation | 🔲 Not Started | [Components] |

---

## 2. Model Hierarchy

*Subsystem nesting within the .slx file. Shows how the algorithm is decomposed.*

```
[AlgorithmName].slx (root)
├── [Subsystem1]              # [Purpose — e.g., Signal Conditioning]
│   ├── [SubSubsystem1a]      # [e.g., Anti-Aliasing Filter]
│   └── [SubSubsystem1b]      # [e.g., Rate Limiter]
├── [Subsystem2]              # [Purpose — e.g., State Estimation]
│   └── [StateflowChart]      # [e.g., Mode Logic]  (Stateflow)
├── [Subsystem3]              # [Purpose — e.g., Control Law]
│   └── [MATLABFcn]           # [e.g., Gain Schedule Lookup]  (MATLAB Function)
└── [Subsystem4]              # [Purpose — e.g., Output Limiting]
```

*For Model References (`→ .slx`), note the separate file — these enable the strongest parallel development.*

---

## 3. Dependencies

| Toolbox | Required For | Required? |
|---------|-------------|-----------|
| Simulink | All | Yes |
| Stateflow | [Components — e.g., Mode Logic chart] | [Yes/No] |
| [Toolbox — e.g., Control System Toolbox] | [Components] | [Yes/No] |
| [Toolbox — e.g., Fixed-Point Designer] | [Code generation — Phase 4] | [Yes/No] |

---

## 4. Workstream Graph

*Interface contract gates all parallel work; integration is downstream.*

```
    Phase 0: Interface Contract & Stubs
                    │
       ┌────────────┼────────────┐
       ▼            ▼            ▼
  [Component1] [Component2] [Component3]   ← Phase 1 (parallel)
       │            │            │
       └────────────┼────────────┘
                    │
    Phase 2: Integration (wire, rate transitions)
                    │
    Phase 3: System Integration (closed-loop)
                    │
    Phase 4: Code Generation (optional)
```

---

## 5. Build Phases

### Phase 0: Interface Contract & Stubs
**Goal:** *Freeze all interfaces, create compilable root model with stubs*  
**Duration:** [X hours] — **gates all parallel work**

| Step | Details |
|------|---------|
| 0.1 Freeze port interfaces | Port list, signal names, data types, dimensions, sample times per architecture spec §3-4 |
| 0.2 Signal conventions | Signal scaling, enumeration types, default/initial values |
| 0.3 Bus objects (if needed) | Define bus types for multi-signal interfaces |
| 0.4 Parameter workspace | Workspace script or Data Dictionary with all parameters from §6 |
| 0.5 Stub subsystems | Empty subsystem per component with final ports + placeholder pass-through |
| 0.6 Root model skeleton | Root .slx with stubs wired together — must compile and run |

**Verification:**
- Root model compiles without errors
- `model_overview` — verify hierarchy matches §2
- `model_read` — verify all ports present on each stub

**Checkpoint 0:** Root model with stubs compiles and runs; all interfaces documented and frozen.

### Phase 1: Parallel Component Implementation
**Goal:** *Build algorithm internals and write component-level tests — in parallel*  
**Duration:** [X hours]  
**Components:** [List — these can be built concurrently]

| Builder Agent | Tester Agent (parallel) |
|---------------|------------------------|
| **[Component 1]**: Implement blocks, Stateflow charts, MATLAB Function blocks, set parameters per architecture spec | Write component tests per test plan §2 |
| **[Component 2]**: [Build tasks] | Write tests per test plan §2 |
| **[Component 3]**: [Build tasks] | Write tests per test plan §2 |

*Tightly coupled components (e.g., estimator→controller) — assign to same agent or add coordination points.*

**Verification per component:**
- `model_read` — verify block topology matches architecture
- `model_query_params` — spot-check key parameter values
- Component-level test per test plan §2

**Checkpoint 1:** [Criteria — e.g., "Each component's step response and mode transitions match expected behavior"]

### Phase 2: Integration
**Goal:** *Wire real components, resolve rate transitions, validate integrated algorithm*  
**Duration:** [X hours]

| Builder Agent | Tester Agent (parallel) |
|---------------|------------------------|
| Replace stubs with real components, wire per architecture signal flow, resolve rate transitions, configure solver | Write integrated algorithm tests per test plan §3 |

**Verification:**
- `model_read` — verify signal path input → processing → output
- Integrated algorithm test per test plan §3

**Checkpoint 2:** [Criteria — e.g., "Complete algorithm produces correct outputs for nominal inputs"]

### Phase 3: System Integration
**Goal:** *Connect algorithm to plant or upstream/downstream subsystems for system-level validation*  
**Duration:** [X hours]

| Builder Agent | Tester Agent (parallel) |
|---------------|------------------------|
| Connect algorithm↔plant (or upstream/downstream), add rate transitions, set initial conditions | Write closed-loop and system-level tests per test plan §4 |

**Verification:**
- Closed-loop or system-level test per test plan §4
- Stability and performance tests per test plan

**Checkpoint 3:** [Criteria — e.g., "Closed-loop simulation runs, algorithm meets performance requirements"]

### Phase 4: Code Generation *(optional — include only if algorithm is destined for code generation)*
**Goal:** *Prepare algorithm for production code generation*  
**Duration:** [X hours]

| Builder Agent | Tester Agent (parallel) |
|---------------|------------------------|
| Convert to fixed-point (if required), resolve Model Advisor warnings, configure code generation settings, set storage classes | Write SIL test harness, run back-to-back floating↔fixed comparison |

**Verification:**
- Model Advisor checks pass (MAB / MISRA guidelines)
- SIL simulation matches floating-point baseline within tolerance
- PIL test (if target hardware available) matches SIL

**Checkpoint 4:** [Criteria — e.g., "Model Advisor clean, SIL matches baseline, generated code compiles"]

---

## 6. Parameter Table

*Every algorithm parameter with a documented source.*

| Parameter | Symbol | Value | Unit | Source | Calibratable? | Block Path |
|-----------|--------|-------|------|--------|---------------|------------|
| [Name] | [sym] | [val] | [unit] | [Reference / requirement / tuning] | [Yes/No] | [Algorithm/Subsystem/Block] |
| [Name] | [sym] | [val] | [unit] | [Source] | [Yes/No] | [Path] |

---

## 7. Sync Points

*What happens at each checkpoint.*

After each phase:
1. `model_read` — verify block topology matches architecture spec
2. `model_query_params` — spot-check parameter values against §6
3. Run validation test for that phase (from test plan)
4. Review against specs
5. Update Progress Summary — proceed only when checkpoint criteria met

**If algorithm logic deviation found:** Update architecture spec, re-run review gate before proceeding.  
**If interface mismatch found:** Stop, update architecture spec interfaces, re-stub, re-verify affected components.

---

## 8. Definition of Done

### Interface Contract Complete (Phase 0)
- [ ] Port interfaces frozen (names, data types, dimensions, sample times)
- [ ] Signal conventions documented (scaling, enumerations, initial values)
- [ ] Parameter workspace created with all parameters
- [ ] Stub subsystems created with correct ports
- [ ] Root model compiles and runs with stubs

### Component Complete (Phase 1)
- [ ] All blocks/charts/MATLAB Functions placed per architecture spec
- [ ] Ports match architecture interface exactly (names, types, dimensions)
- [ ] Parameters set from parameter table
- [ ] Mode logic implemented per architecture spec (if applicable)
- [ ] Component-level test passes acceptance criteria

### Algorithm Integrated (Phase 2)
- [ ] All components integrated (stubs replaced)
- [ ] Signal flow matches architecture spec
- [ ] Rate transitions handled correctly
- [ ] Integrated algorithm tests pass

### System Integration Complete (Phase 3)
- [ ] Algorithm connected to plant/upstream/downstream
- [ ] Cross-boundary rate transitions handled
- [ ] Closed-loop or system-level tests pass
- [ ] Performance requirements met

### Code Generation Complete (Phase 4, optional)
- [ ] Fixed-point conversion complete (if required)
- [ ] Model Advisor checks pass
- [ ] SIL test passes (matches floating-point baseline)
- [ ] PIL test passes (if applicable)

---

## 9. Risk Mitigation

| Risk | Mitigation |
|------|------------|
| [e.g., Stateflow complexity causes state explosion] | [e.g., Decompose into parallel states, exhaustive mode tests] |
| [e.g., Fixed-point introduces unacceptable error] | [e.g., Bit-true comparison early, budget quantization per stage] |
| [e.g., Rate transition causes data integrity issue] | [e.g., Rate Transition blocks, multi-rate test] |
