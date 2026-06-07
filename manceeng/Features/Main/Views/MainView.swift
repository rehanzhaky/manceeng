//
//  MainView.swift
//  manceeng
//
//  Halaman utama: background animasi, top bar, kartu tangkapan teratas,
//  dan tombol kamera. Logika & data dipegang oleh MainViewModel.
//
//  Created by M. Iqbal on 06/06/26.
//

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: MainViewModel

    init(viewModel: MainViewModel = MainViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            AnimatedBackgroundView()

            VStack(spacing: 0) {
                topBar
                title

                Spacer()

                CatchCardStackView(catches: viewModel.catches)

                Spacer()

                CameraButton {
                    viewModel.capturePhoto()
                }
                .padding(.bottom, 40)
            }
        }.fullScreenCover( //Sebagian besar menggunakan present/fullscreen modal, bukan push dari navigation stack.
            isPresented: $viewModel.showCamera
        ) {
            CameraView()
        }
    }

    // MARK: - Sections

    /// Top bar: ikon peta (kiri) & ikan (kanan).
    private var topBar: some View {
        HStack {
            CircleIconButton(systemName: "map.fill") { viewModel.openMap() }
            Spacer()
            CircleIconButton(systemName: "fish.fill") { viewModel.openFishList() }
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
    }

    private var title: some View {
        HStack {
            Text(viewModel.title)
                .font(.LargeTitleBlack)
                .foregroundStyle(Color.brandWhite)
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.top, 28)
    }
}

#Preview("Kosong") {
    MainView()
}

#Preview("Ada Card") {
    MainView(
        viewModel: MainViewModel(
            catches: [
                Catch(
                    name: "Ikan Lele", weight: "15 Kg", length: "100 Cm",
                )
            ]
        )
    )
}
