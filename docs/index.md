---
title: plugin.fs
description: Local development and Project launch.
status: reference
---

# plugin.fs

Provides the filesystem proxy `gams:fs/fs@1.2.0`. Read and write text or
binary files, list directories, inspect file metadata, rename entries and remove
files within directories preopened by the Host. Plugin paths cannot broaden
those capabilities; filesystem failures return WIT result errors.

Develop with `nix develop --command make test`; output is
`dist/plugin.fs.wasm`. The test transpiles the component with jco and exercises
filesystem operations in a disposable directory. The local Project uses this
built component for the published Files View.

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

The component API and release safeguards remain documented in the repository README.
