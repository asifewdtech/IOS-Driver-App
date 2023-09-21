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
    @State var willMoveToAccountInfo: Bool = false
    @State var willMoveToChangePassword: Bool = false
    @State var willMoveToBankAccount: Bool = false
    
    // MARK: - Views
    var body: some View {
        
        ZStack{
            
            NavigationLink("", destination: AccountInfoView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToAccountInfo).isDetailLink(false)
            NavigationLink("", destination: ChangePasswordView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToChangePassword).isDetailLink(false)
            NavigationLink("", destination: BankAccountView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToBankAccount).isDetailLink(false)
            
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack(spacing: 40){
                topArea
                profileView
                listView
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
        
        VStack(spacing: 5){
            Image(uiImage: .image_placeholder)
                .resizable()
                .frame(width: 150, height: 150)
                .cornerRadius(75)
            Text("Tommy Jason")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Text(verbatim: "tommyjason@gmail.com")
                .font(.custom(.poppinsThin, size: 18))
                .foregroundColor(.white)
        }
    }
    
    var listView: some View{
        
        VStack(spacing: 15){
            
            HStack{
                HStack(spacing: 20){
                    Image(uiImage: .ic_Account)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text("Account Info")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(.white)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(.darkGrayColor))
            }.onTapGesture {
                willMoveToAccountInfo.toggle()
            }
            
            HStack{
                HStack(spacing: 20){
                    Image(uiImage: .ic_ChangePassword)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text("Change Password")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(.white)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(.darkGrayColor))
            }.onTapGesture {
                willMoveToChangePassword.toggle()
            }
            
            HStack{
                HStack(spacing: 20){
                    Image(uiImage: .ic_BankAccount)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text("Bank Account")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(.white)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(.darkGrayColor))
            }.onTapGesture {
                willMoveToBankAccount.toggle()
            }
            
        }
        .padding(.horizontal, 10)
    }
}
