//
//  TemplateImageRenderer.swift
//  manceeng
//
//  Created by Codex on 07/06/26.
//

import SwiftUI
import UIKit

enum TemplateImageRenderer {
    @MainActor
    static func render(
        data: FishCatch,
        layout: TemplateLayout,
        photoAdjustment: PhotoAdjustment = .identity,
        exportLongSide: CGFloat = 2048
    ) -> UIImage? {
        let exportSize = exportSize(for: layout, longSide: exportLongSide)
        let content = TemplateCanvasView(data: data, layout: layout, photoAdjustment: photoAdjustment)
            .frame(width: exportSize.width, height: exportSize.height)

        let renderer = ImageRenderer(content: content)
        renderer.scale = 1
        renderer.proposedSize = ProposedViewSize(exportSize)

        return renderer.uiImage
    }

    private static func exportSize(for layout: TemplateLayout, longSide: CGFloat) -> CGSize {
        let aspectRatio = layout.contentAspectRatio

        if aspectRatio >= 1 {
            return CGSize(width: longSide, height: longSide / aspectRatio)
        }

        return CGSize(width: longSide * aspectRatio, height: longSide)
    }
}
