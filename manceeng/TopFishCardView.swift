//
//  TopFishCardView.swift
//  manceeng
//
//  Created by M. Iqbal on 05/06/26.
//

import SwiftUI

struct TopFishCardView: View {
    var fishName: String
    var weightName: String
    var lengthName: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(fishName)
                .font(.boldTitle1)
                .foregroundStyle(Color.brandWhite)
                .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "fish.fill")
                .font(.system(size: 64))
                .foregroundStyle(Color.brandWhite.opacity(0.6))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)

            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Berat")
                        .font(.caption)
                        .foregroundStyle(Color.brandWhite.opacity(0.7))
                    Text(weightName)
                        .font(.boldTitle2)
                        .foregroundStyle(Color.brandWhite)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Panjang")
                        .font(.caption)
                        .foregroundStyle(Color.brandWhite.opacity(0.7))
                    Text(lengthName)
                        .font(.boldTitle2)
                        .foregroundStyle(Color.brandWhite)
                }
            }
        }
        .padding(24)
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: 400)
        .background(
            LinearGradient(
                colors: [Color.brandDark, Color.brandBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: Radius.borderRadius.rawValue))
        .padding(.horizontal, 20)
    }
}

#Preview {
    TopFishCardView(fishName: "Ikan Lele", weightName: "1.1 kg", lengthName: "15 cm")
}
