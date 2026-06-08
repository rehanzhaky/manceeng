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
    }

    func delete(_ location: CatchLocation) {
        locations.removeAll { $0.id == location.id }
        selectedLocation = nil
    }
}
