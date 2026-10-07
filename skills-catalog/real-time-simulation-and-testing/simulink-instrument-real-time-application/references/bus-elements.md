# Bus Elements and Virtual Bus Checks

Use this reference only when the user wants to capture a **leaf element** inside a bus with `BusElement`, a Bus Selector path, or wording like "log this element of the bus." Do not use it to block whole-bus streaming; a virtual bus can still be instrumented and streamed as a whole signal.

## Rule for `BusElement`

`BusElement` only resolves on **non-virtual** buses. A virtual bus is a Simulink signal-routing construct with no contiguous storage for individual leaves in the generated application, so `validate(inst, mldatx)` reports the leaf as unresolved.

Note two traps when a leaf does not resolve. `validate` **warns**; it does not throw, so a
`try`/`catch` will not catch it. And `generateScript` still emits the unresolvable `addSignal`
line, so a generated script is not evidence the signal resolves. Read the warning, or check the
signal after `validate`.

Two user-facing options:

1. Convert the bus to non-virtual at the source (for example, set the Bus Creator block to output a nonvirtual bus, or define a `Simulink.Bus` object and set the signal data type to that bus). This is a model edit and requires a rebuild, so ask first.
2. Instrument the upstream leaf signal directly by block path + outport index before it enters the Bus Creator. This avoids bus traversal and is usually the lighter touch for one or two leaves.

Option 1 is appropriate when many leaves of the same bus are needed and the user owns the bus structure. Option 2 is appropriate when the user only needs a small number of leaves and can tolerate logging the upstream signal source.

## Array of Buses

A signal can be an **array of buses** — an array where each element is a bus (represented as a structure in generated code). When using `BusElement` on an array-of-buses signal, the `BusElement` value must be prefixed with `(x).`, where `x` is the 1-based array index:

```matlab
% For a scalar bus signal:
addSignal(inst, "sig_bus", "BusElement", "signal1.signal2");

% For an array-of-buses signal (selecting element 2):
addSignal(inst, "sig_aob", "BusElement", "(2).signal1.signal2");
```

### When the user specifies the array element up front

If the user states which array element they want (e.g., "the 2nd element"), format `BusElement` as `"(N).leafPath"` directly:

```matlab
addSignal(inst, "sig_aob", "BusElement", "(2).signal1.signal2");
```

### When the user does not specify the array element

Use the bus element path without the prefix (e.g., `"signal1.signal2"`). If the signal is an array of buses, `addSignal` throws one of two warnings:

| Warning ID                  | Meaning                                                        | Action                                                                                  |
|-----------------------------|----------------------------------------------------------------|-----------------------------------------------------------------------------------------|
| `BusElementRequiresDims`    | The signal is an array of buses and a dimension prefix is required | Remove the signal from the instrument, ask the user which array element to capture, then re-add with `"(N).leafPath"` format |
| `BusElementInvalidDims`     | The user-supplied dimension prefix is invalid (out of range, wrong syntax) | Remove the signal from the instrument, surface the error (including the valid range from the warning message), ask the user for a correct index, then re-add with the corrected prefix |

**Important:** `addSignal` adds the signal to the instrument even when a warning is thrown, but the signal will not resolve at runtime. Always remove the invalid signal before prompting the user, and only re-add once a valid index is obtained.

Handle these warnings reactively:

```matlab
lastwarn('');
addSignal(inst, "sig_aob", "BusElement", "signal1.signal2");
[warnMsg, warnId] = lastwarn;
if ~isempty(warnMsg)
    % Signal was added but won't resolve — remove only the invalid entry
    % IMPORTANT: use the same BusElement value to target the specific entry;
    % removeSignal(inst, "sig_aob") alone removes ALL entries for that signal name
    removeSignal(inst, "sig_aob", "BusElement", "signal1.signal2");
    % Ask user which element to capture (surface warnMsg for context)
    % Then re-add with valid index:
    % addSignal(inst, "sig_aob", "BusElement", "(N).signal1.signal2");
end
```

**Important:** When removing an invalid bus element entry, always pass the same `BusElement` value to `removeSignal` that was used in the failed `addSignal`. Using just the signal name (`removeSignal(inst, "sig_aob")`) removes **all** entries for that signal, including previously added valid entries.

### Wording for users (array of buses — dimensions required)

> *"This signal is an array of buses. `BusElement` requires a dimension prefix of the form `(N).` before the leaf path. Which array element do you want to capture? I'll format it as `(N).signal1.signal2`."*

### Wording for users (array of buses — invalid dimensions)

> *"The array index (N) exceeds the dimensions of this signal (the warning says it has M elements). Which element (1 through M) would you like to capture?"*

## Check Bus Virtuality

`CompiledBusType` is a compile-time property and reads empty on an uncompiled model. Read it with
`model_query_params` and `compile=true`, which handles the compile and terminate for you — target
the bus **signal**, not the block:

```json
{"targets": ["blk_3.y1 -> blk_4.u1"],
 "params":  ["CompiledBusType"],
 "compile": true}
```

The value is `VIRTUAL_BUS` or `NON_VIRTUAL_BUS`.

If `CompiledBusType` is `VIRTUAL_BUS`, do not add the leaf with `BusElement`. Ask the user whether to convert the source bus to non-virtual and rebuild, or instrument the upstream leaf signal directly.

### Converting to non-virtual takes two changes, not one

Setting `NonVirtualBus: "on"` on the Bus Creator is **not sufficient** — a non-virtual bus also
needs an explicit `Simulink.Bus` object as the output data type. Leaving `OutDataTypeStr` at
`Inherit: auto` is not a silent no-op: the model does not compile in that state, so the failure
surfaces at build time rather than as a mysteriously still-virtual bus. Set both parameters in one
edit:

```json
[{"op": "configure", "target": "blk_3",
  "params": {"NonVirtualBus": "on", "OutDataTypeStr": "Bus: MyBus"}}]
```

The bus object must exist and its element names must match the incoming signal names,
or the compile emits an element-name-mismatch warning per element. This is why the
Ask-First gate exists: "convert the bus to non-virtual" means authoring a bus object
and renaming signals to match, not flipping one flag.

## Wording for Users

Use language like:

> `BusElement` capture requires a non-virtual bus. I can stream the whole bus if that is what you want, but for one leaf I need either a non-virtual bus or the upstream leaf signal. Do you want me to check the compiled bus type first?

----

Copyright 2026 The MathWorks, Inc.

----
