# Licensing and redistribution gate

Proposed first-party license for `plugin.fs`: **Apache License 2.0**. The root
`LICENSE` contains the exact unmodified Apache 2.0 text downloaded from
`https://www.apache.org/licenses/LICENSE-2.0.txt` (SHA-256
`cfc7749b96f63bd31c3c42b5c471bf756814053e847c10f3eb003417bc523d30`).
The root `NOTICE` includes proposed GAMS copyright attribution and the reviewed
third-party texts; see `THIRD-PARTY-REVIEW.md` for scope and the identified
W3C CLA grant/attribution conditions for WASI 0.2 specification WIT.
This does not retroactively relicense unrelated plugins or Director Compiler.

**Before a public CI artifact, GHCR push, or GitHub Release:** the owner must
approve the exact `LICENSE` and `NOTICE` bytes, copyright attribution, the
WASI WIT specification classification/CLA attribution, and complete applicable
third-party obligations. Approval must be
recorded in the repository variables named in `PUBLISHING.md`. Do not set them
speculatively. Local builds and non-uploading CI verification are allowed while
these distribution gates remain unset.

Raw WASM now embeds both exact files after stripping, in custom sections named
`gams.license` and `gams.notice`; uploading a component stripped again after the
embedding step would remove the notices and fail the verification gate.

This is an engineering preparation, not legal advice or final distribution approval.
