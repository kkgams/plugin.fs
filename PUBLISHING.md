> **Prospective v0.2.0 maintenance preparation — NOT release-ready.**
> Target: `plugin.fs` v0.2.0, `plugin.fs.wasm`, `ghcr.io/kkgams/gams/fs:0.2.0`.
> Below is frozen historical documentation: existing GitHub Release URLs,
> versioned examples and repair instructions refer to their original releases.
> For a future v0.2.0 candidate, use the prepared distribution metadata;
> rebuild and run repository-owned locked toolchain/runtime tests, review
> source drift, linked evidence and exact LICENSE/NOTICE/candidate digests.
> Migrate the direct-release publisher to draft-first immutable-policy and
> exact public-byte verification before any tag/OCI push/Pages publication.
> Do not run the historical publishing commands as v0.2.0 instructions.

# plugin.fs pilot publishing

The owner authorized **public CI artifact distribution** of the current exact Apache-2.0/WASI WIT notice bytes and accepted responsibility for the licensing decision. This scaffold targets the standalone **`kkgams/plugin.fs`** repository. No approval variables or publication have been created by the assistant. The retry Distribution Version is **`0.1.1`** (tag `v0.1.1`), separate from WIT **`gams:fs@1.2.0`** (export `gams:fs/fs@1.2.0`). The proposed raw component location is **`ghcr.io/kkgams/gams/fs:0.1.1`**; no mutable `latest` tag is pushed. The GitHub Release would attach `plugin.fs.wasm`, `LICENSE`, `NOTICE`, and `SHA256SUMS` covering all three payload files.

## Safety contract

`release.yml` runs on `v*` tags and manual dispatch. A manual run on a branch verifies only: it cannot upload a release candidate, push GHCR, or create a Release. Both paths require the owner to set `GAMS_FS_RELEASE_APPROVED` to exactly `true`, and `GAMS_FS_LICENSE_SHA256` and `GAMS_FS_NOTICE_SHA256` to lowercase SHA-256 digests of nonempty root `LICENSE` and `NOTICE`, **before building**. On tag runs, the release job checks approval again. The tag must equal `v0.1.1`; runs in a repository other than `kkgams/plugin.fs` fail. These are proposal constants in the workflow, not a discovered version file; future versions require deliberate coordinated edits.

After testing and building, the workflow must validate the component and run `python3 scripts/wasm-notices.py verify dist/plugin.fs.wasm --license LICENSE --notice NOTICE`. The standalone Makefile now strips to an intermediate and embeds both exact files afterward; `make test` and both workflows verify their final raw-WASM bytes. Separate Release assets do not replace that check. `THIRD-PARTY-REVIEW.md` now identifies upstream WASI Preview 2 v0.2.0 sources and the W3C CLA copyright grant and mandatory name/version attribution. The owner must review that interpretation and exact updated `NOTICE` before approving distribution.

Only then can the tag candidate be staged and uploaded. The publish job downloads that run's candidate, verifies `SHA256SUMS`, rechecks notice embedding and approval, and refuses an existing GitHub Release. It logs into GHCR with the workflow token; the registry preflight uses a validated GHCR Bearer challenge, requests a pull-only token, and interprets only explicit manifest `404` as absent. For manifest `200`, it pulls the existing component and skips push only when bytes match exactly. Auth, malformed responses, transport failures, and any other HTTP status fail; differing existing bytes are never replaced. The published GitHub Release carries the checksum file and licensing assets. A retry with an already existing GitHub Release fails for owner review.

`verify.yml` is a separate branch candidate CI workflow, not this release workflow. Each `release` branch **push** now uploads a public candidate after checking the exact embedded LICENSE/NOTICE bytes against the owner-approved SHA-256 values pinned in `scripts/stage-ci-artifact.sh`; a missing or changed notice fails before upload. PR and manual runs do not upload. A CI candidate does **not** grant OCI release approval: GHCR/GitHub Release remains gated by its own repository variables.

## Owner-controlled enablement and remaining verification

- The owner's authorization of exact current CI artifact bytes is recorded in `RELEASE-CHECKLIST.md` and pinned in `scripts/stage-ci-artifact.sh`. The owner alone sets the exact `LICENSE` and `NOTICE` digest repository variables and the separate **release** approval variable using their GitHub credentials before GHCR/GitHub Release publication; the assistant does not set them. If either file changes, both the CI pins and release digest variables need deliberate re-review. See `THIRD-PARTY-REVIEW.md`.
- The release shell has pinned `wkg` 0.15.0, but its actual Linux release-path build, GitHub/GHCR credentials, registry/package visibility, and byte-equivalence behavior require hosted validation. The normal build shell does not have to build `wkg`.
- `packaging/ecosystem/components.py` copies this release workflow, scripts, and documentation into the prepared standalone `plugin.fs` repo. Keep pilot coordinates aligned with the repository name and WIT declaration.
- Record a successful clean standalone Linux verification run and its commit, then review all checks in [RELEASE-CHECKLIST.md](RELEASE-CHECKLIST.md) before the owner creates any tag. No publication has been attempted here.

## Owner execution order (only after syncing the verified `release` commit)

1. Push `release` and inspect the hosted Linux `verify.yml` result for that **exact commit**. A successful run uploads a public candidate automatically. Check the downloaded artifact's embedded notices and `SHA256SUMS`; neither release approval variable is needed for this branch artifact.
2. From the standalone repo, record `sha256sum LICENSE NOTICE` and set repository variables `GAMS_FS_LICENSE_SHA256` and `GAMS_FS_NOTICE_SHA256` to those **exact current** digests. Check GHCR package-write policy/visibility. Set `GAMS_FS_RELEASE_APPROVED=true` and manually run `release.yml` on `release`; it verifies on Linux but must **not** publish on a branch.
3. Only after successful hosted runs, the owner creates/pushes `v0.1.1` on that same verified commit. The tag run is publication-capable: review its GHCR artifact, GitHub Release assets, checksums and raw-WASM notices. Do not create a tag simply to test the scaffold.

The first `v0.1.0` tag run failed before GHCR push when Nix built `wkg`: its upstream registry-dependent integration test cannot run inside the Linux build sandbox. The release shell now skips just that test; the pushed `v0.1.0` tag still points to the *old* commit. Do **not** force-move that tag or assume rerunning its historical workflow will pick up branch fixes. The retry uses coordinated workflow, test, release preflight and OCI coordinates at **0.1.1**. Host CI must still prove the corrected Linux release-shell build before the owner pushes `v0.1.1`.

Offline safety checks: `bash scripts/test-release-oci-preflight.sh`, `bash scripts/test-release-absent.sh`, and `bash scripts/test-artifact-approval.sh`. Revoke/disable the approval variables when the pilot is done if they are not intended to remain active. If either notice file changes, **re-review and reset its approved digest before another distribution**.
