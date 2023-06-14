#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudio.h>

BOOL isDeviceInUse(AVMediaType mediaType) {
    AVCaptureDeviceDiscoverySession *discoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInMicrophone, AVCaptureDeviceTypeExternalUnknown] mediaType:mediaType position:AVCaptureDevicePositionUnspecified];
    NSArray *devices = discoverySession.devices;

    for (AVCaptureDevice *device in devices) {
        if ([device isInUseByAnotherApplication]) {
            return YES;
        }
    }

    return NO;
}


BOOL isMicrophoneInUse() {
    AudioObjectPropertyAddress propertyAddress = {
        kAudioHardwarePropertyDevices,
        kAudioObjectPropertyScopeGlobal,
        kAudioObjectPropertyElementMain
    };
    
    UInt32 dataSize = 0;
    OSStatus status = AudioObjectGetPropertyDataSize(kAudioObjectSystemObject, &propertyAddress, 0, NULL, &dataSize);
    if (status != noErr) {
        NSLog(@"Error getting audio device list size: %d", status);
        return YES;
    }
    
    UInt32 deviceCount = dataSize / sizeof(AudioDeviceID);
    AudioDeviceID *deviceIDs = (AudioDeviceID *)malloc(dataSize);
    
    status = AudioObjectGetPropertyData(kAudioObjectSystemObject, &propertyAddress, 0, NULL, &dataSize, deviceIDs);
    if (status != noErr) {
        // NSLog(@"Error getting audio device list: %d", status);
        free(deviceIDs);
        return NO;
    }
    
    for (UInt32 i = 0; i < deviceCount; i++) {
        AudioDeviceID deviceID = deviceIDs[i];
        
        propertyAddress.mSelector = kAudioDevicePropertyDeviceIsAlive;
        UInt32 isAlive = 0;
        dataSize = sizeof(isAlive);
        status = AudioObjectGetPropertyData(deviceID, &propertyAddress, 0, NULL, &dataSize, &isAlive);
        if (status != noErr || !isAlive) {
            continue;
        }
        
        propertyAddress.mSelector = kAudioDevicePropertyDeviceIsRunningSomewhere;
        UInt32 isRunning = 0;
        dataSize = sizeof(isRunning);
        status = AudioObjectGetPropertyData(deviceID, &propertyAddress, 0, NULL, &dataSize, &isRunning);
        if (status != noErr || !isRunning) {
            continue;
        }
        
        propertyAddress.mSelector = kAudioDevicePropertyDeviceUID;
        CFStringRef deviceUID = NULL;
        dataSize = sizeof(deviceUID);
        status = AudioObjectGetPropertyData(deviceID, &propertyAddress, 0, NULL, &dataSize, &deviceUID);
        if (status != noErr) {
            continue;
        }
        
        // NSLog(@"Microphone is being used by device: %@", deviceUID);
        CFRelease(deviceUID);

        return YES;
    }
    
    free(deviceIDs);
    return NO;
}

BOOL isCameraInUse() {
    return isDeviceInUse(AVMediaTypeVideo);
}
