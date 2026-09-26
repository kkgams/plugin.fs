# plugin.fs pilot release checklist

No box here authorizes publication. Proposed Distribution Version `0.1.0`, WIT `gams:fs@1.2.0`, repo `kkgams/plugin.fs`, raw GHCR `ghcr.io/kkgams/gams/fs:0.1.0`.

- [x] Proposed Apache 2.0 root `LICENSE` and linked-code `NOTICE` are supplied for owner review; neither authorizes publication by itself.
- [x] Post-strip embedding and `scripts/wasm-notices.py` are implemented; the final raw WASM must pass exact-byte verification before upload. Release assets alone are insufficient.
- [x] Pinned `wkg` is provided in the separate release shell; extraction copies the workflow and docs.
- [ ] Owner has reviewed attribution, third-party inventory, and unresolved WASI WIT spec provenance/redistribution conditions before approving the exact license/notice bytes.
- [ ] Standalone Linux build/test and WASM validation pass; record run URL and exact source commit. `bash scripts/test-release-oci-preflight.sh` passes offline.
- [ ] Owner set `GAMS_FS_RELEASE_APPROVED=true`, `GAMS_FS_LICENSE_SHA256=$(sha256sum LICENSE | cut -d ' ' -f 1)`, and `GAMS_FS_NOTICE_SHA256=$(sha256sum NOTICE | cut -d ' ' -f 1)` as repository variables only after reviewing both exact files. Any byte change requires new approval.
- [ ] Owner confirmed repository `kkgams/plugin.fs`, tag `v0.1.0`, WIT version `1.2.0`, GHCR package policy/permissions, and no `latest` or WIT-only OCI tag.
- [ ] Branch manual `release.yml` verification passed without publication. Owner alone created the release tag after all blockers resolved.
- [ ] Release assets `plugin.fs.wasm`, `LICENSE`, `NOTICE` verify against `SHA256SUMS`; GHCR exact-version pull is byte-equal to the release WASM, with embedded licensing bytes verified again.
- [ ] If rerunning, an existing GitHub Release or differing OCI tag stops the workflow; owner resolves manually without replacing any version tag.

See [PUBLISHING.md](PUBLISHING.md) for detailed blockers and workflow behavior.
