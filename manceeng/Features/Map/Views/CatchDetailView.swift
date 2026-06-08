//
//  CatchDetailView.swift
//  manceeng
//
//  Detail satu tangkapan (Summary Detail), ditampilkan sebagai modal sheet
//  saat marker peta di-tap. Berisi foto ikan, info, share & tombol Save.
//
//  Created by M. Iqbal on 08/06/26.
//

import SwiftUI
import CoreLocation

struct CatchDetailView: View {
    let location: CatchLocation
    var onSave: () -> Void = {}

    @Environment(\.dismiss) private var dismiss

    private var shareText: String {
        "\(location.fishName) — \(location.weightKg.formatted()) kg, \(location.lengthCm.formatted()) cm @ \(location.locationName)"
    }

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

            VStack(spacing: 0) {
                topBar
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                ScrollView {
                    VStack(spacing: 24) {
                        fishImage
                        infoCard
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                }
                .scrollBounceBehavior(.basedOnSize)

                saveButton
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
            }
        }
        .presentationBackground(.clear)
    }

    // MARK: - Top bar

    private var topBar: some View {
        HStack {
            circleButton("chevron.left") { dismiss() }
            Spacer()
            ShareLink(item: shareText) {
                circleIcon("square.and.arrow.up")
            }
        }
    }

    private func circleButton(_ systemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            circleIcon(systemName)
        }
        .buttonStyle(.plain)
    }

    private func circleIcon(_ systemName: String) -> some View {
        Image(systemName: systemName)
            .font(.system(size: 17, weight: .semibold))
            .foregroundStyle(Color(hex: "0A2A5E"))
            .frame(width: 40, height: 40)
            .background(Color.white.opacity(0.22), in: Circle())
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

    // MARK: - Save

    private var saveButton: some View {
        Button(action: onSave) {
            Text("Save")
                .font(.headline.bold())
                .foregroundStyle(Color.brandWhite)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.brandBlue)
                )
        }
        .buttonStyle(.plain)
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
            .presentationDetents([.large])
            .presentationDragIndicator(.visible)
        }
}
