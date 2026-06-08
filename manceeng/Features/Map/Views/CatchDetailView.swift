//
//  CatchDetailView.swift
//  manceeng
//
//  Detail satu tangkapan, ditampilkan sebagai modal sheet saat marker peta
//  di-tap. Berisi foto ikan, info (nama/berat/panjang/lokasi), share & delete.
//
//  Created by M. Iqbal on 08/06/26.
//

import SwiftUI
import CoreLocation

struct CatchDetailView: View {
    let location: CatchLocation
    var onDelete: () -> Void

    private var shareText: String {
        "\(location.fishName) — \(location.weightKg.formatted()) kg, \(location.lengthCm.formatted()) cm @ \(location.locationName)"
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.brandBlue, Color.brandDark],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                actionBar
                fishImage
                infoCard
                Spacer(minLength: 0)
            }
            .padding(20)
        }
    }

    // MARK: - Sections

    private var actionBar: some View {
        HStack {
            Spacer()
            HStack(spacing: 4) {
                ShareLink(item: shareText) {
                    icon("square.and.arrow.up")
                }

                Button(role: .destructive, action: onDelete) {
                    icon("trash")
                }
            }
            .padding(6)
            .background(.ultraThinMaterial, in: Capsule())
        }
    }

    private func icon(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(Color.brandWhite)
            .frame(width: 40, height: 40)
    }

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
                    .foregroundStyle(Color.brandWhite.opacity(0.85))
                    .padding(.horizontal, 40)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 180)
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            field(label: "Nama Ikan", value: location.fishName, prominent: true)

            HStack(alignment: .top) {
                valueField(label: "Weight", value: location.weightKg.formatted(), unit: "kg")
                Spacer()
                valueField(label: "Length", value: location.lengthCm.formatted(), unit: "cm")
            }

            field(label: "Location", value: location.locationName, prominent: true)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.white.opacity(0.06))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.brandWhite.opacity(0.25), lineWidth: 1)
        )
    }

    // MARK: - Rows

    private func field(label: String, value: String, prominent: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.footnote)
                .foregroundStyle(Color.brandWhite.opacity(0.7))
            Text(value)
                .font(prominent ? .title3.bold() : .body)
                .foregroundStyle(Color.brandWhite)
        }
    }

    private func valueField(label: String, value: String, unit: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.footnote)
                .foregroundStyle(Color.brandWhite.opacity(0.7))
            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text(value)
                    .font(.title.bold())
                Text(unit)
                    .font(.subheadline)
                    .foregroundStyle(Color.brandWhite.opacity(0.8))
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
                ),
                onDelete: {}
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
}
