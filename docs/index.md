---
title: Filesystem Proxy
description: Capability-bound filesystem operations for GAMS.
status: reference
---
# Filesystem Proxy

The filesystem proxy is a [GAMS](https://github.com/kkgams/gams) WASM Project Unit providing `gams:fs/fs@1.2.0`. It reads/writes text and binary files, lists/stats entries, creates/removes directories, renames and removes files within Host-preopened directories. Filesystem failures return WIT result errors; the plugin cannot broaden its preopened capabilities.

| Unit | Source / output | Original work |
| --- | --- | --- |
| Filesystem proxy | `src/component.c`, `src/wit/package.wit`; `build.nosync/plugin.fs.wasm` | GAMS contributors; WASI specification/runtime contributors |

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
| `make clean` | Remove all of `build.nosync/`, `tools/` and `gams_modules/`, including unmarked contents; refuse tracked files and symlinks before deleting anything. |

The Host downloads only when absent, retains its notices and is not updated implicitly. Local `gams.json` uses the built filesystem component with the published Files View and unchanged supporting pins. The native filesystem suite is not a Host GUI test.
