# Coder Dictionary Reference (`coder.dictionary.*`)

## Purpose

Create, link, and populate Embedded Coder Dictionaries that define reusable code generation artifacts — storage classes, memory sections, and (for Service Interface) service interface entries. A dictionary can be either DataInterface or ServiceInterface.

**Relationship to code mapping:** Code mapping (`coder.mapping.*`) assigns dictionary entries to model elements. This reference covers creating those entries.

---

## The Bridge Parameter: `EmbeddedCoderDictionary`

The `EmbeddedCoderDictionary` configset parameter links a model to an Embedded Coder Dictionary (either DataInterface or ServiceInterface). No error message or API will ever point you to this parameter — you must know it exists.

It lives on the config set of the model, so read and write it with the model tools — **not** `set_param`/`get_param`.

**Write** — `model_edit` with `scope: 'root'` and a `configure` op on `config:<ModelName>`:

```json
{"op": "configure", "target": "config:MyModel",
 "params": {"EmbeddedCoderDictionary": "MyDictionary.sldd"}}
```

**Read** — `model_query_params` with `targets: ["config:MyModel"]` and `params: ["EmbeddedCoderDictionary"]`.

These two calls are referred to below as *link through `model_edit`* and *read through `model_query_params`*.

**Critical distinctions:**
- `DataDictionary` links the data dictionary (for parameters, signals, types)
- `EmbeddedCoderDictionary` links the coder dictionary (for storage classes, memory sections, and service interfaces)
- These are separate parameters — setting one does NOT set the other
- The mode (DataInterface vs ServiceInterface) is determined by the dictionary content, not by the parameter itself

---

## Workflow (Order Matters)

### Data Interface Dictionary

1. **Create a DataInterface dictionary** — `coder.dictionary.create(sldd,"DataInterface")`
2. **Link it to the model** — set `EmbeddedCoderDictionary` to `'dict.sldd'`, link through `model_edit`
3. **Define storage classes and memory sections** in the dictionary
4. **Assign entries** through code mapping (`setDataDefault`, `setInport`, etc. with `StorageClass` / `MemorySection`)

### Service Interface Dictionary

These steps must happen in sequence. Skipping or reordering causes silent failures:

1. **Create a ServiceInterface dictionary** — `coder.dictionary.create(sldd,"ServiceInterface")`
2. **Link it to the model** — set `EmbeddedCoderDictionary` to `'dict.sldd'`, link through `model_edit`
3. **Set deployment type** — `setDeploymentType(cm,"Component")` (options expand only after step 2)
4. **Configure interfaces** using dictionary entries

---

## Creating a Dictionary

```matlab
% Create or open an SLDD
sldd = Simulink.data.dictionary.open('MyDictionary.sldd');

% Create a DataInterface dictionary
coder.dictionary.create(sldd, 'DataInterface');

% OR create a ServiceInterface dictionary
coder.dictionary.create(sldd, 'ServiceInterface');
```

A **Service Interface** dictionary must reside in a **shared .sldd file** — it cannot be embedded in the model (`coder.dictionary.create(model,"ServiceInterface")` errors: *"Set up a service code interface configuration in a shared Embedded Coder Dictionary (.sldd file)."*). A **Data Interface** dictionary, by contrast, may be **model-embedded** — its `StorageClasses`, `MemorySections`, and `FunctionCustomizationTemplates` sections all work without any external `.sldd` (verified: an embedded template + function memory section generated `#pragma section(...)` around the step function). Use a shared `.sldd` for DI only when you want to reuse the definitions across models. A single SLDD contains one type of dictionary (DI or SI), not both.

---

## Opening and Navigating the Dictionary

Read the linked SLDD path through `model_query_params`, then open that path by value — `coder.dictionary.open` takes the `.sldd` name, so there is nothing to nest:

```matlab
% Open dictionary from the linked SLDD (correct for SI models).
% 'MyDictionary.sldd' is the EmbeddedCoderDictionary value returned by model_query_params.
dict = coder.dictionary.open("MyDictionary.sldd");

% Get a section
section = getSection(dict,"StorageClasses");
```

**Two caveats with `coder.dictionary.open(model)`:**
1. **Errors on a model with no dictionary yet.** On a fresh model that has neither a code mapping nor a linked `EmbeddedCoderDictionary`, the call throws *"Embedded Coder Dictionary does not exist in '<model>'."* — it does not return an empty/default dictionary (verified R2026b, both GRT and ERT targets). Creating a code mapping (`coder.mapping.utils.create`) or linking an SLDD makes it succeed. To detect mode safely on an unknown model, use `introspect_api("mode",model)` instead — it returns `mode: "unknown"` (with a note) rather than erroring.
2. **Always DataInterface even when an SI dictionary is linked.** When it does succeed, it opens the *model-embedded* dictionary, which reports `DataInterface` regardless of the linked SLDD. To read the real mode, open through the SLDD path — read `EmbeddedCoderDictionary` through `model_query_params`, then `coder.dictionary.open("<that path>")`. `introspect_api("mode",model)` does both steps for you and is the preferred route.

### Verifying Dictionary Mode

Prefer `introspect_api("mode",model)` — it handles the unknown-model case that `coder.dictionary.open` errors on. To check the dictionary file directly, read `EmbeddedCoderDictionary` through `model_query_params` and open that path:

```matlab
dict = coder.dictionary.open("MyDictionary.sldd");   % path from model_query_params
getCodeInterfaceType(dict)  % Returns "DataInterface" or "ServiceInterface"
```

---

## Dictionary Sections

Discover available sections at runtime:

```matlab
dict = coder.dictionary.open("MyDictionary.sldd");  % SLDD path from model_query_params — see caveats above
sections = getSections(dict);  % Returns Section array with Name property
```

Sections differ by mode — DataInterface and ServiceInterface dictionaries have different sections. Use `getSections` to enumerate rather than hardcoding names.

**Enumerate on the coder dictionary object, not the data dictionary.** The section-enumeration method is `getSections(dict)` where `dict` came from `coder.dictionary.open(...)`. There is **no `getSectionNames` method** — and calling one on a `Simulink.data.Dictionary` (the object from `Simulink.data.dictionary.open`) errors with *"Unrecognized method, property, or field 'getSectionNames' for class 'Simulink.data.Dictionary'."* Open the coder dictionary with `coder.dictionary.open`, then call `getSections`; read each section's `Name` property for the list.

---

## Guardrail: Never Manufacture Entries

**STOP. Do NOT proceed with `addEntry` or `set(entry, ...)` calls until the user has provided the actual values.**

This is a hard constraint — not a suggestion. If the user has not explicitly provided the pragma text, entry name, communication method, or storage class name, you MUST ask before writing any code. Do not invent placeholder values, do not provide "example" values that the user might copy, do not say "adapt this to your target."

**Why this is a hard stop:**
- **Memory sections:** `PreStatement`/`PostStatement` pragma syntax is compiler-specific (`#pragma section` for GHS, `__attribute__((section(...)))` for GCC, `#pragma location` for IAR). A wrong pragma silently compiles but places code/data in the wrong memory region — a runtime failure that is extremely hard to debug.
- **Receiver/Sender interfaces:** `DuringExecution` vs `OutsideExecution` determines thread-safety guarantees. Guessing wrong causes data races in production.
- **Storage classes:** these encode project-level naming and placement conventions. Inventing one breaks the memory map of the build system.

**Required sequence:**
1. STOP and ask: "What are the exact pragma statements for your target compiler? (PreStatement and PostStatement)"
2. Wait for the user to respond with actual values
3. Only then write the `addEntry` + `set(...)` calls using their exact text

**If the user says "just use something"** — provide a template with `<PLACEHOLDER>` tokens that won't compile, forcing them to fill in real values:
```matlab
set(entry,PreStatement="<YOUR_PRAGMA_HERE>");
set(entry,PostStatement="<YOUR_PRAGMA_END_HERE>");
```

This applies to ALL `addEntry` calls — memory sections, interfaces, and storage classes.

---

## Working with Dictionary Entries

### Finding Entries

```matlab
section = getSection(dict,"StorageClasses");
entries = find(section);  % Returns Entry array with Name property
```

### Adding Entries

```matlab
section = getSection(dict,"StorageClasses");
addEntry(section,"MyEntry");
```

### Setting Entry Properties

**Do NOT use dot-notation:** `entry.Property = value` will fail silently or error.

**Use the `set()` method:**

```matlab
entry = find(section,Name="MyEntry");
set(entry,PropertyName=value);
```

### Discovering Available Properties

**Do NOT trust `properties(entry)`** — it returns an incomplete list.

**Use `getAvailableProperties(entry)`** — returns the actual complete list of settable properties.

```matlab
entry = getEntry(section,"MyEntry");
props = getAvailableProperties(entry);
```

---

## Communication Methods (Service Interface Only)

The `DataCommunicationMethod` property on service interface entries controls how data flows at runtime:

| Method | Generated C Pattern | Meaning |
|---|---|---|
| `DuringExecution` | `void func(type *ptr)` | Caller provides buffer; callee writes to it |
| `OutsideExecution` | `type func(void)` | Callee returns value; caller consumes it |
| `DirectAccess` | `extern type var;` | No function call — direct variable access through assigned StorageClass |

### Entry Properties by Section

Properties differ by section and communication method. Use `getAvailableProperties(entry)` to discover at runtime.

| Section | Communication Methods | Function Naming Property |
|---|---|---|
| `DataReceiverInterfaces` | `OutsideExecution`, `DuringExecution`, `DirectAccess` | `FunctionName` (e.g., `get_$X$N`) |
| `DataSenderInterfaces` | `OutsideExecution`, `DuringExecution`, `DirectAccess` | `FunctionNamingRuleForValue` + `FunctionNamingRuleForValueReference` (OutsideExecution only) |
| `MeasurementInterfaces` | N/A | N/A — uses `StorageClass` only |
| `ParameterTuningInterfaces` | N/A | N/A — uses `StorageClass` only |

`DirectAccess` entries in receiver/sender sections use `StorageClass` instead of function naming properties.

### Validating in Generated Code

After building, inspect the generated service header file:
- `void func(type *ptr)` = DuringExecution
- `type func(void)` = OutsideExecution
- No entry in service header, variable in model header = DirectAccess

---

## Naming Tokens

Dictionary entries use naming tokens that expand during code generation:

| Token | Meaning | Restriction | Example |
|---|---|---|---|
| `$N` | Name of associated element (port name, block name, parameter name, function name) | | `get_$N` → `get_speed` |
| `$X` | Model name + function context qualifier (prevents collisions across models) | Service interface dictionary entries only | `get_$X$N` → `get_MyModel_step_speed` |
| `$R` | Root model name (unsupported chars replaced with `_`) | | `$R$N` → `MyModel_init` |
| `$M` | Name-mangling text to avoid naming collisions | Inserted automatically when needed | |
| `$U` | User-specified custom token text (from `Custom token text` config param) | | |
| `$C` | Conditional checksum for uniqueness | Shared utility function naming only (`CustomSymbolStrUtil`) — not valid in other identifier formats or dictionary entry names | |

---

## Memory Sections

Memory sections control pragma-wrapped placement of functions and data in generated code. They are dictionary entries in the `MemorySections` section.

### Configuring a Memory Section

```matlab
section = getSection(dict,"MemorySections");  % DI: "MemorySections", SI: "FunctionMemorySections" or "DataMemorySections"
entry = find(section,"Name","MyMemorySection");
set(entry,Comment="/* Fast RAM placement */");
set(entry,PreStatement='#pragma section ".fast_ram"');
set(entry,PostStatement="#pragma section");
```

### Key Properties

| Property | Purpose | Example |
|---|---|---|
| `Comment` | Comment above the pragma block | `'/* Fast RAM placement */'` |
| `PreStatement` | Pragma before the function/data | `'#pragma section ".fast_ram"'` |
| `PostStatement` | Pragma after the function/data | `'#pragma section'` |

### Important Notes

- `PreStatement` and `PostStatement` are **not discoverable through `properties(entry)`** — use `getAvailableProperties(entry)` or `set()` directly
- Dot-notation (`entry.PreStatement = ...`) will fail with "Unrecognized property" — always use `set(entry,PreStatement=value)`
- **STOP:** Do not fill in PreStatement/PostStatement values yourself. Ask the user: "What are the exact pragma statements for your target compiler?" Different compilers use entirely different syntax — there is no safe default.

---

## Example Entries (Built-in)

When a dictionary is created, some sections are populated with built-in example entries. Inspect existing entries before creating new ones:

```matlab
section = getSection(dict, sectionName);
entries = find(section);
% Inspect the properties of an entry
entry = entries(1);
props = getAvailableProperties(entry);
```

---

## Silent Failures

These succeed without error but produce wrong results:

| Operation | What Goes Wrong | How to Detect |
|---|---|---|
| `set_param(model,DataDictionary=...)` when expecting SI | Links data dictionary but does NOT activate service interface | `introspect_api("mode",model)` reports the model resolves to `DataInterface` (query the **model's resolved mode**, not the dictionary file's type — the `.sldd` can be a ServiceInterface dictionary while the model still resolves to DataInterface because it is not linked through `EmbeddedCoderDictionary`) |
| `slbuild` with deployment type `"Automatic"` in SI mode | Builds but generates no service calls | No service header file in generated code |
| `coder.mapping.utils.create(model,"ServiceInterface")` | Its second argument is a **config set object**, not a mode selector — accepted and ignored. Mode comes from the linked dictionary. `coder.dictionary.create` is the function that takes `"DataInterface"`/`"ServiceInterface"`. | `introspect_api("mode",model)` reports `DataInterface`. Link the SI `.sldd` through `EmbeddedCoderDictionary` **before** creating mappings. |

---

## Build Reason Logs

`slbuild` prints build reasons that confirm your changes were detected. If the build reason does NOT mention your dictionary/configuration change, the change may not have propagated.

---

## Common Error Messages

| Error | Actual Cause | Action |
|---|---|---|
| "Unrecognized property 'X'" on dictionary entry | Dot-notation blocked | Use `set(entry,X=value)` |
| "Set up a service code interface configuration in a shared Embedded Coder Dictionary (.sldd file)" | Tried to create a **ServiceInterface** dictionary embedded in the model — SI requires an external `.sldd` | Create the SI dictionary in a shared `.sldd` (`coder.dictionary.create(sldd,"ServiceInterface")`) and link it. *(DataInterface dictionaries — including function customization templates and memory sections — do NOT need an external `.sldd`; they work model-embedded.)* |
| "Expected input number 1, DEPLOYMENTTYPE, to match one of these values: 'Automatic', 'Subcomponent'" | Model is in DataInterface mode — `"Component"` is exclusive to ServiceInterface | Set up ServiceInterface mode if `"Component"` needed, or use `"Automatic"` in DI |

---

## Verification

After dictionary setup:
- [ ] `introspect_api("mode",model)` reports the resolved mode of the model — or, to read the linked SLDD directly, read `EmbeddedCoderDictionary` through `model_query_params` and call `getCodeInterfaceType(coder.dictionary.open("<that path>"))` (open through the SLDD path, **not** `coder.dictionary.open(model)`, which always reports `DataInterface` — see caveats above)
- [ ] `getSections(dict)` shows expected sections
- [ ] Entry properties set through `set()` — not dot-notation
- [ ] Build reason logs confirm dictionary changes were detected

---

## Related References

- **`code_mapping.md`** — Assigning dictionary entries to model elements (ports, states, functions)
- **`simulink-configure-model-for-code-generation` skill** — ERT base configuration (must be done before service interface setup)

----

Copyright 2026 The MathWorks, Inc.

----
