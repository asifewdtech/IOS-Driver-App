//
//  GiftCardView.swift
//  Farepay
//
//  Created by Arslan on 02/09/2023.
//

import SwiftUI

struct GiftCardView: View {
    
    //MARK: - Variables
    @Binding var presentSideMenu: Bool
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                topArea
                Spacer()
            }
            .padding(.horizontal, 15)
        }
    }
}

struct GiftCardView_Previews: PreviewProvider {
    static var previews: some View {
        GiftCardView(presentSideMenu: .constant(false))
    }
}

extension GiftCardView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            
            Image(uiImage: .menuIcon)
                .resizable()
                .frame(width: 25, height: 25)
                .onTapGesture {
                    
                    presentSideMenu.toggle()
                }
            Text("Gift Cards")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
        }
    }
}
