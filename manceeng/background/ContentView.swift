//
//  ContentView.swift
//  Challenge3
//
//  Created by M. Iqbal on 04/06/26.
//

import SwiftUI

extension Color {
    /// Warna background utama (versi lebih deep dari #04044A → #02022E)
    static let appBackground = Color(red: 0x02 / 255, green: 0x02 / 255, blue: 0x2E / 255)
    /// Warna gradient #0090DF
    static let appGradient = Color(red: 0x00 / 255, green: 0x90 / 255, blue: 0xDF / 255)
}

extension View {
    /// Gaya liquid glass: fill abu-abu/biru tua semi-transparan + aksen gradient biru di tepi.
    @ViewBuilder
    func glassStyle<S: InsettableShape>(_ shape: S, lineWidth: CGFloat = 1.5) -> some View {
        self
            .background {
                ZStack {
                    // Fill abu-abu/biru tua — memberi kesan "tinted glass" seperti di screenshot
                    shape.fill(Color(red: 0.08, green: 0.12, blue: 0.30).opacity(0.55))

                    // Lapisan glass iOS 26 / material fallback di atasnya
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
                            Color.appGradient.opacity(0.9),
                            Color.appGradient.opacity(0.15)
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

/// Satu bubble gradient yang mengembara ke titik-titik acak di layar
/// sambil berdenyut membesar–mengecil.
struct GradientBubble: View {
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
                            Color.appGradient.opacity(0.85),
                            Color.appGradient.opacity(0.0)
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

struct AnimatedBackground: View {
    var body: some View {
        ZStack {
            // Lapisan dasar solid yang TIDAK di-blur.
            // Jadi kalaupun tepi blur memudar/transparan, yang terlihat tetap warna ini (bukan putih).
            Color.appBackground
                .ignoresSafeArea()

            // Lapisan bubble yang di-blur, bergerak acak, ukuran besar–kecil bervariasi.
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

/// Tombol kamera bergaya liquid glass: tengah transparan, hanya aksen gradient biru di tepi.
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
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
                .frame(width: size, height: size)
                // Liquid glass transparan + aksen gradient biru di tepi
                .glassStyle(shape)
                // Glow biru lembut di luar tombol
                .shadow(color: Color.appGradient.opacity(0.6), radius: 16)
                .shadow(color: Color.appGradient.opacity(0.3), radius: 28)
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

/// Tombol ikon bulat bergaya glass untuk top bar — sama persis gaya dengan CameraButton.
struct CircleIconButton: View {
    let systemName: String
    var action: () -> Void
    @State private var pressed = false

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(.white)
                .shadow(color: .black.opacity(0.2), radius: 2, y: 1)
                .frame(width: 52, height: 52)
                .glassStyle(Circle())
                .shadow(color: Color.appGradient.opacity(0.6), radius: 16)
                .shadow(color: Color.appGradient.opacity(0.3), radius: 28)
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

/// Data satu tangkapan ikan.
struct Catch: Identifiable {
    let id = UUID()
    let name: String
    let weight: String
    let length: String
}

/// Kartu satu tangkapan ikan bergaya glass.
struct CatchCard: View {
    let item: Catch

    private let corner: CGFloat = 28
    private let cardWidth: CGFloat = 270
    private let cardHeight: CGFloat = 300

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(item.name)
                .font(.title3.bold())
                .foregroundStyle(.white)

            Spacer(minLength: 12)

            Image(systemName: "fish.fill")
                .font(.system(size: 78))
                .foregroundStyle(.white.opacity(0.85))
                .frame(maxWidth: .infinity)

            Spacer(minLength: 12)

            HStack {
                Text("Weight: \(item.weight)")
                Spacer()
                Text("Length: \(item.length)")
            }
            .font(.subheadline)
            .foregroundStyle(.white.opacity(0.9))
        }
        .padding(20)
        .frame(width: cardWidth, height: cardHeight)
        .glassStyle(RoundedRectangle(cornerRadius: corner, style: .continuous))
        .shadow(color: Color.appGradient.opacity(0.45), radius: 24)
        .shadow(color: Color.appGradient.opacity(0.2), radius: 40)
    }
}

/// Ikan berenang bebas ke segala arah, rotasi mengikuti arah gerak.
struct SwimmingFish: View {
    // fish.fill menghadap KANAN secara default (0°).
    // scaleX: -1 dipakai saat bergerak ke kiri agar ikan tidak terbalik (belly tetap di bawah).
    // Tilt (rotasi) dihitung dari komponen vertikal relatif terhadap arah hadap ikan.
    @State private var scaleX: CGFloat = 1
    @State private var posX: CGFloat = 0
    @State private var posY: CGFloat = 0
    @State private var tilt: Double = 0        // −90° (atas) s/d +90° (bawah)

    // Batas area renang dalam frame
    private let rangeX: CGFloat = 90
    private let rangeY: CGFloat = 70

    var body: some View {
        ZStack {
            // Bayangan elips — posisi ikut ikan, opacity berubah dengan ketinggian
            Ellipse()
                .fill(Color.appGradient.opacity(0.15))
                .frame(width: 65, height: 10)
                .blur(radius: 5)
                .offset(x: posX, y: rangeY - 4)   // selalu di "lantai" area

            Image(systemName: "fish.fill")
                .font(.system(size: 64))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.appGradient, Color.appGradient.opacity(0.5)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: Color.appGradient.opacity(0.6), radius: 10)
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
        // Titik tujuan acak dalam area renang
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
        // Untuk ikan yang menghadap kanan: tilt = atan2(dy, dx)
        // Untuk ikan yang menghadap kiri : mirror → atan2(dy, -dx)
        let effectiveDX = newScaleX > 0 ? Double(dx) : Double(-dx)
        let newTilt = atan2(Double(dy), effectiveDX) * 180 / .pi

        let pxPerSec = Double.random(in: 38...68)
        let moveDur  = max(0.7, dist / CGFloat(pxPerSec))
        let pause    = Double.random(in: 0.1...0.6)

        if needsFlip {
            // Squish → flip → expand sebelum bergerak
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
        // Luruskan tilt menjelang akhir perjalanan
        DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.75) {
            withAnimation(.easeOut(duration: duration * 0.25)) { tilt = 0 }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration + pause) { swim() }
    }
}

/// Empty state — ikan berenang bebas tanpa container card.
struct EmptyCatchState: View {
    var body: some View {
        VStack(spacing: 16) {
            SwimmingFish()

            Text("Perlu tambah gambar dulu")
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.5))
        }
    }
}

/// Kartu tangkapan — kalau kosong tampilkan empty state.
struct CatchCardStack: View {
    let catches: [Catch]

    var body: some View {
        ZStack {
            if catches.isEmpty {
                EmptyCatchState()
            } else {
                if let front = catches.first {
                    CatchCard(item: front)
                }
            }
        }
    }
}

struct ContentView: View {
    @StateObject private var ambient = AmbientSound()

    // Kosongkan untuk lihat empty state; isi untuk lihat kartu.
    private let catches: [Catch] = []

    var body: some View {
        ZStack {
            AnimatedBackground()

            VStack(spacing: 0) {
                // Top bar: ikon peta (kiri) & ikan (kanan)
                HStack {
                    CircleIconButton(systemName: "map.fill") {}
                    Spacer()
                    CircleIconButton(systemName: "fish.fill") {}
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)

                // Judul
                HStack {
                    Text("Top 5 Catches")
                        .font(.largeTitle.bold())
                        .foregroundStyle(.white)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 28)

                Spacer()

                CatchCardStack(catches: catches)

                Spacer()

                // Tombol kamera di tengah-bawah
                CameraButton {
                    SoundEffect.cameraShutter()
                    // TODO: aksi buka kamera
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear { ambient.start() }
        .onDisappear { ambient.stop() }
    }
}

#Preview {
    ContentView()
}
