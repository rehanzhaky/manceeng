//
//  SwimmingFishView.swift
//  manceeng
//
//  Ikan berenang bebas ke segala arah, rotasi mengikuti arah gerak.
//  Dipakai pada empty state halaman Main.
//
//  Created by M. Iqbal on 06/06/26.
//

import SwiftUI

struct SwimmingFishView: View {
    // fish.fill menghadap KANAN secara default (0°).
    // scaleX: -1 dipakai saat bergerak ke kiri agar ikan tidak terbalik (belly tetap di bawah).
    // Tilt (rotasi) dihitung dari komponen vertikal relatif terhadap arah hadap ikan.
    @State private var scaleX: CGFloat = 1
    @State private var posX: CGFloat = 0
    @State private var posY: CGFloat = 0
    @State private var tilt: Double = 0        // −90° (atas) s/d +90° (bawah)

    // Batas area renang dalam frame.
    private let rangeX: CGFloat = 90
    private let rangeY: CGFloat = 70

    var body: some View {
        ZStack {
            // Bayangan elips — posisi ikut ikan.
            Ellipse()
                .fill(Color.brandSky.opacity(0.15))
                .frame(width: 65, height: 10)
                .blur(radius: 5)
                .offset(x: posX, y: rangeY - 4)   // selalu di "lantai" area

            Image(systemName: "fish.fill")
                .font(.system(size: 64))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.brandSky, Color.brandSky.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: Color.brandSky.opacity(0.6), radius: 10)
                .scaleEffect(x: scaleX, y: 1)
                .rotationEffect(.degrees(tilt))
                .offset(x: posX, y: posY)
        }
        .frame(width: rangeX * 2, height: rangeY * 2)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { swim() }
        }
    }

    private func swim() {
        // Titik tujuan acak dalam area renang.
        let targetX = CGFloat.random(in: -rangeX * 0.85 ... rangeX * 0.85)
        let targetY = CGFloat.random(in: -rangeY * 0.85 ... rangeY * 0.85)

        let dx = targetX - posX
        let dy = targetY - posY
        let dist = sqrt(dx * dx + dy * dy)
        guard dist > 18 else { swim(); return }

        // Tentukan arah hadap: kiri atau kanan berdasarkan dx.
        // Saat dx ≈ 0 (gerak murni vertikal), pertahankan scaleX terakhir.
        let newScaleX: CGFloat = dx > 5 ? 1 : (dx < -5 ? -1 : scaleX)
        let needsFlip = newScaleX != scaleX

        // Tilt: sudut vertikal dari perspektif ikan (selalu −90°…+90°, tidak pernah terbalik).
        // Ikan menghadap kanan: tilt = atan2(dy, dx); menghadap kiri: mirror → atan2(dy, -dx).
        let effectiveDX = newScaleX > 0 ? Double(dx) : Double(-dx)
        let newTilt = atan2(Double(dy), effectiveDX) * 180 / .pi

        let pxPerSec = Double.random(in: 38...68)
        let moveDur  = max(0.7, dist / CGFloat(pxPerSec))
        let pause    = Double.random(in: 0.1...0.6)

        if needsFlip {
            // Squish → flip → expand sebelum bergerak.
            withAnimation(.easeIn(duration: 0.08)) { scaleX = 0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                scaleX = newScaleX
                withAnimation(.easeOut(duration: 0.08)) {
                    scaleX = newScaleX
                    tilt = newTilt
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                    move(to: targetX, targetY: targetY, tilt: newTilt, duration: Double(moveDur), pause: pause)
                }
            }
        } else {
            withAnimation(.easeInOut(duration: 0.25)) { tilt = newTilt }
            move(to: targetX, targetY: targetY, tilt: newTilt, duration: Double(moveDur), pause: pause)
        }
    }

    private func move(to tx: CGFloat, targetY ty: CGFloat, tilt newTilt: Double, duration: Double, pause: Double) {
        withAnimation(.easeInOut(duration: duration)) {
            posX = tx
            posY = ty
        }
        // Luruskan tilt menjelang akhir perjalanan.
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.75) {
            withAnimation(.easeOut(duration: duration * 0.25)) { tilt = 0 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + pause) { swim() }
    }
}

#Preview {
    ZStack {
        Color.brandNavy.ignoresSafeArea()
        SwimmingFishView()
    }
}
