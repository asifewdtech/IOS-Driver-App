//
//  HomeView.swift
//  Farepay
//
//  Created by Arslan on 30/08/2023.
//

import SwiftUI

struct PaymentView: View {
    
    //MARK: - Variables
    @State private var farePriceText: String = ""
    @State private var willMoveToPaymentDetail = false
    @Binding var presentSideMenu: Bool
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            NavigationLink("", destination: PaymentDetailView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToPaymentDetail).isDetailLink(false)
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            VStack{
                topArea
                Spacer()
                keypadArea
                buttonArea
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView(presentSideMenu: .constant(false))
    }
}

extension PaymentView{
    
    var topArea: some View{
        
        VStack(spacing: 20){
            HStack{
                Image(uiImage: .logo)
                    .resizable()
                    .frame(width: 50, height: 50)
                Spacer()
            }
            
            HStack(spacing: 20){
                
                Image(uiImage: .menuIcon)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .onTapGesture {
                        
                        presentSideMenu.toggle()
                    }
                Text("Charge Fare")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                Spacer()
            }
            
            ZStack{
                
                HStack{
                    
                    Text("$")
                        .font(.custom(.poppinsMedium, size: 25))
                        .foregroundColor(Color(.darkGrayColor))
                    Spacer()
                    
                    TextField("", text: $farePriceText, prompt: Text("0.00").foregroundColor(Color(.white)))
                        .font(.custom(.poppinsBold, size: 40))
                        .frame(height: 30)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(1)
                        .disabled(true)
                }
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(Color(.darkBlueColor))
            .cornerRadius(10)
        }
        .padding(.horizontal, 15)
    }
    
    var keypadArea: some View{
        
        VStack(spacing: 40){
            
            HStack{
                
                Group{
                    
                    Text("1")
                        .onTapGesture {
                            farePriceText += "1"
                        }
                    Text("2")
                        .onTapGesture {
                            farePriceText += "2"
                        }
                    Text("3")
                        .onTapGesture {
                            farePriceText += "3"
                        }
                }
                .font(.custom(.poppinsBold, size: 35))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            }

            HStack{
                
                Group{
                    
                    Text("4")
                        .onTapGesture {
                            farePriceText += "4"
                        }
                    Text("5")
                        .onTapGesture {
                            farePriceText += "5"
                        }
                    Text("6")
                        .onTapGesture {
                            farePriceText += "6"
                        }
                }
                .font(.custom(.poppinsBold, size: 35))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            }
            
            HStack{
                
                Group{
                    
                    Text("7")
                        .onTapGesture {
                            farePriceText += "7"
                        }
                    Text("8")
                        .onTapGesture {
                            farePriceText += "8"
                        }
                    Text("9")
                        .onTapGesture {
                            farePriceText += "9"
                        }
                }
                .font(.custom(.poppinsBold, size: 35))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            }
            
            HStack{
                
                Group{
                    
                    Text("*")
                        .onTapGesture {
                            farePriceText += "*"
                        }
                    Text("0")
                        .onTapGesture {
                            farePriceText += "0"
                        }
                    Image(uiImage: .ic_BackSpace)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            
                            if !farePriceText.isEmpty {
                                farePriceText.removeLast()
                            }
                        }
                }
                .font(.custom(.poppinsBold, size: 35))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 10)
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 25){
            Button {
                willMoveToPaymentDetail.toggle()
            } label: {
                
                Text("Pay")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(farePriceText == "0" || farePriceText == "" ? Color(.buttonColor).opacity(0.5) : Color(.buttonColor))
                    .cornerRadius(30)
            }
            .disabled(farePriceText == "0" || farePriceText == "" ? true : false)
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 20)
    }
}
