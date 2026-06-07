//
//  OnboardingPage1.swift
//  manceeng
//
//  Created by Zahra Areefa Ananta on 07/06/26.
//

import SwiftUI

struct OnboardingPage1: View {

    @Binding var currentPage: Int

    var body: some View {
        ZStack {
            AnimatedBackground()

            VStack {
                Image("Page1")

                Button {
                    currentPage = 2
                } label: {
                    AppImage.NextButton.image
                }
            }
            .padding()
        }
        .ignoresSafeArea()
    }
}


