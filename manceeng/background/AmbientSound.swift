//
//  AmbientSound.swift
//  Challenge3
//
//  Memutar musik latar (background_music.mp3) saat aplikasi mulai digunakan,
//  dan menyediakan sound effect saat tombol ditekan (pakai system sound iOS).
//

import AVFoundation
import Combine

final class AmbientSound: ObservableObject {
    private var player: AVAudioPlayer?

    /// Nama file musik latar yang ada di bundle (tanpa ekstensi).
    private let musicName = "background_music"
    private let musicExt = "mp3"

    init() {
        prepare()
    }

    private func prepare() {
        guard let url = Bundle.main.url(forResource: musicName, withExtension: musicExt) else {
            print("AmbientSound: file \(musicName).\(musicExt) tidak ditemukan di bundle")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1   // loop terus
            player?.volume = 0           // mulai dari 0 untuk fade-in
            player?.prepareToPlay()
        } catch {
            print("AmbientSound: gagal load musik: \(error)")
        }
    }

    func start() {
        configureSession()
        guard let player else { return }
        player.play()
        // Fade-in volume halus selama 2 detik.
        player.setVolume(0.7, fadeDuration: 2)
    }

    func stop() {
        player?.setVolume(0, fadeDuration: 0.5)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.player?.pause()
        }
    }

    private func configureSession() {
        #if os(iOS)
        let session = AVAudioSession.sharedInstance()
        do {
            // .playback = tetap berbunyi walau saklar silent aktif.
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            print("AVAudioSession gagal: \(error)")
        }
        #endif
    }
}

/// Sound effect ringan memakai system sound bawaan iOS.
enum SoundEffect {
    /// Suara shutter kamera bawaan iOS.
    static func cameraShutter() {
        #if os(iOS)
        AudioServicesPlaySystemSound(1108)
        #endif
    }
}
