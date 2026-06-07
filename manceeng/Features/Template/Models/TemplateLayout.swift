//
//  TemplateLayout.swift
//  manceeng
//
//  Created by Codex on 07/06/26.
//

import SwiftUI

struct TemplateLayout: Identifiable {
    let id: String
    let name: String
    let backgroundImageName: String
    let contentAspectRatio: CGFloat
    let fishImage: ImageAnchor
    let fishName: TextAnchor
    let length: MetricAnchor
    let weight: MetricAnchor
}
