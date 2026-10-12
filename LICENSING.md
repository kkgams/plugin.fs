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

# Licensing and redistribution

Owner-approved first-party license for the current `plugin.fs` pilot: **Apache License 2.0**. The root
`LICENSE` contains the exact unmodified Apache 2.0 text downloaded from
`https://www.apache.org/licenses/LICENSE-2.0.txt` (SHA-256
`cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30`).
The root `NOTICE` includes proposed GAMS copyright attribution and the reviewed
third-party texts; see `THIRD-PARTY-REVIEW.md` for scope and the identified
W3C CLA grant/attribution conditions for WASI 0.2 specification WIT.
This does not retroactively relicense unrelated plugins or Director Compiler.

The owner authorized public CI distribution of the current exact `LICENSE` and
`NOTICE` bytes, accepting responsibility for their attribution and WASI WIT
analysis. Their SHA-256 digests are pinned in `scripts/stage-ci-artifact.sh`;
release-branch pushes upload only if the final WASM embeds both approved files.
Changed licensing bytes fail until the owner reviews and repins them.

**GHCR and GitHub Release publication remains separate**: the owner must set
the exact digest variables and `GAMS_FS_RELEASE_APPROVED=true` as specified in
`PUBLISHING.md` before a release tag can publish. The assistant has not set
variables, pushed a tag, or published a release.

Raw WASM now embeds both exact files after stripping, in custom sections named
`gams.license` and `gams.notice`; uploading a component stripped again after the
embedding step would remove the notices and fail the verification gate.

This is an engineering preparation, not legal advice or final distribution approval.
