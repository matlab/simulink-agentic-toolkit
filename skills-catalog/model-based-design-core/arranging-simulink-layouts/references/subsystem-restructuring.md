# Subsystem Restructuring

Group blocks into a subsystem, or expand a subsystem in place, while keeping wiring intact and the surrounding layout stable. Both operations go through `evaluate_matlab_code`, because `model_edit`'s `create_subsystem` op only creates an empty subsystem with an interface.

Resolve `blk_X` IDs to paths with `Simulink.ID.getFullName('<Model>:<N>')`. Don't build paths from block names: names can contain newlines.

## Group blocks into a new subsystem

1. Collect the handles of the blocks to group. All of them must share one parent.
   ```matlab
   ids = {'45','41','37'};   % from blk_45, blk_41, blk_37
   h = cellfun(@(n) get_param(Simulink.ID.getFullName(['<Model>:' n]), 'Handle'), ids);
   Simulink.BlockDiagram.createSubsystem(h, 'Name', 'MuTerm');
   ```
   - Lines between the grouped blocks and the rest of the diagram become subsystem ports. Wiring is preserved.
   - The grouped blocks keep their SIDs, so their `blk_X` IDs still work inside the new subsystem.
2. Run `model_read` on the parent (depth `"0"`) to get the new subsystem's `blk_X` ID.
3. Lay out the inside of the new subsystem. It is a new scope, so a full layout is appropriate:
   `model_edit(model, "<newSubsystemId>", "[]", "full")`
4. In the parent, lay out the new subsystem block and its immediate neighbours:
   `model_edit(model, "<parentScope>", '[{"op":"layout","targets":["<newSubsystemId>","<neighbour1>","<neighbour2>"]}]', "incremental")`
5. Run `model_check(model, "<parentScope>", '["unconnected_ports","unconnected_lines"]')`.

## Expand a subsystem into its parent

1. Expand it:
   ```matlab
   Simulink.BlockDiagram.expandSubsystem(Simulink.ID.getFullName('<Model>:<N>'));
   ```
   - The content keeps its SIDs.
   - Simulink shifts the neighbouring blocks to make room, sometimes to negative coordinates.
   - Simulink leaves an area annotation, named after the subsystem, around the expanded blocks. Layout never moves annotations. Ask the user whether to keep or delete the area.
2. If an earlier `model_edit` in this session did a layout, SATK's background listener may already have re-placed the blocks about 1 s after the expand. Re-run `model_read` on the parent before choosing targets.
3. Lay out the blocks that came out of the subsystem, plus the shifted neighbours:
   `model_edit(model, "<parentScope>", '[{"op":"layout","targets":["blk_45","blk_41","blk_37","<neighbour>"]}]', "incremental")`
4. Run `model_check` as above.

If the parent is still messy after step 3, offer a full layout of the parent scope. Ask before running it.
