//
//  GlassPressStyle.swift
//  manceeng
//
//  Shared ButtonStyle that provides the spring press-feedback used by
//  CameraButton and CircleIconButton.
//

import SwiftUI

struct GlassPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
