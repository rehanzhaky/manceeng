//
//  EmptyStateFish.swift
//  manceeng
//
//  Created by Raihan Zhaky Al Hafizh on 08/06/26.
//


import SwiftUI

struct EmptyStateFish: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 48) {
            Image(systemName: "fish.fill")
                .font(.system(size: 100, weight: .regular))
                .foregroundStyle(Color.brandSky)
            
            Text(title)
                .font(.Title1Semibold)
                .foregroundStyle(Color.brandWhite)
                .multilineTextAlignment(.center)
        }
    }
}

#Preview {
    ZStack {
        Color.brandBlack
            .ignoresSafeArea()
        
        EmptyStateFish(title: "Add your first fish")
    }
}
