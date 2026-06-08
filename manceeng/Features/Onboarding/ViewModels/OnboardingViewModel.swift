//
//  OnboardingViewModel.swift
//  manceeng
//
//  Created by Raihan Zhaky Al Hafizh on 06/06/26.
//

import SwiftUI
import Foundation
import Combine

final class OnboardingViewModel: ObservableObject {
    @Published var currentPage: Int = 0
    @Published var isFinished: Bool = false
    
    let items: [OnboardingItem] = [
        OnboardingItem(
                    imageName: "onboarding2",
                    title: "Capture",
                    description: "Simply point your camera at your catch and let FishApp do the work. Instantly generate fish details such as species, estimated weight, length, and other useful information."
                ),
                OnboardingItem(
                    imageName: "onboarding3",
                    title: "Summary",
                    description: "FishApp automatically turns your photos into clear records. Review species information, estimated size, weight, and location history so you can easily revisit and track your fishing experiences."
                ),
                OnboardingItem(
                    imageName: "onboarding4",
                    title: "Template",
                    description: "Choose from ready-to-use templates designed for anglers. Turn your catches into eye-catching stories and share them effortlessly across your favorite social media platforms."
                )
    ]
    
    var buttonTitle: String {
        currentPage == 3 ? "Start": "Next"
    }
    
    func buttonTapped() {
        withAnimation {
            if currentPage < 3 {
                currentPage += 1
            } else {
                isFinished = true
            }
        }
    }
}
