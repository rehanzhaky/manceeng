//
//  TopFishCardStackView.swift
//  manceeng
//
//  Created by M. Iqbal on 05/06/26.
//

import SwiftUI

struct TopFishCardStackView: View {
    let model: Catch

    @State private var frontIndex = 0
    @State private var dragOffset: CGSize = .zero

    private let cardCount = 4

    // pos 0 = depan, 1 = kedua, 2 = ketiga, 3 = belakang
    private func stackPos(for cardIndex: Int) -> Int {
        (cardIndex - frontIndex + cardCount) % cardCount
    }

    var body: some View {
        ZStack {
            ForEach(0..<cardCount, id: \.self) { i in
                let pos = stackPos(for: i)
                let isFront = pos == 0

                TopFishCardView(model: model)
                    .brightness(pos == 3 ? -0.20 : pos == 2 ? -0.13 : pos == 1 ? -0.07 : 0)
                    .rotationEffect(.degrees(
                        isFront ? dragOffset.width / 20 :
                        pos == 1 ? 8 : pos == 2 ? -8 : 0
                    ))
                    .offset(
                        x: isFront ? dragOffset.width : (pos == 1 ? 18 : pos == 2 ? -18 : 0),
                        y: isFront ? dragOffset.height * 0.2 : (pos == 3 ? -50 : -28)
                    )
                    .zIndex(isFront ? 3 : pos == 1 ? 2 : pos == 2 ? 1 : 0)
                    .gesture(isFront ? DragGesture()
                        .onChanged { value in
                            dragOffset = value.translation
                        }
                        .onEnded { value in
                            if abs(value.translation.width) > 100 {
                                let dir: CGFloat = value.translation.width > 0 ? 1 : -1
                                withAnimation(.easeOut(duration: 0.25)) {
                                    dragOffset = CGSize(width: dir * 600, height: value.translation.height)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    dragOffset = .zero
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                                        frontIndex = (frontIndex + 1) % cardCount
                                    }
                                }
                            } else {
                                withAnimation(.spring()) {
                                    dragOffset = .zero
                                }
                            }
                        } : nil
                    )
            }
        }
    }
}

#Preview {
    TopFishCardStackView(model: Catch(name: "Ikan Lele", weight: "1000g", length: "100cm", image: nil, location: nil, capturedAt: Date()))
        .padding()
}
