# Conditional `Rte_Write` prerequisites

Use this note only when the user explicitly asks for generated AUTOSAR C where `Rte_Write_*` appears inside an `if` guard.

## Minimum documented prerequisites

The documented prerequisites are:

- The conditional write targets an outport, not an IRV.
- The sender port is mapped as `ExplicitSend`.
- The model is an Export-Function model.
- Every outport from the conditional subsystem to the root uses "Ensure outport is virtual".

## Modeling guidance

- Keep the solution at the model and mapping level. Do not edit generated C manually.
- Use a model-side change-detection pattern, such as previous-value state plus comparison feeding a conditionally executed subsystem.
- Feed the comparison into an Enabled Subsystem and configure that subsystem so output and states are held while disabled.
- Treat moving from `ImplicitSend` to `ExplicitSend` as an architectural decision, not a silent local tweak.

## Unsupported or non-goal cases

- Do not promise conditional `Rte_Write` for IRVs.
- Do not promise conditional `Rte_Write` for `ImplicitSend`.
- Do not promise conditional `Rte_Write` for rate-based models; the documented requirement is Export-Function.
- If a rate-based model asks to switch to `ExplicitSend` solely to obtain conditional `Rte_Write`, refuse that mapping change, preserve the existing access mode, and explain the Export-Function prerequisite. Do not silently convert the model architecture.

## Generated-artifact details

When the user asks about the generated implementation, look for:

- Generated `.c` contains an if-guarded `Rte_Write_<port>_<dataElement>(...)` call.
- Generated ARXML contains the expected `<DATA-SEND-POINTS>` as a secondary check.

If the model satisfies the documented prerequisites and the generated code still does not contain the expected if-guarded `Rte_Write`, do not invent extra undocumented rules. Escalate to MathWorks support.

----

Copyright 2026 The MathWorks, Inc.

----
