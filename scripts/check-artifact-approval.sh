#!/usr/bin/env bash
# Validate final artifact and source licensing payloads.
set -euo pipefail

for file in LICENSE NOTICE dist/plugin.fs.wasm dist/SHA256SUMS; do
  if [[ ! -s "$file" ]]; then
    echo "CI artifact distribution blocked: $file is missing or empty" >&2
    exit 1
  fi
done
# The build job validated and checksummed this exact WASM before the gate.
(cd dist && sha256sum --check SHA256SUMS)
python3 scripts/wasm-notices.py verify dist/plugin.fs.wasm --license LICENSE --notice NOTICE
cp LICENSE NOTICE dist/
(cd dist && sha256sum plugin.fs.wasm LICENSE NOTICE > SHA256SUMS && sha256sum --check SHA256SUMS)
