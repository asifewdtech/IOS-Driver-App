//
//  ReferAFriendView.swift
//  Farepay
//
//  Created by Arslan on 04/09/2023.
//

import SwiftUI

struct ReferAFriendView: View {
    
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
            .padding(.all, 15)
        }
    }
}

struct ReferAFriendView_Previews: PreviewProvider {
    static var previews: some View {
        ReferAFriendView(presentSideMenu: .constant(false))
    }
}

extension ReferAFriendView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            
            Image(uiImage: .menuIcon)
                .resizable()
                .frame(width: 25, height: 25)
                .onTapGesture {
                    
                    presentSideMenu.toggle()
                }
            Text("Refer A Friend")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
        }
    }
}
