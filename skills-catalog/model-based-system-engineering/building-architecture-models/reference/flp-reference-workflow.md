<!-- Copyright 2026 The MathWorks, Inc. -->

# F/L/P Reference Workflow

This is a reference workflow — a pre-defined methodology template showing one way to do structured system development with F/L/P architecture. It is meant to be tailored by the customer to their process, standards, and project scope.

**How to use this reference:**
- Assess what the user already has and enter at the appropriate phase
- Not all phases apply to every project — adapt to scope and existing artifacts
- Layer conventions and traceability principles are fixed; build order, number of layers, and artifact choices are configurable
- Present this workflow to the user as a starting point, then tailor it together based on their constraints

---

## Step 1: Requirements

> Creating requirement sets: see `generate-requirement-drafts/reference/slreq-patterns.md`
> Derive links (SN → SR): see [requirements-traceability-api.md § Derive Links](requirements-traceability-api.md#derive-links-stakeholder-needs--system-requirements)

Get or import the system requirements (SRs) the architecture will satisfy:
- User may have requirements in `.slreqx`, Word, Excel, or other format
- User may not have requirements yet — gather them conversationally, then create Simulink Requirements
- SRs can be derived from Stakeholder Needs (SNs) if those exist

Get user review. Ensure the requirements feel complete for the system being built before designing against them.

---

## Step 2: Core Architecture Design

> Structural modeling: use `model_edit` per `building-simulink-models/reference/system-composer.md`
> Interface dictionaries: see [system-composer-api.md § Interface Dictionaries](system-composer-api.md#interface-dictionaries)

The default build order is top-down: Functional → Logical → Physical. Each layer is an independent model with its own interface dictionary. Customers may choose a different order or subset of layers depending on their process.

### Functional Layer

Derive functions from SRs. Each SR must map to at least one function.
- Components are verb phrases: `SenseAircraftState`, `ComputeControlLaws`
- Interfaces are abstract information flows — no physical units or implementation decisions
- A function with no SR trace is orphaned or covers an undocumented need

### Logical Layer

Derive logical elements from the functional architecture. Each logical element realizes one or more functions.
- Components are solution-role nouns: `SensingUnit`, `ControlUnit`, `ActuationUnit`
- Interfaces have typed fields with semantic meaning — no datasheet-level specifics
- Design-agnostic: no vendor names or part numbers

### Physical Layer

Derive physical components from the logical architecture and SR constraints.
- Components are concrete hardware/software units
- SR constraints (budgets, environment, packaging) drive component boundaries
- Interfaces have concrete fields with physical units: `ElectricalPower` with Voltage and Current elements

---

## Step 3: Allocation and Requirements Tracing

> Allocation sets: see [system-composer-api.md § Allocation Sets](system-composer-api.md#allocation-sets)
> Linking components: see [requirements-traceability-api.md § Linking SC Architecture Components](requirements-traceability-api.md#linking-sc-architecture-components)

### Layer-to-Layer Allocation Sets

Map elements between models: "Function X → Logical Element Y" and "Logical Element Y → Physical Component Z." Together they give full-chain traceability.

### Requirements → Architecture (Implement Links)

Connect SRs to architecture components:
- SR → Function (mandatory — closes the requirements loop)
- SR → Logical (non-functional requirements: timing, safety, performance)
- SR → Physical (hardware-specific: EMC, packaging, environment)

All components should map to at least 1 SR. All SRs should map to at least one component.

---

## Step 4: Component Properties and Views

> Profiles/stereotypes: see [system-composer-api.md § Profiles and Stereotypes](system-composer-api.md#profiles-and-stereotypes)
> Views: see [system-composer-api.md § Architecture Views](system-composer-api.md#architecture-views)

Apply to the physical model.

**Stereotypes:** Attach quantitative properties (mass, power, cost, reliability). Name stereotypes after what you're characterizing (`FlightProperties`, `HardwareProperties`), not the analysis. Create the profile as part of building the physical model so it survives rebuilds.

**Views:** Surface components that need attention — cost drivers, over-budget items, zeroed estimates. Each view queries a stereotype property.

Properties and views are coupled: every view queries a stereotype property, and every property should serve at least one view or analysis.

---

## Step 5: Analysis (Optional)

> Roll-up API: see [system-composer-api.md § Roll-Up Analysis](system-composer-api.md#roll-up-analysis)

Roll up stereotype property values from leaf components through the hierarchy. Use when SRs contain budget caps (e.g., "total mass ≤ 50 kg") and you need to verify margins.

Depends on Step 4 — no stereotype properties means nothing to analyze. Components with zero estimates silently contribute nothing, which is why views that flag zeroes matter.

Produces: totals at each hierarchy level, margins against SR caps, flags for negative margins.
