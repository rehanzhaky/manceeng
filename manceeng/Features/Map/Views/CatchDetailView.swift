//
//  CatchDetailView.swift
//  manceeng
//
//  Konten detail tangkapan (Summary Detail) + halaman push-nya.
//  Di peta dipakai lewat CatchDetailPanel (bottom panel custom);
//  di History dipakai sebagai halaman penuh (push) dengan top bar.
//
//  Created by M. Iqbal on 08/06/26.
//

import SwiftUI
import CoreLocation

extension LinearGradient {
    /// Gradient biru khas halaman detail tangkapan.
    static var catchDetail: LinearGradient {
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
}

// MARK: - Konten (transparan; background disediakan pemanggil)

struct CatchDetailContent: View {
    let location: CatchLocation
    var topInset: CGFloat = 24

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                fishImage
                infoCard
            }
            .padding(.horizontal, 20)
            .padding(.top, topInset)
            .padding(.bottom, 24)
        }
        .scrollBounceBehavior(.basedOnSize)
    }

    private var fishImage: some View {
        Image(location.imageName ?? "ikan_1")
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .frame(height: 220)
            .shadow(color: .black.opacity(0.3), radius: 16, y: 10)
    }

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

// MARK: - Halaman push (History): gradient penuh + top bar back/share

struct CatchDetailView: View {
    let location: CatchLocation
    /// `true` saat dibuka sebagai halaman (push) → tampilkan top bar back + share.
    var showsActions: Bool = false

    @Environment(\.dismiss) private var dismiss

    private var shareText: String {
        "\(location.fishName) — \(location.weightKg.formatted()) kg, \(location.lengthCm.formatted()) cm @ \(location.locationName)"
    }

    var body: some View {
        ZStack {
            LinearGradient.catchDetail.ignoresSafeArea()
            CatchDetailContent(location: location, topInset: showsActions ? 76 : 24)
        }
        .overlay(alignment: .top) {
            if showsActions { topBar }
        }
        .toolbar(.hidden, for: .navigationBar)
    }

    private var topBar: some View {
        HStack {
            CircleIconButton(systemName: "chevron.left") { dismiss() }
            Spacer()
            ShareLink(item: shareText) {
                GlassCircleIcon(systemName: "square.and.arrow.up")
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 8)
    }
}

#Preview {
    CatchDetailView(
        location: CatchLocation(
            fishName: "Catfish",
            coordinate: .init(latitude: 1.0, longitude: 104.0),
            weightKg: 0.7,
            lengthCm: 15,
            locationName: "South China Sea"
        ),
        showsActions: true
    )
}
