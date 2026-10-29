# Map User Phrasing to Configuration Choices

Internal lookup tables for the single `configure_for_codegen` call. The parameter names in these tables are for building the call only — never show them to the user.

## Inferences to narrate

| User phrasing | Inferred choice | How to say it back |
|---|---|---|
| "embedded C", "production C" (no C++ mention) | source language = C | "Using C as the source language since you said 'embedded C' — let me know if you meant C++." |
| "AUTOSAR" (bare, no Classic/Adaptive) | target = AUTOSAR Classic | "Using AUTOSAR Classic since you didn't specify — say the word if you meant AUTOSAR Adaptive." |
| "embedded", "production", "ECU" (no shared-library / AUTOSAR / rapid-prototyping mention) | target = ERT executable | "Building for an ERT executable target — tell me if you want a shared library instead." |
| "rapid prototyping", "GRT", "generate GRT code", "desktop test target (no Speedgoat / Simulink Real-Time)" | target = GRT | "Using the GRT rapid-prototyping target since you asked for rapid prototyping — this is Simulink Coder, not Embedded Coder. Tell me if you meant a production ERT build." |
| "ARM Cortex-A", "Cortex-M4", "x86-64" (short form) | full hardware device string | "Mapped 'ARM Cortex-A' to the ARM Compatible ARM Cortex-A device — let me know if you meant a different variant." |

## Phrase to parameter

| User phrase | Parameter |
|---|---|
| "just configure", "apply settings only", "prepare the model but don't generate code" | `ConfigOnly=true` |
| "codegen", "generate code", "generate the code but don't build/compile", "generate code without building an executable" | *(no override — defaults `ConfigOnly=false, Build=false` generate source without a toolchain build)* |
| "build it", "compile it", "generate and build", "produce an executable" | `Build=true` |
| "MISRA" (bare) | `Compliance="MISRA C"` or `"MISRA C++"` per `Language` (see the MISRA ambiguity rule in SKILL.md) |
| "speed", "fast", "execution efficiency" | `Objective="Speed"` |
| "small flash", "minimize RAM", "memory-constrained", "low memory" | `Objective="RAM"` |
| "debug", "debuggable", "step through", "step-through", "traceability", "preserve block structure" | `Objective="Debug"` |
| "check what the model needs", "right-size the code", "accurate support flags", "match support flags to the model", "compile it first to see what the model uses" | `Introspect=true` |

## Three distinct build modes

The words "don't build" / "don't compile" appear in *two* of these buckets and are ambiguous on their own; disambiguate by whether the user wants code generated:

| Intent | User signal | Mode |
|---|---|---|
| Apply ConfigSet only, produce no code | user says "just configure" / "apply settings" / "don't generate code" — no code wanted | `ConfigOnly=true` (skips `rtwbuild` entirely) |
| Generate source files, skip toolchain build | user asks for code ("generate code", "codegen") while also saying "don't build/compile" (or says nothing about building) | defaults — `rtwbuild(..., 'GenerateCodeOnly', true)` |
| Generate source and produce an executable | user says "build" / "compile" / "produce an executable" | `Build=true` (calls `slbuild`) |

"Just apply the settings" or "don't generate code" maps to configure-only. "Generate code but don't build/compile" maps to the default mode — the user asked for code, and "don't build" means skip only the *executable* build. Configure-only is wrong whenever the user asks for code to be generated.

## Assumed-defaults narration

Example: "Since you didn't specify, I applied these defaults: nonreusable function interface, no MISRA compliance profile, configured the model but did not run a build, placed generated code next to the model file, and skipped model introspection to keep this fast (support flags applied conservatively — say the word if you'd like me to compile the model to right-size them). Let me know if you want any of these changed."

----

Copyright 2026 The MathWorks, Inc.

----
