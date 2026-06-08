//
//  TutorialStep.swift
//  manceeng
//
//  Data langkah-langkah interactive tutorial (coach marks) di halaman Main.
//
//  Created by M. Iqbal on 08/06/26.
//

import Foundation

/// Elemen UI yang bisa di-sorot (highlight) oleh tutorial.
enum TutorialTarget: Hashable {
    case fishList   // tombol ikan (kanan atas)
    case map        // tombol peta (kiri atas)
    case camera     // tombol kamera (tengah bawah)
}

/// Satu langkah tutorial: elemen yang disorot, teks penjelas, dan posisi bubble.
struct TutorialStep: Identifiable {
    /// Posisi bubble petunjuk relatif terhadap elemen yang disorot.
    enum CalloutPlacement {
        case above
        case below
    }

    let id = UUID()
    let target: TutorialTarget
    let text: String
    let placement: CalloutPlacement

    /// Urutan langkah tutorial halaman Main (sesuai mid-fidelity).
    static let mainSteps: [TutorialStep] = [
        TutorialStep(
            target: .fishList,
            text: "Look at the fish you caught!",
            placement: .below
        ),
        TutorialStep(
            target: .map,
            text: "Look at the places you've been fishing",
            placement: .below
        ),
        TutorialStep(
            target: .camera,
            text: "Snap your catch to instantly get weight, length, and species",
            placement: .above
        )
    ]
}
