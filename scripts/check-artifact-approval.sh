#!/usr/bin/env bash
# Run only after the owner has reviewed the exact LICENSE and NOTICE files.
set -euo pipefail

if [[ "${APPROVED:-}" != true ]]; then
  echo 'CI artifact distribution requires explicit GAMS_FS_ARTIFACT_UPLOAD_APPROVED=true' >&2
  exit 1
fi
for file in LICENSE NOTICE dist/plugin.fs.wasm dist/SHA256SUMS; do
  if [[ ! -s "$file" ]]; then
    echo "CI artifact distribution blocked: $file is missing or empty" >&2
    exit 1
  fi
done
for name in APPROVED_LICENSE_SHA256 APPROVED_NOTICE_SHA256; do
  value="${!name:-}"
  if [[ ! "$value" =~ ^[0-9a-f]{64}$ ]]; then
    echo "CI artifact distribution blocked: $name must be an approved lowercase SHA-256" >&2
    exit 1
  fi
done
license_hash="$(sha256sum LICENSE | awk '{print $1}')"
notice_hash="$(sha256sum NOTICE | awk '{print $1}')"
if [[ "$license_hash" != "$APPROVED_LICENSE_SHA256" || "$notice_hash" != "$APPROVED_NOTICE_SHA256" ]]; then
  echo 'CI artifact distribution blocked: approved licensing bytes do not match' >&2
  exit 1
fi
# The build job validated and checksummed this exact WASM before the gate.
(cd dist && sha256sum --check SHA256SUMS)
cp LICENSE NOTICE dist/
(cd dist && sha256sum plugin.fs.wasm LICENSE NOTICE > SHA256SUMS && sha256sum --check SHA256SUMS)
