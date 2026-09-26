# plugin.fs Apache-2.0 pilot preparation

Independent extractions at `build.nosync/release/fs-apache-pilot-final/plugin.fs`
and, after the CLA attribution update,
`build.nosync/release/fs-cla-review/plugin.fs` passed on **Darwin arm64**:

- `nix develop 'path:$PWD' --command make test`: compiled the linked component,
  embedded full `LICENSE` and `NOTICE` *after stripping*, validated final WASM,
  ran eight notice-parser tests, and exercised the real component via jco;
- `nix develop 'path:$PWD#release' --command wkg --version`: pinned wkg 0.15.0;
- mocked GHCR and GitHub Release preflight tests, plus licensing approval tests
  including rejection of altered texts and a correctly checksummed raw WASM
  whose notices had been stripped; `stage-ci-artifact.sh` also staged the
  actual locally built WASM with exact pinned licensing digests;
- isolated `actionlint` for verify/release workflows; npm audit: zero findings.

The first `v0.1.0` tag-run reached the GHCR preflight step, but Linux Nix
building `wkg` failed **before any registry push**: upstream `crates/wkg/tests/e2e.rs`
`check` calls a public registry, while the Nix sandbox has no DNS/CA access.
The release shell now skips only that network-dependent test; its offline
Rust tests remain enabled. On Darwin arm64, Nix rebuilt the modified `wkg`
derivation successfully (`1 passed`, `1 filtered out`) and `wkg --version`
reported `0.15.0`; Linux evaluation confirms the same `checkFlags` and
`doCheck=1`. Hosted Linux confirmation of the corrected derivation is still
required. Neither the failed tag-run nor this local retest proves GHCR
publication or a GitHub Release.
The proposed Apache license digest and full NOTICE are owner-review inputs, not
owner approval. WASI WIT source and W3C CLA conditions have since been
identified and `NOTICE` revised; see `THIRD-PARTY-REVIEW.md`. The updated
independent build and exact embedded-notice verification pass (NOTICE SHA-256
`2d3ac85f8a3df5ff3a0e6e6c7da706d0ff4f18697fa68dc4a0b3ceaf3e05203c`).
No repository variables were enabled and no release or tag was published.
