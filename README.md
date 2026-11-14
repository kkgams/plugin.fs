# GAMS Filesystem Proxy

The filesystem proxy is a [GAMS](https://github.com/kkgams/gams) WASM Project Unit providing `gams:fs/fs@1.2.0`. It reads/writes text and binary files, lists/stats entries, creates/removes directories, renames and removes files within Host-preopened directories. Filesystem failures return WIT result errors; the plugin cannot broaden its preopened capabilities.

| Unit | Source / output | License | Original work |
| --- | --- | --- | --- |
| Filesystem proxy | `src/component.c`, `src/wit/package.wit`; `build.nosync/plugin.fs.wasm` | [Apache-2.0](LICENSE), full [third-party terms](NOTICE) | GAMS contributors; WASI specification/runtime contributors |

The raw component embeds complete LICENSE/NOTICE bytes as `gams.license` and `gams.notice`; preserve these when redistributing. Releases retain raw WASM on GitHub and `ghcr.io/kkgams/gams/fs:<numeric-version>`. Distribution versions do not change the WIT interface version.

## Development

Install Nix; run native commands with `nix develop --command make <target>`. The pinned flake supplies WASI SDK, binding tools and Rust; Cargo locks the native Wasmtime tests. Dependency-free Node runs only the pinned wiki engine.

| Command | Purpose |
| --- | --- |
| `make build` | Compile the filesystem component under `build.nosync/`. |
| `make package` | Build raw WASM, LICENSE, NOTICE and SHA256SUMS; unchanged output does no work. |
| `make test` | Exercise the separate test component with native Cargo/Wasmtime and disposable preopens. |
| `make open` | Build and open local `gams.json` in the released macOS Apple Silicon Host. |
| `make serve-docs` | Serve pinned wiki; independent `DOCS_PORT` defaults to 8080. |
| `make docs` | Build documentation into `build.nosync/site/`. |
| `make validate-docs` | Validate documentation. |
| `make clean` | Remove known generated output/docs and marked downloads; preserve supplied tools/Units and unidentified legacy output. |

The Host downloads only when absent, retains its notices and is not updated implicitly. Local `gams.json` uses the built filesystem component with the published Files View and unchanged supporting pins. The native filesystem suite is not a Host GUI test.
