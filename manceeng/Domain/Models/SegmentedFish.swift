//
//  SegmentedFish.swift
//  manceeng
//
//  Created by Made Vidyatma Adhi Krisna on 07/06/26.
//

import UIKit
import CoreGraphics

struct SegmentedFish: Identifiable {
    let id = UUID()
    var fish: DetectedFish
    let maskImage: UIImage
}
