//
//  PayoutView.swift
//  Farepay
//
//  Created by Arslan on 04/09/2023.
//

import SwiftUI

struct PayoutView: View {
    
    //MARK: - Variable
    @Binding var presentSideMenu: Bool
    
    //MARK: - View
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

struct PayoutView_Previews: PreviewProvider {
    static var previews: some View {
        PayoutView(presentSideMenu: .constant(false))
    }
}

extension PayoutView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            
            Image(uiImage: .menuIcon)
                .resizable()
                .frame(width: 25, height: 25)
                .onTapGesture {
                    
                    presentSideMenu.toggle()
                }
            Text("Payout")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
        }
    }
}
