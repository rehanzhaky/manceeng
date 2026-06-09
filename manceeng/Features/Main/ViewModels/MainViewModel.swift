//
//  MainViewModel.swift
//  manceeng
//
//  Created by M. Iqbal on 06/06/26.
//

import Foundation
import Combine

final class MainViewModel: ObservableObject {
    let title = "Top 5 Catches"

    @Published var catches: [Catch]

    @Published var showCamera = false
    @Published var isMapPresented = false
    @Published var isHistoryPresented = false

    var topCatch: Catch? { catches.first }
    var hasCatches: Bool { !catches.isEmpty }

    // MARK: - Tutorial

    let tutorialSteps = TutorialStep.mainSteps

    /// Index langkah tutorial yang aktif; `nil` artinya tutorial tidak tampil.
    @Published private(set) var tutorialIndex: Int?

    var currentTutorialStep: TutorialStep? {
        guard let index = tutorialIndex, tutorialSteps.indices.contains(index) else { return nil }
        return tutorialSteps[index]
    }

    var isTutorialActive: Bool { tutorialIndex != nil }

    init(catches: [Catch] = []) {
        self.catches = catches
    }
    
    // MARK: - Actions

    func capturePhoto() {
//        SoundEffect.cameraShutter()
        showCamera = true
    }

    /// Tambahkan hasil tangkapan (dari Save di CatchReview) ke beranda & tutup kamera.
    func addCatch(_ newCatch: Catch) {
        catches.insert(newCatch, at: 0)
        showCamera = false
    }

    func openMap() {
        isMapPresented = true
    }

    func openFishList() {
        isHistoryPresented = true
    }

    // MARK: - Tutorial actions

    func startTutorial() {
        guard !tutorialSteps.isEmpty else { return }
        tutorialIndex = 0
    }

    /// Maju ke langkah berikutnya; otomatis selesai bila sudah langkah terakhir.
    func advanceTutorial() {
        guard let index = tutorialIndex else { return }
        let next = index + 1
        tutorialIndex = next < tutorialSteps.count ? next : nil
    }

    func finishTutorial() {
        tutorialIndex = nil
    }
}
