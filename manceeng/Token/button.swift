//
//  button.swift
//  manceeng
//
//  Created by Zahra Areefa Ananta on 06/06/26.
//

import Foundation
import SwiftUI

enum AppImage: String {
    case NextButton = "button"
    case StartButton = "button(start)"

    var image: Image {
        Image(rawValue)
    }
}
