//
//  CircleIconButton.swift
//  manceeng
//

//  Tombol ikon bulat bergaya glass untuk top bar.
//
//  Created by M. Iqbal on 06/06/26.
//


//  Created by Raihan Zhaky Al Hafizh on 08/06/26.
//

import SwiftUI

/// Ikon bulat bergaya glass — tampilan tombol standar aplikasi (dipakai di
/// beranda). Dipisah agar bisa dipakai juga oleh ShareLink dsb. yang bukan Button.
struct GlassCircleIcon: View {
    let systemName: String
    var size: CGFloat = 52
    var iconSize: CGFloat = 20

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: iconSize, weight: .semibold))
            .foregroundStyle(Color.brandWhite)
            .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
            .frame(width: size, height: size)
            .glassStyle(Circle())
            .shadow(color: Color.brandSky.opacity(0.6), radius: 16)
            .shadow(color: Color.brandSky.opacity(0.3), radius: 28)
    }
}

struct CircleIconButton: View {
    let systemName: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            GlassCircleIcon(systemName: systemName)
        }
        .buttonStyle(GlassPressStyle())
    }
}

#Preview {
    ZStack {
        Color.brandNavy.ignoresSafeArea()
        CircleIconButton(systemName: "map.fill") {}
    }
}
