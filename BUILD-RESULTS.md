# plugin.fs Apache-2.0 pilot preparation

An independent extraction at `build.nosync/release/fs-apache-pilot-final/plugin.fs`
passed on **Darwin arm64**:

- `nix develop 'path:$PWD' --command make test`: compiled the linked component,
  embedded full `LICENSE` and `NOTICE` *after stripping*, validated final WASM,
  ran eight notice-parser tests, and exercised the real component via jco;
- `nix develop 'path:$PWD#release' --command wkg --version`: pinned wkg 0.15.0;
- mocked GHCR and GitHub Release preflight tests, plus licensing approval tests
  including rejection of altered texts and a correctly checksummed raw WASM
  whose notices had been stripped;
- isolated `actionlint` for verify/release workflows; npm audit: zero findings.

This is **not** evidence of a Linux release-runner build or GHCR publication.
The proposed Apache license digest and full NOTICE are owner-review inputs, not
owner approval. WASI WIT source license provenance remains open; see
`THIRD-PARTY-REVIEW.md`. No repository variables were enabled and no release
or tag was published.
