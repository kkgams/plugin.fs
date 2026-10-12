## Current 0.2.1 release authorization

The owner's current instruction is: "no need for review of checksums / licenses - those area already prepared - drop pending reviews, commit changes, prepare tags - create script (using gh) to push to repos and create releases."

This supersedes earlier pending human checksum/license and hosted-review approvals
for the prepared 0.2.1 release. Documentation commits and annotated **local**
`v0.2.1` tags at the tested HEAD are authorized. No repeated human review is
pending for these unchanged prepared bytes. Prior "before any tag" restrictions,
including publisher migration, do not restrict local tagging.

This is not evidence of hosted Linux CI, GUI/Host consumption, registry visibility,
immutable policy, draft-first rehearsal or anonymous public-byte verification.
Those coverage gaps remain accurately unverified; publication technical checks
still apply. Version, source closure, evidence, exact license/notice digest and
candidate-byte gates remain strict. No source or legal evidence is refreshed.
No remote push/publication, repository variable or remote configuration change
is performed by this local preparation. Never move or overwrite an existing tag.

> Prepared target: `plugin.fs` v0.2.1; not yet published.
> The documentation below is a frozen historical record, not current
> pending approval requirements. Its human review/local-tag restrictions are
> superseded above; technical publication safeguards are not waived.

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
