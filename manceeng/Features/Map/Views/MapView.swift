//
//  MapView.swift
//  manceeng
//
//  Halaman peta history tangkapan: menampilkan tiap tangkapan sebagai
//  marker foto di lokasinya. Dibuka dari tombol peta di halaman Main.
//
//  Created by M. Iqbal on 08/06/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel: MapViewModel
    @StateObject private var locationManager = LocationManager()
    @Environment(\.dismiss) private var dismiss

    /// Catch yang langsung dipilih saat map dibuka (mis. dari History).
    private let initialSelection: CatchLocation?
    @State private var didApplyInitialSelection = false

    init(viewModel: MapViewModel = MapViewModel(), initialSelection: CatchLocation? = nil) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.initialSelection = initialSelection
    }

    var body: some View {
        Map(position: $viewModel.cameraPosition) {
            UserAnnotation()

            ForEach(viewModel.locations) { location in
                Annotation("", coordinate: location.coordinate, anchor: .bottom) {
                    CatchMapMarker(location: location)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                viewModel.select(location)
                            }
                        }
                }
            }
        }
        .mapStyle(.standard(elevation: .flat))
        .onMapCameraChange { context in
            viewModel.updateVisibleRegion(context.region)
        }
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            backButton
        }
        .overlay(alignment: .topTrailing) {
            if let selected = viewModel.selectedLocation {
                catchActions(for: selected)
            }
        }
        .overlay(alignment: .trailing) {
            if viewModel.selectedLocation == nil {
                mapControls
            }
        }
        // Bottom panel custom (pengganti .sheet) — sudut kotak, full, tanpa scrim.
        .overlay {
            if let selected = viewModel.selectedLocation {
                CatchDetailPanel(location: selected) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.selectedLocation = nil
                    }
                }
            }
        }
        .onAppear {
            locationManager.requestPermission()
            if !didApplyInitialSelection, let initialSelection {
                didApplyInitialSelection = true
                viewModel.select(initialSelection)
            }
        }
    }

    /// Share & delete untuk pin terpilih — di kanan atas layar, di luar modal.
    private func catchActions(for location: CatchLocation) -> some View {
        HStack(spacing: 10) {
            ShareLink(item: shareText(for: location)) {
                GlassCircleIcon(systemName: "square.and.arrow.up")
            }
            CircleIconButton(systemName: "trash") {
                withAnimation { viewModel.delete(location) }
            }
        }
        .padding(.trailing, 16)
        .padding(.top, 8)
        .transition(.opacity)
    }

    private func shareText(for location: CatchLocation) -> String {
        "\(location.fishName) — \(location.weightKg.formatted()) kg, \(location.lengthCm.formatted()) cm @ \(location.locationName)"
    }

    private var backButton: some View {
        CircleIconButton(systemName: "chevron.left") { dismiss() }
            .padding(.leading, 20)
            .padding(.top, 8)
    }

    private var mapControls: some View {
        VStack(spacing: 16) {
            MapZoomControl { factor in
                withAnimation(.easeInOut(duration: 0.25)) {
                    viewModel.zoom(by: factor)
                }
            }

            CircleIconButton(systemName: "location.fill") {
                locationManager.requestPermission()
                withAnimation(.easeInOut(duration: 0.4)) {
                    viewModel.goToUserLocation()
                }
            }
        }
        .padding(.trailing, 16)
    }
}

#Preview {
    MapView()
}
