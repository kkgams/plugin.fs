#[cfg(test)]
mod tests {
    use wasmtime::component::{Component, Linker, ResourceTable};
    use wasmtime::{Config, Engine, Result, Store};
    use wasmtime_wasi::{DirPerms, FilePerms, WasiCtx, WasiCtxView, WasiView};
    wasmtime::component::bindgen!({ path: "../src/wit", world: "fs-proxy" });

    struct State { wasi: WasiCtx, table: ResourceTable }
    impl WasiView for State {
        fn ctx(&mut self) -> WasiCtxView<'_> {
            WasiCtxView { ctx: &mut self.wasi, table: &mut self.table }
        }
    }

    #[test]
    fn filesystem_operations() -> Result<()> {
        let root = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).parent().unwrap();
        let sandbox = root.join("build.nosync/fs-fixtures");
        std::fs::create_dir(&sandbox)?;
        struct Sandbox(std::path::PathBuf);
        impl Drop for Sandbox { fn drop(&mut self) { std::fs::remove_dir_all(&self.0).expect("remove test sandbox"); } }
        let _sandbox = Sandbox(sandbox.clone());
        let mut config = Config::new();
        config.wasm_component_model(true);
        let engine = Engine::new(&config)?;
        let component = Component::from_file(&engine, std::env::var("FS_COMPONENT_PATH")?)?;
        let mut linker = Linker::new(&engine);
        wasmtime_wasi::p2::add_to_linker_sync(&mut linker)?;
        let mut wasi = WasiCtx::builder();
        wasi.preopened_dir(&sandbox, "/", DirPerms::all(), FilePerms::all())?;
        let mut store = Store::new(&engine, State { wasi: wasi.build(), table: ResourceTable::new() });
        let bindings = FsProxy::instantiate(&mut store, &component, &linker)?;
        let fs = bindings.gams_fs_fs();
        fs.call_create_dir(&mut store, "data")?.unwrap();
        fs.call_write_text(&mut store, "data/hello.txt", "hello")?.unwrap();
        assert_eq!(fs.call_read_text(&mut store, "data/hello.txt")?.unwrap(), "hello");
        assert_eq!(fs.call_read_file(&mut store, "data/hello.txt")?.unwrap(), b"hello");
        assert_eq!(fs.call_stat(&mut store, "data/hello.txt")?.unwrap().type_, "regular-file");
        assert!(fs.call_list(&mut store, "data")?.unwrap().iter().any(|entry| entry.name == "hello.txt"));
        fs.call_rename(&mut store, "data/hello.txt", "data/world.txt")?.unwrap();
        fs.call_remove_file(&mut store, "data/world.txt")?.unwrap();
        fs.call_remove_dir(&mut store, "data")?.unwrap();
        Ok(())
    }
}
