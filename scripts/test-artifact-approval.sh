#!/usr/bin/env bash
set -euo pipefail
unset APPROVED APPROVED_LICENSE_SHA256 APPROVED_NOTICE_SHA256
source_dir="$(cd "$(dirname "$0")" && pwd)"
script="$source_dir/check-artifact-approval.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
cd "$work"
mkdir dist scripts
cp "$source_dir/wasm-notices.py" "$source_dir/check-artifact-approval.sh" scripts/
printf 'test license\n' > LICENSE
printf 'test notice\n' > NOTICE
printf '\0asm\r\0\1\0' > dist/plugin.fs.wasm
python3 scripts/wasm-notices.py embed dist/plugin.fs.wasm --license LICENSE --notice NOTICE
(cd dist && sha256sum plugin.fs.wasm > SHA256SUMS)
# Re-run from a clean staging state for every failure case.
reject() {
  if bash "$script" > "$work/output" 2>&1; then
    echo 'payload gate accepted invalid licensing state' >&2
    exit 1
  fi
  test ! -e dist/LICENSE
  test ! -e dist/NOTICE
}
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
