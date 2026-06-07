//
//  CardBackground.swift
//  manceeng
//
//  Created by Made Vidyatma Adhi Krisna on 05/06/26.
//

import SwiftUI

struct CardBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: Radius.borderRadius.rawValue)
            .fill(
                LinearGradient(
                    colors: [
                        .brandDark,
                        .brandBlue,
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                RoundedRectangle(cornerRadius: Radius.borderRadius.rawValue)
                    .stroke(Color.brandCyan.opacity(0.7), lineWidth: 2)
            }
    }
}

#Preview {
    CardBackground()
}
