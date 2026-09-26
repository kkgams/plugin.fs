# plugin.fs pilot publishing

The owner authorized proceeding with the Apache-2.0/WASI WIT publishing pilot and accepted responsibility for the licensing decision. This scaffold targets the standalone **`kkgams/plugin.fs`** repository. No approval variables, tags, or publication have been created by the assistant. The proposed Distribution Version is **`0.1.0`** (tag `v0.1.0`), separate from WIT **`gams:fs@1.2.0`** (export `gams:fs/fs@1.2.0`). The proposed raw component location is **`ghcr.io/kkgams/gams/fs:0.1.0`**; no mutable `latest` tag is pushed. The GitHub Release would attach `plugin.fs.wasm`, `LICENSE`, `NOTICE`, and `SHA256SUMS` covering all three payload files.

## Safety contract

`release.yml` runs on `v*` tags and manual dispatch. A manual run on a branch verifies only: it cannot upload a release candidate, push GHCR, or create a Release. Both paths require the owner to set `GAMS_FS_RELEASE_APPROVED` to exactly `true`, and `GAMS_FS_LICENSE_SHA256` and `GAMS_FS_NOTICE_SHA256` to lowercase SHA-256 digests of nonempty root `LICENSE` and `NOTICE`, **before building**. On tag runs, the release job checks approval again. The tag must equal `v0.1.0`; runs in a repository other than `kkgams/plugin.fs` fail. These are proposal constants in the workflow, not a discovered version file; future versions require deliberate coordinated edits.

After testing and building, the workflow must validate the component and run `python3 scripts/wasm-notices.py verify dist/plugin.fs.wasm --license LICENSE --notice NOTICE`. The standalone Makefile now strips to an intermediate and embeds both exact files afterward; `make test` and both workflows verify their final raw-WASM bytes. Separate Release assets do not replace that check. `THIRD-PARTY-REVIEW.md` now identifies upstream WASI Preview 2 v0.2.0 sources and the W3C CLA copyright grant and mandatory name/version attribution. The owner must review that interpretation and exact updated `NOTICE` before approving distribution.

Only then can the tag candidate be staged and uploaded. The publish job downloads that run's candidate, verifies `SHA256SUMS`, rechecks notice embedding and approval, and refuses an existing GitHub Release. It logs into GHCR with the workflow token; the registry preflight uses a validated GHCR Bearer challenge, requests a pull-only token, and interprets only explicit manifest `404` as absent. For manifest `200`, it pulls the existing component and skips push only when bytes match exactly. Auth, malformed responses, transport failures, and any other HTTP status fail; differing existing bytes are never replaced. The published GitHub Release carries the checksum file and licensing assets. A retry with an already existing GitHub Release fails for owner review.

`verify.yml` is a separate branch candidate CI workflow, not this release workflow. It also checks the exact embedded LICENSE/NOTICE bytes before allowing the separately approved CI artifact upload. A CI candidate still does not grant OCI release approval; the two approval booleans are distinct.

## Owner-controlled enablement and remaining verification

- The owner's authorization to proceed is recorded in `RELEASE-CHECKLIST.md`. The owner must set the exact `LICENSE` and `NOTICE` SHA-256 repository variables and explicit upload/release approval variables using their GitHub credentials; the assistant does not set them. If either file changes, the approvals must be updated deliberately before distribution. See `THIRD-PARTY-REVIEW.md`.
- The release shell has pinned `wkg` 0.15.0, but its actual Linux release-path build, GitHub/GHCR credentials, registry/package visibility, and byte-equivalence behavior require hosted validation. The normal build shell does not have to build `wkg`.
- `packaging/ecosystem/components.py` copies this release workflow, scripts, and documentation into the prepared standalone `plugin.fs` repo. Keep pilot coordinates aligned with the repository name and WIT declaration.
- Record a successful clean standalone Linux verification run and its commit, then review all checks in [RELEASE-CHECKLIST.md](RELEASE-CHECKLIST.md) before the owner creates any tag. No publication has been attempted here.

## Owner execution order (only after syncing the verified `release` commit)

1. Push `release` and inspect the hosted Linux `verify.yml` result for that **exact commit**. Neither approval boolean should be set merely to test the branch build.
2. From the standalone repo, record `sha256sum LICENSE NOTICE` and set repository variables `GAMS_FS_LICENSE_SHA256` and `GAMS_FS_NOTICE_SHA256` to those **exact current** digests. Set `GAMS_FS_ARTIFACT_UPLOAD_APPROVED=true`, then manually rerun `verify.yml` on `release` and inspect the downloadable candidate, embedded notices, and `SHA256SUMS`.
3. Check GHCR package-write policy/visibility. Set the distinct `GAMS_FS_RELEASE_APPROVED=true` variable and manually run `release.yml` on `release`; it verifies on Linux but must **not** publish on a branch.
4. Only after successful hosted runs, the owner creates/pushes `v0.1.0` on that same verified commit. The tag run is publication-capable: review its GHCR artifact, GitHub Release assets, checksums and raw-WASM notices. Do not create a tag simply to test the scaffold.

Offline safety checks: `bash scripts/test-release-oci-preflight.sh`, `bash scripts/test-release-absent.sh`, and `bash scripts/test-artifact-approval.sh`. Revoke/disable the approval variables when the pilot is done if they are not intended to remain active. If either notice file changes, **re-review and reset its approved digest before another distribution**.
