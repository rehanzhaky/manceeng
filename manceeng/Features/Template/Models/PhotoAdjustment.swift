//
//  PhotoAdjustment.swift
//  manceeng
//
//  Created by Codex on 07/06/26.
//

import SwiftUI

struct PhotoAdjustment {
    var scale: CGFloat = 1
    var offset: CGSize = .zero
    var rotation: Angle = .degrees(0)

    static let identity = PhotoAdjustment()
}
