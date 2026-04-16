%% Generate Requirement Drafts from a Simulink Model using Requirements Toolbox
%
% End-to-end example: read model, create requirement set, add draft
% requirements with hierarchy, establish traceability links to model
% blocks, and save. All outputs are DRAFTS requiring human review.
%
% Prerequisites: MATLAB R2023a+, Simulink, Requirements Toolbox
% Model: CruiseControl (must be on path or in current folder)

%% 1. Load the model
model = "CruiseControl";
load_system(model);

%% 2. Create a new requirement set
rs = slreq.new(model + "_Requirements");

%% 3. Add a custom ASIL attribute
addAttribute(rs, 'ASIL', 'Combobox', 'List', {'Unset','QM','A','B','C','D'});

%% 4. Add top-level system requirement (DRAFT)
sysReq = add(rs, ...
    Id="REQ_CC_001", ...
    Summary="The cruise control system shall maintain vehicle speed within +/- SpeedTolerance (2.0) km/h of the driver-set target speed under steady-state conditions.", ...
    Description="Derived from the top-level CruiseControl system architecture.");
sysReq.Rationale = "Maintains driver comfort and fuel efficiency.";
sysReq.Keywords = ["draft", "auto-generated", "cruise-control", "performance"];
setAttribute(sysReq, 'ASIL', 'QM');

%% 5. Add subsystem-level requirements (children, DRAFT)
throttleReq = add(sysReq, ...
    Id="REQ_CC_002", ...
    Summary="If throttle command exceeds ThrottleMax (1.0) or falls below ThrottleMin (0.0), then the controller shall clamp the output to the valid range.", ...
    Description="Derived from CruiseControl/ThrottleCmd.");
throttleReq.Rationale = "Prevents invalid actuator commands that could damage the throttle body.";
throttleReq.Keywords = ["draft", "auto-generated", "control", "safety"];
setAttribute(throttleReq, 'ASIL', 'A');

brakeReq = add(sysReq, ...
    Id="REQ_CC_003", ...
    Summary="When brake pedal input exceeds BrakeThreshold (0.0), the controller shall disengage cruise control.", ...
    Description="Derived from CruiseControl/BrakeLogic.");
brakeReq.Rationale = "Safety override — driver braking must always take priority.";
brakeReq.Keywords = ["draft", "auto-generated", "safety", "brake"];
setAttribute(brakeReq, 'ASIL', 'B');

%% 6. Create traceability links (model element → requirement = Implement)
lnk1 = slreq.createLink(model + "/ThrottleCmd", throttleReq);
lnk2 = slreq.createLink(model + "/BrakeLogic", brakeReq);

%% 7. Save everything (requirement set + all link sets)
save(rs);
linkSets = slreq.find(Type="LinkSet");
for i = 1:numel(linkSets), save(linkSets(i)); end

%% 8. Verify status
disp("Implementation status:");
disp(getImplementationStatus(rs));
disp("Verification status:");
disp(getVerificationStatus(rs));

fprintf("Requirement set saved: %s\n", rs.Filename);
