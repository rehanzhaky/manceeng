//
//  TemplateLayouts.swift
//  manceeng
//
//  Created by Codex on 07/06/26.
//

import SwiftUI

extension TemplateLayout {
    static let all: [TemplateLayout] = [
        .templateOne,
        .templateTwo,
        .templateThree
    ]

    static let templateOne = TemplateLayout(
        id: "template_1",
        name: "Template 1",
        backgroundImageName: "template_1",
        contentAspectRatio: 941.0 / 1672.0,
        
        fishImage: ImageAnchor(
            center: CGPoint(x: 0.50, y: 0.53),
            widthRatio: 0.76,
            rotation: .degrees(-4)
        ),
        fishName: TextAnchor(
            center: CGPoint(x: 0.50, y: 0.695),
            widthRatio: 0.72,
            fontSizeRatio: 0.07,
            rotation: .degrees(0),
            weight: .black,
            color: .brandWhite,
            alignment: .center,
            uppercase: true
        ),
        length: MetricAnchor(
            center: CGPoint(x: 0.165, y: 0.835),
            widthRatio: 0.30,
            labelFontSizeRatio: 0.024,
            valueFontSizeRatio: 0.090,
            rotation: .degrees(0),
            labelColor: .brandBlack.opacity(0.58),
            valueColor: .brandBlack,
            alignment: .center
        ),
        weight: MetricAnchor(
            center: CGPoint(x: 0.835, y: 0.835),
            widthRatio: 0.30,
            labelFontSizeRatio: 0.024,
            valueFontSizeRatio: 0.085,
            rotation: .degrees(0),
            labelColor: .brandBlack.opacity(0.58),
            valueColor: .brandBlack,
            alignment: .center
        )
    )

    static let templateTwo = TemplateLayout(
        id: "template_2",
        name: "Template 2",
        backgroundImageName: "template_2",
        contentAspectRatio: 941.0 / 1672.0,
        fishImage: ImageAnchor(
            center: CGPoint(x: 0.50, y: 0.65),
            widthRatio: 0.70,
            rotation: .degrees(3)
        ),
        fishName: TextAnchor(
            center: CGPoint(x: 0.50, y: 0.3),
            widthRatio: 0.76,
            fontSizeRatio: 0.06,
            rotation: .degrees(0),
            weight: .heavy,
            color: .brandBlack,
            alignment: .center,
            uppercase: true
        ),
        length: MetricAnchor(
            center: CGPoint(x: 0.23, y: 0.87),
            widthRatio: 0.28,
            labelFontSizeRatio: 0.022,
            valueFontSizeRatio: 0.12,
            rotation: .degrees(0),
            labelColor: .brandBlack.opacity(0.74),
            valueColor: .brandBlack,
            alignment: .center
        ),
        weight: MetricAnchor(
            center: CGPoint(x: 0.72, y: 0.87),
            widthRatio: 0.28,
            labelFontSizeRatio: 0.022,
            valueFontSizeRatio: 0.12,
            rotation: .degrees(0),
            labelColor: .brandBlack.opacity(0.74),
            valueColor: .brandBlack,
            alignment: .center
        )
    )

    static let templateThree = TemplateLayout(
        id: "template_3",
        name: "Template 3",
        backgroundImageName: "template_3",
        contentAspectRatio: 941.0 / 1672.0,
        
        fishImage: ImageAnchor(
            center: CGPoint(x: 0.50, y: 0.65),
            widthRatio: 0.70,
            rotation: .degrees(3)
        ),
        fishName: TextAnchor(
            center: CGPoint(x: 0.50, y: 0.3),
            widthRatio: 0.76,
            fontSizeRatio: 0.06,
            rotation: .degrees(0),
            weight: .heavy,
            color: .brandBlack,
            alignment: .center,
            uppercase: true
        ),
        length: MetricAnchor(
            center: CGPoint(x: 0.23, y: 0.87),
            widthRatio: 0.28,
            labelFontSizeRatio: 0.022,
            valueFontSizeRatio: 0.12,
            rotation: .degrees(0),
            labelColor: .brandBlack.opacity(0.74),
            valueColor: .brandBlack,
            alignment: .center
        ),
        weight: MetricAnchor(
            center: CGPoint(x: 0.72, y: 0.87),
            widthRatio: 0.28,
            labelFontSizeRatio: 0.022,
            valueFontSizeRatio: 0.12,
            rotation: .degrees(0),
            labelColor: .brandBlack.opacity(0.74),
            valueColor: .brandBlack,
            alignment: .center
        )
    )
}
