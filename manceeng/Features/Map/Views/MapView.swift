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
    @Environment(\.dismiss) private var dismiss
    @State private var detent: PresentationDetent = .medium

    init(viewModel: MapViewModel = MapViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Map(position: $viewModel.cameraPosition) {
            ForEach(viewModel.locations) { location in
                Annotation("", coordinate: location.coordinate, anchor: .bottom) {
                    CatchMapMarker(location: location)
                        .onTapGesture {
                            detent = .medium
                            withAnimation(.easeInOut(duration: 0.4)) {
                                viewModel.select(location)
                            }
                        }
                }
            }
        }
        .mapStyle(.standard(elevation: .flat))
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            backButton
        }
        .sheet(item: $viewModel.selectedLocation) { location in
            CatchDetailView(location: location, isExpanded: detent == .large) {
                viewModel.delete(location)
            }
            .presentationDetents([.medium, .large], selection: $detent)
            .presentationDragIndicator(detent == .large ? .hidden : .visible)
            .presentationBackgroundInteraction(.enabled(upThrough: .medium))
        }
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
}

#Preview {
    MapView()
}
