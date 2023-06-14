#[link(name = "macos_api", kind = "static")]
extern "C" {
    pub fn isMicrophoneInUse() -> bool;
    pub fn isCameraInUse() -> bool;
}
