fn main() {
    // build the macos_api static library
    cc::Build::new()
        .file("src/macos_api.m")
        .flag("-fobjc-arc")
        .compile("macos_api");

    // link macOS frameworks
    println!("cargo:rustc-link-lib=framework=AVFoundation");
    println!("cargo:rustc-link-lib=framework=Foundation");
    println!("cargo:rustc-link-lib=framework=CoreAudio");
}
