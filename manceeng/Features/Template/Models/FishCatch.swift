//
//  FishCatch.swift
//  manceeng
//
//  Created by Codex on 07/06/26.
//

import UIKit

struct FishCatch {
    let fishName: String
    let weight: Double
    let length: Double
    let fishImageName: String
    let fishImage: UIImage?

    init(
        fishName: String,
        weight: Double,
        length: Double,
        fishImageName: String,
        fishImage: UIImage? = nil
    ) {
        self.fishName = fishName
        self.weight = weight
        self.length = length
        self.fishImageName = fishImageName
        self.fishImage = fishImage
    }
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
