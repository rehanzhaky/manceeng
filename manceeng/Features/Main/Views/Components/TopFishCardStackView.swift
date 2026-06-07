//
//  TopFishCardStackView.swift
//  manceeng
//
//  Created by M. Iqbal on 05/06/26.
//

import SwiftUI

struct TopFishCardStackView: View {
    var fishName: String
    var weightName: String
    var lengthName: String

    @State private var frontIndex = 0
    @State private var dragOffset: CGSize = .zero

    // pos 0 = depan, 1 = tengah, 2 = belakang
    private func stackPos(for cardIndex: Int) -> Int {
        (cardIndex - frontIndex + 3) % 3
    }

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { i in
                let pos = stackPos(for: i)
                let isFront = pos == 0

                TopFishCardView(
                    fishName: fishName,
                    weightName: weightName,
                    lengthName: lengthName
                )
                .brightness(pos == 2 ? -0.15 : pos == 1 ? -0.08 : 0)
                .rotationEffect(.degrees(
                    isFront ? dragOffset.width / 20 :
                    pos == 1 ? 10 : -10
                ))
                .offset(
                    x: isFront ? dragOffset.width : (pos == 1 ? 20 : -20),
                    y: isFront ? dragOffset.height * 0.2 : -30
                )
                .zIndex(isFront ? 2 : pos == 1 ? 1 : 0)
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
                                    frontIndex = (frontIndex + 1) % 3
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
    TopFishCardStackView(fishName: "Ikan Lele", weightName: "1.1 kg", lengthName: "15 cm")
        .padding()
}
