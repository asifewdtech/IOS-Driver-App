//
//  TransactionView.swift
//  Farepay
//
//  Created by Arslan on 04/09/2023.
//

import SwiftUI

struct TransactionView: View {
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

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(presentSideMenu: .constant(false))
    }
}

extension TransactionView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            
            Image(uiImage: .menuIcon)
                .resizable()
                .frame(width: 25, height: 25)
                .onTapGesture {
                    
                    presentSideMenu.toggle()
                }
            Text("Transactions")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
        }
    }
}
