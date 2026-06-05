<!-- Copyright 2026 The MathWorks, Inc. -->

# System Composer Architecture Model Rules

To create a new blank System Composer Architecture model, use `evaluate_matlab_code` with `systemcomposer.createModel("<ModelName>")`. Then modify with `model_edit`.

## Key Differences from Standard Simulink

- **Components** are created with `type: "SubSystem"` -- they become architecture components automatically
- **Architecture ports** are created by adding In/Out Bus Element blocks inside a component -- the block name becomes the architecture port name
- **Connecting** uses the PortName shown by `model_read`: `blk_X.y1 -> blk_Y.PortName`
- Use `model_read` to discover all available port names on a component before connecting

## Creating a Component with Named Ports

1. Add component at root scope:
   `{"op": "add_block", "type": "SubSystem", "name": "Sensor", "ref": "s1"}`

2. Inside the component (scope = blk_ID of Sensor), add bus element ports:
   `{"op": "add_block", "type": "simulink/Ports & Subsystems/In Bus Element", "name": "Voltage"}`
   `{"op": "add_block", "type": "simulink/Ports & Subsystems/Out Bus Element", "name": "Torque"}`

3. Connect from root scope using the `blk_id` returned in the `created` map:
   `{"op": "connect", "target": "blk_<Source>.y1 -> blk_<Sensor>.Voltage"}`

## Fan-Out and Fan-In

A single output port can connect to multiple input ports (1-to-N fan-out) — just connect the same source to multiple destinations. However, a single input port cannot receive connections from multiple sources. SC has no merge semantics — attempting to wire two outputs into one input either errors or silently fails. Give the destination component separate named input ports for each source (e.g., `Status_Cook`, `Status_Pack`, `Status_Load`) and wire 1:1.

## Working with Composite Components

Scope into an existing component to add sub-components, ports, and connections inside it. Use the component's `blk_id` as the scope:

1. Use `model_read` on the component's `blk_id` to see its internal structure
2. Use `model_edit` with `scope="blk_X"` (the component's ID) to add sub-components and wire them

This works at any nesting depth — you can scope into a sub-component of a sub-component.

## Layout Mode

- `layout_mode: "full"` — use when building a new model or populating an empty component from scratch. Produces optimal block arrangement.
- `layout_mode: "incremental"` — use when adding components to an existing architecture that already has positioned blocks. Preserves existing layout.

## Creating Behavior Models from Architecture Components

Use `evaluate_matlab_code` with `systemcomposer.createSimulinkBehavior` to create a behavior model with matching interfaces:

```matlab
model = systemcomposer.loadModel('MyArchModel');
comp = lookup(model, Path="MyArchModel/Plant");
createSimulinkBehavior(comp, 'Plant_impl');
```

This creates `Plant_impl.slx` with ports matching the architecture component's interface. Repeat for each leaf component. Then use `model_edit` on each generated behavior model to build the block diagrams inside.

## When to use `model_edit` vs `evaluate_matlab_code` for System Composer features

For the following SC-specific features, use `evaluate_matlab_code`— see the `building-architecture-models` skill and its [System Composer Scripting reference](../../../model-based-system-engineering/building-architecture-models/reference/system-composer-api.md):
- Interface dictionaries (`.sldd`) — creating, linking, assigning to ports
- Stereotype profiles — creating, applying, setting property values
- Allocation sets (`.mldatx`) — cross-model traceability
- Architecture views — property-query-driven filters
- Roll-up analysis — instantiate, iterate, report