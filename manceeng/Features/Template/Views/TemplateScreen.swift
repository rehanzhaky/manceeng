//
//  TemplateScreen.swift
//  manceeng
//
//  Created by Codex on 07/06/26.
//

import SwiftUI

struct TemplateScreen: View {
    private let fishCatches: [FishCatch]
    private let layouts: [TemplateLayout]

    @State private var activeCarouselID: String?
    @State private var shareImage: ShareImage?

    private static let middleLoopIndex = 10
    private static let loopCount = 21

    init(
        fishCatches: [FishCatch] = FishCatch.samples,
        layouts: [TemplateLayout] = TemplateLayout.all
    ) {
        self.fishCatches = fishCatches
        self.layouts = layouts
        _activeCarouselID = State(initialValue: "\(Self.middleLoopIndex)-\(layouts[0].id)")
    }

    private var carouselItems: [CarouselTemplateItem] {
        (0..<Self.loopCount).flatMap { loopIndex in
            layouts.enumerated().map { index, layout in
                CarouselTemplateItem(
                    id: "\(loopIndex)-\(layout.id)",
                    layout: layout,
                    layoutIndex: index,
                    loopIndex: loopIndex
                )
            }
        }
    }

    private var activeLayout: TemplateLayout {
        guard let activeCarouselID,
              let item = carouselItems.first(where: { $0.id == activeCarouselID }) else {
            return layouts[0]
        }

        return item.layout
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 28) {
                carousel

                indicator

                Button {
                    shareCurrentTemplate()
                } label: {
                    Label("SHARE", systemImage: "square.and.arrow.up")
                        .font(.system(size: 17, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                }
                .buttonStyle(.borderedProminent)
                .tint(.brandBlue)
                .padding(.horizontal, 24)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Choose Template")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $shareImage) { item in
                ActivityView(activityItems: [item.image])
            }
        }
    }

    private var carousel: some View {
        GeometryReader { geometry in
            let cardWidth: CGFloat = 270
            let sidePadding = max((geometry.size.width - cardWidth) / 2, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 24) {
                    ForEach(carouselItems) { item in
                        TemplateCarouselCard(data: fishCatch(for: item.layoutIndex), layout: item.layout)
                            .frame(width: cardWidth)
                            .id(item.id)
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, sidePadding)
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $activeCarouselID)
        }
        .frame(height: 452)
        .frame(maxWidth: 430)
    }

    private var indicator: some View {
        HStack(spacing: 7) {
            ForEach(layouts) { layout in
                Circle()
                    .fill(layout.id == activeLayout.id ? Color.brandBlack : Color.brandBlack.opacity(0.24))
                    .frame(width: 6, height: 6)
            }
        }
        .frame(height: 8)
    }

    @MainActor
    private func shareCurrentTemplate() {
        let activeLayoutIndex = layouts.firstIndex { $0.id == activeLayout.id } ?? 0

        if let image = TemplateImageRenderer.render(data: fishCatch(for: activeLayoutIndex), layout: activeLayout) {
            shareImage = ShareImage(image: image)
        }
    }

    private func fishCatch(for index: Int) -> FishCatch {
        guard fishCatches.indices.contains(index) else {
            return fishCatches.first ?? .barramundiSample
        }

        return fishCatches[index]
    }

}

#Preview {
    TemplateScreen()
}
