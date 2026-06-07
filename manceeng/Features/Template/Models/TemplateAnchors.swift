//
//  TemplateAnchors.swift
//  manceeng
//
//  Created by Codex on 07/06/26.
//

import SwiftUI

struct ImageAnchor {
    let center: CGPoint
    let widthRatio: CGFloat
    let rotation: Angle
}

struct TextAnchor {
    let center: CGPoint
    let widthRatio: CGFloat
    let fontSizeRatio: CGFloat
    let rotation: Angle
    let weight: Font.Weight
    let color: Color
    let alignment: TextAlignment
    let uppercase: Bool
}

struct MetricAnchor {
    let center: CGPoint
    let widthRatio: CGFloat
    let labelFontSizeRatio: CGFloat
    let valueFontSizeRatio: CGFloat
    let rotation: Angle
    let labelColor: Color
    let valueColor: Color
    let alignment: HorizontalAlignment
}
