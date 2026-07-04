#!/usr/bin/env bash
# fanout へ manifest を送る(OIDC 認証・シークレット不要)。apply 成功後に on-merge から呼ぶ。
# body は {manifest: {...}} エンベロープ(repository-fanout spec v2 §6.4)。
set -euo pipefail

: "${FANOUT_URL:?}" "${ACCOUNT:?}" "${GITHUB_SHA:?}"
: "${ACTIONS_ID_TOKEN_REQUEST_TOKEN:?}" "${ACTIONS_ID_TOKEN_REQUEST_URL:?}"

manifest=$(terraform -chdir="${GITHUB_WORKSPACE}/terraform" output -json fanout_manifest)
revision=$(date +%s)
body=$(jq -cn --argjson m "${manifest}" --arg rev "${revision}" --arg sha "${GITHUB_SHA}" \
  '{manifest: ($m + {revision: ($rev | tonumber), sourceCommit: $sha})}')

token=$(curl -sS -H "Authorization: bearer ${ACTIONS_ID_TOKEN_REQUEST_TOKEN}" \
  "${ACTIONS_ID_TOKEN_REQUEST_URL}&audience=${FANOUT_URL}" | jq -r .value)

for i in 1 2 3; do
  code=$(curl -sS -o /tmp/fanout-resp -w '%{http_code}' -X POST "${FANOUT_URL}/sync/${ACCOUNT}" \
    -H "Authorization: Bearer ${token}" -H "content-type: application/json" -d "${body}")
  if [ "${code}" = "202" ]; then cat /tmp/fanout-resp; exit 0; fi
  echo "attempt ${i}: HTTP ${code} $(cat /tmp/fanout-resp)"
  sleep $((i * 5))
done
echo "fanout sync failed after 3 attempts" >&2
exit 1
