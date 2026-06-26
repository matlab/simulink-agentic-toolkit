# Stateflow API Patterns

Non-obvious patterns and gotchas for Stateflow in Model Advisor checks. Assumes familiarity with `sfroot`, chart access, and basic `.find()` queries.

---

## Private Conversion APIs

Use only when find-by-path is insufficient:
```matlab
rt = sfroot;
chartId = sfprivate('block2chart', blockHandle);
chart = rt.idToHandle(chartId);
blockHandle = sfprivate('chart2block', chartId);
```

---

## Finding Stateflow Objects

```matlab
% Find within a specific chart
states = chart.find('-isa', 'Stateflow.State');
transitions = chart.find('-isa', 'Stateflow.Transition');
junctions = chart.find('-isa', 'Stateflow.Junction');

% Find data by scope
inputData = chart.find('-isa', 'Stateflow.Data', 'Scope', 'Input');

% Combine filters
objs = chart.find('-isa', 'Stateflow.State', '-or', '-isa', 'Stateflow.Transition');
```

### Stateflow element types
| Type | Class |
|------|-------|
| Chart | `Stateflow.Chart` |
| State Transition Table | `Stateflow.StateTransitionTableChart` |
| Truth Table | `Stateflow.TruthTable` / `Stateflow.TruthTableChart` |
| MATLAB Function (EML) | `Stateflow.EMChart` |
| State | `Stateflow.State` |
| Transition | `Stateflow.Transition` |
| Junction | `Stateflow.Junction` |
| Data | `Stateflow.Data` |
| Graphical Function | `Stateflow.Function` |

---

## Key Gotchas

### Default transition detection
**Check with `isempty(Source)`, NOT a `.IsDefaultTransition` property:**
```matlab
if isempty(transition.Source)
    % This is a default transition
end
```

### Junction.Position returns an object, NOT [x y]
```matlab
jPos = junction.Position;
center = jPos.Center;     % [x y]
radius = jPos.Radius;     % scalar
```

### Data properties use Props struct
**Use `data.Props.InitialValue`, NOT `data.InitialValue`:**
```matlab
data.Props.InitialValue
data.Props.Range.Minimum
data.Props.Range.Maximum
```

### Navigation methods are lowercase
```matlab
state.innerTransitions      % NOT InnerTransitions
state.outerTransitions
state.sinkedTransitions
state.sourcedTransitions
junction.sourcedTransitions
junction.sinkedTransitions
```

---

## MATLAB Function Block Script Access

```matlab
emlObj = rt.idToHandle(chartId);
script = emlObj.Script;
```

---

## AST (Abstract Syntax Tree) Analysis

For analyzing Stateflow action language expressions:

```matlab
container = Stateflow.Ast.getContainer(sfObj);
sections = container.sections;
for i = 1:numel(sections)
    roots = sections(i).roots;
    % Process root AST nodes
end
```

### AST node properties
```matlab
node.sourceSnippet     % code text
node.children          % child nodes
node.lhs / node.rhs   % left/right-hand side
node.treeStart / node.treeEnd  % character positions
node.value             % numeric value (literals)
```

### AST node type checking
Use `isa(node, 'Stateflow.Ast.TypeName')`:

| Category | Types |
|----------|-------|
| Literals | `IntegerNum`, `FloatNum` |
| Identifiers | `Identifier`, `QualifiedId`, `StructMember` |
| Arithmetic | `Plus`, `Minus`, `Times`, `Divide`, `Modulus`, `Pow` |
| Comparison | `IsEqual`, `IsNotEqual` |
| Logical | `LogicalAnd`, `LogicalOr` |
| Functions | `UserFunction`, `CastFunction` |
| Assignments | `EqualAssignment`, `ExplicitTypeCast` |

---

## Reporting Stateflow Violations

Stateflow objects have SIDs — use `'SID'` type:
```matlab
sid = Simulink.ID.getSID(sfObj);

rd = ModelAdvisor.ResultDetail;
ModelAdvisor.ResultDetail.setData(rd, 'SID', sid);
rd.Description = 'State has invalid decomposition';
rd.Status = 'Violation found';
rd.RecAction = 'Change decomposition to EXCLUSIVE_OR';
```
