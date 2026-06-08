//
//  MapViewModel.swift
//  manceeng
//
//  Created by M. Iqbal on 08/06/26.
//

import SwiftUI
import MapKit
import Combine

final class MapViewModel: ObservableObject {
    /// Daftar lokasi tangkapan yang ditampilkan sebagai marker.
    @Published var locations: [CatchLocation]

    /// Lokasi yang dipilih (tap marker) → menampilkan detail sheet. `nil` = tertutup.
    @Published var selectedLocation: CatchLocation?

    /// Posisi/zoom kamera peta.
    @Published var cameraPosition: MapCameraPosition

    /// Region peta yang sedang terlihat (di-update saat kamera bergerak).
    private var visibleRegion: MKCoordinateRegion?

    /// Region awal — juga dipakai sebagai fallback bila lokasi user belum tersedia.
    private let defaultRegion: MKCoordinateRegion

    private let minSpan: CLLocationDegrees = 0.002
    private let maxSpan: CLLocationDegrees = 120

    init(
        locations: [CatchLocation] = CatchLocation.samples,
        center: CLLocationCoordinate2D = .init(latitude: 1.03, longitude: 104.0),
        span: MKCoordinateSpan = .init(latitudeDelta: 0.55, longitudeDelta: 0.55)
    ) {
        self.locations = locations
        self.defaultRegion = MKCoordinateRegion(center: center, span: span)
        self.cameraPosition = .region(defaultRegion)
    }

    // MARK: - Actions

    func select(_ location: CatchLocation) {
        selectedLocation = location

        // Panel custom menutup ±82% layar bawah, jadi map terlihat hanya strip atas
        // (~18%). Geser pusat kamera ke selatan agar marker pas di tengah strip itu.
        // Faktor ini gampang disetel: lebih kecil = pin turun, lebih besar = pin naik.
        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        let center = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude - span.latitudeDelta * 0.60,
            longitude: location.coordinate.longitude
        )
        cameraPosition = .region(MKCoordinateRegion(center: center, span: span))
    }

    func delete(_ location: CatchLocation) {
        locations.removeAll { $0.id == location.id }
        selectedLocation = nil
    }

    // MARK: - Camera

    /// Simpan region terlihat terkini (dipanggil dari `onMapCameraChange`).
    func updateVisibleRegion(_ region: MKCoordinateRegion) {
        visibleRegion = region
    }

    /// Zoom dengan mengalikan span. `factor` < 1 = zoom in, > 1 = zoom out.
    func zoom(by factor: Double) {
        let region = visibleRegion ?? defaultRegion
        let newSpan = MKCoordinateSpan(
            latitudeDelta: clampSpan(region.span.latitudeDelta * factor),
            longitudeDelta: clampSpan(region.span.longitudeDelta * factor)
        )
        cameraPosition = .region(MKCoordinateRegion(center: region.center, span: newSpan))
    }

    /// Pindah & ikuti lokasi user (titik biru). Fallback ke region awal bila izin belum ada.
    func goToUserLocation() {
        cameraPosition = .userLocation(fallback: .region(defaultRegion))
    }

    private func clampSpan(_ value: CLLocationDegrees) -> CLLocationDegrees {
        min(max(value, minSpan), maxSpan)
    }
}
