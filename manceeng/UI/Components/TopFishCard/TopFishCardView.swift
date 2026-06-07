//
//  TopFishCardView.swift
//  manceeng
//
//  Created by Made Vidyatma Adhi Krisna on 05/06/26.
//

import SwiftUI

struct TopFishCardView: View {
    var body: some View {
        VStack(alignment: .leading){
            Text("Fish Name 1").font(.headline).foregroundStyle(Color.white70)
            EnumAppIcon.fishIcon
                .padding(.vertical)
                .font(.system(size: 97))
                .foregroundStyle(Color.white70)
                .frame(maxWidth: .infinity, alignment: .center)
            
            HStack{
                VStack(alignment: .leading){
                    Text("Weight: ").font(.subheadline.weight(.regular)).foregroundStyle(Color.white70)
                    Text("1.5 Kg").foregroundStyle(Color.white).foregroundStyle(Color.white)
                }
                Spacer()
                
                VStack(alignment: .leading){
                    Text("Length: ").font(.subheadline.weight(.regular)).foregroundStyle(Color.white70)
                    Text("23.5 cm").foregroundStyle(Color.white)
                }
            }.font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                   colors: [
                       .brandPrimaryBlue1,
                       .neutralSecondaryBlue2
                   ],
                   startPoint: .topLeading,
                   endPoint: .bottomTrailing
               )
        )
        .clipShape(RoundedRectangle(cornerRadius: EnumBorder.borderRadius))
        .shadow(radius: 4)
        
    }
}

#Preview {
    TopFishCardView()
}
