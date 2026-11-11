# Subsystem Restructuring

Group blocks into a subsystem, or expand a subsystem in place, while keeping wiring intact and the surrounding layout stable. Both operations go through `evaluate_matlab_code`, because `model_edit`'s `create_subsystem` operation only creates an empty subsystem with an interface.

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
   - **Goto/From links aren't preserved.** A Goto with `TagVisibility` `local` is visible only in its own subsystem. If the group splits it from its From blocks, the From loses its source. The model still compiles and simulates with no error, and the signal reads 0. Before grouping, check for Goto or From blocks in the group, and tell the user if the group splits a local pair.
2. Run `model_read` on the parent (depth `"0"`) to get the new subsystem's `blk_X` ID.
3. Follow [After either operation](#after-either-operation). Typical leftovers:
   - Inside the subsystem, the new ports go into the gaps between the grouped blocks, where they can overlap blocks, or land well away from them. A port on a named signal takes the signal's name (for example `x2`); the rest are `In1`, `In2`, ….
   - When the grouped blocks weren't next to each other, the new subsystem can land on top of blocks left outside it, with wires looping around it.

## Expand a subsystem into its parent

```matlab
Simulink.BlockDiagram.expandSubsystem(Simulink.ID.getFullName('<Model>:<N>'));
```

- The content keeps its SIDs.
- **Local Goto tags can collide.** If a Goto inside the subsystem uses the same local tag as a Goto in the parent, the expand succeeds but the model no longer compiles ("Multiple Gotos found with tag named …"). Before expanding, compare the subsystem's local Goto tags with the parent's, and tell the user about any clash.
- Simulink shifts the neighbouring blocks to make room, sometimes to negative coordinates.
- Simulink leaves an area annotation, named after the subsystem, around the expanded blocks. Layout never moves annotations. Ask the user whether to keep or delete the area.
- If an earlier `model_edit` in this session did a layout, SATK's background listener may reposition the expanded blocks about 1 s after the expand. Re-run `model_read` on the parent before reporting positions.
- Then follow [After either operation](#after-either-operation).

## After either operation

Don't run any layout, selective or full. Describe any overlaps to the user and offer a full layout of the affected scope: the new subsystem, the parent, or both. It is the only way to get a fully clean result, but it moves every block in that scope, so the user has to re-read the diagram. Run `model_edit(model, "<scope>", "[]", "full")` only if the user agrees. A request to "make it tidy" doesn't count as agreement.

----

Copyright 2026 The MathWorks, Inc.

----
