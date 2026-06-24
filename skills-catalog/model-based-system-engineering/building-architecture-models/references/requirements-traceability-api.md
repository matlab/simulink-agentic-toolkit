<!-- Copyright 2026 The MathWorks, Inc. -->

# Requirements Traceability API Reference

> **Execution model:** Execute all patterns in this file via `evaluate_matlab_code`. Do not create `.m` script files unless the user explicitly asks for this. Otherwise, write the code inline and execute it directly.

Architecture-specific patterns for requirements and traceability links. For general slreq API patterns (creating sets, adding requirements, basic linking, saving), see [`generate-requirement-drafts/references/slreq-patterns.md`](../../../model-based-design-core/generate-requirement-drafts/references/slreq-patterns.md).

---

## Linking SC Architecture Components

The `generate-requirement-drafts` skill links Simulink blocks via handle or path. For System Composer architecture components, pass the component object directly:

```matlab
model = systemcomposer.openModel('MyPhysical');
arch = model.Architecture;
comp = arch.getComponent("SensorUnit");

req = srSet.find('Id', 'SR-SYS-003');
lnk = slreq.createLink(comp, req);
lnk.Type = 'Implement';
```

The link source is the component; the destination is the requirement. From the requirement's perspective, these are `inLinks()`.

For nested components, use [`resolveComponent`](../scripts/resolveComponent.m):

```matlab
comp = resolveComponent(arch, 'Assembly/Actuator');
lnk = slreq.createLink(comp, req);
lnk.Type = 'Implement';
```

---

## Derive Links (Stakeholder Needs → System Requirements)

`Derive` links decompose high-level needs into testable requirements. The source is the parent (SN), the destination is the derived child (SR):

```matlab
snSet = slreq.load(fullfile(reqDir, 'StakeholderNeeds.slreqx'));
srSet = slreq.load(fullfile(reqDir, 'SystemRequirements.slreqx'));

sn = snSet.find('Id', 'SN-SYS-001');
sr = srSet.find('Id', 'SR-SYS-001');

lnk = slreq.createLink(sn, sr);
lnk.Type = 'Derive';

slreq.saveAll();
```

---

## `.slmx` File Lifecycle

slreq stores links in `.slmx` files keyed on the **source artifact**:

| Source artifact | Link file created |
|---|---|
| Requirement in `StakeholderNeeds.slreqx` | `StakeholderNeeds~slreqx.slmx` |
| Component in `MyPhysical.slx` | `MyPhysical~mdl.slmx` |

A `.slmx` only appears when its companion artifact is the source of at least one link. An artifact that is only a link destination never gets one.

### Register with project

```matlab
slmx = fullfile(archDir, 'MyPhysical~mdl.slmx');
if isfile(slmx)
    addFile(proj, slmx);
end
```

Always guard with `isfile` — the file may not exist if no links were created from that artifact.

### Idempotent cleanup

Delete `.slmx` files alongside their parent artifacts on rebuild to avoid stale link data:

```matlab
if isfile(slmx), delete(slmx); end
```

---

## Idempotent Rebuild Pattern

`slreq.new(file)` intermittently fails with a name-conflict error even after `slreq.clear()` and `delete(file)`. The robust pattern is load-or-clear-and-repopulate:

```matlab
slreq.clear();
if isfile(reqFile)
    rs = slreq.load(reqFile);
    % Clear existing links first to avoid orphan warnings
    lnkSets = slreq.find('Type', 'LinkSet', 'Artifact', reqFile);
    for i = 1:numel(lnkSets)
        links = lnkSets(i).getLinks();
        for j = 1:numel(links), links(j).remove(); end
    end
    % Clear existing requirements
    existing = rs.find('Type', 'Requirement');
    for k = numel(existing):-1:1, existing(k).remove(); end
else
    rs = slreq.new(reqFile);
end
% ... populate fresh ...
rs.save();
```

---

## Gotchas

- **`req.inLinks()` auto-loads referenced sets.** Calling `inLinks()` triggers slreq to resolve link sources, which silently loads other `.slreqx`/`.slmx` files into memory. Call `slreq.clear()` between pipeline phases to avoid hidden state.
- **Avoid `<` and `>` in Description fields.** The Requirements Editor treats them as HTML. Use "not exceeding", "at least", "greater than" instead.
- **`req.remove()` leaves orphan outLinks.** Clear the link set before removing requirements (shown in the idempotent pattern above).
- **Model must be open.** `slreq.createLink(comp, req)` requires the model to be loaded. Use `systemcomposer.openModel` before linking.
