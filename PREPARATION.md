# Preparation evidence

Historical source provenance and extraction hashes are recorded in `SOURCE.json`.

## Validation status

Run the commands below against the current checkout and record their results.
Historical extraction validation is not proof that the current checkout passes.

- Required command: `nix develop --command make test`
- Required artifact check: `nix develop --command wasm-tools validate dist/plugin.fs.wasm`
- `make test` runs the component through its independently transpiled JavaScript.

No timestamp or platform is asserted here because this generated repository does not
carry an independently established validation record for its current bytes.

## Release blockers

- Repository-owner license approval remains unresolved; see `LICENSING.md`.
- Third-party provenance, notices, source obligations, and artifact inventory need approval.
- Independent Linux CI evidence has not yet been recorded.
