//
//  MapModels.swift
//  manceeng
//
//  Model untuk halaman Map — lokasi tangkapan ikan (history capture).
//
//  Created by M. Iqbal on 08/06/26.
//

import Foundation
import CoreLocation

/// Satu titik tangkapan ikan di peta.
struct CatchLocation: Identifiable {
    let id = UUID()
    let fishName: String
    let coordinate: CLLocationCoordinate2D
    let weightKg: Double
    let lengthCm: Double
    /// Nama tempat (mis. "South China Sea").
    let locationName: String
    /// Nama asset foto tangkapan; `nil` → tampilkan placeholder.
    let imageName: String?

    init(
        fishName: String,
        coordinate: CLLocationCoordinate2D,
        weightKg: Double,
        lengthCm: Double,
        locationName: String,
        imageName: String? = nil
    ) {
        self.fishName = fishName
        self.coordinate = coordinate
        self.weightKg = weightKg
        self.lengthCm = lengthCm
        self.locationName = locationName
        self.imageName = imageName
    }
}

extension CatchLocation {
    /// Data contoh di sekitar Batam (sesuai mid-fidelity). Ganti dengan data asli nanti.
    static let samples: [CatchLocation] = [
        CatchLocation(fishName: "Catfish",     coordinate: .init(latitude: 1.115, longitude: 104.065), weightKg: 0.7, lengthCm: 15, locationName: "South China Sea"),
        CatchLocation(fishName: "Ikan Kerapu", coordinate: .init(latitude: 1.020, longitude: 103.945), weightKg: 1.4, lengthCm: 28, locationName: "Selat Singapura"),
        CatchLocation(fishName: "Ikan Nila",   coordinate: .init(latitude: 0.930, longitude: 104.010), weightKg: 0.9, lengthCm: 18, locationName: "Pulau Bulan")
    ]
}
