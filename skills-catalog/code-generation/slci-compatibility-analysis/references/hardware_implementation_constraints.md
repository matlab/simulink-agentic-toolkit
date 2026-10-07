# Hardware Implementation Constraints

SLCI verifies model-to-code equivalence by comparing Simulink simulation results
against the semantics of the generated C code. To do this reliably, SLCI must know
the exact bit-widths and arithmetic behavior of every C data type on the target
hardware. If the Hardware Implementation settings do not match a known,
deterministic configuration, SLCI cannot guarantee that the generated code
faithfully reproduces the model behavior.

---

## 1-11. Number of Bits Constraints (ProdBitPerChar, ProdBitPerShort, ProdBitPerInt, ProdBitPerLong, ProdBitPerLongLong, ProdBitPerFloat, ProdBitPerDouble, ProdWordSize, ProdBitPerPointer, ProdBitPerSizeT, ProdBitPerPtrDiffT) — Nonfatal

**Required:**

| # | Parameter | Required Value |
|---|-----------|---------------|
| 1 | ProdBitPerChar | 8 |
| 2 | ProdBitPerShort | 16 |
| 3 | ProdBitPerInt | 32 |
| 4 | ProdBitPerLong | 32 or 64 |
| 5 | ProdBitPerLongLong | 64 |
| 6 | ProdBitPerFloat | 32 |
| 7 | ProdBitPerDouble | 64 |
| 8 | ProdWordSize (native) | 32 |
| 9 | ProdBitPerPointer | 32 |
| 10 | ProdBitPerSizeT | 32 |
| 11 | ProdBitPerPtrDiffT | 32 |

**Why:** SLCI maps every Simulink data type to a C type with a guaranteed bit-width. If the hardware implementation settings specify non-standard widths, the code generator produces typedefs that do not match what SLCI expects, and SLCI cannot verify that intermediate computations, saturation, and wrap-on-overflow produce identical results in the model and in the code. Pointer and size_t widths affect array indexing and memory offset calculations in generated code.

**Fix:**
```matlab
% Set all number-of-bits parameters to required values
cs = getActiveConfigSet(model);
set_param(cs, 'ProdBitPerChar',      8);
set_param(cs, 'ProdBitPerShort',    16);
set_param(cs, 'ProdBitPerInt',      32);
set_param(cs, 'ProdBitPerLong',     32);   % or 64
set_param(cs, 'ProdBitPerLongLong', 64);
set_param(cs, 'ProdBitPerFloat',    32);
set_param(cs, 'ProdBitPerDouble',   64);
set_param(cs, 'ProdWordSize',       32);
set_param(cs, 'ProdBitPerPointer',  32);
set_param(cs, 'ProdBitPerSizeT',    32);
set_param(cs, 'ProdBitPerPtrDiffT', 32);
```

---

## 12. Signed Integer Division Rounds to (ProdIntDivRoundTo) — Nonfatal

**Required:** `'Zero'`

**Why:** The C99 and C11 standards define that integer division truncates toward zero. SLCI assumes this behavior when verifying that the model's integer arithmetic matches the generated code. If the hardware rounds toward negative infinity or the setting is left as `Undefined`, the simulation result may differ from the compiled code result for negative operands, breaking model-to-code equivalence.

**Fix:**
```matlab
set_param(model, 'ProdIntDivRoundTo', 'Zero');
```

---

## 13. Shift Right on a Signed Integer as Arithmetic Shift (ProdShiftRightIntArith) — Nonfatal

**Required:** `'on'`

**Why:** SLCI generates code that uses the C `>>` operator on signed integers to implement Simulink arithmetic shift blocks. The C standard leaves the behavior of right-shifting a negative signed integer implementation-defined. By requiring `ProdShiftRightIntArith = 'on'`, SLCI knows the target hardware performs an arithmetic (sign-extending) shift, matching the Simulink block's semantics and ensuring shift operations on negative values produce equivalent results in model and code.

**Fix:**
```matlab
set_param(model, 'ProdShiftRightIntArith', 'on');
```

---

## 14. Test Hardware Is the Same as Production Hardware (ProdEqTarget) — Nonfatal

**Required:** `'on'`

**Why:** SLCI performs equivalence checking between simulation results (run on test hardware) and generated code (targeting production hardware). If test and production hardware differ in type sizes, endianness, or arithmetic behavior, simulation results computed with one set of assumptions cannot be meaningfully compared against code generated for a different set. Setting `ProdEqTarget` to `'on'` ensures a single, consistent hardware model is used throughout, making equivalence verification sound.

**Fix:**
```matlab
set_param(model, 'ProdEqTarget', 'on');
```

---

## 15. Device Vendor / Device Type (ProdHWDeviceType) — Nonfatal

**Required:** Must NOT be set to `'ASIC/FPGA'`

**Why:** SLCI verifies equivalence between Simulink models and generated C code. The ASIC/FPGA device type represents hardware that does not execute standard C code -- it uses HDL (Verilog/VHDL) with fundamentally different arithmetic semantics (arbitrary bit-width registers, no C integer promotion, parallel execution). SLCI's analysis is based on C language semantics and cannot reason about HDL-targeted code. Any non-ASIC/FPGA processor target is acceptable.

**Fix:**
```matlab
% Set to a standard processor target (example: generic 32-bit processor)
set_param(model, 'ProdHWDeviceType', 'Intel->x86-64 (Linux 64)');

% Or any other non-ASIC/FPGA target, for example:
% set_param(model, 'ProdHWDeviceType', 'ARM Compatible->ARM Cortex-A');
% set_param(model, 'ProdHWDeviceType', 'Generic->32-bit x86 compatible');
```

----

Copyright 2026 The MathWorks, Inc.

----
