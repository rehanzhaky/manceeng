//
//  MainView.swift
//  manceeng
//
//  Halaman utama: background animasi, top bar, kartu tangkapan teratas,
//  dan tombol kamera. Logika & data dipegang oleh MainViewModel.
//
//  Created by M. Iqbal on 06/06/26.

//  Created by Raihan Zhaky Al Hafizh on 08/06/26.

import SwiftUI

struct MainView: View {
    @StateObject private var viewModel: MainViewModel
    @AppStorage("hasSeenMainTutorial") private var hasSeenTutorial = false
    @State private var selectedCatch: Catch?

    init(viewModel: MainViewModel = MainViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
        ZStack {
            AnimatedBackgroundView()

            VStack(spacing: 0) {
                topBar
                title

                Spacer()

                if let front = viewModel.catches.first {
                    TopFishCardStackView(model: front)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) { selectedCatch = front }
                        }
                } else {
                    EmptyCatchStateView()
                }

                Spacer()

                CameraButton {
                    viewModel.capturePhoto()
                }
                .tutorialTarget(.camera)
                .padding(.bottom, 40)
            }
        }
        .fullScreenCover( //Sebagian besar menggunakan present/fullscreen modal, bukan push dari navigation stack.
            isPresented: $viewModel.showCamera
        ) {
            CameraView(onSave: { viewModel.addCatch($0) })
        }
        .overlayPreferenceValue(TutorialAnchorKey.self) { anchors in
            GeometryReader { proxy in
                if let step = viewModel.currentTutorialStep, let anchor = anchors[step.target] {
                    TutorialOverlayView(
                        step: step,
                        rect: proxy[anchor],
                        containerSize: proxy.size,
                        stepNumber: (viewModel.tutorialIndex ?? 0) + 1,
                        totalSteps: viewModel.tutorialSteps.count,
                        onNext: {
                            withAnimation(.easeInOut(duration: 0.25)) {
                                viewModel.advanceTutorial()
                            }
                            if !viewModel.isTutorialActive { hasSeenTutorial = true }
                        }
                    )
                }
            }
            .ignoresSafeArea()
        }
        // Pindah halaman = push (geser dari kanan), bukan modal atas-bawah.
        .navigationDestination(isPresented: $viewModel.isMapPresented) {
            MapView()
                .toolbar(.hidden, for: .navigationBar)
                .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(isPresented: $viewModel.isHistoryPresented) {
            HistoryView()
                .toolbar(.hidden, for: .navigationBar)
                .navigationBarBackButtonHidden(true)
        }
        .navigationDestination(item: $selectedCatch) { item in
            // Tap kartu beranda → buka detail tangkapan di atas peta (pin + panel detail).
            let location = CatchLocation(item)
            MapView(
                viewModel: MapViewModel(locations: CatchLocation.samples + [location]),
                initialSelection: location
            )
            .toolbar(.hidden, for: .navigationBar)
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            if !hasSeenTutorial && !viewModel.isTutorialActive {
                viewModel.startTutorial()
            }
        }
        }
    }

    // MARK: - Sections

    private var topBar: some View {
        HStack {
            CircleIconButton(systemName: "map.fill") { viewModel.openMap() }
                .tutorialTarget(.map)
            Spacer()
            CircleIconButton(systemName: "fish.fill") { viewModel.openFishList() }
                .tutorialTarget(.fishList)
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

    MainView(
        viewModel: MainViewModel(
            catches: [
                Catch(
                    name: "Ikan Lele", weight: "15 Kg", length: "100 Cm",
                ),
                Catch(name: "Ikan Lele", weight: "1.1 Kg", length: "15 Cm"),
                Catch(name: "Ikan Nila", weight: "0.8 Kg", length: "12 Cm"),
            ]
        )
    )
}

#Preview("Tutorial") {
    let viewModel = MainViewModel(catches: [
        Catch(name: "Ikan Lele", weight: "1.1 Kg", length: "15 Cm")
    ])

    MainView(viewModel: viewModel)
}
