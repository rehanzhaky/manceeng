//
//  CardBackground.swift
//  manceeng
//
//  Created by Made Vidyatma Adhi Krisna on 05/06/26.
//

import SwiftUI

struct CardBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: EnumBorder.borderRadius)
            .fill(
                LinearGradient(
                    colors: [
                        .brandPrimaryBlue1,
                        .neutralSecondaryBlue2,
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                RoundedRectangle(cornerRadius: EnumBorder.borderRadius)
                    .stroke(Color.surfaceAccentBlue3.opacity(0.7), lineWidth: 2)
            }
    }
}

#Preview {
    CardBackground()
}
