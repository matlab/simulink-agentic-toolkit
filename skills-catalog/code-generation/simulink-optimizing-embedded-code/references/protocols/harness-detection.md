# Test Harness Detection Guardrail

> **When to read:** Phase 1 only (fresh run), before entering Phase 2.

**NEVER optimize a test harness model directly.** Test harnesses are wrapper models created by Simulink Test that contain test infrastructure around a "component under test." Optimizing harness scaffolding is meaningless — the generated code is not deployed.

## Detection

Before performing any analysis or entering Phase 2, check:

```matlab
% Method 1: Check OwnerModelName property
try
    ownerModel = get_param('<model>', 'OwnerModelName');
    isHarness = ~isempty(ownerModel);
catch
    isHarness = false;
end

% Method 2: Use sltest.harness API (requires Simulink Test license)
try
    isHarness = sltest.harness.isHarness('<model>');
catch
    isHarness = false;
end
```

If either method returns `true`, the model is a harness. **Do NOT proceed with optimization.**

## Extraction

```matlab
% Get the owner (parent) model
ownerModel = get_param('<harness_model>', 'OwnerModelName');
ownerComponent = get_param('<harness_model>', 'HarnessOwnerPath');

% Close harness, open owner
sltest.harness.close(ownerComponent, '<harness_model>');
open_system(ownerModel);

fprintf('Owner model: %s\n', ownerModel);
fprintf('Component under test: %s\n', ownerComponent);
```

## Routing

1. Inform the user: *"The model you selected (`<harness_model>`) is a test harness. The actual model under test is `<ownerModel>`. I'll optimize that instead."*
2. Switch optimization target to `ownerModel` for all subsequent phases.
3. Never run `model_overview`, `model_read`, SIL/PIL, or any optimization on the harness itself.
4. If the harness wraps a specific subsystem (not the full model), note that subsystem path as a candidate for `targetFunctions` in Phase 2.5.

## Listing Harnesses (informational)

```matlab
harnessInfo = sltest.harness.find(ownerModel);
for i = 1:numel(harnessInfo)
    fprintf('  Harness: %s (type: %s)\n', harnessInfo(i).name, harnessInfo(i).type);
end
```


----

Copyright 2026 The MathWorks, Inc.

----