#!/usr/bin/env bash
set -euo pipefail
script="$(cd "$(dirname "$0")" && pwd)/check-release-absent.sh"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT
cat > "$work/curl" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
[[ "$*" == *'https://api.github.com/repos/kkgams/plugin.fs/releases/tags/v0.2.0'* ]] || exit 9
case "$TEST_STATUS" in
  transport) exit 7 ;;
  *) printf '%s' "$TEST_STATUS" ;;
esac
SH
chmod +x "$work/curl"
export CURL_BIN="$work/curl" GH_TOKEN=fake GITHUB_REPOSITORY=kkgams/plugin.fs GITHUB_REF_NAME=v0.2.0
TEST_STATUS=404 bash "$script"
for status in 200 401 403 500 transport; do
  if TEST_STATUS="$status" bash "$script" >"$work/out" 2>&1; then
    echo "Unsafe acceptance of release lookup status: $status" >&2; exit 1
  fi
done
if GITHUB_REPOSITORY=attacker/repo TEST_STATUS=404 bash "$script" >"$work/out" 2>&1; then
  echo 'Unsafe repository acceptance' >&2; exit 1
fi
echo 'GitHub Release absence preflight tests passed'
