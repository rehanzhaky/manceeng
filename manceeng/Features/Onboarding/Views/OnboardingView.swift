//
//  OnboardingView.swift
//  manceeng
//
//  Created by Raihan Zhaky Al Hafizh on 06/06/26.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        Group {
            if viewModel.isFinished {
                MainView()
            } else {
                ZStack {
                    LinearGradient(
                        colors: [Color.brandBlue, Color.brandDark],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                    
                    VStack {
                        TabView(selection: $viewModel.currentPage) {
                            Opening()
                                .tag(0)
                            
                            ForEach(Array(viewModel.items.enumerated()), id: \.element.id) { index, item in
                                Onboarding(
                                    imageName: item.imageName,
                                    title: item.title,
                                    description: item.description,
                                    currentPage: index,
                                    totalPages: viewModel.items.count
                                )
                                .tag(index + 1)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        
                        ButtonOnboard(title: viewModel.buttonTitle) {
                            viewModel.buttonTapped()
                        }
                        .padding(.bottom, 34)
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingView()
}
