//
//  CameraButton.swift
//  manceeng
//
//  Tombol kamera bergaya liquid glass: tengah transparan, hanya aksen
//  gradient biru di tepi, dengan glow biru lembut di luar.
//
//  Created by M. Iqbal on 06/06/26.
//

import SwiftUI

struct CameraButton: View {
    var action: () -> Void

    @State private var pressed = false

    private let size: CGFloat = 88
    private let corner: CGFloat = 26

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: corner, style: .continuous)
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: "camera.fill")
                .font(.system(size: 34, weight: .medium))
                .foregroundStyle(Color.brandWhite)
                .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
                .frame(width: size, height: size)
                // Liquid glass transparan + aksen gradient biru di tepi.
                .glassStyle(shape)
                // Glow biru lembut di luar tombol.
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
        CameraButton {}
    }
}
