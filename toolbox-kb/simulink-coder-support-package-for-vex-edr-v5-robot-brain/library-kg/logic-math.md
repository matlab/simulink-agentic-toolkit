---
type: Simulink Block Category
title: Logic math
description: Logic and math operations
tags: [compare, logical, math, gain, add, trig]
status: stable
source: mathworks_toolbox
library_root: Simulink Coder Support Package for VEX EDR V5 Robot Brain
category_path: Logic math
block_count: 25
---

# Logic math

Use these blocks for logic math.

## Recommended Blocks

| Block | ReferenceBlock | Since | Intent |
|---|---|---|---|
| Compare To Constant | vexv5lib/Logical Operations Library/Compare To Constant | R2023a+ | Compare signal to constant — use for threshold decisions in V5 robot logic |
| Compare To Zero | vexv5lib/Logical Operations Library/Compare To Zero | R2023a+ | Compare signal to zero — use for zero-crossing detection in V5 programs |
| Logical Operator | vexv5lib/Logical Operations Library/Logical Operator | R2023a+ | AND/OR/NOT logic gate — use for combining boolean conditions |
| Logical Operator1 | vexv5lib/Logical Operations Library/Logical Operator1 | R2023a+ | Additional logic gate — use for OR operations in robot decision logic |
| Relational Operator | vexv5lib/Logical Operations Library/Relational Operator | R2023a+ | Compare two signals — use for condition checking between V5 sensor values |
| Abs | vexv5lib/Math Library/Abs | R2023a+ | Absolute value — use for magnitude regardless of sign |
| Add | vexv5lib/Math Library/Add | R2023a+ | Sum signals — use for combining sensor inputs or control terms |
| Bias | vexv5lib/Math Library/Bias | R2023a+ | Add constant offset — use for sensor calibration on V5 |
| Divide | vexv5lib/Math Library/Divide | R2023a+ | Divide signals — use for ratio computation or normalization |
| Gain | vexv5lib/Math Library/Gain | R2023a+ | Multiply by constant — use for scaling V5 sensor readings or motor commands |
| Math Function | vexv5lib/Math Library/Math Function | R2023a+ | Apply math function — use for exp, log, power operations on V5 |
| MinMax | vexv5lib/Math Library/MinMax | R2023a+ | Find min or max — use for clamping V5 motor outputs |
| MinMax Running Resettable | vexv5lib/Math Library/MinMax Running Resettable | R2023a+ | Track running min/max — use for peak detection over time |
| Polynomial | vexv5lib/Math Library/Polynomial | R2023a+ | Evaluate polynomial — use for nonlinear sensor calibration |
| Product | vexv5lib/Math Library/Product | R2023a+ | Multiply signals — use for combining gains |
| Reciprocal Sqrt | vexv5lib/Math Library/Reciprocal Sqrt | R2023a+ | Compute 1/sqrt — use for normalization |
| Rounding Function | vexv5lib/Math Library/Rounding Function | R2023a+ | Round to integer — use for discrete value conversion |
| Sign | vexv5lib/Math Library/Sign | R2023a+ | Extract sign — use for direction detection |
| Signed Sqrt | vexv5lib/Math Library/Signed Sqrt | R2023a+ | Sign-preserving sqrt — use for signed root computation |
| Sine Wave Function | vexv5lib/Math Library/Sine Wave Function | R2023a+ | Generate sine wave — use for periodic test stimuli |
| Slider Gain | vexv5lib/Math Library/Slider Gain | R2023a+ | Adjustable gain — use for tuning during V5 simulation |
| Sqrt | vexv5lib/Math Library/Sqrt | R2023a+ | Square root — use for distance calculations |
| Subtract | vexv5lib/Math Library/Subtract | R2023a+ | Subtract signals — use for error computation in control loops |
| Trigonometric Function | vexv5lib/Math Library/Trigonometric Function | R2023a+ | Trig functions — use for angle calculations in V5 navigation |
| Unary Minus | vexv5lib/Math Library/Unary Minus | R2023a+ | Negate signal — use for reversing direction |
