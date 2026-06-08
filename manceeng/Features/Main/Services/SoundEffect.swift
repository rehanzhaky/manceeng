//
//  SoundEffect.swift
//  manceeng
//
//  Sound effect ringan memakai system sound bawaan iOS.
//
//  Created by M. Iqbal on 06/06/26.
//

import AVFoundation

enum SoundEffect {
    /// Suara shutter kamera bawaan iOS.
    static func cameraShutter() {
        #if os(iOS)
        AudioServicesPlaySystemSound(1108)
        #endif
    }
}
