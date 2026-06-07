//
//  TemplateCarouselCard.swift
//  manceeng
//
//  Created by Codex on 07/06/26.
//

import SwiftUI

struct TemplateCarouselCard: View {
    let data: FishCatch
    let layout: TemplateLayout

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(Color.black.opacity(0.08))
                .frame(height: 280)
                .padding(.horizontal, 18)

            TemplateCanvasView(data: data, layout: layout)
                .aspectRatio(layout.contentAspectRatio, contentMode: .fit)
                .frame(height: 430)
                .clipShape(RoundedRectangle(cornerRadius: 3, style: .continuous))
                .shadow(color: .black.opacity(0.22), radius: 12, x: 0, y: 8)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TemplateCarouselCard(data: .barramundiSample, layout: .templateOne)
}
