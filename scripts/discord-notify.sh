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

JSON=$(TAG="${TAG}" ISO_NAME="${ISO_NAME}" ISO_SHA256="${ISO_SHA256}" python3 -c "
import json, os
tag = os.environ.get('TAG', 'unknown')
name = os.environ.get('ISO_NAME', 'unknown')
sha = os.environ.get('ISO_SHA256', 'n/a')
msg = {
    'content': '\n'.join([
        '@everyone',
        '> **RaveOS · Új ISO elérhető!**',
        '> ',
        f'> Verzió: **{tag}**',
        f'> Fájl: `{name}`',
        '> Letöltés: https://links.rp1.hu/raveos-download',
        f'> SHA256: `{sha}`',
    ]),
    'allowed_mentions': {'parse': ['everyone']},
}
print(json.dumps(msg, ensure_ascii=False))
")

curl -s \
  -F "payload_json=${JSON}" \
  -F "file=@assets/discord-notify.png" \
  -X POST "${WEBHOOK}" || true
