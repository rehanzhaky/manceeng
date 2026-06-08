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

    init(
        locations: [CatchLocation] = CatchLocation.samples,
        center: CLLocationCoordinate2D = .init(latitude: 1.03, longitude: 104.0),
        span: MKCoordinateSpan = .init(latitudeDelta: 0.55, longitudeDelta: 0.55)
    ) {
        self.locations = locations
        self.cameraPosition = .region(
            MKCoordinateRegion(center: center, span: span)
        )
    }

    // MARK: - Actions

    func select(_ location: CatchLocation) {
        selectedLocation = location

        // Sheet medium menutup ±setengah layar bawah, jadi area peta yang terlihat
        // adalah setengah atas. Geser pusat kamera ke selatan ¼ span agar pin tampil
        // di tengah area sisa tersebut (bukan tengah layar penuh).
        let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
        let center = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude - span.latitudeDelta * 0.25,
            longitude: location.coordinate.longitude
        )
        cameraPosition = .region(MKCoordinateRegion(center: center, span: span))
    }

    func delete(_ location: CatchLocation) {
        locations.removeAll { $0.id == location.id }
        selectedLocation = nil
    }
}
