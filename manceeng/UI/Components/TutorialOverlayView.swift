//
//  TutorialOverlayView.swift
//  manceeng
//
//  Overlay interactive tutorial (coach marks): meredupkan layar, menyorot
//  satu elemen dengan glow, dan menampilkan bubble petunjuk + progress.
//
//  Created by M. Iqbal on 08/06/26.
//

import SwiftUI

// MARK: - Anchor preference

/// Mengumpulkan frame (bounds) tiap elemen yang bisa disorot tutorial.
struct TutorialAnchorKey: PreferenceKey {
    static let defaultValue: [TutorialTarget: Anchor<CGRect>] = [:]

    static func reduce(
        value: inout [TutorialTarget: Anchor<CGRect>],
        nextValue: () -> [TutorialTarget: Anchor<CGRect>]
    ) {
        value.merge(nextValue()) { $1 }
    }
}

extension View {
    /// Menandai view ini sebagai elemen yang bisa disorot oleh tutorial.
    func tutorialTarget(_ target: TutorialTarget) -> some View {
        anchorPreference(key: TutorialAnchorKey.self, value: .bounds) { [target: $0] }
    }
}

// MARK: - Overlay

struct TutorialOverlayView: View {
    let step: TutorialStep
    /// Frame elemen yang disorot (sudah di-resolve ke koordinat layar).
    let rect: CGRect
    let containerSize: CGSize
    let stepNumber: Int
    let totalSteps: Int
    let onNext: () -> Void

    @State private var calloutSize: CGSize = .zero

    private let holePadding: CGFloat = 10
    private let calloutGap: CGFloat = 16
    private let screenPadding: CGFloat = 20

    private var holeRect: CGRect {
        rect.insetBy(dx: -holePadding, dy: -holePadding)
    }

    /// Tombol bulat → lingkaran; kamera (rounded rect) → sudut tetap.
    private var holeCorner: CGFloat {
        step.target == .camera ? 30 : holeRect.height / 2
    }

    private var isLast: Bool { stepNumber >= totalSteps }

    var body: some View {
        ZStack(alignment: .topLeading) {
            // Lapisan redup dengan "lubang" di posisi elemen yang disorot.
            Color.black.opacity(0.65)
                .cutoutMask {
                    RoundedRectangle(cornerRadius: holeCorner, style: .continuous)
                        .frame(width: holeRect.width, height: holeRect.height)
                        .position(x: holeRect.midX, y: holeRect.midY)
                }
                .contentShape(Rectangle())
                .onTapGesture { }   // telan tap agar app di belakang tidak bisa ditekan

            // Glow putih mengelilingi elemen yang disorot.
            RoundedRectangle(cornerRadius: holeCorner, style: .continuous)
                .stroke(Color.white, lineWidth: 2)
                .frame(width: holeRect.width, height: holeRect.height)
                .position(x: holeRect.midX, y: holeRect.midY)
                .shadow(color: .white.opacity(0.9), radius: 10)
                .shadow(color: .white.opacity(0.6), radius: 22)
                .allowsHitTesting(false)

            // Bubble petunjuk.
            TutorialCallout(
                text: step.text,
                stepNumber: stepNumber,
                totalSteps: totalSteps,
                isLast: isLast,
                onNext: onNext
            )
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear { calloutSize = geo.size }
                        .onChange(of: geo.size) { _, newValue in calloutSize = newValue }
                }
            )
            .offset(calloutOffset)
        }
        .ignoresSafeArea()
    }

    /// Posisi (titik kiri-atas) bubble: di bawah/atas elemen, di-clamp dalam layar.
    private var calloutOffset: CGSize {
        let width = calloutSize.width
        let height = calloutSize.height

        var x = holeRect.midX - width / 2
        let maxX = max(screenPadding, containerSize.width - width - screenPadding)
        x = min(max(screenPadding, x), maxX)

        let y: CGFloat
        switch step.placement {
        case .below: y = holeRect.maxY + calloutGap
        case .above: y = holeRect.minY - calloutGap - height
        }

        return CGSize(width: x, height: y)
    }
}

// MARK: - Callout bubble

private struct TutorialCallout: View {
    let text: String
    let stepNumber: Int
    let totalSteps: Int
    let isLast: Bool
    let onNext: () -> Void

    var body: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text(text)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.black)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)

            if isLast {
                Button(action: onNext) {
                    Text("Start")
                        .font(.footnote.weight(.bold))
                        .foregroundStyle(.black)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 7)
                        .background(Capsule().fill(Color.black.opacity(0.08)))
                }
                .buttonStyle(.plain)
            } else {
                HStack(spacing: 10) {
                    Text("\(stepNumber)/\(totalSteps)")
                        .font(.footnote.weight(.bold))
                        .foregroundStyle(.black)

                    Button(action: onNext) {
                        Image(systemName: "arrow.right")
                            .font(.footnote.weight(.bold))
                            .foregroundStyle(.black)
                            .frame(width: 28, height: 28)
                            .overlay(Circle().stroke(.black, lineWidth: 1.3))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(16)
        .frame(width: 230, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white)
        )
        .shadow(color: .white.opacity(0.3), radius: 14)
        .shadow(color: .black.opacity(0.25), radius: 18, y: 6)
    }
}

// MARK: - Helpers

private extension View {
    /// Membuat "lubang" transparan pada view sesuai bentuk mask (destinationOut).
    @ViewBuilder
    func cutoutMask<M: View>(@ViewBuilder _ mask: () -> M) -> some View {
        self.mask {
            Rectangle()
                .overlay { mask().blendMode(.destinationOut) }
                .compositingGroup()
        }
    }
}
