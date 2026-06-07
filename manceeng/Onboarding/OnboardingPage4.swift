//
//  OnboardingPage4.swift
//  manceeng
//
//  Created by Zahra Areefa Ananta on 07/06/26.
//

import SwiftUI

struct OnboardingPage4: View {

    var body: some View {
        ZStack {
            AnimatedBackground()

            VStack {
                Image("Page4")

                Button {

                    // Nanti masuk ke HomeView

                } label: {
                    AppImage.StartButton.image
                }
            }
            .padding()
        }
        .ignoresSafeArea()
    }
}
