# Structured YAML Requirements Format

Text-file fallback for requirement drafts when Requirements Toolbox is unavailable.

## File Convention

- One file per model: `<model>_requirements.yaml`
- All requirements in a single file under the `requirements` list

## Schema

```yaml
schema_version: "1.0"
package: SystemName

requirements:
  - id: REQ_SYS_001
    summary: "EARS shall-statement (WHAT)."
    description: "Derived from <Model>/<Subsystem>."
    rationale: "Engineering justification (WHY)."
    asil: QM            # Unset | QM | A | B | C | D
    status: Draft        # Draft | Review | Approved | Implemented
    priority: High       # Unset | Low | Medium | High | Critical
    keywords: [draft, auto-generated, control]
    derived_from: null   # parent requirement ID string, or null
```

## Field Rules

| Field | Required | Content |
|-------|----------|---------|
| `schema_version` | Yes | Always `"1.0"` |
| `package` | Yes | System or model name |
| `id` | Yes | `REQ_<ABBREV>_NNN`, stable across regeneration |
| `summary` | Yes | EARS "shall" statement — behavioral intent, not block topology |
| `description` | Yes | Provenance — which model/subsystem this came from |
| `rationale` | Yes | Engineering justification for why this requirement exists |
| `asil` | Yes | One of: `Unset`, `QM`, `A`, `B`, `C`, `D`. Use `Unset` when the model does not indicate safety level |
| `status` | Yes | Always `Draft` for auto-generated requirements |
| `priority` | Yes | One of: `Unset`, `Low`, `Medium`, `High`, `Critical`. Use `Unset` when unknown |
| `keywords` | Yes | List; must include `draft` |
| `derived_from` | No | Parent requirement ID (string) or `null` |

## Validation

Validate with any YAML parser:

```python
python -c "import yaml, sys; yaml.safe_load(open(sys.argv[1])); print('OK')" path/to/requirements.yaml
```

### Self-Check Rules

Before finishing, verify:
- Every requirement has `status: Draft` and `keywords` includes `draft`
- `asil` values are bare strings (`Unset`, `QM`, `A`, `B`, `C`, `D`) — NOT qualified enums
- `summary` uses EARS patterns, not block-topology restatements
- `id` values are unique and sequential
- `derived_from` references an `id` that exists in the same file, or is `null`
