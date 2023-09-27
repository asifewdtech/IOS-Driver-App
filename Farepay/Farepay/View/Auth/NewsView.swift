//
//  NewsView.swift
//  Farepay
//
//  Created by Arslan on 27/09/2023.
//

import SwiftUI

struct NewsView: View {
    
    //MARK: - Variables
    
    //MARK: - Views
    var body: some View {
        ZStack{
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack(spacing: 25){
                Image(uiImage: .newsImage)
                    .resizable()
                    .frame(width: 270, height: 270)
                Text("Great News")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                Text("ou've successfully signed up. Now, let's complete your registration by adding your bank account.")
                    .frame(width: 300)
                    .font(.custom(.poppinsMedium, size: 12))
                    .foregroundColor(Color(.darkGrayColor))
                    .multilineTextAlignment(.center)
                NavigationLink {
                    AddNewBankAccountView().toolbar(.hidden, for: .navigationBar)
                } label: {
                    Text("Add New Account")
                        .font(.custom(.poppinsBold, size: 22))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(.buttonColor))
                        .cornerRadius(30)
                        .frame(width: 340)
                }

            }
            .padding(15)
        }
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView()
    }
}
