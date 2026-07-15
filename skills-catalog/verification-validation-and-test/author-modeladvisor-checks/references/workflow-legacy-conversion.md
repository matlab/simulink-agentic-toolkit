# Legacy Conversion Workflow

When converting existing StyleOne/StyleTwo/StyleThree checks to DetailStyle:

1. **Read the existing code** — Identify the legacy callback style, registration method, and all utility/infrastructure classes used
2. **Map the infrastructure** — Categorize what the utility provides:
   - Block search / model traversal → **PRESERVE** (keep calling it)
   - Progress bars / waitbars → **PRESERVE** (keep calling it)
   - Justification / exclusion logic → **PRESERVE** (keep calling it)
   - Result formatting / HTML packaging → **REPLACE** (this is the only layer that changes)
   - Input parsing (varargin handling) → **ADAPT** (DetailStyle provides `system` directly, but utility may still need model name)
3. **Choose conversion strategy** (present to user):
   - **Wrapper strategy** (preferred for shared utilities): Keep the algorithm and utility calls intact. Only change the callback signature and replace the result-packaging step with ResultDetail construction.
   - **Utility modification strategy** (when utility is owned by same team): Modify the utility's result method to return ResultDetail objects. All checks using it benefit immediately.
   - **Inline strategy** (only for single-use checks with no shared infrastructure): Replace utility calls with direct API usage. **Never use this for checks that share utilities with other checks.**
4. **Convert registration** — Change `CallbackHandle`/`CallbackStyle` to `setCallbackFcn(@cb, context, 'DetailStyle')`
5. **Convert callback signature** — From `function [ResultDescription, ResultDetails] = cb(varargin)` or `function ResultDescription = cb(system)` to `function cb(system, CheckObj)`
6. **Convert result packaging only** — Replace the utility's HTML/cell result output with ResultDetail objects. The algorithm output (cell arrays of failing blocks/paths) feeds directly into `setData('SID', ...)`.
7. **Validate** — Run `check_matlab_code` on each modified `.m` file
8. **Report** — Show what changed, what was preserved, and test command

**Critical rule:** Never remove or rewrite utility classes that are shared across multiple checks. The conversion scope is the result-reporting layer only. Algorithm logic, block search, progress indicators, and custom exclusion/justification systems must be preserved as-is.
