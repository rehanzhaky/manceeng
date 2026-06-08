//
//  CameraButton.swift
//  manceeng
//
//  Created by Raihan Zhaky Al Hafizh on 08/06/26.
//


import SwiftUI

struct CameraButton: View {
    var action: () -> Void

    private let size: CGFloat = 88

    private var shape: Circle {
        Circle()
    }

    var body: some View {
        Button(action: action) {
            Image(systemName: "camera.fill")
                .font(.system(size: 34, weight: .medium))
                .foregroundStyle(Color.brandWhite)
                .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
                .frame(width: size, height: size)
                .glassStyle(shape)
                .shadow(color: Color.brandSky.opacity(0.6), radius: 16)
                .shadow(color: Color.brandSky.opacity(0.3), radius: 28)
        }
        .buttonStyle(GlassPressStyle())
    }
}

#Preview {
    ZStack {
        Color.brandNavy.ignoresSafeArea()
        CameraButton {}
    }

}
