//
//  CircleIconButton.swift
//  manceeng
//
//  Tombol ikon bulat bergaya glass untuk top bar.
//
//  Created by M. Iqbal on 06/06/26.
//

import SwiftUI

struct CircleIconButton: View {
    let systemName: String
    var action: () -> Void

    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.brandWhite)
                .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
                .frame(width: 52, height: 52)
                .glassStyle(Circle())
                .shadow(color: Color.brandSky.opacity(0.6), radius: 16)
                .shadow(color: Color.brandSky.opacity(0.3), radius: 28)
                .scaleEffect(pressed ? 0.92 : 1)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: pressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in pressed = true }
                .onEnded { _ in pressed = false }
        )
    }
}

#Preview {
    ZStack {
        Color.brandNavy.ignoresSafeArea()
        CircleIconButton(systemName: "map.fill") {}
    }
}
