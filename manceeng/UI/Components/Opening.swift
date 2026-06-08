//
//  Opening.swift
//  manceeng
//
//  Created by Raihan Zhaky Al Hafizh on 08/06/26.
//

import SwiftUI

struct Opening: View {
    let action: () -> Void
    
    init(action: @escaping () -> Void = {}) {
        self.action = action
    }
    
    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.brandDark.opacity(0.4))
                .frame(width: 363, height: 380)
                .overlay(
                    Text("Image Mockup")
                        .font(.Title1Bold)
                        .foregroundStyle(Color.brandWhite.opacity(0.4))
                )
                .padding(.top, 60)
            Spacer()
            
            Text("Fish App")
                .font(.Title1Semibold)
                .foregroundStyle(Color.brandWhite)
            Spacer()
            
            VStack(spacing: 8) {
                Text("Welcome, Angler!")
                    .font(.CaptionOnboarding)
                    .foregroundStyle(Color.brandWhite)
                Text("Identify your catch instantly with AR-powered camera technology. Fast, easy, and fun.")
                    .font(.CaptionOnboarding)
                    .foregroundStyle(Color.brandWhite)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
            }
            Spacer()
        }
    }
}

#Preview {
    Opening {
        print("Onboarding page 1 button tapped")
    }
}
