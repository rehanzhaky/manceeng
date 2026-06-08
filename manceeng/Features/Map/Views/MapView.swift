//
//  MapView.swift
//  manceeng
//
//  Halaman peta history tangkapan: menampilkan tiap tangkapan sebagai
//  marker foto di lokasinya. Dibuka dari tombol peta di halaman Main.
//
//  Created by M. Iqbal on 08/06/26.
//  Created by Raihan Zhaky Al Hafizh on 08/06/26.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel: MapViewModel
    @StateObject private var locationManager = LocationManager()
    @Environment(\.dismiss) private var dismiss

    /// Detent teratas — sheet besar yang menyisakan sedikit map di atas.
    private let topDetent: PresentationDetent = .fraction(0.85)
    @State private var detent: PresentationDetent = .fraction(0.85)

    init(viewModel: MapViewModel = MapViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Map(position: $viewModel.cameraPosition) {
            UserAnnotation()

            ForEach(viewModel.locations) { location in
                Annotation("", coordinate: location.coordinate, anchor: .bottom) {
                    CatchMapMarker(location: location)
                        .onTapGesture {
                            detent = topDetent
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
        .onAppear { locationManager.requestPermission() }
        .sheet(item: $viewModel.selectedLocation) { location in
            CatchDetailView(location: location)
                .presentationDetents([.fraction(0.4), topDetent], selection: $detent)
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(.enabled(upThrough: topDetent))
        }
    }

    /// Share & delete untuk pin terpilih — di kanan atas layar, di luar modal.
    private func catchActions(for location: CatchLocation) -> some View {
        HStack(spacing: 2) {
            ShareLink(item: shareText(for: location)) {
                actionIcon("square.and.arrow.up")
            }
            Button(role: .destructive) {
                withAnimation { viewModel.delete(location) }
            } label: {
                actionIcon("trash")
            }
            .buttonStyle(.plain)
        }
        .padding(5)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1))
        .padding(.trailing, 16)
        .padding(.top, 8)
        .transition(.opacity)
    }

    private func actionIcon(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 40, height: 40)
    }

    private func shareText(for location: CatchLocation) -> String {
        "\(location.fishName) — \(location.weightKg.formatted()) kg, \(location.lengthCm.formatted()) cm @ \(location.locationName)"
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)
                .frame(width: 44, height: 44)
                .background(.ultraThinMaterial, in: Circle())
        }
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

            Button {
                locationManager.requestPermission()
                withAnimation(.easeInOut(duration: 0.4)) {
                    viewModel.goToUserLocation()
                }
            } label: {
                Image(systemName: "location.fill")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.brandBlue)
                    .frame(width: 46, height: 46)
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(Circle().stroke(Color.white.opacity(0.15), lineWidth: 1))
            }
            .buttonStyle(.plain)
        }
        .padding(.trailing, 16)
    }
}

#Preview {
    NavigationStack {
        MapView()
    }
}
