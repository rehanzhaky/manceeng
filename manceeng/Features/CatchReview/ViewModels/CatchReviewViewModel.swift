//
//  CatchReviewViewModel.swift
//  manceeng
//
//  Created by Made Vidyatma Adhi Krisna on 07/06/26.
//

import Foundation
import Combine
import UIKit

@MainActor
final class CatchReviewViewModel: ObservableObject {
    let image: UIImage?
    let segmentedFishes: [SegmentedFish]

    var fishName: String {
        "Catfish"
    }

    var weightText: String {
        "0.7 kg"
    }

    var lengthText: String {
        guard let length = primaryFish?.estimatedLengthCm else { return "-" }
        return String(format: "%.0f cm", length)
    }

    var primaryFish: DetectedFish? {
        segmentedFishes.max { $0.fish.confidence < $1.fish.confidence }?.fish
    }

    init(image: UIImage?, segmentedFishes: [SegmentedFish]) {
        self.image = image
        self.segmentedFishes = segmentedFishes
    }
}
