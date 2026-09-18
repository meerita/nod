//! Applies the kernel linker script.

fn main() {
    let Ok(manifest_dir) = std::env::var("CARGO_MANIFEST_DIR") else {
        println!("cargo::error=CARGO_MANIFEST_DIR is not set");
        std::process::exit(1);
    };
    println!("cargo:rerun-if-changed={manifest_dir}/link.ld");
    println!("cargo:rustc-link-arg=-T{manifest_dir}/link.ld");
}
