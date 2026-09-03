# evolutions-checkpoint

> **Implementation:** MATLAB functions wrapping git commands. No external server required.

## Setup

Add the scripts directory to the MATLAB path before first use:

```matlab
addpath('<skill_root>/scripts');
```

Where `<skill_root>` is the simulink-optimizing-embedded-code skill directory.

## Functions

| Function | Purpose | Bundles |
|----------|---------|---------|
| `eco_init(workspacePath)` | Initialize git repo in workspace | .gitignore setup |
| `eco_snapshot(workspacePath, tag, desc, model)` | Take a versioned snapshot | `save_system` before commit |
| `eco_revert(workspacePath, shaOrTag, model)` | Restore to a prior version | `close_system` before, `open_system` after |
| `eco_list(workspacePath)` | List all versions with tree graph | — |

## Tag Format (MANDATORY)

Tags and refs passed to `eco_snapshot` and `eco_revert` MUST match:

```
^[A-Za-z0-9._/-]+$
```

Only alphanumeric characters, dots, underscores, slashes, and hyphens are permitted. **No spaces, parentheses, dollar signs, backticks, semicolons, or other shell metacharacters.** The functions will error if this constraint is violated.

Use the pattern `v<N>_<snake_case_description>` — e.g., `v2_buffer_reuse`, `v3_inline_gains`, `v4_user_revert_to_v2`.

## How It Works

- `.git` lives visibly in the workspace directory
- Every snapshot creates a git commit + tag
- Revert detaches HEAD at the target commit — the next snapshot branches from that point
- Tags keep all commits permanently reachable (no lost history)
- `.eco_diagnostics/` is gitignored and survives all reverts

## Version Tree Example

```
eco_init       → v0_pristine (HEAD)
eco_snapshot   → v0_pristine → v1_baseline (HEAD)
eco_snapshot   → v0_pristine → v1_baseline → v2_opt_A (HEAD)
eco_snapshot   → v0_pristine → v1_baseline → v2_opt_A → v3_opt_B (HEAD)

eco_revert to v1_baseline → HEAD moves to v1_baseline

eco_snapshot   → v0_pristine → v1_baseline → v2_opt_A → v3_opt_B
                                └→ v4_opt_C (HEAD, branched from v1)
```

## Function Reference

### eco_init(workspacePath)

```matlab
result = eco_init('C:/path/to/workspace')
% result.status    = 'ok' | 'already_initialized'
% result.commitSHA = '7a3b2c1...'
% result.tag       = 'v0_pristine'
```

- Creates `.git` if absent
- Ensures `.gitignore` contains: `.eco_diagnostics/`, `bench_results/`, `slprj/`, `*.mexw64`
- Creates initial commit tagged `v0_pristine`
- Idempotent: returns existing state if already initialized

### eco_snapshot(workspacePath, tag, description, modelName)

```matlab
result = eco_snapshot('C:/path/to/workspace', 'v2_buffer_reuse', 'Applied buffer reuse; RAM -12%', 'MyModel')
% result.status    = 'ok' | 'no_changes'
% result.commitSHA = 'abc123...'
% result.tag       = 'v2_buffer_reuse'
% result.parentSHA = 'def456...'
```

- Calls `save_system(modelName)` first
- Stages all changes (`git add -A`)
- Commits with tag as subject line, description as body
- Creates a git tag for permanent reachability
- If no changes since last snapshot: returns `no_changes` with current HEAD

### eco_revert(workspacePath, commitSHAorTag, modelName)

```matlab
result = eco_revert('C:/path/to/workspace', 'v1_baseline', 'MyModel')
% result.status  = 'ok' | 'error'
% result.headSHA = '7a3b2c1...'
% result.tag     = 'v1_baseline'
```

- Calls `close_system(modelName)` and `clear mex`/`clear functions`
- Resolves tag name or SHA to full commit hash
- Detaches HEAD at target commit (`git checkout <sha>`)
- Reopens model from restored workspace
- Next `eco_snapshot` will branch from this point

### eco_list(workspacePath)

```matlab
result = eco_list('C:/path/to/workspace')
% result.status   = 'ok'
% result.head     = 'abc123...'
% result.versions = [struct('tag','v0_pristine','commitSHA','...','parentSHA',''), ...]
% result.graph    = '* abc123 (tag: v2) v2_buffer_reuse\n...'
```

- Lists all tagged versions sorted by creation date
- Shows parent relationships (tree structure)
- Prints a summary table to the command window
- Includes `git log --graph` visualization

## State Tracking

The orchestrator (main skill) tracks versions in `state.json`:

```json
{
  "versionMap": [
    {
      "version": "v0",
      "tag": "v0_pristine",
      "commitSHA": "7a3b2c1...",
      "metrics": {},
      "status": "OK pristine",
      "parentVersion": null
    },
    {
      "version": "v1",
      "tag": "v1_baseline",
      "commitSHA": "abc123...",
      "metrics": {"ExecTime_ns": 1200},
      "status": "OK baseline",
      "parentVersion": "v0"
    }
  ]
}
```

- `commitSHA` is the direct git commit hash (no UUID mapping)
- `parentVersion` matches the git commit parent (tree is in git)
- `.git` IS the state

## Error Handling

| Error | Cause | Resolution |
|-------|-------|------------|
| `'Not a git repository'` | `eco_init` not called | Call `eco_init(workspacePath)` first |
| `'Invalid ref: ...'` | Bad SHA or tag name | Check `eco_list` for valid refs |
| `git checkout` fails with file lock | `.mexw64` still loaded | `clear mex; clear functions` (bundled in `eco_revert`) |
| `'save_system failed'` | Model not loaded or path issue | Verify model is open in MATLAB |
| Tag already exists | Duplicate tag name | Use unique version tags (v0, v1, v2...) |


----

Copyright 2026 The MathWorks, Inc.

----