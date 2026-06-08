//
//  PageIndicator.swift
//  manceeng
//
//  Created by Raihan Zhaky Al Hafizh on 08/06/26.
//

import SwiftUI

struct PageIndicator: View {
    let currentPage: Int
    let totalPages: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? Color.brandWhite : Color.brandWhite.opacity(0.4))
                    .frame(width: 8, height: 8)
            }
        }
    }
}

#Preview {
    PageIndicator(currentPage: 0, totalPages: 3)
        .background(Color.brandBlue)
}
