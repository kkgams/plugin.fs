#!/usr/bin/env bash
set -euo pipefail
source_dir="$(cd "$(dirname "$0")" && pwd)"
script="$source_dir/check-artifact-approval.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
cd "$work"
mkdir dist scripts
cp "$source_dir/wasm-notices.py" scripts/wasm-notices.py
printf 'test license\n' > LICENSE
printf 'test notice\n' > NOTICE
printf '\0asm\r\0\1\0' > dist/plugin.fs.wasm
python3 scripts/wasm-notices.py embed dist/plugin.fs.wasm --license LICENSE --notice NOTICE
(cd dist && sha256sum plugin.fs.wasm > SHA256SUMS)
export APPROVED=true
export APPROVED_LICENSE_SHA256="$(sha256sum LICENSE | awk '{print $1}')"
export APPROVED_NOTICE_SHA256="$(sha256sum NOTICE | awk '{print $1}')"
# Re-run from a clean staging state for every failure case.
reject() {
  if bash "$script" > "$work/output" 2>&1; then
    echo 'approval gate accepted invalid licensing state' >&2
    exit 1
  fi
  test ! -e dist/LICENSE
  test ! -e dist/NOTICE
}
APPROVED=false reject
APPROVED_LICENSE_SHA256="$(printf '0%.0s' {1..64})" reject
APPROVED_NOTICE_SHA256="$(printf '0%.0s' {1..64})" reject
mv NOTICE saved-notice
reject
mv saved-notice NOTICE
printf 'changed\n' >> NOTICE
reject
printf 'test notice\n' > NOTICE
printf '\0asm\r\0\1\0' > dist/plugin.fs.wasm
(cd dist && sha256sum plugin.fs.wasm > SHA256SUMS)
reject  # A correctly checksummed WASM stripped of notices is still invalid.
python3 scripts/wasm-notices.py embed dist/plugin.fs.wasm --license LICENSE --notice NOTICE
(cd dist && sha256sum plugin.fs.wasm > SHA256SUMS)
bash "$script"
(cd dist && sha256sum --check SHA256SUMS)
echo 'CI candidate licensing gate tests passed'
