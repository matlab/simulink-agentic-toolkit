#!/usr/bin/env bash
set -euo pipefail

toolkit_root="${1:-}"
if [[ -z "${toolkit_root}" ]]; then
  toolkit_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
fi

# Determine skills directory: prefer ~/.agents/skills/, fall back to
# ~/.copilot/skills/ if the primary cannot be created (e.g., restricted
# home directory layouts on some corporate machines).
skills_root="${HOME}/.agents/skills"
if ! mkdir -p "${skills_root}" 2>/dev/null; then
  skills_root="${HOME}/.copilot/skills"
  mkdir -p "${skills_root}"
fi

link_skill() {
  local source_dir="$1"
  local link_name
  link_name="$(basename "${source_dir}")"
  ln -sfn "${source_dir}" "${skills_root}/${link_name}"
  printf 'Linked %s -> %s\n' "${skills_root}/${link_name}" "${source_dir}"
}

while IFS= read -r skill_dir; do
  link_skill "${skill_dir}"
done < <(find "${toolkit_root}/skills-catalog/model-based-design-core" "${toolkit_root}/skills-catalog/toolkit" \
  -mindepth 1 -maxdepth 1 -type d | sort)

printf '\nSkills directory: %s\n' "${skills_root}"
