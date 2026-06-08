//
//  GlassPressStyle.swift
//  manceeng
//
//  Created by Raihan Zhaky Al Hafizh on 08/06/26.
//


import SwiftUI

struct GlassPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}