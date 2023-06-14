use crate::macos_api;

#[derive(Clone, Debug)]
pub struct DeviceStatus {
    pub camera_in_use: bool,
    pub microphone_in_use: bool,
}

impl DeviceStatus {
    pub fn new() -> Self {
        DeviceStatus {
            camera_in_use: false,
            microphone_in_use: false,
        }
    }

    pub fn update_status(&mut self) {
        self.microphone_in_use = unsafe { macos_api::isMicrophoneInUse() };
        self.camera_in_use = unsafe { macos_api::isCameraInUse() };
        // println!("Microphone in use {}", self.microphone_in_use);
        // println!("Camera in use: {}", self.camera_in_use);
    }
}
