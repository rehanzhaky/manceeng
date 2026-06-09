//
//  CatchMapMarker.swift
//  manceeng
//
//  Marker peta bergaya foto polaroid kecil dengan pointer ke bawah,
//  menunjuk lokasi tangkapan ikan.
//
//  Created by M. Iqbal on 08/06/26.
//

import SwiftUI
import CoreLocation

struct CatchMapMarker: View {
    let location: CatchLocation

    private let photoSize: CGFloat = 54
    private let framePadding: CGFloat = 4

    var body: some View {
        VStack(spacing: -1) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.white)
                .frame(width: photoSize + framePadding * 2,
                       height: photoSize + framePadding * 2)
                .overlay {
                    photo
                        .frame(width: photoSize, height: photoSize)
                        .clipShape(RoundedRectangle(cornerRadius: 9, style: .continuous))
                }

            DownTriangle()
                .fill(.white)
                .frame(width: 16, height: 9)
        }
        .shadow(color: .black.opacity(0.35), radius: 4, y: 2)
    }

    private var photo: some View {
        Image(location.imageName ?? "ikan_1")
            .resizable()
            .scaledToFill()
    }
}

/// Segitiga menghadap ke bawah untuk pointer marker.
private struct DownTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ZStack {
        Color.gray
        CatchMapMarker(
            location: CatchLocation(
                fishName: "Ikan Kerapu",
                coordinate: .init(latitude: 1.1, longitude: 104.0),
                weightKg: 1.4,
                lengthCm: 28,
                locationName: "Selat Singapura"
            )
        )
    }
}
