//
//  GlassStyle.swift
//  manceeng
//
//  Modifier "liquid glass": fill biru tua semi-transparan + aksen gradient
//  biru di tepi. Dipakai oleh tombol & kartu di halaman Main.
//
//  Created by M. Iqbal on 06/06/26.
//

import SwiftUI

extension View {
    /// Gaya liquid glass: fill abu-abu/biru tua semi-transparan + aksen gradient biru di tepi.
    @ViewBuilder
    func glassStyle<S: InsettableShape>(_ shape: S, lineWidth: CGFloat = 1.5) -> some View {
        self
            .background {
                ZStack {
                    // Fill biru tua — memberi kesan "tinted glass".
                    shape.fill(Color(red: 0.08, green: 0.12, blue: 0.30).opacity(0.55))

                    // Lapisan glass iOS 26 / material fallback di atasnya.
                    Group {
                        if #available(iOS 26.0, *) {
                            Color.clear.glassEffect(.regular, in: shape)
                        } else {
                            shape.fill(.ultraThinMaterial)
                        }
                    }
                    .opacity(0.15)
                }
            }
            .overlay {
                shape.strokeBorder(
                    LinearGradient(
                        colors: [
                            Color.brandSky.opacity(0.9),
                            Color.brandSky.opacity(0.15)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: lineWidth
                )
            }
            .clipShape(shape)
    }
}
