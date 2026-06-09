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

            Image("ikan_1")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 130)
                .padding(.vertical, 16)

            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Berat")
                        .font(.callout)
                        .foregroundStyle(Color.brandWhite.opacity(0.7))
                    Text(model.weight)
                        .font(.title2Bold)
                        .foregroundStyle(Color.brandWhite)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Panjang")
                        .font(.callout)
                        .foregroundStyle(Color.brandWhite.opacity(0.7))
                    Text(model.length)
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
    TopFishCardView(model: Catch(name: "Ikan Lele", weight: "100 Kg", length: "100 Cm"))
}
