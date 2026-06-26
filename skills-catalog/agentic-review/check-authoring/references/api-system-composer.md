# System Composer API Patterns

API patterns for querying and modifying System Composer architecture elements in check logic. Focuses on inspection (for violations) and deterministic modification (for auto-fix).

---

## Accessing the Architecture Model

```matlab
% In a Model Advisor callback, 'system' is the model name
scModel = systemcomposer.loadModel(system);
arch = scModel.Architecture;
```

### Detecting a System Composer model
```matlab
try
    scModel = systemcomposer.loadModel(system);
    isArchModel = true;
catch
    isArchModel = false;
end
```

> **Context:** Architecture models do not compile. Always use `'None'` callback context (never `'PostCompile'`).

---

## Components

### Finding components
```matlab
% All top-level components
comps = arch.Components;

% Hierarchical iteration (visits all nested components)
iterate(arch, 'PreOrder', @(comp, ~) myCheckFcn(comp));

% Iteration types: 'PreOrder', 'PostOrder', 'TopDown', 'BottomUp'
% Include ports in iteration:
iterate(arch, 'PreOrder', @(elem, ~) myFcn(elem), 'IncludePorts', true);

% Lookup by path (equivalent to find_system result)
comp = lookup(scModel, 'Path', 'modelName/ComponentName');

% Query helper — all components in model
comps = systemcomposer.query.findElementsOfType(scModel, 'Component');
```

### Component properties (for checks)
```matlab
comp.Name                    % component name
comp.Ports                   % array of ComponentPort
comp.OwnedArchitecture       % architecture inside this component
comp.SimulinkHandle          % numeric handle for SID
comp.UUID                    % unique identifier
comp.IsAdapterComponent      % true if adapter
isReference(comp)            % true if references another model
getQualifiedName(comp)       % full path: 'model/comp/subcomp'
```

### Modifying components (for auto-fix)
```matlab
set_param(comp.SimulinkHandle, 'Name', 'NewName');
```

### Cross-reference with find_system
```matlab
% Components appear as SubSystem blocks in find_system
blks = find_system(system, 'SearchDepth', 1, 'Type', 'block');
% Convert to SC object:
scComp = lookup(scModel, 'Path', blks{i});
```

---

## Ports

### Querying ports
```matlab
ports = comp.Ports;                     % all ports on a component
port = comp.getPort('portName');        % specific port by name

port.Name                               % port name
port.Direction                          % 'Input', 'Output', or 'Physical'
port.InterfaceName                      % assigned interface name ('' if none)
port.Connected                          % true/false
port.Parent                             % parent component

% All ports in model
allPorts = systemcomposer.query.findElementsOfType(scModel, 'Port');
```

### Modifying ports (for auto-fix)
```matlab
setInterface(port, ifaceObj);           % assign interface to port
port.setName('newPortName');            % rename port
```

---

## Connectors

### Querying connectors
```matlab
conns = arch.Connectors;               % all connectors at this architecture level

conn.Name                               % connector name
conn.SourcePort                         % source ComponentPort
conn.DestinationPort                    % destination ComponentPort
conn.SourcePort.Parent                  % source component
conn.DestinationPort.Parent             % destination component

% All connectors in model
allConns = systemcomposer.query.findElementsOfType(scModel, 'Connector');
```

> **Gotcha:** Ports and connectors have `SimulinkHandle` but `Simulink.ID.getSID()` returns empty for them. Report the parent component SID for violations involving ports/connectors.

---

## Interfaces

### Querying interfaces
```matlab
dict = scModel.InterfaceDictionary;
names = getInterfaceNames(dict);        % cell array of interface names
iface = getInterface(dict, 'InterfaceName');

% Interface elements
elem = getElement(iface, 'elementName');
elem.Name                               % element name
elem.Type.DataType                      % e.g. 'double', 'single', 'uint8'
elem.Type.Dimensions                    % e.g. '1', '[3 1]'
elem.Type.Units                         % e.g. 'degC', 'm/s'
elem.Description                        % description string
```

### Modifying interface elements (for auto-fix)
```matlab
elem.Type.DataType = 'single';          % change data type
elem.Type.Dimensions = '1';             % change dimensions
elem.Type.Units = 'degC';              % change units
setDescription(elem, 'New description');% set description (read-only property, use method)
```

---

## Stereotypes and Properties

### Querying stereotypes on elements
```matlab
% Check if element has a stereotype
tf = hasStereotype(comp, 'ProfileName.StereotypeName');

% List all stereotypes on element
stereoNames = getStereotypes(comp);     % cell array of 'Profile.Stereotype' strings

% Get property value (returns expression string)
val = getProperty(comp, 'ProfileName.StereotypeName.PropertyName');

% Get evaluated property value (returns typed value)
evalVal = getEvaluatedPropertyValue(comp, 'ProfileName.StereotypeName.PropertyName');

% Works on components, ports, and connectors
tf = hasStereotype(port, 'ProfileName.StereotypeName');
val = getProperty(conn, 'ProfileName.StereotypeName.PropertyName');
```

### Finding elements by stereotype
```matlab
% Get profile and stereotype objects first
profile = systemcomposer.profile.Profile.find('ProfileName');
st = getStereotype(profile, 'StereotypeName');

% Find all components with a specific stereotype
comps = systemcomposer.query.findElementsWithStereotype(scModel, 'Component', st);
% ElementType options: 'Component', 'Port', 'Connector'
```

### Modifying stereotype properties (for auto-fix)
```matlab
% String values require inner double-quotes
setProperty(comp, 'ProfileName.StereotypeName.PropertyName', '"newValue"');

% Numeric values as plain strings
setProperty(comp, 'ProfileName.StereotypeName.Level', '3');

% Apply/remove stereotypes
applyStereotype(comp, 'ProfileName.StereotypeName');
removeStereotype(comp, 'ProfileName.StereotypeName');
```

---

## Reporting Violations

### Component violations (use SID)
```matlab
sid = Simulink.ID.getSID(comp.SimulinkHandle);

rd = ModelAdvisor.ResultDetail;
ModelAdvisor.ResultDetail.setData(rd, 'SID', sid);
rd.Description = 'Component missing required stereotype';
rd.Status = 'Violation found';
rd.RecAction = 'Apply the required stereotype to this component';
```

### Port/Connector violations (report parent component)
```matlab
% Ports and connectors lack valid SIDs — report the owning component
parentComp = port.Parent;  % or conn.SourcePort.Parent
sid = Simulink.ID.getSID(parentComp.SimulinkHandle);

rd = ModelAdvisor.ResultDetail;
ModelAdvisor.ResultDetail.setData(rd, 'SID', sid);
rd.Description = sprintf('Port "%s" has no interface assigned', port.Name);
rd.Status = 'Missing interface';
rd.RecAction = 'Assign an interface to this port';
```

---

## Key Gotchas

| Gotcha | Detail |
|--------|--------|
| `addPort` is on Architecture, not Component | Use `addPort(comp.OwnedArchitecture, name, dir)` |
| Port direction strings differ from `addPort` arg | `addPort` uses `'in'`/`'out'`/`'physical'`; property returns `'Input'`/`'Output'`/`'Physical'` |
| `elem.Type` is read-only | Modify via `elem.Type.DataType = ...` or use `setDescription(elem, ...)` |
| String stereotype properties need inner quotes | `setProperty(comp, qn, '"value"')` not `'value'` |
| `iterate` type is traversal order, not element type | Use `'PreOrder'` not `'Component'` |
| `connect` returns empty if ports already connected | Check `port.Connected` before connecting |
| No `'PostCompile'` for architecture models | Always use `'None'` callback context |
| `getSID` returns empty for ports/connectors | Report parent component SID instead |
| `arch.Connectors` only returns connectors at that level | Iterate recursively for nested architectures |
