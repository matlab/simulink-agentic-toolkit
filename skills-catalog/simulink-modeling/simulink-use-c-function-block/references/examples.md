# C Function Block Examples

Additional examples for C Function block configuration patterns.

## Example: Block-Level Custom Code (Preferred)

Uses block-level settings (default `CustomCodeSettingLocation` = `"BlockSettings"`). Each block carries its own headers/sources — preferred unless multiple blocks share the same code.

```
# 1. Configure model solver and add block with block-level custom code
model_edit(model: "mMyTest.slx", scope: "root", operations: [{"op": "configure", "target": "config:mMyTest", "params": {"SimTargetLang": "C++", "Solver": "FixedStepDiscrete"}}, {"op": "add_block", "type": "C Function", "ref": "cfunc", "params": {"SimCustomHeaderFile": "myFunctions.h", "SimCustomSourceFile": "myFunctions.cpp", "SimCustomSearchDirectory": "./src", "OutputCode": "y = myFunc(u1);"}}], layout_mode: "full")

# 2. Query SymbolSpec via model_query_params, then configure via evaluate_matlab_code
model_query_params(model: "mMyTest.slx", targets: ["C Function"], params: ["SymbolSpec"])

evaluate_matlab_code:
  obj = get_param('mMyTest/C Function', 'SymbolSpec');
  obj.addSymbol('u1');
  obj.addSymbol('y');
  yobj = obj.getSymbol('y');
  yobj.Scope = 'Output';
  save_system('mMyTest');
  close_system('mMyTest', 0);
```

## Example: C++ Class with Constructor Args

Integrates a C++ class (`Adder`) using Persistent scope with `Class: ClassName` type and a Parameter for the constructor argument.

```
# 1. Configure model and add block
model_edit(model: "mClassTest.slx", scope: "root", operations: [{"op": "configure", "target": "config:mClassTest", "params": {"SimTargetLang": "C++", "Solver": "FixedStepDiscrete", "SimCustomHeaderCode": "#include \"Adder.h\"", "SimUserSources": "Adder.cpp"}}, {"op": "add_block", "type": "C Function", "ref": "cfunc", "params": {"CustomCodeSettingLocation": "ModelConfigurationParameters", "OutputCode": "y = adderObj.add(u);"}}], layout_mode: "full")

# 2. Query SymbolSpec via model_query_params, then configure via evaluate_matlab_code
model_query_params(model: "mClassTest.slx", targets: ["C Function"], params: ["SymbolSpec"])

evaluate_matlab_code:
  obj = get_param('mClassTest/C Function', 'SymbolSpec');

  % Parameter for constructor arg
  obj.addSymbol('p');
  pObj = obj.getSymbol('p');
  pObj.Scope = 'Parameter';

  % Class instance — constructor arg specified in Name
  obj.addSymbol('adderObj(p)');
  classObj = obj.getSymbol('adderObj(p)');
  classObj.Scope = 'Persistent';
  classObj.Type = 'Class: Adder';

  % I/O
  obj.addSymbol('u');
  obj.addSymbol('y');
  yobj = obj.getSymbol('y');
  yobj.Scope = 'Output';
  save_system('mClassTest');
  close_system('mClassTest', 0);

# 3. Set parameter value
model_edit(model: "mClassTest.slx", scope: "root", operations: [{"op": "configure", "target": "#cfunc", "params": {"p": "100"}}])
```

----

Copyright 2026 The MathWorks, Inc.

----
