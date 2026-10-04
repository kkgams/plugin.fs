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

The owner approved the current exact `LICENSE` and `NOTICE` bytes for a public
CI candidate. Each push to `release` builds, tests, validates, checksums and
uploads `dist/plugin.fs.wasm` with both texts and `SHA256SUMS` as a short-lived
GitHub Actions artifact. `scripts/stage-ci-artifact.sh` pins both approved file
digests and verifies the raw WASM embeds those exact bytes; changes to either
file fail CI until explicitly reviewed and repinned. PRs never upload an artifact.
A CI artifact is downloadable distribution, **not** a GitHub Release or GHCR
package. The tag-only GHCR/GitHub Release workflow remains separately gated;
it has not been approved or published. See `LICENSING.md`, `PUBLISHING.md`,
`THIRD-PARTY-REVIEW.md`, and `RELEASE-CHECKLIST.md` before distribution.
