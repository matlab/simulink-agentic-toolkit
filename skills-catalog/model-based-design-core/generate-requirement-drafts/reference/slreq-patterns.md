# Requirements Toolbox API Patterns

Cookbook for programmatic requirements management using `slreq` APIs. All APIs are safe for R2023a+.

## Detection

```matlab
hasSlreq = ~isempty(which('slreq.new'));
if hasSlreq
    try, slreq.find(Type="Link"); catch, hasSlreq = false; end
end
```

## Create a Requirement Set

```matlab
rs = slreq.new("MyModel_Requirements");   % creates .slreqx in current folder
rs = slreq.new("C:\path\to\MyReqs");      % creates at specified path
```

## Add Requirements

```matlab
% Top-level requirement
req = add(rs, ...
    Id="REQ_CC_001", ...
    Summary="Controller shall limit throttle command to [0,1].", ...
    Description="Derived from Saturation logic in CruiseControl/ThrottleCmd.");

% Set additional properties via dot notation
req.Rationale = "Prevents invalid actuator commands.";
req.Keywords = ["control", "safety"];
req.Type = "Functional";   % "Functional" | "Informational" | "Container"

% Child requirement (creates hierarchy)
child = add(req, ...
    Id="REQ_CC_002", ...
    Summary="Controller shall disengage when brake pedal > 0.");
```

## Custom Attributes

```matlab
% Add an ASIL attribute to the requirement set
addAttribute(rs, 'ASIL', 'Combobox', 'List', {'Unset','QM','A','B','C','D'});

% Set attribute on a requirement
setAttribute(req, 'ASIL', 'C');

% Query attribute
val = getAttribute(req, 'ASIL');
```

## Create Traceability Links

Links connect model elements to requirements. The link type is auto-assigned based on artifact types.

```matlab
% Using block path (string) — most common
lnk = slreq.createLink("MyModel/Subsystem/Block", req);

% Using block handle
h = get_param("MyModel/Subsystem", "Handle");
lnk = slreq.createLink(h, req);
```

**Link direction matters:**
- Source = model element, Destination = requirement → **`Implement`** (auto)
- Source = test case, Destination = requirement → **`Verify`** (auto)
- Source = requirement, Destination = requirement → **`Relate`** (default)

**Always save both the requirement set and the link set:**
```matlab
save(rs);
save(linkSet(lnk));
```

### Linking Multiple Requirements in a Loop

```matlab
captureTable = {
    "REQ_CC_001", "CruiseControl/ThrottleCmd", "Limit throttle to [0,1]";
    "REQ_CC_002", "CruiseControl/BrakeLogic",  "Disengage on brake";
};

for i = 1:size(captureTable,1)
    req = add(rs, Id=captureTable{i,1}, Summary=captureTable{i,3});
    lnk = slreq.createLink(captureTable{i,2}, req);
end
save(rs);
% Save link sets
linkSets = slreq.find(Type="LinkSet");
for i = 1:numel(linkSets), save(linkSets(i)); end
```

## Find and Query

```matlab
% Load an existing requirement set
rs = slreq.load("MyModel_Requirements");

% Find all requirements
reqs = find(rs, Type="Requirement");

% Find by property
req = find(rs, Id="REQ_CC_001");

% Find globally
allReqs = slreq.find(Type="Requirement");
allLinks = slreq.find(Type="Link");
allLinkSets = slreq.find(Type="LinkSet");
```

## Status Queries

```matlab
implStatus = getImplementationStatus(rs);   % implementation coverage
verifStatus = getVerificationStatus(rs);     % verification coverage
```

## Navigate Hierarchy

```matlab
topLevel = children(rs);       % top-level requirements
kids = children(req);          % children of a requirement
par = parent(req);             % parent requirement
```

## Navigate Links

```matlab
outgoing = outLinks(req);      % links where req is source
incoming = inLinks(req);       % links where req is destination
```

## Save, Close, Clear

```matlab
save(rs);
close(rs);          % close specific requirement set
slreq.clear;        % clear all loaded req sets and link sets from memory
```

## Common Pitfalls

| Pitfall | Fix |
|---------|-----|
| Reversed link direction (requirement → block) | Source must be the model element, destination the requirement |
| Forgot to save the link set | `save(linkSet(lnk))` — saving the req set alone does not save links |
| Over-linking every primitive block | Link at subsystem level unless the requirement is block-specific |
| Unstable IDs on regeneration | Preserve existing IDs on regeneration; append new IDs sequentially |
| Model not loaded when linking | Ensure the model is open (`load_system`) before calling `slreq.createLink` with block paths |
