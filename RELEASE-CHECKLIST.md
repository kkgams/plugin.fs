# plugin.fs pilot release checklist

The owner has authorized proceeding with the `plugin.fs` publishing pilot and accepted responsibility for the licensing decision. That authorization is **not a record that CI has passed on the current commit**, and no GitHub approval variables, tags, or releases have been created by the assistant. Distribution Version `0.1.0`, WIT `gams:fs@1.2.0`, repo `kkgams/plugin.fs`, raw GHCR `ghcr.io/kkgams/gams/fs:0.1.0`.

- [x] The owner approved public CI artifact distribution of these exact Apache-2.0 root `LICENSE` and linked-code `NOTICE` bytes. The pinned hashes in `scripts/stage-ci-artifact.sh` prevent an unnoticed text change from uploading.
- [x] Post-strip embedding and `scripts/wasm-notices.py` are implemented; the final raw WASM must pass exact-byte verification before upload. Release assets alone are insufficient.
- [x] Pinned `wkg` is provided in the separate release shell; extraction copies the workflow and docs.
- [x] WASI WIT source and W3C CLA grant/mandatory name-and-version attribution identified in `THIRD-PARTY-REVIEW.md`; updated attribution included in `NOTICE`.
- [x] Owner authorized public CI artifacts based on the Apache-2.0/WASI WIT licensing assessment and accepted responsibility for the decision. GHCR/GitHub Release remains separately gated.
- [ ] Next `release` branch push successfully uploads a short-lived **public** GitHub Actions artifact from hosted Linux CI; download it, verify `SHA256SUMS` and embedded notices, and record the run URL and commit. `bash scripts/test-release-oci-preflight.sh` passes offline.
- [ ] Owner set `GAMS_FS_RELEASE_APPROVED=true`, `GAMS_FS_LICENSE_SHA256=$(sha256sum LICENSE | cut -d ' ' -f 1)`, and `GAMS_FS_NOTICE_SHA256=$(sha256sum NOTICE | cut -d ' ' -f 1)` as repository variables only after reviewing both exact files. Any byte change requires new approval.
- [ ] Owner confirmed repository `kkgams/plugin.fs`, tag `v0.1.0`, WIT version `1.2.0`, GHCR package policy/permissions, and no `latest` or WIT-only OCI tag.
- [ ] Branch manual `release.yml` verification passed without publication. Owner alone created the release tag after all blockers resolved.
- [ ] Release assets `plugin.fs.wasm`, `LICENSE`, `NOTICE` verify against `SHA256SUMS`; GHCR exact-version pull is byte-equal to the release WASM, with embedded licensing bytes verified again.
- [ ] If rerunning, an existing GitHub Release or differing OCI tag stops the workflow; owner resolves manually without replacing any version tag.

See [PUBLISHING.md](PUBLISHING.md) for detailed blockers and workflow behavior.
