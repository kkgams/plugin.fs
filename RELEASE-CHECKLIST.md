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

# plugin.fs pilot release checklist

The owner authorized the `plugin.fs` publishing pilot and accepted responsibility for the licensing decision. The `v0.1.0` tag run failed during Nix's `wkg` build, before GHCR push; **do not move/reuse that tag**. Retry Distribution Version `0.1.1`, WIT `gams:fs@1.2.0`, repo `kkgams/plugin.fs`, raw GHCR `ghcr.io/kkgams/gams/fs:0.1.1`. No approval variables or releases have been created by the assistant.

- [x] The owner approved public CI artifact distribution of these exact Apache-2.0 root `LICENSE` and linked-code `NOTICE` bytes. The pinned hashes in `scripts/stage-ci-artifact.sh` prevent an unnoticed text change from uploading.
- [x] Post-strip embedding and `scripts/wasm-notices.py` are implemented; the final raw WASM must pass exact-byte verification before upload. Release assets alone are insufficient.
- [x] Pinned `wkg` is provided in the separate release shell; extraction copies the workflow and docs.
- [x] WASI WIT source and W3C CLA grant/mandatory name-and-version attribution identified in `THIRD-PARTY-REVIEW.md`; updated attribution included in `NOTICE`.
- [x] Owner authorized public CI artifacts based on the Apache-2.0/WASI WIT licensing assessment and accepted responsibility for the decision. GHCR/GitHub Release remains separately gated.
- [x] `0cf57bf` release-branch push uploaded a public candidate; its downloaded `SHA256SUMS`, embedded notice bytes and WASM validation passed locally (workspace `verification/plugin.fs-ci-0cf57bf-candidate-review.md`).
- [ ] Corrected `wkg` release shell builds on hosted Linux. Run `release.yml` manually on the new `release` commit to verify without publication; record the run URL/commit before creating any new tag.
- [ ] Owner set `GAMS_FS_RELEASE_APPROVED=true`, `GAMS_FS_LICENSE_SHA256=$(sha256sum LICENSE | cut -d ' ' -f 1)`, and `GAMS_FS_NOTICE_SHA256=$(sha256sum NOTICE | cut -d ' ' -f 1)` as repository variables only after reviewing both exact files. Any byte change requires new approval.
- [ ] Owner confirmed repository `kkgams/plugin.fs`, **new** tag `v0.1.1`, WIT version `1.2.0`, GHCR package policy/permissions, and no `latest` or WIT-only OCI tag.
- [ ] Branch manual `release.yml` verification passed without publication. Owner alone created the release tag after all blockers resolved.
- [ ] Release assets `plugin.fs.wasm`, `LICENSE`, `NOTICE` verify against `SHA256SUMS`; GHCR exact-version pull is byte-equal to the release WASM, with embedded licensing bytes verified again.
- [ ] If rerunning, an existing GitHub Release or differing OCI tag stops the workflow; owner resolves manually without replacing any version tag.

See [PUBLISHING.md](PUBLISHING.md) for detailed blockers and workflow behavior.
