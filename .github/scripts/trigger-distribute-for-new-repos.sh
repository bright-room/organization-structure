#!/usr/bin/env bash
set -euo pipefail

# Detects new repositories from terraform apply output and triggers
# the distribute-initial-files workflow for each.
#
# Required environment variables:
#   TF_APPLY_OUTPUT  - stdout from terraform apply
#   GH_TOKEN         - GitHub token for gh CLI
#
# The exclusion list is read from .github/config/exclude-repos.json

: "${TF_APPLY_OUTPUT:?TF_APPLY_OUTPUT is required}"
: "${GH_TOKEN:?GH_TOKEN is required}"

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
EXCLUDE_FILE="${SCRIPT_DIR}/../config/exclude-repos.json"

exclude=$(cat "$EXCLUDE_FILE")

repos=$(echo "$TF_APPLY_OUTPUT" \
  | grep -oP 'module\.repository_\K[^.]+(?=\.github_repository\.this: Creation complete)' \
  | sed 's/_/-/g' \
  | jq -R -s -c --argjson exclude "$exclude" \
    'split("\n") | map(select(length > 0)) | map(select(. as $n | $exclude | index($n) | not))' \
  || echo '[]')

if [ "$repos" = "[]" ]; then
  echo "No new repositories detected."
  exit 0
fi

echo "New repositories detected: ${repos}"

for repo in $(echo "$repos" | jq -r '.[]'); do
  echo "Triggering distribute-initial-files for ${repo}"
  gh workflow run distribute-initial-files.yml \
    -f target_repo="${repo}" \
    --repo bright-room/organization-structure
done
