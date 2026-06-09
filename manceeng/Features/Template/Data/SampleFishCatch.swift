//
//  SampleFishCatch.swift
//  manceeng
//
//  Created by Codex on 07/06/26.
//

extension FishCatch {
    static let samples: [FishCatch] = [
        .barramundiSample,
        .salmonSample,
        .tenggiriSample
    ]

    static let barramundiSample = FishCatch(
        fishName: "Barramundi",
        weight: 7.5,
        length: 92,
        fishImageName: "ikan_1"
    )

    static let salmonSample = FishCatch(
        fishName: "Ikan Salmon",
        weight: 4.8,
        length: 68,
        fishImageName: "ikan_2"
    )

    static let tenggiriSample = FishCatch(
        fishName: "Ikan Tenggiri",
        weight: 6.2,
        length: 85,
        fishImageName: "ikan_3"
    )
}
