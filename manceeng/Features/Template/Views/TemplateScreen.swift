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
    private let shouldAutoShare: Bool

    @Environment(\.dismiss) private var dismiss
    @State private var activeCarouselID: String?
    @State private var selectedLayoutID: String
    @State private var shareImage: ShareImage?
    @State private var photoAdjustments: [String: PhotoAdjustment] = [:]
    @State private var isShowingSharePanel: Bool
    @State private var didActivateInitialCarousel = false

    private static let middleLoopIndex = 10
    private static let loopCount = 21

    init(
        fishCatches: [FishCatch] = FishCatch.samples,
        layouts: [TemplateLayout] = TemplateLayout.all,
        shouldAutoShare: Bool = false
    ) {
        self.fishCatches = fishCatches
        self.layouts = layouts
        self.shouldAutoShare = shouldAutoShare
        let initialIndex = 0
        _activeCarouselID = State(initialValue: "\(Self.middleLoopIndex)-\(layouts[initialIndex].id)")
        _selectedLayoutID = State(initialValue: layouts[initialIndex].id)
        _isShowingSharePanel = State(initialValue: shouldAutoShare)
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
        guard let layout = layouts.first(where: { $0.id == selectedLayoutID }) else {
            return layouts[0]
        }

        return layout
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                AnimatedBackgroundView()

                VStack(spacing: 18) {
                    topBar

                    Spacer(minLength: 0)
                        .frame(maxHeight: isShowingSharePanel ? 28 : nil)

                    carousel

                    indicator

                    Spacer(minLength: 0)
                }
                .padding(.top, 8)
                .padding(.bottom, isShowingSharePanel ? 210 : 0)
                .onChange(of: activeCarouselID) { _, newValue in
                    guard let newValue,
                          let item = carouselItems.first(where: { $0.id == newValue }) else {
                        return
                    }

                    selectedLayoutID = item.layout.id
                }

                if isShowingSharePanel {
                    sharePanel
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .ignoresSafeArea(edges: .bottom)
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .sheet(item: $shareImage) { item in
                ActivityView(activityItems: [item.image])
            }
            .onAppear {
                activateInitialCarouselIfNeeded()
            }
        }
    }

    private var topBar: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(Color.brandWhite)
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial, in: Circle())
            }

            Spacer()

            Text("Choose Template")
                .font(.headline)
                .foregroundStyle(Color.brandWhite)

            Spacer()

            Color.clear
                .frame(width: 44, height: 44)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }

    private var sharePanel: some View {
        VStack(spacing: 18) {
            Text("Share Action")
                .font(.headline.weight(.semibold))
                .foregroundStyle(Color.brandWhite)

            HStack(spacing: 22) {
                shareOption(title: "Instagram", assetName: "instagram") {
                    shareCurrentTemplate()
                }

                shareOption(title: "WhatsApp", assetName: "whatsapp", iconScale: 1.38) {
                    shareCurrentTemplate()
                }

                shareOption(title: "Message", assetName: "imessege") {
                    shareCurrentTemplate()
                }

                shareOption(title: "More", systemName: "ellipsis", backgroundColor: Color.brandWhite.opacity(0.92), foregroundColor: .brandBlack) {
                    shareCurrentTemplate()
                }
            }
        }
        .padding(.top, 12)
        .padding(.horizontal, 24)
        .padding(.bottom, 20)
        .frame(maxWidth: .infinity, maxHeight: 200 )
        .background(
            UnevenRoundedRectangle(
                topLeadingRadius: Radius.borderRadius,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: Radius.borderRadius,
                style: .continuous
            )
                .fill(Color.brandDark.opacity(0.94))
                .overlay(
                    UnevenRoundedRectangle(
                        topLeadingRadius: Radius.borderRadius,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: Radius.borderRadius,
                        style: .continuous
                    )
                        .stroke(Color.brandWhite.opacity(0.18), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.22), radius: 18, x: 0, y: 10)
        .ignoresSafeArea(edges: .bottom)
    }

    private func shareOption(
        title: String,
        assetName: String? = nil,
        systemName: String? = nil,
        backgroundColor: Color = .clear,
        foregroundColor: Color = .brandWhite,
        iconScale: CGFloat = 1,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 8) {
                shareIcon(
                    assetName: assetName,
                    systemName: systemName,
                    backgroundColor: backgroundColor,
                    foregroundColor: foregroundColor,
                    iconScale: iconScale
                )

                Text(title)
                    .font(.caption2)
                    .foregroundStyle(Color.brandWhite.opacity(0.86))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: 64)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private func shareIcon(
        assetName: String?,
        systemName: String?,
        backgroundColor: Color,
        foregroundColor: Color,
        iconScale: CGFloat
    ) -> some View {
        if let assetName {
            Image(assetName)
                .resizable()
                .scaledToFit()
                .frame(width: 52, height: 52)
                .scaleEffect(iconScale)
        } else if let systemName {
            Image(systemName: systemName)
                .font(.system(size: 25, weight: .bold))
                .foregroundStyle(foregroundColor)
                .frame(width: 52, height: 52)
                .background(backgroundColor, in: RoundedRectangle(cornerRadius: 11, style: .continuous))
        }
    }

    private var carousel: some View {
        GeometryReader { geometry in
            let cardWidth: CGFloat = 224
            let sidePadding = max((geometry.size.width - cardWidth) / 2, 24)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(carouselItems) { item in
                        TemplateCarouselCard(
                            data: fishCatch(for: item.layoutIndex),
                            layout: item.layout,
                            photoAdjustment: photoAdjustment(for: item.layout),
                            onPhotoAdjustmentChange: { adjustment in
                                photoAdjustments[item.layout.id] = adjustment
                            }
                        )
                            .frame(width: cardWidth)
                            .scaleEffect(isActiveCarouselItem(item) ? 1.0 : 0.78)
                            .opacity(isActiveCarouselItem(item) ? 1.0 : 0.64)
                            .zIndex(isActiveCarouselItem(item) ? 1 : 0)
                            .animation(.spring(response: 0.32, dampingFraction: 0.86), value: selectedLayoutID)
                            .animation(.spring(response: 0.32, dampingFraction: 0.86), value: activeCarouselID)
                            .id(item.id)
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, sidePadding)
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $activeCarouselID)
        }
        .frame(height: 430)
        .frame(maxWidth: 430)
    }

    private var indicator: some View {
        HStack(spacing: 7) {
            ForEach(layouts) { layout in
                Circle()
                    .fill(layout.id == activeLayout.id ? Color.brandWhite : Color.brandWhite.opacity(0.32))
                    .frame(width: 6, height: 6)
            }
        }
        .frame(height: 8)
    }

    @MainActor
    private func shareCurrentTemplate() {
        let activeLayoutIndex = layouts.firstIndex { $0.id == activeLayout.id } ?? 0

        if let image = TemplateImageRenderer.render(
            data: fishCatch(for: activeLayoutIndex),
            layout: activeLayout,
            photoAdjustment: photoAdjustment(for: activeLayout)
        ) {
            shareImage = ShareImage(image: image)
        }
    }

    private func fishCatch(for index: Int) -> FishCatch {
        guard fishCatches.indices.contains(index) else {
            return fishCatches.first ?? .barramundiSample
        }

        return fishCatches[index]
    }

    private func photoAdjustment(for layout: TemplateLayout) -> PhotoAdjustment {
        photoAdjustments[layout.id] ?? .identity
    }

    private func isActiveCarouselItem(_ item: CarouselTemplateItem) -> Bool {
        if let activeCarouselID {
            return item.id == activeCarouselID
        }

        return item.loopIndex == Self.middleLoopIndex && item.layout.id == selectedLayoutID
    }

    private func activateInitialCarouselIfNeeded() {
        guard !didActivateInitialCarousel else {
            return
        }

        didActivateInitialCarousel = true
        let initialID = "\(Self.middleLoopIndex)-\(selectedLayoutID)"
        selectedLayoutID = carouselItems.first(where: { $0.id == initialID })?.layout.id ?? selectedLayoutID

        DispatchQueue.main.async {
            DispatchQueue.main.asyncAfter(deadline: .now() + (shouldAutoShare ? 0.08 : 0.02)) {
                selectedLayoutID = carouselItems.first(where: { $0.id == initialID })?.layout.id ?? selectedLayoutID
                activeCarouselID = initialID
            }
        }
    }

}

#Preview {
    TemplateScreen()
}
