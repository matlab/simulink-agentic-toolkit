# Requirements Traceability Query (read-only)

Read-only requirement-linkage query for triaging reachable-but-untested outcomes: which
uncovered logic is **required** (linked to a requirement) versus unlinked. It distinguishes
"untested but required" (high priority) from "untested and unlinked" (lower priority). It
does **not** author or repair links.

Requires **Requirements Toolbox** (SLReq). If unavailable, skip this step and say so; do
not infer requirement status by any other means.

## Read-only contract

- Loading a model / link set and reading `slreq.Link` objects modifies nothing.
- Calling `slreq.createLink`, `setSource`, `setDestination`, or any other mutating call is
  outside this skill's scope — those are authoring actions. This skill only reads links.

## Query pattern

There is no single `slreq.getLinks(block)` accessor. The documented read path is: load the
model's link set, pull all links, and match each link's **source** SID to the block.

```matlab
function [isLinked, reqIds] = iBlockRequirements(modelName, blockPath)
% Requirement IDs linked to blockPath, via the model's link set (read-only).
open_system(modelName);                                 % loads the associated link set (read)
ls = slreq.find(Type="LinkSet", Name=modelName);        % the model's link set ([] if none)
if isempty(ls); isLinked = false; reqIds = strings(0); return; end   % no link set -> unlinked

targetH = getSimulinkBlockHandle(blockPath);
links   = getLinks(ls);
isLinked = false; reqIds = strings(0);
for i = 1:numel(links)
    src = links(i).source;                              % source item = the Simulink block
    if isfield(src,'id') && ~isempty(src.id)
        srcH = Simulink.ID.getHandle([bdroot(blockPath) src.id]);
        if srcH == targetH                              % this block is a link source
            isLinked = true;
            dst = links(i).destination;                 % the requirement
            reqIds(end+1) = string(dst.id);             %#ok<AGROW>
        end
    end
end
end
```

Identify blocks by SID, not by path string (`Simulink.ID.getHandle` resolves a SID to a
handle to compare, as above). SIDs are stable across rename/move.

## Reading the linked requirement

```matlab
ref = slreq.structToObj(link.destination);   % -> slreq.Requirement / slreq.Reference
ref.Id                                         % requirement ID
ref.Summary                                    % short summary
ref.Description                                % full text
```

## Using it in triage

- **linked + uncovered** → "untested but required" — prioritize a test scenario; cite the
  requirement ID.
- **unlinked + uncovered** → lower triage priority, or a hint the logic may be unrequired
  (worth surfacing, not a conclusion).

The link set must be **loaded** (open the model or `slreq.load` the artifact) before
`getLinks` returns anything; `slreq.find(Type="LinkSet")` on an unloaded model returns `[]`.

----

Copyright 2026 The MathWorks, Inc.

----
