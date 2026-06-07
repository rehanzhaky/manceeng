//
//  MainViewModel.swift
//  manceeng
//
//  Created by M. Iqbal on 06/06/26.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    let title = "Top 5 Catches"

    @Published var catches: [Catch]

    var topCatch: Catch? { catches.first }
    var hasCatches: Bool { !catches.isEmpty }

    init(catches: [Catch] = []) {
        self.catches = catches
    }

    // MARK: - Actions

    func capturePhoto() {
        SoundEffect.cameraShutter()
        // TODO: aksi buka kamera & tambah hasil ke `catches`.
    }

    func openMap() {
        // TODO: navigasi ke halaman peta.
    }

    func openFishList() {
        // TODO: navigasi ke daftar ikan.
    }
}
