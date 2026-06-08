//
//  EmptyCatchStateView.swift
//  manceeng
//
//  Empty state halaman Main — ikan berenang bebas tanpa container card.
//
//  Created by M. Iqbal on 06/06/26.
//

import SwiftUI

struct EmptyCatchStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            SwimmingFishView()

            Text("Perlu tambah gambar dulu")
                .font(.subheadline)
                .foregroundStyle(Color.brandWhite.opacity(0.5))
        }
    }
}

#Preview {
    ZStack {
        Color.brandNavy.ignoresSafeArea()
        EmptyCatchStateView()
    }
}
