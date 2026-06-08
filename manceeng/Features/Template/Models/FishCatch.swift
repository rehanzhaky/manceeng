//
//  FishCatch.swift
//  manceeng
//
//  Created by Codex on 07/06/26.
//

import Foundation

struct FishCatch {
    let fishName: String
    let weight: Double
    let length: Double
    let fishImageName: String
}

extension FishCatch {
    init(location: CatchLocation) {
        self.init(
            fishName: location.fishName,
            weight: location.weightKg,
            length: location.lengthCm,
            fishImageName: location.imageName ?? "ikan_1"
        )
    }
}
