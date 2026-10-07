# Block Support Constraints: String Operations

Blocks in this category perform string manipulation including conversion between ASCII and strings, string composition, comparison, concatenation, and length queries. All string blocks require `TargetLang` to be set to `C`.

---

## 4. ASCII to String — Nonfatal

**Block:** simulink/String/ASCII to String

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Dimension of input must be less than `Buffer size of dynamically-sized string (bytes)` | Nonfatal |
| Other | Configuration parameter `TargetLang` must be set to `C` | Nonfatal |

### Constraint Details

#### Input dimension must be less than DynamicStringBufferSize

**Why:** When the input dimension exceeds the dynamic string buffer size, the generated code may write beyond the allocated buffer. SLCI cannot verify code correctness when buffer overflows are possible — the memory access pattern becomes undefined and untraceable.

**Fix:**
```matlab
% Increase buffer size or reduce input dimension
set_param(model, 'DynamicStringBufferSize', '512');
```

#### TargetLang must be `C`

**Why:** String blocks generate code using C string functions (`strcpy`, `strlen`, `strncmp`, etc.). When `TargetLang` is `C++`, different string implementations (e.g., `std::string`) may be used, producing code patterns that SLCI's C-focused analysis cannot verify.

**Fix:**
```matlab
set_param(model, 'TargetLang', 'C');
```

---

## 13. Compose String — Nonfatal

**Block:** simulink/String/Compose String

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | Format (`Format`) parameter value must not contain escape-character sequences | Nonfatal |
| Block Parameters | `DynamicStringBufferSize` configuration parameter value must be greater than the buffer size required for the Format parameter | Nonfatal |
| Other | Configuration parameter `TargetLang` must be set to `C` | Nonfatal |

### Constraint Details

#### Format must not contain escape-character sequences

**Why:** Escape character sequences (`\n`, `\t`, `\\`, etc.) in the format string produce non-printable characters in the output. SLCI verifies string content by comparing format literals — escape sequences introduce ambiguity in how the format string maps to the generated `snprintf` call.

**Fix:**
```matlab
set_param('model/Compose String', 'Format', '%f m/s');
```

#### DynamicStringBufferSize must be greater than Format buffer requirement

**Why:** The Compose String block uses `snprintf` with a buffer sized by `DynamicStringBufferSize`. If the format string's maximum output length exceeds the buffer size, the output is truncated. SLCI cannot verify correctness of truncated string operations — the generated code's `snprintf` length parameter must accommodate the full format expansion.

**Fix:**
```matlab
% Increase buffer size to accommodate format output
set_param(model, 'DynamicStringBufferSize', '512');
```

#### TargetLang must be `C`

**Why:** Same as ASCII to String section 4. String blocks require C target language for standard C string function code generation.

**Fix:**
```matlab
set_param(model, 'TargetLang', 'C');
```

---

## 79. String Compare — Nonfatal

**Block:** simulink/String/String Compare

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | Case sensitive (`CaseSensitive`) must be selected (set to `on`) | Nonfatal |
| Other | Configuration parameter `TargetLang` must be set to `C` | Nonfatal |

### Constraint Details

#### CaseSensitive must be `on`

**Why:** Case-insensitive comparison uses `strcasecmp` (or platform-specific equivalents) which is not part of the C standard library. SLCI verifies string operations against standard C string functions. The case-sensitive `strcmp` is universally available and produces a deterministic, verifiable code pattern.

**Fix:**
```matlab
set_param('model/String Compare', 'CaseSensitive', 'on');
```

#### TargetLang must be `C`

**Why:** Same as ASCII to String section 4. String blocks require C target language for standard C string function code generation.

**Fix:**
```matlab
set_param(model, 'TargetLang', 'C');
```

---

## 80. String Concatenate — Nonfatal

**Block:** simulink/String/String Concatenate

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | No block-specific constraints | Nonfatal |
| Other | Configuration parameter `TargetLang` must be set to `C` | Nonfatal |

### Constraint Details

#### TargetLang must be `C`

**Why:** Same as ASCII to String section 4. String blocks require C target language for standard C string function (`strcat`/`strncat`) code generation.

**Fix:**
```matlab
set_param(model, 'TargetLang', 'C');
```

---

## 81. String Constant — Nonfatal

**Block:** simulink/String/String Constant

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | No block-specific constraints | Nonfatal |
| Other | Configuration parameter `TargetLang` must be set to `C` | Nonfatal |
| Other | `DynamicStringBufferSize` must be greater than buffer size required for input string | Nonfatal |

### Constraint Details

#### TargetLang must be `C`

**Why:** Same as ASCII to String section 4. String blocks require C target language.

**Fix:**
```matlab
set_param(model, 'TargetLang', 'C');
```

#### DynamicStringBufferSize must be greater than string constant length

**Why:** The String Constant block's value is stored in a fixed-size buffer determined by `DynamicStringBufferSize`. If the string constant length exceeds the buffer size, the generated code truncates the string or produces a buffer overflow. SLCI cannot verify truncated or overflowed string initializations.

**Fix:**
```matlab
% Increase buffer size to accommodate the string constant
set_param(model, 'DynamicStringBufferSize', '512');
```

---

## 82. String Length — Nonfatal

**Block:** simulink/String/String Length

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Block Parameters | No block-specific constraints | Nonfatal |
| Other | Configuration parameter `TargetLang` must be set to `C` | Nonfatal |

### Constraint Details

#### TargetLang must be `C`

**Why:** Same as ASCII to String section 4. String blocks require C target language for standard `strlen` code generation.

**Fix:**
```matlab
set_param(model, 'TargetLang', 'C');
```

---

## 89. To String — Nonfatal

**Block:** simulink/String/To String

| Category | Constraint | Severity |
|---|---|---|
| Data Types and Ports | Universal constraints apply | Nonfatal |
| Data Types and Ports | Input port data type must not be an enumerated type | Nonfatal |
| Block Parameters | No block-specific constraints | Nonfatal |
| Other | Configuration parameter `TargetLang` must be set to `C` | Nonfatal |

### Constraint Details

#### Input port must not be enumerated type

**Why:** Converting an enumerated type to string requires the code generator to embed enumeration value names as string literals and produce a switch statement mapping enum values to their string representations. This name-mapping code has no direct model-level counterpart and varies with the enumeration definition. SLCI cannot verify the correctness of enum-to-string mappings.

**Fix:**
```matlab
% Add a Data Type Conversion block before To String
% Convert enum to int32 first
```

#### TargetLang must be `C`

**Why:** Same as ASCII to String section 4. String blocks require C target language for standard C string function code generation.

**Fix:**
```matlab
set_param(model, 'TargetLang', 'C');
```

----

Copyright 2026 The MathWorks, Inc.

----
