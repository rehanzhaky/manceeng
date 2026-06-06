//
//  CatchCardStackView.swift
//  manceeng
//
//  Menampilkan kartu tangkapan teratas; kalau kosong tampilkan empty state.
//
//  Created by M. Iqbal on 06/06/26.
//

import SwiftUI

struct CatchCardStackView: View {
    let catches: [Catch]

    var body: some View {
        ZStack {
            if let front = catches.first {
                TopFishCardStackView(
                    fishName: front.name,
                    weightName: front.weight,
                    lengthName: front.length
                )
            } else {
                EmptyCatchStateView()
            }
        }
    }
}

#Preview("Empty") {
    ZStack {
        Color.brandNavy.ignoresSafeArea()
        CatchCardStackView(catches: [])
    }
}

#Preview("With catch") {
    ZStack {
        Color.brandNavy.ignoresSafeArea()
        CatchCardStackView(catches: [
            Catch(name: "Ikan Lele", weight: "1.1 kg", length: "15 cm")
        ])
    }
}
