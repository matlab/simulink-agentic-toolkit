# Inspecting ARXML and C after `slbuild`

A passing `slbuild` proves that code and ARXML generated successfully, not that
the generated content matches the requested interface or placement. When a
user requests generated artifacts or their content matters to the result,
inspect the generated artifacts.

## Resolve the build directory safely

Do not assume the build output is below `pwd`. Read the configured
code-generation location, then resolve the normal model subdirectory:

```matlab
cfg = Simulink.fileGenControl("getConfig");
buildDir = fullfile(cfg.CodeGenFolder, modelName + "_autosar_rtw");
assert(isfolder(buildDir), "Expected AUTOSAR build directory was not found.");
```

Confirm the actual output reported by `slbuild` if the project overrides the
file-generation configuration. Never delete the active code-generation
folder, cache folder, or an ancestor of either while locating artifacts.

The build directory normally contains:

- `<model>_component.arxml` for the SWC-level description.
- Zero or more companion `*.arxml` files for interfaces, data types, or
  timing.
- `<model>.c` for generated component code.
- `stub/Rte_<model>.h` for RTE macros and runnable declarations.

## ARXML inspection

Scan **all** `*.arxml` files in `buildDir`. Events can be emitted in a
companion file or in the file that contains the component port prototypes.
Do not choose that file from a presumed `<model>_component.arxml` name;
identify it from `R-PORT-PROTOTYPE` or `P-PORT-PROTOTYPE` tags.

Use attribute-tolerant open-tag patterns. A literal
`<TIMING-EVENT>` misses tags with attributes such as `UUID`.

| Question | Pattern or evidence |
|---|---|
| Application SWC kind | `<APPLICATION-SW-COMPONENT-TYPE[ >]` |
| R-port / P-port count | `<R-PORT-PROTOTYPE[ >]` / `<P-PORT-PROTOTYPE[ >]` |
| SR interface | `<SENDER-RECEIVER-INTERFACE[ >]` |
| Runnable | `<RUNNABLE-ENTITY[ >]`, expected `SHORT-NAME`, and expected `SYMBOL` |
| Timing event | `<TIMING-EVENT[ >]` and expected `PERIOD` |
| Data events | `<DATA-RECEIVED-EVENT[ >]` or `<DATA-SEND-COMPLETED-EVENT[ >]` with the expected trigger/access reference |
| Port-interface binding | Expected interface path in a `*-INTERFACE-TREF` element in the file(s) that contain component port prototypes |
| Explicit send | `<DATA-SEND-POINTS[ >]` for each expected sender; its absence means the expected conditional `Rte_Write` cannot be present |
| Code or data placement | The relevant `SW-ADDR-METHOD-REF` in the runnable or data/prototype block |

## C inspection

| Question | Evidence |
|---|---|
| Entry function | Generated C declares and defines `void <symbol>(...)`. |
| Reads and writes | Expected `Rte_Read_<rPort>_<element>` and `Rte_Write_<pPort>_<element>` calls. |
| Conditional write | The expected `Rte_Write` occurs in the intended generated guard. |
| Runnable code placement | The expected `START_SEC_<code>` / `STOP_SEC_<code>` pair wraps the runnable code when applicable. |

Keep code-side and data-side placement checks separate. IRV and internal data
can be RTE-owned and accessed through `Rte_IrvRead_*` or `Rte_IrvWrite_*`.
Their correct data placement can appear only as an ARXML
`SW-ADDR-METHOD-REF`, without a VAR MemMap section in `<model>.c`.

## Example inspection script

```matlab
cfg = Simulink.fileGenControl("getConfig");
buildDir = fullfile(cfg.CodeGenFolder, modelName + "_autosar_rtw");
if ~isfolder(buildDir)
    error("AUTOSAR build directory was not found.");
end

arxmlFiles = dir(fullfile(buildDir, "*.arxml"));
if isempty(arxmlFiles)
    error("No generated ARXML files were found.");
end

allArxml = strings(0);
portPrototypeArxml = strings(0);
for k = 1:numel(arxmlFiles)
    fileText = string(fileread( ...
        fullfile(arxmlFiles(k).folder, arxmlFiles(k).name)));
    allArxml(end+1) = fileText; %#ok<SAGROW>
    if contains(fileText, "<R-PORT-PROTOTYPE") || ...
            contains(fileText, "<P-PORT-PROTOTYPE")
        portPrototypeArxml(end+1) = fileText; %#ok<SAGROW>
    end
end
if isempty(portPrototypeArxml)
    error("No generated ARXML file contains a component port prototype.");
end

arxml = strjoin(allArxml, newline);
portArxml = strjoin(portPrototypeArxml, newline);
csrc = string(fileread(fullfile(buildDir, modelName + ".c")));

hasTag = @(txt, tag) ~isempty(regexp( ...
    char(txt), "<" + tag + "[ >]", "once"));

evidence = struct;
evidence.hasApplicationSwc = hasTag(arxml, "APPLICATION-SW-COMPONENT-TYPE");
evidence.hasExpectedEvent = hasTag(arxml, "TIMING-EVENT") || ...
    hasTag(arxml, "DATA-RECEIVED-EVENT");
evidence.hasRunnable = contains(arxml, ...
    "<SHORT-NAME>" + expectedRunnable + "</SHORT-NAME>");
evidence.hasSymbol = contains(arxml, ...
    "<SYMBOL>" + expectedSymbol + "</SYMBOL>");
evidence.hasPortInterfaceBinding = contains(portArxml, "INTERFACE-TREF") && ...
    contains(portArxml, "/Interfaces/" + expectedInterface);
evidence.hasEntryFunction = contains(csrc, "void " + expectedSymbol + "(");
disp(evidence)
```

The common silent failure is a renamed runnable without an updated `symbol`:
ARXML shows the requested short name, while C still defines the old function
name.

----

Copyright 2026 The MathWorks, Inc.

----
