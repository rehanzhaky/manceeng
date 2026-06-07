//
//  OnboardingPage3.swift
//  manceeng
//
//  Created by Zahra Areefa Ananta on 07/06/26.
//

import SwiftUI

struct OnboardingPage3: View {

    @Binding var currentPage: Int

    var body: some View {
        ZStack {
            AnimatedBackground()

            VStack {
                Image("Page3")

                Button {
                    currentPage = 4
                } label: {
                    AppImage.NextButton.image
                }
            }
            .padding()
        }
        .ignoresSafeArea()
    }
}
