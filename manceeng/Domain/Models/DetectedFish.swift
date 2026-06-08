//
//  DetectedFish.swift
//  manceeng
//
//  Created by Made Vidyatma Adhi Krisna on 07/06/26.
//

import Foundation
import CoreGraphics

struct DetectedFish: Identifiable {
    let id = UUID()
    var boundingBox: CGRect
    let confidence: Float
    var estimatedLengthCm: Double?
    var estimatedWeightKg: Double?
    var species: String?
}
