//
//  MainViewModel.swift
//  manceeng
//
//  Created by M. Iqbal on 06/06/26.
//

import SwiftUI
import Combine

final class MainViewModel: ObservableObject {
    /// Judul halaman.
    let title = "Top 5 Catches"

    /// Daftar tangkapan ikan. Kosong → tampilkan empty state.
    @Published var catches: [Catch]

    /// Tangkapan teratas yang ditampilkan di kartu depan.
    var topCatch: Catch? { catches.first }

    /// Apakah sudah ada tangkapan.
    var hasCatches: Bool { !catches.isEmpty }

    init(catches: [Catch] = []) {
        self.catches = catches
    }

    // MARK: - Actions

    /// Tombol kamera ditekan.
    func capturePhoto() {
        SoundEffect.cameraShutter()
        // TODO: aksi buka kamera & tambah hasil ke `catches`.
    }

    /// Tombol peta (kiri atas) ditekan.
    func openMap() {
        // TODO: navigasi ke halaman peta.
    }

    /// Tombol ikan (kanan atas) ditekan.
    func openFishList() {
        // TODO: navigasi ke daftar ikan.
    }
}
