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
struct CatchLocation: Identifiable, Hashable {
    static func == (lhs: CatchLocation, rhs: CatchLocation) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }

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
    /// Konversi `Catch` (model beranda, berat/panjang berupa String) ke `CatchLocation`
    /// agar bisa ditampilkan di CatchDetail. Koordinat dummy (tak ditampilkan di panel).
    init(_ item: Catch) {
        self.init(
            fishName: item.name,
            // Belum ada geotag asli dari kamera → pakai koordinat default (South China Sea)
            // agar pin muncul di area yang masuk akal saat dibuka di peta.
            coordinate: .init(latitude: 1.115, longitude: 104.065),
            weightKg: CatchLocation.numericPrefix(item.weight),
            lengthCm: CatchLocation.numericPrefix(item.length),
            locationName: item.location ?? "—"
        )
    }

    /// Ambil angka di depan string, mis. "0.7 kg" → 0.7, "15 cm" → 15.
    private static func numericPrefix(_ text: String) -> Double {
        let cleaned = text.replacingOccurrences(of: ",", with: ".")
        let numeric = cleaned.prefix { $0.isNumber || $0 == "." }
        return Double(numeric) ?? 0
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
