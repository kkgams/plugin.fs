#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
subject="$script_dir/release-oci-preflight.sh"
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

cat > "$tmp/curl" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail

body=''
headers=''
url=''
scope=''
authorization=''
while (($#)); do
  case "$1" in
    --output) body="$2"; shift 2 ;;
    --dump-header) headers="$2"; shift 2 ;;
    --data-urlencode)
      [[ "$2" == scope=* ]] && scope="${2#scope=}"
      shift 2
      ;;
    --header)
      [[ "$2" == Authorization:* ]] && authorization="$2"
      shift 2
      ;;
    --write-out|--user) shift 2 ;;
    --silent|--show-error|--get|--head) shift ;;
    *) url="$1"; shift ;;
  esac
done
: "${body:?missing mock response body path}"
: "${headers:?missing mock response header path}"

case "$url" in
  https://ghcr.io/v2/)
    if [[ "$MOCK_SCENARIO" == challenge_transport_failure ]]; then exit 7; fi
    : > "$body"
    if [[ "$MOCK_SCENARIO" == malformed_challenge ]]; then
      printf 'WWW-Authenticate: Basic realm="registry"\r\n' > "$headers"
    else
      printf 'WWW-Authenticate: Bearer realm="https://ghcr.io/token",service="ghcr.io",scope="repository:kkgams/gams/fs:pull"\r\n' > "$headers"
    fi
    if [[ "$MOCK_SCENARIO" == challenge_500 ]]; then printf 500; else printf 401; fi
    ;;
  https://ghcr.io/token)
    [[ "$scope" == 'repository:kkgams/gams/fs:pull' ]] || {
      echo "token request did not use the exact pull-only scope: $scope" >&2
      exit 98
    }
    if [[ "$MOCK_SCENARIO" == token_transport_failure ]]; then exit 6; fi
    : > "$headers"
    if [[ "$MOCK_SCENARIO" == malformed_token ]]; then
      printf '{"token":""}' > "$body"
    else
      printf '{"token":"read-only-token"}' > "$body"
    fi
    case "$MOCK_SCENARIO" in
      token_401) printf 401 ;;
      token_500) printf 500 ;;
      *) printf 200 ;;
    esac
    ;;
  https://ghcr.io/v2/kkgams/gams/fs/manifests/0.1.1)
    [[ "$authorization" == 'Authorization: Bearer read-only-token' ]] || {
      echo 'manifest lookup did not use the challenge token' >&2
      exit 97
    }
    if [[ "$MOCK_SCENARIO" == manifest_transport_failure ]]; then exit 28; fi
    : > "$body"
    : > "$headers"
    case "$MOCK_SCENARIO" in
      absent) printf 404 ;;
      manifest_401) printf 401 ;;
      manifest_403) printf 403 ;;
      manifest_500) printf 500 ;;
      *) printf 200 ;;
    esac
    ;;
  *)
    echo "unexpected mock URL: $url" >&2
    exit 99
    ;;
esac
MOCK

cat > "$tmp/wkg" <<'MOCK'
#!/usr/bin/env bash
set -euo pipefail
[[ "$1 $2 $3" == 'oci pull ghcr.io/kkgams/gams/fs:0.1.1' ]]
[[ "$4" == -o ]]
if [[ "$MOCK_SCENARIO" == identical ]]; then
  cp "$EXPECTED_ARTIFACT" "$5"
else
  printf different > "$5"
fi
MOCK
chmod +x "$tmp/curl" "$tmp/wkg" "$subject"
printf 'expected artifact bytes' > "$tmp/artifact.wasm"

run_success() {
  local scenario="$1" expected="$2"
  local output="$tmp/${scenario}.output"
  MOCK_SCENARIO="$scenario" \
  EXPECTED_ARTIFACT="$tmp/artifact.wasm" \
  CURL_BIN="$tmp/curl" \
  WKG_BIN="$tmp/wkg" \
  GITHUB_ACTOR=release-bot \
  GITHUB_TOKEN=test-token \
  GITHUB_OUTPUT="$output" \
    "$subject" ghcr.io/kkgams/gams/fs:0.1.1 "$tmp/artifact.wasm"
  grep -Fx "$expected" "$output" >/dev/null
}

run_failure() {
  local scenario="$1" expected_message="$2"
  local stderr="$tmp/${scenario}.stderr"
  if MOCK_SCENARIO="$scenario" \
    EXPECTED_ARTIFACT="$tmp/artifact.wasm" \
    CURL_BIN="$tmp/curl" \
    WKG_BIN="$tmp/wkg" \
    GITHUB_ACTOR=release-bot \
    GITHUB_TOKEN=test-token \
      "$subject" ghcr.io/kkgams/gams/fs:0.1.1 "$tmp/artifact.wasm" 2> "$stderr"; then
    echo "scenario unexpectedly succeeded: $scenario" >&2
    exit 1
  fi
  grep -F "$expected_message" "$stderr" >/dev/null
}

run_success absent should_push=true
run_success identical should_push=false
run_failure different 'already exists with different artifact bytes'
run_failure challenge_transport_failure 'transport layer'
run_failure challenge_500 'expected 401'
run_failure malformed_challenge 'malformed authentication challenge'
run_failure token_transport_failure 'transport layer'
run_failure token_401 'token request returned HTTP 401'
run_failure token_500 'token request returned HTTP 500'
run_failure malformed_token 'malformed token response'
run_failure manifest_transport_failure 'transport layer'
run_failure manifest_401 'manifest lookup returned HTTP 401'
run_failure manifest_403 'manifest lookup returned HTTP 403'
run_failure manifest_500 'manifest lookup returned HTTP 500'

echo 'release OCI preflight tests passed'
