//
//  LocationManager.swift
//  manceeng
//
//  Wrapper ringan CLLocationManager: meminta izin lokasi agar titik biru
//  (posisi user) muncul di peta.
//
//  Created by M. Iqbal on 08/06/26.
//

import CoreLocation
import Combine

final class LocationManager: NSObject, ObservableObject {
    private let manager = CLLocationManager()

    @Published private(set) var authorizationStatus: CLAuthorizationStatus

    var isAuthorized: Bool {
        #if os(macOS)
        authorizationStatus == .authorizedAlways
        #else
        authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways
        #endif
    }

    override init() {
        authorizationStatus = manager.authorizationStatus
        super.init()
        manager.delegate = self
    }

    /// Minta izin "When In Use" bila belum ditentukan.
    func requestPermission() {
        if authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
}
