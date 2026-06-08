//
//  MapZoomControl.swift
//  manceeng
//
//  Kontrol zoom peta di sisi kanan: tap +/- atau swipe ke atas (zoom in) /
//  ke bawah (zoom out).
//
//  Created by M. Iqbal on 08/06/26.
//

import SwiftUI

struct MapZoomControl: View {
    /// Dipanggil dengan faktor pengali span. < 1 = zoom in, > 1 = zoom out.
    var onZoom: (Double) -> Void

    /// Faktor per tap tombol.
    private let tapZoomIn: Double = 0.55
    private let tapZoomOut: Double = 1.8

    /// Akumulasi jarak swipe sejak step terakhir.
    @State private var lastStepOffset: CGFloat = 0
    private let swipeStep: CGFloat = 14

    var body: some View {
        VStack(spacing: 12) {
            button("plus") { onZoom(tapZoomIn) }

            Rectangle()
                .fill(Color.primary.opacity(0.2))
                .frame(width: 22, height: 1)

            button("minus") { onZoom(tapZoomOut) }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, 10)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(Capsule().stroke(Color.white.opacity(0.15), lineWidth: 1))
        .simultaneousGesture(
            DragGesture(minimumDistance: 6)
                .onChanged { value in
                    let delta = value.translation.height - lastStepOffset
                    if delta <= -swipeStep {            // swipe ke atas → zoom in
                        onZoom(0.9)
                        lastStepOffset = value.translation.height
                    } else if delta >= swipeStep {      // swipe ke bawah → zoom out
                        onZoom(1.1)
                        lastStepOffset = value.translation.height
                    }
                }
                .onEnded { _ in lastStepOffset = 0 }
        )
    }

    private func button(_ systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.primary)
                .frame(width: 30, height: 30)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ZStack {
        Color.blue
        MapZoomControl { _ in }
    }
}
