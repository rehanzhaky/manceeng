//
//  OnboardingModels.swift
//  manceeng
//
//  Created by Raihan Zhaky Al Hafizh on 06/06/26.
//

import Foundation

struct OnboardingItem: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let description: String
}
