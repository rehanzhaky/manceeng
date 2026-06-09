//
//  CatchReviewView.swift
//  manceeng
//
//  Created by Made Vidyatma Adhi Krisna on 07/06/26.
//

import SwiftUI

struct CatchReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: CatchReviewViewModel
    @State private var isTemplatePresented = false

    let onRetake: () -> Void
    let onSave: (Catch) -> Void

    init(
        image: UIImage?,
        segmentedFishes: [SegmentedFish],
        onRetake: @escaping () -> Void,
        onSave: @escaping (Catch) -> Void
    ) {
        _viewModel = StateObject(wrappedValue: CatchReviewViewModel(
            image: image,
            segmentedFishes: segmentedFishes
        ))
        self.onRetake = onRetake
        self.onSave = onSave
    }

    var body: some View {
        ZStack {
            LinearGradient.catchDetail
                .ignoresSafeArea()

            VStack(spacing: 16) {
                ScrollView {
                    VStack(spacing: 24) {
                        fishPreview
                        infoCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 76)
                    .padding(.bottom, 24)
                }
                .scrollBounceBehavior(.basedOnSize)

                saveButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
            }
        }
        .overlay(alignment: .top) { topBar }
        .fullScreenCover(isPresented: $isTemplatePresented) {
            TemplateScreen(
                fishCatches: [reviewFishCatch],
                shouldAutoShare: true
            )
        }
    }

    private var reviewFishCatch: FishCatch {
        FishCatch(
            fishName: viewModel.fishName.isEmpty ? "Catfish" : viewModel.fishName,
            weight: numericValue(from: viewModel.weightText, fallback: 0.7),
            length: numericValue(from: viewModel.lengthText, fallback: 15),
            fishImageName: "ikan_1"
        )
    }

    private var topBar: some View {
        HStack {
            CircleIconButton(systemName: "chevron.left") { onRetake() }

            Spacer()

            Button {
                isTemplatePresented = true
            } label: {
                GlassCircleIcon(systemName: "square.and.arrow.up")
            }
            .buttonStyle(GlassPressStyle())
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }

    private var fishPreview: some View {
        GeometryReader { proxy in
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white.opacity(0.08))

                if let image = viewModel.image,
                   let primaryFish = viewModel.primaryFish {
                    ReviewCroppedPreview(
                        image: image,
                        boundingBox: primaryFish.boundingBox,
                        displaySize: proxy.size
                    )
                } else if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(systemName: "fish.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundStyle(Color.brandWhite.opacity(0.9))
                        .padding(40)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shadow(color: .black.opacity(0.3), radius: 16, y: 10)
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 22) {
            field(label: "Nama Ikan", value: viewModel.fishName)

            HStack(alignment: .top, spacing: 0) {
                field(label: "Weight", value: viewModel.weightText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                field(label: "Length", value: viewModel.lengthText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            field(label: "Location", value: "South China Sea")
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.28), lineWidth: 1)
        )
    }

    private func field(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.brandWhite.opacity(0.7))
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(Color.brandWhite)
        }
    }

    private var saveButton: some View {
        ButtonOnboard(title: "Save") {
            onSave(savedCatch)
        }
    }

    /// Bangun model `Catch` dari hasil review untuk ditampilkan sebagai card di beranda.
    private var savedCatch: Catch {
        Catch(
            name: viewModel.fishName,
            weight: viewModel.weightText,
            length: viewModel.lengthText,
            image: viewModel.image,
            location: "South China Sea"
        )
    }

    private func numericValue(from text: String, fallback: Double) -> Double {
        let normalizedText = text.replacingOccurrences(of: ",", with: ".")
        let candidate = normalizedText
            .split(separator: " ")
            .compactMap { Double($0) }
            .first

        return candidate ?? fallback
    }
}

// MARK: - Cropped fish preview (shows region around the detected fish)

private struct ReviewCroppedPreview: View {
    let image: UIImage
    let boundingBox: CGRect  // Normalized, Vision coords (origin bottom-left)
    let displaySize: CGSize

    var body: some View {
        if let croppedImage = cropImageAroundFish() {
            ZStack {
                Image(uiImage: croppedImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: displaySize.width, maxHeight: displaySize.height)

                // Overlay bounding box on the cropped image
                GeometryReader { geo in
                    let imageFrame = aspectFitFrame(imageSize: croppedImage.size, displaySize: geo.size)
                    let box = bboxInCroppedSpace(imageFrame: imageFrame, croppedSize: croppedImage.size)

                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: box.width, height: box.height)
                        .position(x: box.midX, y: box.midY)

                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.brandSky, lineWidth: 2)
                        .frame(width: box.width + 5, height: box.height + 5)
                        .position(x: box.midX, y: box.midY)
                }
            }
        }
    }

    /// Crops the original image around the fish bounding box with padding
    private func cropImageAroundFish() -> UIImage? {
        let imgW = image.size.width
        let imgH = image.size.height

        // Convert Vision bbox (origin bottom-left) to UIKit coords (origin top-left)
        let fishRect = CGRect(
            x: boundingBox.minX * imgW,
            y: (1 - boundingBox.maxY) * imgH,
            width: boundingBox.width * imgW,
            height: boundingBox.height * imgH
        )

        // Add generous padding around the fish (40% of fish size on each side)
        let padX = fishRect.width * 0.4
        let padY = fishRect.height * 0.4

        let cropRect = CGRect(
            x: max(0, fishRect.minX - padX),
            y: max(0, fishRect.minY - padY),
            width: min(imgW, fishRect.maxX + padX) - max(0, fishRect.minX - padX),
            height: min(imgH, fishRect.maxY + padY) - max(0, fishRect.minY - padY)
        ).integral

        guard cropRect.width > 10, cropRect.height > 10,
              let cgImage = image.cgImage?.cropping(to: cropRect) else {
            return nil
        }

        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }

    /// Calculate where the bounding box should be drawn on the cropped image
    private func bboxInCroppedSpace(imageFrame: CGRect, croppedSize: CGSize) -> CGRect {
        let imgW = image.size.width
        let imgH = image.size.height

        // Fish rect in original image (UIKit coords)
        let fishRect = CGRect(
            x: boundingBox.minX * imgW,
            y: (1 - boundingBox.maxY) * imgH,
            width: boundingBox.width * imgW,
            height: boundingBox.height * imgH
        )

        // Crop origin in original image
        let padX = fishRect.width * 0.4
        let padY = fishRect.height * 0.4
        let cropOrigin = CGPoint(
            x: max(0, fishRect.minX - padX),
            y: max(0, fishRect.minY - padY)
        )

        // Fish rect relative to cropped image
        let relX = (fishRect.minX - cropOrigin.x) / croppedSize.width
        let relY = (fishRect.minY - cropOrigin.y) / croppedSize.height
        let relW = fishRect.width / croppedSize.width
        let relH = fishRect.height / croppedSize.height

        // Map to display coordinates
        return CGRect(
            x: imageFrame.minX + relX * imageFrame.width,
            y: imageFrame.minY + relY * imageFrame.height,
            width: relW * imageFrame.width,
            height: relH * imageFrame.height
        )
    }

    private func aspectFitFrame(imageSize: CGSize, displaySize: CGSize) -> CGRect {
        let scale = min(displaySize.width / imageSize.width, displaySize.height / imageSize.height)
        let width = imageSize.width * scale
        let height = imageSize.height * scale

        return CGRect(
            x: (displaySize.width - width) / 2,
            y: (displaySize.height - height) / 2,
            width: width,
            height: height
        )
    }
}

#Preview {
    CatchReviewView(image: nil, segmentedFishes: [], onRetake: {}, onSave: { _ in })
}
