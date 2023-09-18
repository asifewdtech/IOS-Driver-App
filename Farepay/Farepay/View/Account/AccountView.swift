//
//  AccountView.swift
//  Farepay
//
//  Created by Arslan on 18/09/2023.
//

import SwiftUI

struct AccountView: View {
    
    //MARK: - Variables
    @Binding var presentSideMenu: Bool
    
    // MARK: - Views
    var body: some View {
        
        ZStack{
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack(spacing: 25){
                topArea
                profileView
                Spacer()
            }
            .padding(.all, 15)
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(presentSideMenu: .constant(false))
    }
}

extension AccountView{
    
    var topArea: some View{
        
        VStack(spacing: 30){
            HStack(spacing: 20){
                
                Image(uiImage: .menuIcon)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .onTapGesture {
                        
                        presentSideMenu.toggle()
                    }
                Text("Account")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
    
    var profileView: some View{
        
        Text("Arslan")
            .foregroundColor(.white)
    }
}
