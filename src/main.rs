mod macos_api;
mod monitor;

use monitor::DeviceStatus;
use std::process::Command;
use std::thread;
use std::time::Duration;

fn main() {
    let mut device_status = DeviceStatus::new();

    loop {
        let previous_status = device_status.clone();
        device_status.update_status();

        if device_status.microphone_in_use != previous_status.microphone_in_use {
            let status = if device_status.microphone_in_use {
                "In Use"
            } else {
                "Not In Use"
            };
            println!("Microphone status changed: {}", status);
            display_notification("Microphone Status Changed", status);
        }

        if device_status.camera_in_use != previous_status.camera_in_use {
            let status = if device_status.camera_in_use {
                "In Use"
            } else {
                "Not In Use"
            };
            println!("Camera status changed: {}", status);
            display_notification("Camera Status Changed", status);
        }

        thread::sleep(Duration::from_secs(1));
    }
}

fn display_notification(title: &str, message: &str) {
    let _ = Command::new("osascript")
        .arg("-e")
        .arg(format!(
            "display notification \"{}\" with title \"{}\"",
            message, title
        ))
        .output();
}
