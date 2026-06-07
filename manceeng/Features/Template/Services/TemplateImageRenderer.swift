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
        exportSize: CGSize = CGSize(width: 2048, height: 2048)
    ) -> UIImage? {
        let content = TemplateCanvasView(data: data, layout: layout, photoAdjustment: photoAdjustment)
            .frame(width: exportSize.width, height: exportSize.height)

        let renderer = ImageRenderer(content: content)
        renderer.scale = 1
        renderer.proposedSize = ProposedViewSize(exportSize)

        return renderer.uiImage
    }
}
