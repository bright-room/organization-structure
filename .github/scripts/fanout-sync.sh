#!/usr/bin/env bash
set -euo pipefail
# repository-fanout worker へ manifest を HMAC 署名付きで POST する。
# 必須 env: FANOUT_URL, FANOUT_HMAC_SECRET, ACCOUNT, GITHUB_SHA
# manifest は terraform output から取得（apply 後に実行する前提）。

ts="$(date +%s)"
manifest="$(terraform -chdir="${GITHUB_WORKSPACE}/terraform" output -json fanout_manifest)"
if [ -z "$manifest" ] || [ "$manifest" = "null" ]; then
  echo "::error::fanout_manifest output is empty"
  exit 1
fi

# revision（単調増加する epoch 秒）と sourceCommit を付与
body="$(echo "$manifest" | jq -c --argjson rev "$ts" --arg sha "$GITHUB_SHA" \
  '. + {revision: $rev, sourceCommit: $sha}')"

# HMAC-SHA256(secret, "<ts>.<body>") を hex で（worker signHmac と一致）
sig="$(printf '%s.%s' "$ts" "$body" \
  | openssl dgst -sha256 -hmac "$FANOUT_HMAC_SECRET" -hex | sed 's/^.*= //')"

for attempt in 1 2 3; do
  code="$(curl -s -o /tmp/fanout-resp -w '%{http_code}' -X POST "${FANOUT_URL}/sync/${ACCOUNT}" \
    -H "X-Fanout-Timestamp: ${ts}" \
    -H "X-Fanout-Signature: ${sig}" \
    -H "Content-Type: application/json" \
    --data "$body" || true)"
  if [ "$code" = "202" ]; then
    echo "accepted"
    cat /tmp/fanout-resp
    echo
    exit 0
  fi
  echo "attempt ${attempt}: HTTP ${code}"
  cat /tmp/fanout-resp 2>/dev/null || true
  echo
  sleep $((attempt * 3))
done

echo "::error::fanout /sync not accepted after retries"
exit 1
