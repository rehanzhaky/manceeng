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

                Image(layout.backgroundImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: contentSize.width, height: contentSize.height)
                    .position(x: canvasSize.width / 2, y: canvasSize.height / 2)

                Image(data.fishImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: contentSize.width * layout.fishImage.widthRatio)
                    .rotationEffect(layout.fishImage.rotation)
                    .position(position(for: layout.fishImage.center, in: contentSize, origin: contentOrigin))
                    .shadow(color: .black.opacity(0.22), radius: contentSize.width * 0.018, x: 0, y: contentSize.width * 0.012)

                anchoredText(fishName, anchor: layout.fishName, in: contentSize, origin: contentOrigin)

                metricView(label: "", value: "\(Int(data.length))", anchor: layout.length, in: contentSize, origin: contentOrigin)

                metricView(label: "", value: formattedNumber(data.weight), anchor: layout.weight, in: contentSize, origin: contentOrigin)
            }
        }
        .aspectRatio(layout.contentAspectRatio, contentMode: .fit)
    }

    private var fishName: String {
        layout.fishName.uppercase ? data.fishName.uppercased() : data.fishName
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
