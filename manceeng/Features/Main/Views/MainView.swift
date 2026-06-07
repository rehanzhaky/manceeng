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

                if let front = viewModel.catches.first {
                    TopFishCardStackView(model: front)
                } else {
                    EmptyCatchStateView()
                }

                Spacer()

                CameraButton {
                    viewModel.capturePhoto()
                }
                .padding(.bottom, 40)
            }
        }
    }

    // MARK: - Sections

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
                .font(.largeTitleBlack)
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
    MainView(viewModel: MainViewModel(catches: [
        Catch(name: "Ikan Lele", weightKg: 1.1, lengthCm: 15),
        Catch(name: "Ikan Nila", weightKg: 0.8, lengthCm: 12),
        Catch(name: "Ikan Mas",  weightKg: 1.5, lengthCm: 20)
    ]))
}
