# Code Mapping Reference (`coder.mapping.*`)

## Purpose

Configure how model elements (inports, outports, states, functions) map to generated code interfaces using the `coder.mapping` API.

**Prerequisite:** A Simulink model in one of these configuration states:
- A GRT Simulink model (a model with the configuration parameter `SystemTargetFile` set to `"grt.tlc"`) — For these models, the skill supports basic data interface operations, such as specifying storage classes for ports, states, and model parameters.
- An ERT Simulink model (a model with the configuration parameter `SystemTargetFile` set to `"ert.tlc"`) — For these models, the skill supports broad scale operations, such as function mapping, setting the model deployment type, and specifying the model mode as either data or service interface configuration.
- An ERT model configured with data interface configuration can either use the internal model Embedded Coder dictionary, or it can alternatively be linked to a shared Embedded Coder dictionary (configured with data interface configuration).
- An ERT model configured with service interface configuration must be linked to a shared Embedded Coder dictionary (configured with service interface configuration).

To link a model to a shared Embedded Coder dictionary, set the value of the `EmbeddedCoderDictionary` configuration parameter to the relative path of the `.sldd` dictionary file. See `coder_dictionary.md` for more information about shared Embedded Coder dictionaries.

---

## Getting the Code Mapping Object

```matlab
cm = coder.mapping.utils.create(model); % Required on fresh models that do not have mappings.
cm = coder.mapping.api.get(model);  
```

- `coder.mapping.api.get` fails if the model does not have code mappings. In this case, call `coder.mapping.utils.create` instead. The create function detects the model mode (data or service interface configuration), and creates the mapping object accordingly.
- The object is model-scoped — one per model.

---

## Storage Class: Use Code Mappings to Assign Storage Classes (and a note on Data Objects)

Assigning a storage class to model elements can be done in one of two alternative ways. For each model element use one option, never both (see guardrail). These are the alternative options:
- Use the functions of the **code mappings** of the model.
- Use **data objects** (`Simulink.Parameter`/`Simulink.Signal`).

**This skill uses the first option, code mappings.**  
Only one of the options should be used with each project. So, first ask the user which of the two options they use with their project, and only use this skill if they are using the code mappings option. If they are using the second option (data objects), do not use this skill, because that is a different workflow. The one unavoidable exception is a parameter that lives outside the model workspace — code mappings cannot address it at all, so it must be configured on the object. See *Configuring a parameter's storage class: which mechanism?* below.

### Code mappings (`coder.mapping.*`)

#### Note about awareness when using shared Embedded Coder dictionaries
When using code mappings without a shared dictionary all the mapping definitions, like storage classes for example, live inside the model. When using a shared dictionary, the code mappings of the model can use elements defined in the shared dictionary. For example:
```matlab
% Create a new data dictionary file, dataDict.sldd.
Simulink.data.dictionary.create("dataDict.sldd");

% In the dictionary file, create a new Embedded Coder dictionary with data interface configuration, and store its handle in the variable d1.
d1 = coder.dictionary.create("dataDict.sldd","DataInterface");

% Link the new shared Embedded Coder dictionary to the model. This step is not a MATLAB call:
% set the EmbeddedCoderDictionary configset parameter to "dataDict.sldd" by linking through
% model_edit (a configure op on config:<ModelName>). See coder_dictionary.md.

% Get the storage classes section of the shared dictionary and store a handle to it in the variable sc_sect.
sc_sect = d1.getSection("StorageClasses");

% Add a new storage class in the storage classes section of the shared dictionary.
sc_sect.addEntry("mySC1");

% Create a mapping object for the model and store its handle in the variable mapObj.
mapObj = coder.mapping.utils.create(bdroot);

% Use the code mapping object to specify the storage class for the inport In1 as this new storage class you created previously in the dictionary.
mapObj.setInport("In1",StorageClass="mySC1")
```
Now the code mappings of the model rely on the dictionary. If the model cannot find the dictionary for some reason, it might result in an error.

---

To use the code mappings of the model, you first need to make sure it exists and if not, create it. You also need to store a handle to it in a variable. The creation function returns a handle to the code mappings object, so store the return value if you are creating the object. If not, use the get function to get a handle to the code mappings object of the model. Here is an example code:
```matlab
try
  % Try to get a handle to the code mappings object of the model.
  cm = coder.mapping.api.get(model);
catch pErr
  if(contains(pErr.identifier,"NoCodeMapping"))
    % In case there is no code mappings object for the model, create one.
    cm = coder.mapping.utils.create(model);
  end
end
```

How to assign storage classes to model signals:
```matlab
% Before you assign a storage class to a signal, you need to add it to the code mappings.
% To add a signal to the code mappings, use its output port handle, not its name or path.
% Narrow exception, not a pattern to follow: get_param is required here because
% model_query_params prints handles at 15 significant digits and most need 16, so
% the value it reports is not a valid handle -- addSignal rejects it.
ph = get_param(model+"/Gain","PortHandles"); % Get the port handles struct of the Gain block signal and store it in the variable ph.

addSignal(cm,ph.Outport(1)); % Add the signal to the code mappings.

setSignal(cm,ph.Outport(1),StorageClass="ExportedGlobal") % Assign the ExportedGlobal storage class to the signal.
```
Limitation: Adding root-level inport signals to the code mappings of the model is not supported. `addSignal` rejects them with *"Signal connected to root-level inport `<model>/In1`. Map signals that are sourced from root-level inports as inports instead of signals."* (id `coderdictionary:mapping:invalidSignalMappingSpecification3`). Configure those through `setInport` instead.

How to assign storage classes to model parameters:
```matlab
% Use the name of the parameter variable to specify the storage class of a model parameter.
setModelParameter(cm,"Kp",StorageClass="ExportedGlobal")
```

- Per-model — not reusable across models.
- **A model parameter appears only when it is a `Simulink.Parameter` in the *model workspace*.** A plain value, or a `Simulink.Parameter` in the *base* workspace, is not tracked — `getModelParameter`/`setModelParameter` error with *"parameter mapping does not exist."* For a model-workspace `Simulink.Parameter`, `setModelParameter` writes through to that object (same backing store).
- Model parameters appear in the mapping at **edit time** — no update diagram needed. Inports, outports, states, data stores, Simulink Functions, and exported functions (`ExportedFunction:<InportName>`) are likewise available at edit time. **Signals are the exception:** `find(cm,"Signals")` never discovers a signal on its own — it must first be registered with `addSignal`, after which it is immediately available with no update diagram. Update diagram **is** required for the rate-based `Periodic:Dn` step functions, and in service interface configuration for Data Transfer entries — the code generator synthesizes those during model compilation. When an element you expect is missing from `find`, run update diagram and enumerate again before concluding it is unmappable.

**Guardrail — do not set storage class in two conflicting places for one signal.** If a signal has a non-`Auto` storage class in **both** the code mapping and an associated `Simulink.Signal`, **code generation fails**:

> *code mapping of signal '…' to code specification '…' conflicts with storage class setting for external data object associated with that signal. Change one of the specifications to 'Auto'.*

A hard build error, not a silent override. Set one side to `"Auto"`. In data interface configuration `Auto` is the code mapping's own neutral value for an element — it is what a freshly created mapping reports for every inport — so clearing the mapping side back to `Auto` is normally the fix. In service interface configuration there is no `Auto`; the neutral values are `"Dictionary default"` and `"From signal object"`. *(For model-workspace `Simulink.Parameter`, the two share one backing store and cannot conflict.)*

**Word of caution — there is no single storage class vocabulary.** The accepted values differ by setter, by category, and by target, and the differences are not guessable. To illustrate the kinds of variation:

- Per-element setters and the defaults API do not agree. Values such as `Auto` and `Model default` are per-element only, while `Default` is a `setDataDefault` value that every per-element setter rejects. Never carry a value from one call to the other.
- The per-element setters are not uniform among themselves — `setState` accepts `FileScope` where `setOutport` does not, and `setModelParameter` differs noticeably from the port setters.
- `setDataDefault` differs by category; some categories accept only a single value.
- A GRT target accepts far fewer values than ERT, and a linked dictionary contributes both a `Dictionary default` value and any custom storage classes it defines.

The names above are examples, not a lookup table. Enumerate for the exact call you are about to make:

```matlab
introspect_api("setOutport",model,property="StorageClass")                        % per-element setter
introspect_api("setDataDefault",model,category="Inports",property="StorageClass") % defaults API
```

### Configuring a parameter's storage class: which mechanism?

For **parameters** specifically, the choice between the two mechanisms is not a free preference — it is determined by **where the parameter lives**:

1. **Is parameter configuration actually being requested?** Only configure a storage class when the user asks to control the parameter's code representation (for example "keep it tunable", "make it a global"). Otherwise leave the default.
2. **Is the parameter a `Simulink.Parameter` in the *model workspace*?** → **Always use code mappings** (`setModelParameter`), *even on a GRT target*. `setModelParameter` writes through to the model-workspace object (same backing store), so the mapping stays the single source of truth. Do **not** reach past it to set `.StorageClass` directly on the model-workspace object.

   ```matlab
   cm = coder.mapping.api.get(model);
   setModelParameter(cm,"Kp",StorageClass="ExportedGlobal")
   ```

3. **Is the parameter an *external parameter object* — a `Simulink.Parameter` in the base workspace or a data dictionary?** → **Set `.StorageClass` directly on the object.** It is not owned by any one model's mapping, so `setModelParameter` cannot address it (it errors with *"parameter mapping does not exist"*, id `coderdictionary:api:invalidMappingParameterName`).

   ```matlab
   Ks.StorageClass = "ExportedGlobal"; % Ks is an external Simulink.Parameter (base workspace or data dictionary)
   ```

The rule of thumb: **model-workspace parameter → code mappings; external parameter object → the object itself.** A plain numeric value (not a `Simulink.Parameter`) has no mapping and no object — make it a model-workspace `Simulink.Parameter` first if it must be tunable.

---

## Deployment Type

### Setting Deployment Type

```matlab
setDeploymentType(cm,"Component")
```

Valid options depend on the dictionary interface mode:

| Mode | Available Deployment Types |
|---|---|
| DataInterface | `"Automatic"`, `"Subcomponent"` |
| ServiceInterface | `"Automatic"`, `"Subcomponent"`, `"Component"` |

`"Component"` is settable only in service interface configuration — but note that this is a limitation on the *property*, not on component deployment itself: in data interface configuration `"Automatic"` determines the deployment type based on context, and for a top model that is a component. Do not switch a model to service interface configuration merely because the user says "component". Similarly, Data Transfer configuration (`getDataTransfer`/`setDataTransfer`) is Service Interface only — in Data Interface mode, rate transitions are handled automatically by the code generator. Data Transfer mappings only appear after running update diagram (`Ctrl+D` or `set_param(model,SimulationCommand="update")`) — the code generator synthesizes these entries during model compilation. If only `"Automatic"` and `"Subcomponent"` appear, the model is in DataInterface mode.

### Querying Deployment Type

```matlab
getDeploymentType(cm) % Returns current deployment type string
```

---

## Port and State Mapping

**Guardrail:** The entry names used below (for example, `"MyReceiverEntry"`) must already exist in the linked dictionary. Never invent entry names — first enumerate available entries with `find(dict.getSection(...))` and ask the user which entry to assign. If no suitable entry exists, switch to `coder_dictionary.md` to create one (with user-provided values).

### Setting Interface on Ports

```matlab
setInport(cm,portHandle,ReceiverService="MyReceiverEntry")
setOutport(cm,portHandle,SenderService="MySenderEntry")
```

- The third argument is the **property name** (ServiceInterface mode)
- The fourth argument is the **dictionary entry name** (must exist in the linked dictionary)

### Setting Interface on States

```matlab
setState(cm,blockHandle,MeasurementService="MyMeasurementEntry")
```

### Setting Interface on Data Stores

A Data Store Memory block appears in the mapping under the `"DataStores"` category **immediately** after the block is added — no update diagram needed. Its default `StorageClass` is `"Auto"`.

**Enumerate with `find(cm,"DataStores")` before any `setDataStore`.** The `find` call returns the store's **block handle** and confirms it is mapped. `setDataStore` accepts that handle, and also the data store **name** (`"DS"`) or block path. Guessing a store name without enumerating first is the common failure.

```matlab
find(cm,"DataStores") % enumerate FIRST — returns block handles
setDataStore(cm,"DS",StorageClass="ExportedGlobal") % by data store name...
setDataStore(cm,model+"/DSMem",StorageClass="ExportedGlobal") % ...or block path
getDataStore(cm,"DS","StorageClass") % read back
```

Addressable by data store name, block path, or block handle. In ServiceInterface mode the property is `MeasurementService` instead of `StorageClass` (see the mode-awareness table: "State/signal/data store").

---

## Mode Awareness: DataInterface vs ServiceInterface

Detect mode: `introspect_api("mode",model)` — or, to read the linked dictionary file directly, read `EmbeddedCoderDictionary` through `model_query_params` and call `getCodeInterfaceType(coder.dictionary.open("<that path>"))`. Note: `coder.dictionary.open(model)` returns the model-embedded dictionary which is always DataInterface — use the SLDD path.

The mode determines which properties are valid on code mapping calls:

| Concept | DataInterface Property | ServiceInterface Property |
|---|---|---|
| Inport config | `StorageClass` | `ReceiverService` |
| Outport config | `StorageClass` | `SenderService` |
| State/signal/data store | `StorageClass` | `MeasurementService` |
| Model parameter | `StorageClass` | `ParameterTuningService` |
| Additional per-element properties | Per-instance props depend on assigned StorageClass (`GetSet` adds `GetFunction`/`SetFunction`, `ExportToFile` adds `HeaderFile`/`DefinitionFile`/`Owner`, and so on), plus the same profile props listed at right | `Identifier` + profile props (`Export`, `BitMask`, `CalibrationAccess`, `DisplayIdentifier`, `Format`, `CompuMethod`) |
| Defaults API | `getDataDefault(cm,category,property)` / `setDataDefault` | `getDictionaryDefault(dict,sectionName)` / `setDictionaryDefault(dict,sectionName,entryName)` — operates on the dictionary object, not code mapping |
| Function placement | `MemorySection` | `FunctionCustomizationTemplate` (references dictionary template; `MemorySection` not valid) |
| Deployment types | `Automatic`, `Subcomponent` | `Automatic`, `Subcomponent`, `Component` |

Use `introspect_api("setInport",model)` (or any `set*` variant) to get the full property list and allowed values for the current mode.

**Calibration (A2L/ASAP2) boundary.** The profile properties in the row above — `Export`, `CalibrationAccess`, `BitMask`, `CompuMethod`, `DisplayIdentifier`, `Format` — are the **model-side** calibration attributes; the A2L exporter reads them, so setting them here is how you configure calibration data that persists with the model. Set them through code mappings and they survive every build. Customizing the **exported A2L file** — adding COMPU_METHODs or GROUPs, converting STD_AXIS to COM_AXIS, BIT_OPERATIONs, VARIANT_CODING — is a different API (`coder.asap2.*`) and belongs to the **`simulink-customize-a2l`** skill. Hand off there. Two traps that skill documents and this one does not: `slbuild` is required after `setInport`/`setOutport` before export or the A2L is silently stale, and `coder.asap2.export` silently discards all customizations if `CustomEcuDescriptions` is omitted.

---

## Function Mapping

### Rate-Based Step Functions Require Update Diagram

`find(cm,"Functions")` lists `Initialize`, `Terminate`, and any Simulink Functions in the model (as `SimulinkFunction:<name>`) at edit time. What is missing before compilation is the rate-based step functions: the **periodic step functions are synthesized during model compilation** and appear only after an update diagram:

```matlab
set_param(model,SimulationCommand="update"); % or Ctrl+D
find(cm,"Functions")
% Single-rate model  -> Initialize, Terminate, Periodic:D1
% Multi-rate model   -> Initialize, Terminate, Periodic:D1, Periodic:D2, ...  (one per discrete rate)
```

Each `Periodic:Dn` corresponds to one discrete rate in the model. Enumerate with `find(cm,"Functions")` **after** update diagram to get the exact names, then use those names with `setFunction`. Do not hardcode `Periodic:D1` — the set of rate functions depends on the model's rates.

### Setting Function Names

```matlab
setFunction(cm,"Initialize","FunctionName","MyModel_init")
setFunction(cm,"Periodic:D1","FunctionName","MyModel_step") % use name from find(cm,"Functions")
```

### Function Prototype (Argument Configuration)

Control how a function's C prototype is generated — argument order, and whether each argument is passed by value or by pointer — through the **code mapping** (the code-generation layer) with `setFunction(cm,"<fcn>",Arguments=...)`. This is what the code generator honors. It applies to **both** kinds of function the code mapping exposes:

- **Simulink Functions** (`"SimulinkFunction:<name>"`) — the arguments are the function's own ArgIn/ArgOut blocks (for example `u`, `y`).
- **Model step (periodic) functions** (`"Periodic:Dn"`) — the arguments are the model's **root Inport/Outport blocks**, referenced by their block names (for example `In1`, `Out1`). By default a step function passes I/O through the global data structure and has **no arguments** (`getFunction(..., "Arguments")` errors with *"periodic function is configured with no arguments"*); setting `Arguments` opts the step interface into an argument-based prototype.

Do **not** rely on the Trigger block's `FunctionPrototype` parameter for a Simulink Function: that is the model's *design* interface, and it can diverge from the generated code (verified — changing only the code mapping flips the generated declaration while the Trigger block's prototype stays put). This code-mapping route also **replaces** the legacy `RTW.ModelSpecificCPrototype`/`setArgCategory` API for step-function prototype control.

```matlab
% names come from find(cm,"Functions")
args = getFunction(cm,"SimulinkFunction:f","Arguments") % read current prototype
setFunction(cm,"SimulinkFunction:f",Arguments="y = (u)") % Simulink Function: return y by value
setFunction(cm,"Periodic:D1",Arguments="Out1 = (In1)") % step function: return root Outport by value
```

The `Arguments` string names the arguments and encodes each one's passing mechanism (`*` = by pointer, no `*` = by value; a name to the left of `=` = returned by value). The syntax is unintuitive — return-by-value vs pointer output is the case that trips people up most (examples use a Simulink Function `f(u, y)`; a step function behaves identically with root-port names):

| `Arguments` string | Meaning | Generated C |
|---|---|---|
| `y = (u)` | `y` returned by value | `double f(const double u)` |
| `(u, *y)` | `y` as pointer output (void return) | `void f(const double u, double *y)` |
| `(u, y)` | output without `*` | **STILL void + pointer** (misleading!) |

**Rules:**
- The `=` on the left of the `Arguments` string is the **ONLY** way to return an output by value; listing an output inside parentheses without `*` silently normalizes to pointer passing.
- The legal string depends on each argument's *direction*: a genuine output argument rejects a qualifier (`OUT or INOUT arguments cannot have a qualifier`); a designed input passed by pointer must be `const` (`Input argument passed by pointer must be a const pointer`). Enumerate the function's allowed properties with `introspect_api("setFunction",model)` — which lists `Arguments` for each `SimulinkFunction` and `Periodic` function — rather than guessing the string.
- `&y` syntax fails with "by reference not supported for C".

*(The Trigger block's `FunctionPrototype` parameter accepts the same string forms and is the design-side equivalent, but the code mapping is the code-interface control this skill configures — set `Arguments`, not the block parameter.)*

---

## Discovery Techniques

### Find Model Elements by Category

Use `find` on the code mapping object to enumerate model elements and their current mappings:

```matlab
cm = coder.mapping.api.get(model);
inports = find(cm,"Inports");
outports = find(cm,"Outports");
states = find(cm,"States");
dataStores = find(cm,"DataStores");
functions = find(cm,"Functions");
```

**`find(cm,category)` does not return a uniform type — capture it and feed the setter the *exact same value* `find` returned.** Most categories return a numeric **handle**; named workspace entities return a **name string**. The subtle trap: the handle is a **block handle** for ports/states/data stores but an **output-port handle** for signals — and the two are not interchangeable. Passing the wrong one errors inside `MappingUtils.getInport` / `getSignal`.

| Category | `find(cm,category)` returns | Identifier passed to the setter |
|---|---|---|
| `"Inports"` / `"Outports"` | numeric **block handle** (for example `145.0001`) | that handle → `setInport(cm,h,…)` / `setOutport(cm,h,…)` — a raw `PortHandles.Outport(1)` **fails** |
| `"Signals"` | numeric **output-port handle** of the source block (for example `282.0001`, `Type="port"`) | that handle → `setSignal(cm,h,…)`; to add a not-yet-mapped signal use `addSignal(cm,get_param(block,"PortHandles").Outport(n))` — a block handle **fails** |
| `"States"` | numeric **block handle** (for example `283.0001`) | that handle → `setState(cm,h,…)` |
| `"DataStores"` | numeric **block handle** (for example `147.0001`) | that handle → `setDataStore(cm,h,…)`; the data store **name** (`"DS"`) and block path are also accepted |
| `"ModelParameters"` | **name string** (for example `"Kp"`) | the name → `setModelParameter(cm,"Kp",…)` |
| `"Functions"` | **name string** (for example `"Initialize"`, `"Periodic:D1"`) | the name → `setFunction(cm,"Periodic:D1",…)` |

Rule of thumb: **feed the setter exactly what `find` gave you.** Ports, states, and data stores come back as *block* handles; signals come back as *output-port* handles (and are the one case where you supply a port handle from `get_param(block,"PortHandles")` when adding). Both block and port handles look alike (fractional doubles like `145.0001`) — the fraction does **not** tell them apart, so never hand-construct or swap them. Parameters and functions come back as name strings.

### Filter by Property

```matlab
find(cm,"Inports",ReceiverService="MyReceiverEntry")
find(cm,"States",MeasurementService="MyMeasurementEntry")
```

### Discover Allowed Values and Per-Instance Properties

Use `introspect_api` (in `scripts/introspect_api.m`) to discover valid options at runtime without probing:

```matlab
% What properties can be set on inports?
introspect_api("setInport",model)

% What storage classes are allowed for inports?
introspect_api("setInport",model,property="StorageClass")

% What data default categories exist?
introspect_api("setDataDefault",model)

% What storage classes are allowed for a default category?
introspect_api("setDataDefault",model,category="Inports",property="StorageClass")

% What properties does each function support?
introspect_api("setFunction",model)

% Detect Data Interface vs Service Interface mode
introspect_api("mode",model)

% Enumerate the actual elements in a category + each identifier's form
introspect_api("find",model,category="DataStores")
```

The script encapsulates internal API calls and returns JSON with allowed values, per-instance properties (which properties become available when a specific StorageClass is assigned), and current settings.

`introspect_api("find",model,category=...)` lists the elements currently in that category and reports each one's `identifierForm` — `handle` for Inports/Outports/States/Signals/DataStores, `name` for ModelParameters/Functions — matching the return-type table above. (`setDataStore` additionally accepts the store's name or block path, but `find` reports a handle.) Use it to grab the right identifier form before calling the corresponding setter.

**Scope:** `introspect_api` covers code mapping operations only — element properties, defaults, functions, and mode detection. For dictionary entry properties, use `getAvailableProperties(entry)` directly (see `coder_dictionary.md`).

---

## Common Error Messages

| Error | Actual Cause | Action |
|---|---|---|
| "Expected input number 1, DEPLOYMENTTYPE, to match one of these values: 'Automatic', 'Subcomponent'" | Model is in DataInterface mode, where `"Component"` is not a settable value | Usually no change is needed: `"Automatic"` determines the deployment type based on context, and for a top model that is a component. Only set up ServiceInterface mode (see `coder_dictionary.md`) if the user actually wants service interfaces. |
| "'Property' is not a valid property for ... mapping" | Using DataInterface property in ServiceInterface mode (or vice versa) | Check mode with `introspect_api("mode",model)` and switch to the correct property (see mode table above) |
| "linked to a shared Embedded Coder Dictionary that defines a service code interface configuration. Configuring '...' is only supported for ... data code interface" | Using `setDataDefault`/`setFunctionDefault` in ServiceInterface mode | These APIs are DataInterface only. In SI, defaults come from the dictionary entries directly. |
| "code mapping of signal '...' to code specification '...' conflicts with storage class setting for external data object associated with that signal. Change one of the specifications to 'Auto'." | Signal has a non-`Auto` storage class in **both** the code mapping and an associated `Simulink.Signal` data object | Set one specification to `'Auto'` so the storage class comes from a single source (see "Storage Class: Two Mechanisms" above). |
| "Unable to get parameter mapping for '...' because parameter mapping does not exist. Update diagram to update code mappings." | Parameter is not a `Simulink.Parameter` in the **model workspace** (plain value, or object in the base workspace), or update diagram has not been run | Make it a model-workspace `Simulink.Parameter`, then run update diagram before calling `getModelParameter`/`setModelParameter`. |

---

## Verification

After mapping configuration:

**Data Interface:**
- `getDataDefault(cm,category,property)` returns expected storage class
- After build: generated `.c`/`.h` files contain expected variable declarations
- No regressions on existing ports/states

**Service Interface:**
- `getDeploymentType(cm)` returns `"Component"`
- After build: service header file contains expected function declarations
- Function signatures match intended communication method
- Function names match token expansion expectations

---

## Related References

- **`coder_dictionary.md`** — Creating and linking ServiceInterface dictionaries, dictionary entries, communication methods
- **`simulink-configure-model-for-code-generation` skill** — ERT base configuration (must be done before service interface setup)
- **`simulink-customize-a2l` skill** — Customizing the exported A2L (ASAP2) calibration file through `coder.asap2.*`; consumes the calibration profile properties set here

----

Copyright 2026 The MathWorks, Inc.

----
