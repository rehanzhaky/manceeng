//
//  CameraService.swift
//  manceeng
//
//  Created by Made Vidyatma Adhi Krisna on 07/06/26.
//

import Foundation
import UIKit

final class CameraService {
    private let segmentationService = FishSegmentationService()

    func segment(image: UIImage, completion: @escaping ([SegmentedFish]) -> Void) {
        segmentationService.segment(image: image, completion: completion)
    }
}
