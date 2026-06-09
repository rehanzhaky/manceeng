//
//  MainModels.swift
//  manceeng
//
//  Created by M. Iqbal on 06/06/26.
//

import Foundation
import UIKit
/// Data satu tangkapan ikan yang ditampilkan di halaman Main.
struct Catch: Identifiable {
    let id = UUID()
    let name: String
    let weight: String
    let length: String
    var image: UIImage?
    var location: String?
    var capturedAt: Date = Date()
}

extension Catch: Hashable {
    static func == (lhs: Catch, rhs: Catch) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}

//planning buat nanti (Krisna)
//struct Catch: Identifiable {
//
//    let id: UUID
//
//    let image: UIImage
//
//    let species: String
//
//    let weightKg: Double
//
//    let lengthCm: Double
//
//    let location: String?
//
//    let capturedAt: Date
//}
