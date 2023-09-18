//
//  TermsView.swift
//  Farepay
//
//  Created by Arslan on 13/09/2023.
//

import SwiftUI

struct TermsView: View {
    
    //MARK: - Variables
    @Binding var presentSideMenu: Bool
    
    //MARK: - Views
    var body: some View {
        ZStack{
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack{
                topArea
                Spacer()
            }
            .padding(.all, 15)
        }
    }
}

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView(presentSideMenu: .constant(false))
    }
}

extension TermsView{
    
    var topArea: some View{
        
        VStack(spacing: 30){
            HStack(spacing: 20){
                
                Image(uiImage: .menuIcon)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .onTapGesture {
                        
                        presentSideMenu.toggle()
                    }
                VStack(alignment: .leading){
                    Text("Terms of Use")
                        .font(.custom(.poppinsBold, size: 25))
                        .foregroundColor(.white)
                    Text("Last Updated July 28, 2021")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(Color(.darkGrayColor))
                }
                Spacer()
            }
        }
    }
}
