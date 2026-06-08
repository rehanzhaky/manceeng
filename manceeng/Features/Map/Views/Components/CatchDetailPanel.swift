//
//  CatchDetailPanel.swift
//  manceeng
//
//  Bottom panel custom (pengganti .sheet) untuk detail tangkapan di peta.
//  Sudut kotak, full lebar tanpa space, drag ke bawah untuk menutup, dan
//  tidak menggelapkan map.
//
//  Created by M. Iqbal on 09/06/26.
//

import SwiftUI
import CoreLocation

struct CatchDetailPanel: View {
    let location: CatchLocation
    var onClose: () -> Void

    /// Tinggi panel sebagai fraksi tinggi layar (sisanya = strip map di atas).
    var heightFraction: CGFloat = 0.70

    @State private var dragOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geo in
            let height = geo.size.height * heightFraction

            VStack(spacing: 0) {
                Capsule()
                    .fill(Color.white.opacity(0.5))
                    .frame(width: 40, height: 5)
                    .padding(.top, 10)
                    .padding(.bottom, 2)

                CatchDetailContent(location: location)
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(LinearGradient.catchDetail)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 28,
                    topTrailingRadius: 28,
                    style: .continuous
                )
            )
            .frame(maxHeight: .infinity, alignment: .bottom)
            .offset(y: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            dragOffset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > height * 0.3 {
                            onClose()
                        } else {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                                dragOffset = 0
                            }
                        }
                    }
            )
        }
        .ignoresSafeArea()
        .transition(.move(edge: .bottom))
    }
}

#Preview {
    ZStack {
        Color.green.ignoresSafeArea()
        CatchDetailPanel(
            location: CatchLocation(
                fishName: "Catfish",
                coordinate: .init(latitude: 1.0, longitude: 104.0),
                weightKg: 0.7,
                lengthCm: 15,
                locationName: "South China Sea"
            ),
            onClose: {}
        )
    }
}
