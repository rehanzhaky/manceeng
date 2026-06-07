//
//  OnboardingPage2.swift
//  manceeng
//
//  Created by Zahra Areefa Ananta on 07/06/26.
//

import SwiftUI

struct OnboardingPage2: View {

    @Binding var currentPage: Int

    var body: some View {
        ZStack {
            AnimatedBackground()

            VStack {
                Image("Page2")

                Button {
                    currentPage = 3
                } label: {
                    AppImage.NextButton.image
                }
            }
            .padding()
        }
        .ignoresSafeArea()
    }
}
