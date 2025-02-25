//
//  FriendlistView.swift
//  Farepay
//
//  Created by Mursil on 15/09/2023.
//

import SwiftUI

struct FriendlistView: View {
    
    //MARK: - Variable
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    //MARK: - Variable
    var body: some View {
        ZStack{
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack{
                topArea
                ScrollView(showsIndicators: false){
                    VStack(spacing: 40){
                        cardView
                        listView
                    }
                }
            }
            .padding(.all, 15)
        }
    }
}

struct FriendlistView_Previews: PreviewProvider {
    static var previews: some View {
        FriendlistView()
    }
}

extension FriendlistView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            Image(uiImage: .backArrow)
                .resizable()
                .frame(width: 35, height: 30)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("Refer a Friend")
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
        VStack{
            HStack{
                Text("Invited Friends")
                    .font(.custom(.poppinsBold, size: 22))
                    .foregroundColor(.white)
                Spacer()
                Text("(5/10) Accepted")
                    .font(.custom(.poppinsMedium, size: 18))
                    .foregroundColor(Color(.darkGrayColor))
            }
            .padding(.bottom, 15)
            ForEach(0..<7) { index in
                VStack(spacing: 15){
                    HStack{
                        HStack(spacing: 15){
                            Image(uiImage: .ic_Edan)
                                .resizable()
                                .frame(width: 50, height: 50)
                            Text("Edan")
                                .font(.custom(.poppinsBold, size: 25))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Text("Accepted")
                            .font(.custom(.poppinsMedium, size: 18))
                            .frame(width: 150, height: 50)
                            .foregroundColor(.white)
                            .background(Color(.SuccessColor))
                            .cornerRadius(25)
                    }
                    Color(.darkGrayColor)
                        .frame(height: 1)
                }
                .padding(.bottom, 10)
            }
        }
    }
}
