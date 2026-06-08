//
//  FishCollectionCard.swift
//  manceeng
//
//  Kartu satu tangkapan di halaman Fish Collection (history).
//
//  Created by M. Iqbal on 09/06/26.
//

import SwiftUI
import CoreLocation

struct FishCollectionCard: View {
    let location: CatchLocation

    private var goldBorder: LinearGradient {
        LinearGradient(
            colors: [Color(hex: "F5D67A"), Color(hex: "C99B3F")],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                Text(location.fishName)
                    .font(.title2.bold())
                    .foregroundStyle(Color.brandWhite)

                Text(location.locationName)
                    .font(.subheadline)
                    .foregroundStyle(Color.brandWhite.opacity(0.75))

                Text("\(location.weightKg.formatted()) kg")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(Color.brandWhite)
                    .padding(.top, 2)
            }

            Spacer(minLength: 8)

            thumbnail
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.brandWhite.opacity(0.18), Color.brandWhite.opacity(0.05)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(goldBorder, lineWidth: 1.5)
        )
    }

    @ViewBuilder
    private var thumbnail: some View {
        if let imageName = location.imageName {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        } else {
            Image(systemName: "fish.fill")
                .font(.system(size: 52))
                .foregroundStyle(Color.brandWhite)
                .frame(width: 78, height: 72)
        }
    }
}

#Preview {
    ZStack {
        Color.brandDark.ignoresSafeArea()
        FishCollectionCard(
            location: CatchLocation(
                fishName: "Ikan Nila",
                coordinate: .init(latitude: 0.93, longitude: 104.0),
                weightKg: 0.9,
                lengthCm: 18,
                locationName: "Pulau Bulan"
            )
        )
        .padding()
    }
}
