//
//  Button.swift
//  manceeng
//
//  Created by Raihan Zhaky Al Hafizh on 06/06/26.
//


import SwiftUI

struct ButtonOnboard: View{
    let title: String
    let action: () -> Void
    
    var body: some View{
        Button(action: action) {
            HStack{
                Text(title)
                    .font(.ButtonFont)
                    .foregroundStyle(Color.brandWhite)
            }
            .frame(width: 363, height: 58)
            .background(Color.brandBlue)
            .clipShape(RoundedRectangle(cornerRadius: Radius.borderRadius))
        }
    }
}

#Preview{
    ButtonOnboard(title: "Let's start a quick demo") {
        print("ha ini button pertama onboarding")
    }
}
