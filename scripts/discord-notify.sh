#!/usr/bin/env bash
set -euo pipefail

WEBHOOK="${1:-}"
TAG="${2:-unknown}"
ISO_NAME="${3:-unknown}"
ISO_SHA256="${4:-n/a}"

if [ -z "${WEBHOOK}" ]; then
  echo "Hianyzo webhook URL"
  exit 0
fi

CONTENT="@everyone
> **RaveOS · Uj ISO elerheto!**
> 
> Verzio: **${TAG}**
> Fajl: \`${ISO_NAME}\`
> Letoltes: https://links.rp1.hu/raveos-download
> SHA256: \`${ISO_SHA256}\`"

JSON=$(python3 -c "
import json
content = '''${CONTENT}'''
print(json.dumps({'content': content, 'allowed_mentions': {'parse': ['everyone']}}, ensure_ascii=False))
")

curl -s \
  -F "payload_json=${JSON}" \
  -F "file=@assets/discord-notify.png" \
  -X POST "${WEBHOOK}" || true
