# plugin.fs context

## Language

**Filesystem Proxy**: The singleton WASM Plugin built by this repository. It exposes
`gams:fs/fs@1.2.0` and translates its operations to WASI filesystem operations.

**Preopened Directory**: A Host-granted WASI directory capability. It defines the
filesystem boundary visible to the Filesystem Proxy; the Plugin does not receive
ambient access to arbitrary Host paths.

**Plugin Path**: A string passed to a Filesystem Proxy operation and resolved through
the component's WASI preopens.

**Directory Entry**: The name and type returned by `list` for one immediate child.

**File Stat**: File type, byte size, and WASI-provided access, modification, and
creation timestamps returned by `stat`.

## Relationships and boundaries

- The Filesystem Proxy reads, writes, lists, stats, renames, and removes paths inside
  Host-provided Preopened Directories.
- The Host owns selection and permissions of preopens; this Plugin does not discover
  or broaden them.
- The Plugin returns filesystem failures through WIT `result` errors.
- The distribution artifact is `dist/plugin.fs.wasm`; Project installation maps it
  to `plugins/fs.comp.wasm`.
