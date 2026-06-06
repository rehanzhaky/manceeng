//
//  ContentView.swift
//  manceeng
//
//  Created by Raihan Zhaky Al Hafizh on 26/05/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            AnimatedBackground()

            VStack {
                Image("Page1")
                    .resizable()
                    .scaledToFit()

                Button {

                    // Aksi ketika tombol ditekan

                } label: {
                    AppImage.NextButton.image
                }
            }
            .padding()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
