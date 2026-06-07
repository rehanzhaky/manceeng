//
//  AnimatedBackgroundView.swift
//  manceeng
//
//  Background halaman Main: warna dasar gelap + bubble gradient yang
//  mengembara dan berdenyut (di-blur) di atasnya.
//
//  Created by M. Iqbal on 06/06/26.
//

import SwiftUI

struct AnimatedBackgroundView: View {
    var body: some View {
        ZStack {
            // Lapisan dasar solid yang TIDAK di-blur, supaya tepi blur yang
            // memudar tetap menampilkan warna ini (bukan putih).
            Color.brandNavy
                .ignoresSafeArea()

            // Lapisan bubble yang di-blur, bergerak acak, ukuran bervariasi.
            ZStack {
                GradientBubble(diameter: 380, moveDuration: 7, startDelay: 0,   pulseDuration: 5)
                GradientBubble(diameter: 300, moveDuration: 6, startDelay: 1.2, pulseDuration: 6)
                GradientBubble(diameter: 220, moveDuration: 8, startDelay: 2.4, pulseDuration: 4)
                GradientBubble(diameter: 150, moveDuration: 5, startDelay: 0.6, pulseDuration: 3.5)
                GradientBubble(diameter: 110, moveDuration: 6, startDelay: 3,   pulseDuration: 3)
            }
            .blur(radius: 60)
            .ignoresSafeArea()
        }
    }
}

/// Satu bubble gradient yang mengembara ke titik-titik acak di layar
/// sambil berdenyut membesar–mengecil.
private struct GradientBubble: View {
    let diameter: CGFloat
    /// Lama satu kali perpindahan ke titik acak berikutnya.
    let moveDuration: Double
    /// Jeda awal biar tiap bubble tidak barengan.
    let startDelay: Double
    /// Lama satu siklus denyut (membesar lalu mengecil).
    let pulseDuration: Double

    @State private var position: CGPoint = .zero
    @State private var scale: CGFloat = 1
    @State private var timer: Timer?

    var body: some View {
        GeometryReader { geo in
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            Color.brandSky.opacity(0.85),
                            Color.brandSky.opacity(0.0)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: diameter / 2
                    )
                )
                .frame(width: diameter, height: diameter)
                .scaleEffect(scale)
                .position(position)
                .onAppear {
                    // Posisi awal acak.
                    position = randomPoint(in: geo.size)

                    // Denyut membesar–mengecil terus-menerus.
                    withAnimation(.easeInOut(duration: pulseDuration).repeatForever(autoreverses: true)) {
                        scale = 1.25
                    }

                    // Mulai mengembara ke titik acak baru terus-menerus.
                    DispatchQueue.main.asyncAfter(deadline: .now() + startDelay) {
                        moveToRandom(in: geo.size)
                        timer = Timer.scheduledTimer(withTimeInterval: moveDuration, repeats: true) { _ in
                            moveToRandom(in: geo.size)
                        }
                    }
                }
                .onDisappear {
                    timer?.invalidate()
                    timer = nil
                }
        }
    }

    /// Titik acak di seluruh area (boleh sedikit keluar tepi biar gerakannya natural).
    private func randomPoint(in size: CGSize) -> CGPoint {
        CGPoint(
            x: CGFloat.random(in: -diameter / 3 ... size.width + diameter / 3),
            y: CGFloat.random(in: -diameter / 3 ... size.height + diameter / 3)
        )
    }

    private func moveToRandom(in size: CGSize) {
        withAnimation(.easeInOut(duration: moveDuration)) {
            position = randomPoint(in: size)
        }
    }
}

#Preview {
    AnimatedBackgroundView()
}
