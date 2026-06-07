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
    // fish.fill menghadap KANAN secara default — head at image (1, 0).
    // scaleX: -1 mirrors the fish so it faces LEFT.
    // tilt (rotationEffect) is applied AFTER scaleEffect, so transforms compose as:
    //   screen_pos = Rotation(tilt) * Scale(scaleX) * image_pos
    //
    // For head at image (1, 0):
    //   Right-facing (scaleX=+1): screen head = (cos tilt,  sin tilt)  → θ = atan2(dy, dx)
    //   Left-facing  (scaleX=-1): screen head = (−cos tilt, −sin tilt) → θ = atan2(−dy, −dx)
    @State private var scaleX: CGFloat = 1
    @State private var posX: CGFloat = 0
    @State private var posY: CGFloat = 0
    @State private var tilt: Double = 0        // −90° (atas) s/d +90° (bawah)

    private let rangeX: CGFloat = 90
    private let rangeY: CGFloat = 70

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color.brandSky.opacity(0.15))
                .frame(width: 65, height: 10)
                .blur(radius: 5)
                .offset(x: posX, y: rangeY - 4)

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
        let targetX = CGFloat.random(in: -rangeX * 0.85 ... rangeX * 0.85)
        let targetY = CGFloat.random(in: -rangeY * 0.85 ... rangeY * 0.85)

        let dx = targetX - posX
        let dy = targetY - posY
        let dist = sqrt(dx * dx + dy * dy)
        guard dist > 18 else { swim(); return }

        let newScaleX: CGFloat = dx > 5 ? 1 : (dx < -5 ? -1 : scaleX)
        let needsFlip = newScaleX != scaleX

        // Tilt so the head faces the destination.
        // Right-facing: head at (cos θ, sin θ)  → θ = atan2(dy,  dx)
        // Left-facing:  head at (−cos θ, −sin θ) → θ = atan2(−dy, −dx)
        let newTilt: Double
        if newScaleX > 0 {
            newTilt = atan2(Double(dy),  Double(dx))  * 180 / .pi
        } else {
            newTilt = atan2(-Double(dy), -Double(dx)) * 180 / .pi
        }

        let pxPerSec = Double.random(in: 38...68)
        let moveDur  = max(0.7, dist / CGFloat(pxPerSec))
        let pause    = Double.random(in: 0.1...0.6)

        if needsFlip {
            // Squish to flat, flip direction while invisible, then expand.
            withAnimation(.easeIn(duration: 0.08)) { scaleX = 0 }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                // scaleX state is 0; animate to newScaleX so the expand is visible.
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
        // Straighten toward horizontal near the end of each leg.
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
