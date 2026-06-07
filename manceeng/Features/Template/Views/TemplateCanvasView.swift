//
//  TemplateCanvasView.swift
//  manceeng
//
//  Created by Codex on 07/06/26.
//

import SwiftUI

struct TemplateCanvasView: View {
    let data: FishCatch
    let layout: TemplateLayout
    var photoAdjustment: PhotoAdjustment = .identity
    var onPhotoAdjustmentChange: ((PhotoAdjustment) -> Void)?

    @State private var basePhotoAdjustment = PhotoAdjustment.identity
    @GestureState private var dragTranslation: CGSize = .zero
    @GestureState private var magnification: CGFloat = 1
    @GestureState private var rotation: Angle = .degrees(0)

    var body: some View {
        GeometryReader { geometry in
            let canvasSize = geometry.size
            let contentSize = fittedContentSize(in: canvasSize, aspectRatio: layout.contentAspectRatio)
            let contentOrigin = CGPoint(
                x: (canvasSize.width - contentSize.width) / 2,
                y: (canvasSize.height - contentSize.height) / 2
            )

            ZStack {
                layout.fishName.color.opacity(0.08)
                    .ignoresSafeArea()

                switch layout.renderMode {
                case .normal:
                    normalTemplateLayers(in: canvasSize, contentSize: contentSize, contentOrigin: contentOrigin)
                case .twibbon:
                    twibbonTemplateLayers(in: canvasSize, contentSize: contentSize, contentOrigin: contentOrigin)
                }

                anchoredText(fishName, anchor: layout.fishName, in: contentSize, origin: contentOrigin)

                metricView(label: "", value: "\(Int(data.length))", anchor: layout.length, in: contentSize, origin: contentOrigin)

                metricView(label: "", value: formattedNumber(data.weight), anchor: layout.weight, in: contentSize, origin: contentOrigin)
            }
        }
        .aspectRatio(layout.contentAspectRatio, contentMode: .fit)
        .onAppear {
            basePhotoAdjustment = photoAdjustment
        }
        .onChange(of: photoAdjustment.scale) { _, _ in
            basePhotoAdjustment = photoAdjustment
        }
        .onChange(of: photoAdjustment.offset) { _, _ in
            basePhotoAdjustment = photoAdjustment
        }
        .onChange(of: photoAdjustment.rotation) { _, _ in
            basePhotoAdjustment = photoAdjustment
        }
    }

    private var fishName: String {
        layout.fishName.uppercase ? data.fishName.uppercased() : data.fishName
    }

    private var currentPhotoAdjustment: PhotoAdjustment {
        PhotoAdjustment(
            scale: max(0.6, min(basePhotoAdjustment.scale * magnification, 4)),
            offset: CGSize(
                width: basePhotoAdjustment.offset.width + dragTranslation.width,
                height: basePhotoAdjustment.offset.height + dragTranslation.height
            ),
            rotation: basePhotoAdjustment.rotation + rotation
        )
    }

    private func normalTemplateLayers(in canvasSize: CGSize, contentSize: CGSize, contentOrigin: CGPoint) -> some View {
        ZStack {
            templateOverlay(in: canvasSize, contentSize: contentSize)

            fishImage(in: contentSize, origin: contentOrigin)
        }
    }

    private func twibbonTemplateLayers(in canvasSize: CGSize, contentSize: CGSize, contentOrigin: CGPoint) -> some View {
        ZStack {
            adjustableFishImage(in: contentSize, origin: contentOrigin)

            templateOverlay(in: canvasSize, contentSize: contentSize)
        }
        .contentShape(Rectangle())
        .gesture(photoAdjustmentGesture)
    }

    private func templateOverlay(in canvasSize: CGSize, contentSize: CGSize) -> some View {
        Image(layout.backgroundImageName)
            .resizable()
            .scaledToFit()
            .frame(width: contentSize.width, height: contentSize.height)
            .position(x: canvasSize.width / 2, y: canvasSize.height / 2)
    }

    private func fishImage(in size: CGSize, origin: CGPoint) -> some View {
        Image(data.fishImageName)
            .resizable()
            .scaledToFit()
            .frame(width: size.width * layout.fishImage.widthRatio)
            .rotationEffect(layout.fishImage.rotation)
            .position(position(for: layout.fishImage.center, in: size, origin: origin))
            .shadow(color: .black.opacity(0.22), radius: size.width * 0.018, x: 0, y: size.width * 0.012)
    }

    private func adjustableFishImage(in size: CGSize, origin: CGPoint) -> some View {
        let adjustment = currentPhotoAdjustment

        return Image(data.fishImageName)
            .resizable()
            .scaledToFill()
            .frame(width: size.width, height: size.height)
            .scaleEffect(adjustment.scale)
            .rotationEffect(layout.fishImage.rotation + adjustment.rotation)
            .position(position(for: layout.fishImage.center, in: size, origin: origin))
            .offset(adjustment.offset)
            .clipped()
    }

    private var photoAdjustmentGesture: some Gesture {
        SimultaneousGesture(
            DragGesture()
                .updating($dragTranslation) { value, state, _ in
                    state = value.translation
                }
                .onEnded { value in
                    basePhotoAdjustment.offset.width += value.translation.width
                    basePhotoAdjustment.offset.height += value.translation.height
                    onPhotoAdjustmentChange?(basePhotoAdjustment)
                },
            SimultaneousGesture(
                MagnificationGesture()
                    .updating($magnification) { value, state, _ in
                        state = value
                    }
                    .onEnded { value in
                        basePhotoAdjustment.scale = max(0.6, min(basePhotoAdjustment.scale * value, 4))
                        onPhotoAdjustmentChange?(basePhotoAdjustment)
                    },
                RotationGesture()
                    .updating($rotation) { value, state, _ in
                        state = value
                    }
                    .onEnded { value in
                        basePhotoAdjustment.rotation += value
                        onPhotoAdjustmentChange?(basePhotoAdjustment)
                    }
            )
        )
    }

    private func anchoredText(_ text: String, anchor: TextAnchor, in size: CGSize, origin: CGPoint) -> some View {
        Text(text)
            .font(.system(size: size.width * anchor.fontSizeRatio, weight: anchor.weight, design: .rounded))
            .foregroundColor(anchor.color)
            .multilineTextAlignment(anchor.alignment)
            .lineLimit(2)
            .minimumScaleFactor(0.62)
            .frame(width: size.width * anchor.widthRatio)
            .rotationEffect(anchor.rotation)
            .position(position(for: anchor.center, in: size, origin: origin))
    }

    private func metricView(label: String, value: String, anchor: MetricAnchor, in size: CGSize, origin: CGPoint) -> some View {
        VStack(alignment: anchor.alignment, spacing: size.width * 0.008) {
            Text(label.uppercased())
                .font(.system(size: size.width * anchor.labelFontSizeRatio, weight: .medium, design: .rounded))
                .foregroundColor(anchor.labelColor)
                .lineLimit(1)

            Text(value)
                .font(.system(size: size.width * anchor.valueFontSizeRatio, weight: .black, design: .rounded))
                .foregroundColor(anchor.valueColor)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
        .frame(width: size.width * anchor.widthRatio, alignment: alignment(for: anchor.alignment))
        .rotationEffect(anchor.rotation)
        .position(position(for: anchor.center, in: size, origin: origin))
    }

    private func formattedNumber(_ value: Double) -> String {
        let formatted = String(format: "%.2f", value)
        return formatted
            .replacingOccurrences(of: #"0+$"#, with: "", options: .regularExpression)
            .replacingOccurrences(of: #"\.$"#, with: "", options: .regularExpression)
    }

    private func fittedContentSize(in canvasSize: CGSize, aspectRatio: CGFloat) -> CGSize {
        let canvasAspectRatio = canvasSize.width / canvasSize.height

        if canvasAspectRatio > aspectRatio {
            let height = canvasSize.height
            return CGSize(width: height * aspectRatio, height: height)
        }

        let width = canvasSize.width
        return CGSize(width: width, height: width / aspectRatio)
    }

    private func position(for point: CGPoint, in size: CGSize, origin: CGPoint) -> CGPoint {
        CGPoint(x: origin.x + size.width * point.x, y: origin.y + size.height * point.y)
    }

    private func alignment(for horizontalAlignment: HorizontalAlignment) -> Alignment {
        switch horizontalAlignment {
        case .leading:
            return .leading
        case .trailing:
            return .trailing
        default:
            return .center
        }
    }
}

#Preview {
    TemplateCanvasView(data: .barramundiSample, layout: .templateOne)
}
