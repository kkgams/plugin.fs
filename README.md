## Current tag-based release authorization

Pushing the matching version tag authorizes release in this repository. No manual
checksum variables, approval boolean, hosted-review approval, or `release`-branch
HEAD match is required. Branch candidates still validate their payloads; they do
not publish a GitHub Release or OCI version. Manual branch runs verify only.

Repository/tag/version and WIT identity checks, build/runtime tests, source and
build-evidence checks, nonempty LICENSE/NOTICE, exact embedded licensing bytes,
generated SHA256SUMS, independent candidates, and GitHub Release/OCI no-overwrite
checks remain required. The workflow uses the automatic GitHub token. Never move
or overwrite an existing version tag. Pages publication remains independent.

This policy supersedes historical approval-variable and pre-tag review/branch
requirements below, not source provenance or legal terms. It does not claim hosted
validation or authorize this editing session to commit, push, tag, or publish.
No source snapshots, legal texts, or historical evidence are refreshed.

> Prepared target: `plugin.fs` v0.2.1; not yet published.
> The documentation below is a frozen historical record, not current
> pending approval requirements. Its manual approval/checksum and pre-tag
> review/branch requirements are superseded above; content checks remain.

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

## Local Project and documentation

```sh
nix develop --command make open
make serve-docs                 # http://localhost:8080; override DOCS_PORT
make validate-docs
make docs                       # portable site under build/site/
```

`make open` builds the component and opens this repository's `gams.json` with
explicit `GAMS_APP_CWD`. If absent, `tools/gams.app` is downloaded from the latest
GAMS macOS Apple Silicon release, with its accompanying notices retained.
An existing download is never updated implicitly; Gatekeeper is not bypassed.
No neighboring checkout is required. First launch needs network access for the
Project's pinned published dependencies.

The local Project loads the built plugin and the published Files View to browse
Project files. It is not a plugin-specific editor or an API/runtime test.
The wiki uses pinned `justgook/wiki` v1.4.0, cached under ignored `build/`.
GitHub Pages builds with `make docs` on every push to `release`, independently of
component releases. Set Pages source to **GitHub Actions** in repository settings.
