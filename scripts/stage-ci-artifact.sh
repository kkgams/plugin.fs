#!/usr/bin/env bash
# The owner approved these exact source texts for public CI artifacts. A change
# to either file must be reviewed and deliberately pinned here before upload.
set -euo pipefail
license_sha=cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30
notice_sha=2d3ac85f8a3df5ff3a0e6e6c7da706d0ff4f18697fa68dc4a0b3ceaf3e05203c
printf '%s  LICENSE\n%s  NOTICE\n' "$license_sha" "$notice_sha" | sha256sum --check -
(cd dist && sha256sum --check SHA256SUMS)
python3 scripts/wasm-notices.py verify dist/plugin.fs.wasm --license LICENSE --notice NOTICE
cp LICENSE NOTICE dist/
(cd dist && sha256sum plugin.fs.wasm LICENSE NOTICE > SHA256SUMS && sha256sum --check SHA256SUMS)
