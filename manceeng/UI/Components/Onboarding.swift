//
//  Onboarding.swift
//  manceeng
//
//  Created by Raihan Zhaky Al Hafizh on 08/06/26.
//

import SwiftUI

struct Onboarding: View {
    let imageName: String
    let title: String
    let description: String
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        VStack(spacing: 24) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 363, height: 351)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.top, 60)
            
            PageIndicator(currentPage: currentPage, totalPages: totalPages)
            
            Text(title)
                .font(.Title1Semibold)
                .foregroundStyle(Color.brandWhite)
            
            Text(description)
                .font(.CaptionOnboarding)
                .foregroundStyle(Color.brandWhite)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
           
        }
    }
}

#Preview {
    Onboarding(
        imageName: "dummy_image",
        title: "FishApp",
        description: "FishApp automatically turns your photos into clear records.",
        currentPage: 0,
        totalPages: 3
    )
    .background(Color.brandBlack)
}
