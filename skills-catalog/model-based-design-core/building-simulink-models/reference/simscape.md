# Simscape Physical Connection Rules

Physical ports (electrical, mechanical, thermal) use bidirectional `<->` syntax.

## Connection Syntax

- **Always use `<->`** for physical connections, not `->`: `{"op": "connect", "target": "blk_X.RConn1 <-> blk_Y.LConn1"}`
- **No replace.** Connecting to a conserving port that is already connected **adds a new branch** and does not remove existing connections.
- **Rewiring requires disconnect first.** To move a conserving port from one branch point to another, disconnect the old pair first (`disconnect`), then connect the new pair (`connect`).
- Wildcard disconnect (`blk_X.LConn1 <-> ?`) removes all branches from a conserving port.

## Common Physical Port Patterns

| Block Type | `LConn1` | `RConn1` | Other |
|------------|----------|----------|-------|
| **2-terminal electrical** (Resistor, Capacitor, Inductor, Voltage Source, Current Source) | +/p | -/n | |
| **References** (Electrical Reference, Mechanical Translational Reference) | single port | | |
| **Voltage Sensor** | + (electrical) | - (electrical) | |
| **Current Sensor** | + (electrical) | I (**physical signal** output) | `RConn2`: - (electrical) |
| **PS-Simulink Converter** | physical input | | |
| **Simulink-PS Converter** | | physical output | |
| **Solver Configuration** | | single port (connect to any node) | |
| **Rotational mechanical** (Inertia, Rotational Damper) | R/shaft | C/case | |
| **DC Motor (PM mode)** | p/+ (electrical) | n/- (electrical) | `LConn2`: R (rotor shaft), `RConn2`: C (case) |

## Mixed-Domain Ports

Sensor blocks often have both conserving (electrical/mechanical) terminals AND physical signal outputs for measurement. Physical signal ports connect to PS-Simulink Converters, NOT to other electrical or mechanical components.

If `model_edit` connect fails with a domain error, check `physical_ports` in `model_read` output to verify port domains. For blocks not listed above, `model_read` `physical_ports` provides the authoritative port-to-domain mapping.

## Initial Target Variables

Some blocks in Simscape allow you to set initial values via **initial target variables**. When a setting initial targets for a block, you **must** also set the `_specify` flag to `"on"` for the solver to enforce the value:
`{"op": "configure", "target": "blk_1", "params": {"T": "360", "T_specify": "on", "T_priority": "High"}}`

This pattern (`<var>`, `<var>_specify`, `<var>_priority`) is universal across all Simscape domains — e.g., `T`/`T_specify` (thermal), `vc`/`vc_specify` (electrical capacitor), `x`/`x_specify` (translational spring), `w`/`w_specify` (rotational inertia).
Use `model_query_params` to discover which initial target variables a block exposes (if any).
