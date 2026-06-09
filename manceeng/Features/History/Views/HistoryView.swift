//
//  HistoryView.swift
//  manceeng
//
//  Halaman Fish Collection (history) — daftar semua tangkapan.
//  Dibuka (push) dari tombol ikan (kanan atas) di halaman Main.
//
//  Created by M. Iqbal on 09/06/26.
//

import SwiftUI

struct HistoryView: View {
    @StateObject private var viewModel: HistoryViewModel
    @Environment(\.dismiss) private var dismiss

    init(viewModel: HistoryViewModel = HistoryViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            AnimatedBackgroundView()

            VStack(alignment: .leading, spacing: 20) {
                header

                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.catches) { item in
                            Button {
                                viewModel.selectedLocation = item
                            } label: {
                                FishCollectionCard(location: item)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.bottom, 24)
                }
                .scrollIndicators(.hidden)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
        }
        .toolbar(.hidden, for: .navigationBar)
        .navigationDestination(item: $viewModel.selectedLocation) { location in
            MapView(initialSelection: location)
                .toolbar(.hidden, for: .navigationBar)
                .navigationBarBackButtonHidden(true)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            CircleIconButton(systemName: "chevron.left") { dismiss() }

            Text("Fish Collection")
                .font(.largeTitleBlack)
                .foregroundStyle(Color.brandWhite)
                .padding(.horizontal, 4)
        }
    }
}

#Preview {
    NavigationStack {
        HistoryView()
    }
}
