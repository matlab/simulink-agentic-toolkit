---
type: api-reference
triggers: [matlab_code, mtree, checkcode, codeIssues, parse_tree, MATLAB_Function]
tags: [api, code-analysis, mtree, AST, checkcode]
related:
  - apis/stateflow.md
  - apis/framework.md
---
# MATLAB Code Analysis API Patterns

API patterns for analyzing MATLAB code in MATLAB Function blocks and script files. Focuses on mtree usage patterns — assumes familiarity with `checkcode` and `codeIssues`.

---

## When to Use Which

| Need | Use |
|------|-----|
| Simple lint-style check on a file | `checkcode` or `codeIssues` |
| Parse code structure (AST, operators, variables) | `mtree` |
| Analyze Stateflow action expressions | Stateflow AST (see [apis/stateflow.md](stateflow.md)) |

---

## mtree — MATLAB Parse Tree

> **Warning:** `mtree` is experimental and undocumented. Its behavior may change between releases. There is no documented alternative for MATLAB code parse trees.

> **Code generation rule:** When using `mtree`, you **MUST** add this comment above the first `mtree(...)` call:
> ```matlab
> % mtree is an experimental program whose behavior and interface is likely
> % to change in the future.
> ```

### Creating a parse tree
```matlab
% From a code string (e.g., MATLAB Function block script)
mt = mtree(codeString, '-com', '-cell');

% From a file
mt = mtree(fileName, '-com', '-file');
```

### Getting MATLAB Function block code
```matlab
emlObj = rt.idToHandle(chartId);
script = emlObj.Script;
mt = mtree(script, '-com', '-cell');
```

### Finding nodes by kind
```matlab
eqNodes = mt.mtfind('Kind', 'EQ');           % == comparisons
callNodes = mt.mtfind('Kind', 'CALL');       % function calls
idNodes = mt.mtfind('Kind', 'ID');           % identifiers

% Multiple kinds
comparisonNodes = mt.mtfind('Kind', {'EQ', 'NE', 'LT', 'GT', 'LE', 'GE'});
```

### Finding by function name
```matlab
bitOps = mt.mtfind('Fun', {'bitsll', 'bitsrl', 'bitsra'});
```

### Navigating and reading nodes
```matlab
node.Left / node.Right   % operands
node.Arg                 % argument of unary op
node.Fname               % function name from CALL node
node.kind                % kind string: 'ID', 'EQ', 'CALL', etc.
node.string              % string value
node.tree2str            % subtree back to code string
node.lefttreepos         % start char position
node.righttreepos        % end char position
```

### Iterating over found nodes
```matlab
nodes = mt.mtfind('Kind', 'EQ');
idx = indices(nodes);
for i = 1:numel(idx)
    n = mt.select(idx(i));
    leftStr = n.Left.string;
    rightStr = n.Right.string;
end
```

### Common Kind values
| Kind | Meaning |
|------|---------|
| `'ID'` | Identifier |
| `'INT'` / `'DOUBLE'` | Numeric literal |
| `'EQUALS'` | Assignment |
| `'CALL'` | Function call |
| `'IF'` / `'FOR'` / `'WHILE'` | Control flow |
| `'EQ'` / `'NE'` / `'LT'` / `'GT'` / `'LE'` / `'GE'` | Comparisons |
| `'PLUS'` / `'MINUS'` / `'MUL'` / `'DIV'` | Arithmetic |
| `'NOT'` / `'AND'` / `'OR'` | Logical |

---

## Reporting Code Violations

Use `'FileName'` setData type to highlight code spans:
```matlab
rd = ModelAdvisor.ResultDetail;
ModelAdvisor.ResultDetail.setData(rd, 'FileName', filePath, ...
    'Expression', node.tree2str, ...
    'TextStart', node.lefttreepos, 'TextEnd', node.righttreepos);
rd.Description = 'Prohibited operator found';
```

----

Copyright 2026 The MathWorks, Inc.

----
