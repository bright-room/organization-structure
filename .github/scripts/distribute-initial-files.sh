#!/usr/bin/env bash
set -euo pipefail

# Distributes initial template files to a target repository.
#
# Required environment variables:
#   TARGET_REPO_DIR  - Path to the checked-out target repository
#   TEMPLATES_DIR    - Path to the templates directory
#
# Outputs (via GITHUB_OUTPUT):
#   has_changes - "true" if any changes were made, "false" otherwise

: "${TARGET_REPO_DIR:?TARGET_REPO_DIR is required}"
: "${TEMPLATES_DIR:?TEMPLATES_DIR is required}"

# Define file mappings: template_file -> destination_path (relative to target repo)
# Template files use .template extension to avoid being recognized by tools in this repository.
declare -A FILE_MAP=(
  ["renovate.json.template"]="renovate.json"
  ["CODEOWNERS.template"]=".github/CODEOWNERS"
)

has_changes=false
summary=""

# Copy template files
for template in "${!FILE_MAP[@]}"; do
  src="${TEMPLATES_DIR}/${template}"
  dest="${TARGET_REPO_DIR}/${FILE_MAP[$template]}"

  if [ ! -f "$src" ]; then
    echo "::warning::Template not found: ${src}"
    continue
  fi

  if [ -f "$dest" ]; then
    echo "Skipping ${FILE_MAP[$template]} (already exists)"
    continue
  fi

  mkdir -p "$(dirname "$dest")"
  cp "$src" "$dest"
  echo "Copied ${template} -> ${FILE_MAP[$template]}"
  has_changes=true

  case "${FILE_MAP[$template]}" in
    renovate.json)
      summary="${summary}- Add \`renovate.json\` for automated dependency updates\n"
      ;;
    .github/CODEOWNERS)
      summary="${summary}- Add \`.github/CODEOWNERS\` for code review assignments\n"
      ;;
  esac
done

echo "has_changes=${has_changes}" >> "$GITHUB_OUTPUT"
{
  echo "summary<<EOF"
  echo -e "$summary"
  echo "EOF"
} >> "$GITHUB_OUTPUT"
