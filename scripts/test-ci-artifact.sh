#!/usr/bin/env bash
set -euo pipefail
source_dir="$(cd "$(dirname "$0")/.." && pwd)"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
cd "$work"
mkdir -p dist scripts
cp "$source_dir/LICENSE" "$source_dir/NOTICE" .
cp "$source_dir/scripts/wasm-notices.py" scripts/
printf '\0asm\r\0\1\0' > dist/plugin.fs.wasm
python3 scripts/wasm-notices.py embed dist/plugin.fs.wasm --license LICENSE --notice NOTICE
checksum() { (cd dist && sha256sum plugin.fs.wasm > SHA256SUMS); }
reject() {
  if bash "$source_dir/scripts/stage-ci-artifact.sh" > "$work/out" 2>&1; then
    echo 'CI staging accepted invalid source/artifact bytes' >&2; exit 1
  fi
  test ! -e dist/LICENSE && test ! -e dist/NOTICE
}
checksum
printf 'unreviewed change\n' >> LICENSE
reject
cp "$source_dir/LICENSE" LICENSE
printf 'unreviewed change\n' >> NOTICE
reject
cp "$source_dir/NOTICE" NOTICE
printf '\0asm\r\0\1\0' > dist/plugin.fs.wasm
checksum
reject # Even a correctly checksummed WASM cannot omit its notices.
python3 scripts/wasm-notices.py embed dist/plugin.fs.wasm --license LICENSE --notice NOTICE
checksum
printf '\0' >> dist/plugin.fs.wasm
reject
printf '\0asm\r\0\1\0' > dist/plugin.fs.wasm
python3 scripts/wasm-notices.py embed dist/plugin.fs.wasm --license LICENSE --notice NOTICE
checksum
bash "$source_dir/scripts/stage-ci-artifact.sh"
(cd dist && sha256sum --check SHA256SUMS)
echo 'Approved CI artifact staging tests passed'
