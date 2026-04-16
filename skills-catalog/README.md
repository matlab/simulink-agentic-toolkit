# Skills Catalog

The skills catalog organizes agent skills into groups. Each group is a directory containing one or more skills (each with a `SKILL.md` and `manifest.yaml`).

## Skill Groups

| Group | Description | Status |
|-------|-------------|--------|
| [model-based-design-core](model-based-design-core/) | Core MBD skills for building, testing, and specifying Simulink models | Available |
| [PRODUCT-GROUP-NAME](PRODUCT-GROUP-NAME/) | Placeholder for additional skill groups (e.g., Verification, Validation & Test or Code Generation) | Placeholder |

## How Skills Are Installed

Skills are not auto-discovered from this catalog. Each agent platform has a manifest file (in the repo root) that explicitly scopes which skill groups are included. See the [README](../README.md) for per-agent installation instructions.

## Adding Skills

See [CONTRIBUTING.md](../CONTRIBUTING.md) for guidelines on adding skills to the catalog.
