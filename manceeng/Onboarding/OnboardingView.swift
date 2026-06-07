//
//  OnboardingView.swift
//  manceeng
//
//  Created by Zahra Areefa Ananta on 07/06/26.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 1

    var body: some View {
        switch currentPage {
        case 1:
            OnboardingPage1(currentPage: $currentPage)
        case 2:
            OnboardingPage2(currentPage: $currentPage)
        case 3:
            OnboardingPage3(currentPage: $currentPage)
        case 4:
            OnboardingPage4()
        default:
            OnboardingPage1(currentPage: $currentPage)
        }
    }
}

#Preview {
    OnboardingView()
}
