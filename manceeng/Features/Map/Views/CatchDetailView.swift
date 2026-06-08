//
//  CatchDetailView.swift
//  manceeng
//
//  Detail satu tangkapan (Summary Detail), ditampilkan sebagai modal sheet
//  saat marker peta di-tap. Hanya foto ikan + info; aksi (share/delete) ada
//  di kanan atas layar peta.
//
//  Created by M. Iqbal on 08/06/26.
//

import SwiftUI
import CoreLocation

struct CatchDetailView: View {
    let location: CatchLocation

    private var background: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: "2C7FB8"),
                Color(hex: "0B3A86"),
                Color(hex: "05123A")
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var body: some View {
        ZStack {
            background.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    fishImage
                    infoCard
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
            .scrollBounceBehavior(.basedOnSize)
        }
        .presentationBackground(.clear)
    }

    // MARK: - Fish image

    private var fishImage: some View {
        Group {
            if let imageName = location.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
            } else {
                Image(systemName: "fish.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(Color.brandWhite.opacity(0.9))
                    .padding(.horizontal, 60)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 220)
        .shadow(color: .black.opacity(0.3), radius: 16, y: 10)
    }

    // MARK: - Info card

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 22) {
            field(label: "Nama Ikan", value: location.fishName)

            HStack(alignment: .top, spacing: 0) {
                valueField(label: "Weight", value: location.weightKg.formatted(), unit: "kg")
                    .frame(maxWidth: .infinity, alignment: .leading)
                valueField(label: "Length", value: location.lengthCm.formatted(), unit: "cm")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            field(label: "Location", value: location.locationName)
        }
        .padding(22)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.28), lineWidth: 1)
        )
    }

    private func field(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.brandWhite.opacity(0.7))
            Text(value)
                .font(.title2.bold())
                .foregroundStyle(Color.brandWhite)
        }
    }

    private func valueField(label: String, value: String, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.brandWhite.opacity(0.7))
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.system(size: 30, weight: .bold))
                Text(unit)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.brandWhite.opacity(0.85))
            }
            .foregroundStyle(Color.brandWhite)
        }
    }
}

#Preview {
    Color.black
        .sheet(isPresented: .constant(true)) {
            CatchDetailView(
                location: CatchLocation(
                    fishName: "Catfish",
                    coordinate: .init(latitude: 1.0, longitude: 104.0),
                    weightKg: 0.7,
                    lengthCm: 15,
                    locationName: "South China Sea"
                )
            )
            .presentationDetents([.fraction(0.85)])
            .presentationDragIndicator(.visible)
        }
}
