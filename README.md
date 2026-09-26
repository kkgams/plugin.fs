# plugin.fs

Standalone extraction of the GAMS filesystem proxy WebAssembly component. It
exports `gams:fs/fs@1.2.0` and accesses only directories preopened by its host.

## Build and verify

```sh
nix develop --command make test
```

The test transpiles the component with jco and exercises create, text/binary
read/write, list, stat, rename, and removal in a disposable directory. Build
output is `dist/plugin.fs.wasm` and is ignored by Git.

The `release` branch CI builds, tests, validates, and checksums `dist/plugin.fs.wasm`.
It does **not** upload the binary while distribution approval remains unset. The
short-lived CI candidate upload requires exact embedded Apache 2.0 `LICENSE` and
third-party `NOTICE` bytes in the final raw WASM, both matching
owner-approved repository variables `GAMS_FS_LICENSE_SHA256` and
`GAMS_FS_NOTICE_SHA256`, and `GAMS_FS_ARTIFACT_UPLOAD_APPROVED=true`.
Do not set these until the owner approves the exact text and artifact notice
packaging after a complete linked-code/third-party review.
A CI artifact is downloadable distribution, **not** a GitHub Release or GHCR
package. A separately gated, tag-only GHCR/GitHub Release pilot workflow is prepared but
**not approved or published**. See `LICENSING.md`, `PUBLISHING.md`,
`THIRD-PARTY-REVIEW.md`, and `RELEASE-CHECKLIST.md` before distribution.
