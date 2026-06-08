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
    @State private var showShareSection = false
    @State private var isTemplatePresented = false

    let onRetake: () -> Void
    let onDone: () -> Void

    init(
        image: UIImage?,
        segmentedFishes: [SegmentedFish],
        onRetake: @escaping () -> Void,
        onDone: @escaping () -> Void
    ) {
        _viewModel = StateObject(wrappedValue: CatchReviewViewModel(
            image: image,
            segmentedFishes: segmentedFishes
        ))
        self.onRetake = onRetake
        self.onDone = onDone
    }

    var body: some View {
        ZStack {
            AnimatedBackgroundView()

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                
                Spacer()
                
                fishPreview
                
                Spacer()
                
                infoCard
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
            }

            if showShareSection {
                shareSection
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.32, dampingFraction: 0.88), value: showShareSection)
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
            fishImageName: "ikan_1",
            fishImage: viewModel.image
        )
    }

    private var topBar: some View {
        HStack {
            Button {
                onRetake()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(.black)
                    .frame(width: 52, height: 52)
                    .background(.ultraThinMaterial, in: Circle())
                    .shadow(color: .black.opacity(0.15), radius: 4, y: 2)
            }
            .buttonStyle(.plain)

            Spacer()

            HStack(spacing: 8) {
                Button {
                    isTemplatePresented = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.black)
                }
                
                Button(role: .destructive) {
                    // Delete action
                } label: {
                    Image(systemName: "trash")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.black)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().stroke(.white.opacity(0.3), lineWidth: 1))
        }
    }

    private var fishPreview: some View {
        Group {
            if let image = viewModel.image,
               let primaryFish = viewModel.primaryFish {
                ReviewCroppedPreview(
                    image: image,
                    boundingBox: primaryFish.boundingBox,
                    displaySize: CGSize(width: 300, height: 300)
                )
            } else if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "fish.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.white.opacity(0.6))
                    .frame(width: 200, height: 200)
            }
        }
        .frame(height: 300)
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 24) {
            field(label: "Nama Ikan", value: viewModel.fishName.isEmpty ? "Catfish" : viewModel.fishName)

            HStack(alignment: .top, spacing: 0) {
                valueField(label: "Weight", value: viewModel.weightText.isEmpty ? "0.7" : viewModel.weightText, unit: "kg")
                    .frame(maxWidth: .infinity, alignment: .leading)
                valueField(label: "Length", value: viewModel.lengthText.isEmpty ? "15" : viewModel.lengthText, unit: "cm")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            field(label: "Location", value: "South China Sea")
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.white.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.25), lineWidth: 1)
        )
    }

    private func field(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.75))
            Text(value)
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
        }
    }

    private func valueField(label: String, value: String, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.75))
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text(value)
                    .font(.system(size: 40, weight: .bold))
                Text(unit)
                    .font(.title2.weight(.medium))
                    .foregroundStyle(.white.opacity(0.9))
            }
            .foregroundStyle(.white)
        }
    }

    private func numericValue(from text: String, fallback: Double) -> Double {
        let normalizedText = text.replacingOccurrences(of: ",", with: ".")
        let candidate = normalizedText
            .split(separator: " ")
            .compactMap { Double($0) }
            .first

        return candidate ?? fallback
    }

    private var shareSection: some View {
        VStack(spacing: 18) {
            HStack {
                Spacer()

                Button {
                    showShareSection = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(.white.opacity(0.18), in: Circle())
                }
                .buttonStyle(.plain)
            }

            Text("Share section")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(.white)

            HStack(spacing: 18) {
                shareButton(title: "Instagram", systemName: "camera.fill", color: Color(hex: "E4405F"))
                shareButton(title: "WhatsApp", systemName: "phone.fill", color: Color(hex: "25D366"))
                shareButton(title: "Message", systemName: "message.fill", color: Color(hex: "34C759"))
                shareButton(title: "More", systemName: "ellipsis", color: Color.white.opacity(0.9), darkIcon: true)
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 12)
        .padding(.bottom, 28)
        .frame(maxWidth: .infinity)
        .background(Color.brandNavy.opacity(0.92), in: RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white.opacity(0.18), lineWidth: 1)
        )
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea(edges: .bottom)
    }

    private func shareButton(title: String, systemName: String, color: Color, darkIcon: Bool = false) -> some View {
        VStack(spacing: 8) {
            Image(systemName: systemName)
                .font(.system(size: 23, weight: .bold))
                .foregroundStyle(darkIcon ? .black : .white)
                .frame(width: 50, height: 50)
                .background(color, in: RoundedRectangle(cornerRadius: 8))

            Text(title)
                .font(.system(size: 9, weight: .medium))
                .foregroundStyle(.white.opacity(0.86))
                .lineLimit(1)
                .minimumScaleFactor(0.72)
                .frame(width: 58)
        }
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
    CatchReviewView(image: nil, segmentedFishes: [], onRetake: {}, onDone: {})
}
