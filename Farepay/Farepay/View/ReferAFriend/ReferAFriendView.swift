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
    @State var willMoveToFriendList: Bool = false
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            
            NavigationLink("", destination: FriendlistView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToFriendList).isDetailLink(false)
            
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack{
                topArea
                ScrollView(showsIndicators: false){
                    VStack(spacing: 40){
                    cardView
                    HStack(spacing: 10){
                        Color(.darkGrayColor)
                            .frame(height: 2)
                        Text("How it works!")
                            .font(.custom(.poppinsBold, size: 25))
                            .foregroundColor(.white)
                            .fixedSize()
                        Color(.darkGrayColor)
                            .frame(height: 1)
                    }
                    listView
                    linkView
                    buttonArea
                }
                
            }
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
    
    var cardView: some View{
        VStack(spacing: 20){
           
            HStack{
                VStack(alignment: .leading){
                    Text("Get $50")
                        .font(.custom(.poppinsBold, size: 25))
                        .foregroundColor(.white)
                    Text("When friends transact")
                        .font(.custom(.poppinsMedium, size: 16))
                        .foregroundColor(.white)
                }
                Spacer()
                VStack(spacing: 5){
                    Text("Collected")
                        .font(.custom(.poppinsMedium, size: 16))
                        .foregroundColor(.white)
                    Text("$ 150")
                        .font(.custom(.poppinsBold, size: 20))
                        .foregroundColor(.white)
                }
                .frame(width: 120, height: 60)
                .background(.black)
                .cornerRadius(8)
            }
            .padding(.horizontal, 15)
            HStack{
                Text("Invites accepted")
                    .font(.custom(.poppinsMedium, size: 16))
                    .foregroundColor(.white)
                Spacer()
                Text("$10")
                    .font(.custom(.poppinsBold, size: 16))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 15)
            HStack{
                Text("Total referrals earned")
                    .font(.custom(.poppinsMedium, size: 16))
                    .foregroundColor(.white)
                Spacer()
                Text("$0")
                    .font(.custom(.poppinsBold, size: 16))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 15)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(Color(.buttonColor))
        .cornerRadius(10)
    }
    
    var listView: some View{
        VStack(spacing: 20){
            HStack(spacing: 20){
                Image(uiImage: .ic_Link)
                    .resizable()
                    .frame(width: 60, height: 60)
                VStack(alignment: .leading, spacing: 3){
                    Text("Invite your friends")
                        .font(.custom(.poppinsSemiBold, size: 22))
                        .foregroundColor(.white)
                    Text("Share this link with your friends via email or preferred messenger app.")
                        .font(.custom(.poppinsSemiBold, size: 18))
                        .foregroundColor(Color(.darkGrayColor))
                }
            }
            HStack(spacing: 20){
                Image(uiImage: .ic_Money)
                    .resizable()
                    .frame(width: 60, height: 60)
                VStack(alignment: .leading, spacing: 3){
                    Text("Invite your friends")
                        .font(.custom(.poppinsSemiBold, size: 22))
                        .foregroundColor(.white)
                    Text("Share this link with your friends via email or preferred messenger app.")
                        .font(.custom(.poppinsSemiBold, size: 18))
                        .foregroundColor(Color(.darkGrayColor))
                }
            }
        }
        
    }
    
    var linkView: some View{
        
        VStack(spacing: 20){
            VStack{
                Text("jdifjweijvew9fk9ef0eofwf0eoofvelo")
                    .font(.custom(.poppinsMedium, size: 20))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(.darkBlueColor))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundColor(Color(.darkGrayColor))
            )
            
            HStack(spacing: 15){
                Text("Copy")
                    .font(.custom(.poppinsMedium, size: 20))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(.buttonColor).opacity(0.5))
                    .cornerRadius(10)
                    .disabled(true)
                
                Text("Share")
                    .font(.custom(.poppinsMedium, size: 20))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(.buttonColor))
                    .cornerRadius(10)
            }
        }
    }
    
    var buttonArea: some View{
        Text("View List")
            .font(.custom(.poppinsBold, size: 25))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(.buttonColor))
            .cornerRadius(30)
            .onTapGesture {
                willMoveToFriendList.toggle()
            }
    }
}
