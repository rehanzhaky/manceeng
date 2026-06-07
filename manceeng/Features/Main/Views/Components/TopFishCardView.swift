//
//  TopFishCardView.swift
//  manceeng
//
//  Created by M. Iqbal on 05/06/26.
//

import SwiftUI

struct TopFishCardView: View {
    let model: Catch

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(model.name)
                .font(.title1Bold)
                .foregroundStyle(Color.brandWhite)
                .frame(maxWidth: .infinity, alignment: .leading)

            Image(systemName: "fish.fill")
                .font(.system(size: 100))
                .foregroundStyle(Color.brandWhite.opacity(0.6))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 24)

            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Berat")
                        .font(.callout)
                        .foregroundStyle(Color.brandWhite.opacity(0.7))
                    Text(String(format: "%.1f kg", model.weightKg))
                        .font(.title2Bold)
                        .foregroundStyle(Color.brandWhite)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Panjang")
                        .font(.callout)
                        .foregroundStyle(Color.brandWhite.opacity(0.7))
                    Text(String(format: "%.0f cm", model.lengthCm))
                        .font(.title2Bold)
                        .foregroundStyle(Color.brandWhite)
                }
            }
        }
        .padding(24)
        .aspectRatio(1, contentMode: .fit)
        .frame(maxWidth: 300)
        .background(
            LinearGradient(
                colors: [Color.brandDark, Color.brandBlue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: Radius.borderRadius))
        .padding(.horizontal, 20)
    }
}

#Preview {
    TopFishCardView(model: Catch(name: "Ikan Lele", weightKg: 1.1, lengthCm: 15))
}
