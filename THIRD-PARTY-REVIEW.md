# plugin.fs WebAssembly third-party review (Apache-2.0 pilot)

## Scope and status

This engineering inventory began with the standalone source snapshot at
`/Users/gook/Repos/kkgams-local/plugin.fs` and its **then-current**
`dist/plugin.fs.wasm` (historical SHA-256
`1cb9292fef8906180374134d79664e66204e3eecf833c2d72b1ba659073b14e3`).
Rebuilds after embedding notices have different bytes; repeat the inventory on
release builders.
It is not a review of the repository's `node_modules`, generated test JS, or
other plugins. `NOTICE` contains third-party notices for linked or conservatively
embedded material. The proposed Apache-2.0 `LICENSE` has since been supplied from the official
text (https://www.apache.org/licenses/LICENSE-2.0.txt), but still requires owner
approval and confirmation of rights to GAMS-authored files; this audit does not
authorize publication. `LICENSING.md` says not to publish pending that review.

**No Odin or Lua notice belongs in this component.** `src/` contains one
project C implementation, `plugin.mk`, a project WIT file and three WASI WIT
dependency packages; no `src/vendor`, `.odin`, or Lua sources. `config.mk` sets
`HAS_ODIN=0` and `HAS_LUA=0`. The common build shell happens to carry Odin,
but this particular Makefile's selected source list is only `src/component.c`,
generated `build/bindings/fs_proxy.c` and the generated component-type object.
There is no Odin core object in the link.

## Linked SDK code: observed evidence

`flake.nix` pins release `wasi-sdk-33` (`33.0`) by platform-specific archive
hash, `wit-bindgen` 0.57.1, and `wasm-tools` 1.248.0. On the inspected macOS
arm64 shell the SDK's `VERSION` reads `33.0+m`, `wasi-libc: 161b3195fc25`,
`llvm: 4434dabb6991`, `llvm-version: 22.1.0`, `config: f992bcc08219`.
The SDK uses `wasm-component-ld 0.5.22`. The SDK release source tag
`wasi-sdk-33` peels to `c10c0507deb3e5aad506f1f9f32084e49a21834b`;
its wasi-libc submodule is
`161b3195fc2558d2b1ba3eb9ffae3b2b47407623` (also tag `wasi-sdk-33`).
The notice copies the latter commit's `LICENSE`, `LICENSE-MIT`,
`libc-top-half/musl/COPYRIGHT`, and the opening notice from
`dlmalloc/src/malloc.c` verbatim (apart from section headings). wasi-libc's
multi-license inventory permits selecting the MIT option for wasi-libc-authored
code; the separate source licenses remain applicable.

Re-linking exactly the Makefile's C inputs and flags with an added link map
found `crt1-reactor.o` plus these **selected** `libc.a` members:

```text
__init_tls.c.obj  abort.c.obj  default_attr.c.obj  defsysinfo.c.obj
pthread_self.c.obj  errno.c.obj  sbrk.c.obj  dlmalloc.c.obj
memcmp.c.obj  strlen.c.obj
```

The map resolves `memcmp.c.obj` and `strlen.c.obj` from the musl-derived
`libc-top-half/musl/src/string` sources, and `dlmalloc.c.obj` from dlmalloc.
`errno.c.obj` corresponds to `libc-bottom-half/sources/errno.c` (the
`__EINVAL`/`__ENOMEM` definitions used by dlmalloc), not Cloudlibc's errno.
`crt1-reactor.o` and the other selected objects use wasi-libc-authored code;
`NOTICE` therefore includes the wasi-libc MIT option, musl's **full** COPYRIGHT,
and dlmalloc's complete opening CC0/public-domain attribution. The inventory
mentions cloudlibc, emmalloc and musl-fts, but none of their implementation
objects is selected: no additional notices for these are asserted necessary.
No `libclang_rt.builtins.a` member appears in the map: the SDK compiler-rt
archive is available to the driver but contributes no linked code on this
re-link. Accordingly no separate LLVM/compiler-rt notice is included for it.
Headers and LLVM compiler executables alone do not justify runtime notices.

## Component linker, bindings and adapter

`wasm-component-ld` v0.5.22 (upstream commit
`c9e38b9bc181ce7a4f8b3d21edb48c47ddf197de`) encodes the component;
`wit-bindgen` v0.57.1 (locked commit
`2e00369a643c0c8048b8636401e36b0cbf2dfb05`) generates C bindings and
component-type data. Their upstream `LICENSE-MIT` texts are byte-identical.
The common exact MIT text is included **conservatively** for generated C
support and linker-synthesized component support that may remain in the WASM,
not for the whole CLI executables or their dependency closures. Unbundling the
unstripped component reports core module 0 with `wit-bindgen-c [0.57.1]` and
`wit-component [0.247.0]` producer metadata, plus three very small
`wit-component [0.246.2]`-processed modules and one 24-byte empty module.
Producer metadata alone does not prove every byte of a generator is embedded.

**Unlike the Director compiler, fs does not contain the Wasmtime Preview 1
reactor adapter.** Its generated core imports are directly named
`wasi:filesystem/types@0.2.0`, `wasi:filesystem/preopens@0.2.0`, etc.; the
component's imports are WASI Preview 2 instances. Neither source nor final
component has `wasi_snapshot_preview1` imports, and unbundling finds no
Rust-produced ~10 KB reactor module. `-mexec-model=reactor` specifies the
C start model, not proof of a Preview 1 adapter. The linker *can* inject a
Wasmtime adapter when required, but does not here. Therefore **do not copy**
Director's Wasmtime Apache-with-LLVM-exception or Rust runtime MIT notices.
If imports or linker behavior change, reassess against the resulting artifact.

`wasm-tools` strips/validates; Clang, `wasm-ld`, Odin, Nix, npm/jco, Node and
their host dependencies are build/test tools, not distributed runtime code in
`dist/plugin.fs.wasm`. `build/jco` JS and `node_modules` are not part of this
artifact review; distributing them requires a separate inventory.

## Source-distribution and remaining provenance questions

- `src/wit/deps/wasi-{clocks,filesystem,io}-0.2.0/package.wit` contain WASI
  interface declarations and commentary, not executable vendor C. Their
  interfaces and retained descriptions correspond to upstream WASI v0.2.0
  packages at `WebAssembly/wasi-clocks` commit
  `8d875dfb5fbdcc28f450d9003ea87591ee372f4e`, `wasi-filesystem` commit
  `e79b05803e9ffd3b0cfdc0a8af20ac743abbe36a`, and `wasi-io` commit
  `324be895965666805cb1c622ed4f071b9e3cbd65` (all tag `v0.2.0`).
  These bundled `package.wit` files are **abbreviated/adapted**, not byte-for-byte
  copies of upstream full WIT files. Earlier review only looked for LICENSE files
  in the individual proposal repositories and missed a better source: the
  [WebAssembly/WASI `v0.2.0` release](https://github.com/WebAssembly/WASI/tree/v0.2.0)
  has [`LICENSE.md`](https://github.com/WebAssembly/WASI/blob/v0.2.0/LICENSE.md)
  explicitly identifying the W3C Community Contributor License Agreement (CLA).
  Its [`preview2/README.md`](https://github.com/WebAssembly/WASI/blob/v0.2.0/preview2/README.md)
  identifies the clocks, filesystem, and io WIT APIs as WASI Preview 2 version
  `0.2.0`. Byte comparisons confirm its `preview2/clocks/wall-clock.wit`,
  `preview2/filesystem/types.wit`, and `preview2/io/streams.wit` are identical
  to the respective individual proposal-repository `v0.2.0` sources. The
  absence of a license file in the historical clocks/filesystem *proposal*
  repositories is therefore not evidence that the published WASI 0.2 WIT
  specifications are unlicensed.

  [W3C CLA §2.1](https://www.w3.org/community/about/process/cla/) grants
  recipients permission to reproduce, adapt, sublicense, distribute, and
  implement *Contributions to the Specification*; §2.2 requires derivative
  works to identify the Specification by **name and version**. The proposed
  `NOTICE` identifies WASI Preview 2 / WASI 0.2 and the three WIT packages
  at `0.2.0`, records that their WIT was abbreviated/adapted, and preserves
  the upstream copyright text. The CLA §1 excludes source code *outside* the
  Specification: this analysis relies on these WIT API declarations and their
  documentation being part of the WASI Preview 2 Specification, as described
  in its README. It is not a blanket license for arbitrary code in the repos.
  Do not infer that the generated bindings' MIT notice or GAMS's Apache
  license grants rights over upstream WIT. Owner review of this documented
  interpretation and exact attribution is still required; seek counsel if the
  classification of any particular adapted text remains disputed.
- Project-owned `src/component.c`, `src/wit/package.wit`, generated outputs
  and extracted snapshot still require owner approval of the project license;
  the owner should replace the current no-license warning in the eventual
  standalone release through the authorized preparation process.
- `wasm-component-ld` is installed by the SDK; SDK source uses
  `cargo install wasm-component-ld@0.5.22` without an explicit `--locked`.
  Version, linked imports and module metadata support the above conclusions,
  but transformed internal modules cannot be whole-file matched to a crate
  artifact. A fully attestable source-to-binary chain needs an upstream
  attestation or reproducible/pinned component-linker build.
- Only the arm64 macOS SDK was byte-inspected. Four separate platform archives
  are pinned in the flake. Repeat VERSION, map and component checks on release
  builders (especially Linux), and re-audit on any source/toolchain pin change.
- For MIT/musl notices preserve copyright and permission text with binary
  distributions; carry source headers and attribution when shipping source.
  The dlmalloc notice records the CC0/public-domain dedication; verify any
  applicable source-preservation duties when shipping its sources. The
  project's Apache-2.0 license/NOTICE handling is a separate owner decision.

This is technical provenance analysis with explicit uncertainty, **not legal
advice or legal approval**.

## Reproduction (scratch outputs only)

From `/Users/gook/Repos/kkgams-local/plugin.fs` on macOS in its locked shell:

```sh
sha256sum dist/plugin.fs.wasm
nix develop 'path:.' --command bash -c '
  cat "$WASI_SDK_PATH/VERSION"; wasm-component-ld --version
  wasm32-wasip2-clang -o /tmp/plugin-fs-review.wasm -mexec-model=reactor \
    -Ibuild/bindings -O2 -DNDEBUG build/bindings/fs_proxy.c \
    src/component.c build/bindings/fs_proxy_component_type.o \
    -Wl,--strip-all -Wl,-Map,/tmp/plugin-fs-review.map
  grep -E "libc[.]a|clang_rt|crt1-reactor" /tmp/plugin-fs-review.map
'
# Raw re-link bytes need not match a stripped release component:
nix develop 'path:.' --command wasm-tools strip -a \
  /tmp/plugin-fs-review.wasm -o /tmp/plugin-fs-review-stripped.wasm
sha256sum /tmp/plugin-fs-review-stripped.wasm dist/plugin.fs.wasm
mkdir -p /tmp/fs-review-unbundle
nix develop 'path:.' --command wasm-tools component unbundle \
  --threshold 0 --module-dir /tmp/fs-review-unbundle \
  build/plugin.fs.unstripped.wasm -o /tmp/fs-review-unbundle/component.wasm
for m in /tmp/fs-review-unbundle/unbundled-module*.wasm; do
  nix develop 'path:.' --command wasm-tools metadata show "$m"
done
nix develop 'path:.' --command wasm-tools print dist/plugin.fs.wasm \
  | grep -E 'wasi_snapshot_preview1|wasi:filesystem|core module' | head -30
```

For a clean independent check, run `nix develop 'path:.' --command make clean
test` in a **copy** of the standalone repository, then repeat the link map;
never run `make clean` against the evidence source snapshot. Compare the
upstream NOTICE sections against the pinned raw URLs listed in `NOTICE`.
