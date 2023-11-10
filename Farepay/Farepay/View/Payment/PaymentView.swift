//
//  HomeView.swift
//  Farepay
//
//  Created by Arslan on 30/08/2023.
//

import SwiftUI

struct PaymentView: View {
    
    //MARK: - Variables
    @ObservedObject private var currencyManager = CurrencyManager(amount: 0)
    @State private var willMoveToPaymentDetail = false
    @Binding var presentSideMenu: Bool
//    @State private var totalChargresWithTax = 0.0
//    @State private var totalAmount = 0.0
//    @State private var serviceFee = 0.0
//    @State private var serviceFeeGst = 0.0
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            NavigationLink("", destination: PaymentDetailView(farePriceText: $currencyManager.string).toolbar(.hidden, for: .navigationBar), isActive: $willMoveToPaymentDetail).isDetailLink(false)
            
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            VStack{
                topArea
//                calculationArea
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
            HStack(spacing: 20){
                Image(uiImage: .logo)
                    .resizable()
                    .frame(width: 50, height: 50)
                Text("FarePay")
                    .font(.custom(.poppinsBold, size: 35))
                    .foregroundColor(.white)
                    .onAppear(){
                        setMainView(true)
                    }
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
                    
                    TextField(currencyManager.string, text: $currencyManager.string)
                        .font(.custom(.poppinsBold, size: 40))
                        .frame(height: 30)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: currencyManager.string, perform: currencyManager.valueChanged)
                        
                        .disabled(true)
                }
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(.darkBlueColor))
            .cornerRadius(10)
        }
        .padding(.horizontal, 15)
    }
    
    var calculationArea : some View {
        VStack{
            
//            HStack(spacing: 30){
//                
//                
//                
//                Text("Charge Fare ")
//                    .foregroundColor(.white)
//                    .font(.custom(.poppinsBold, size: 25))
//                
//                Spacer()
//            }
//            .frame(maxWidth: .infinity)
//            
//            ZStack{
//                HStack{
//                    
//                    Text("$")
//                        .font(.custom(.poppinsMedium, size: 25))
//                        .foregroundColor(Color(.darkGrayColor))
//                    Spacer()
//                    
//                    //                    TextField("", text: $totalChargresWithTax, prompt: Text("0.00").foregroundColor(Color(.white)))
//                    
//                    Text(totalChargresWithTax.description)
//                        .font(.custom(.poppinsBold, size: 40))
//                        .frame(height: 30)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.trailing)
//                        .lineLimit(1)
////                        .disabled(isDisabled)
//                }
//                .padding(.horizontal, 20)
//            }
//            .frame(maxWidth: .infinity)
//            .frame(height: 80)
//            .background(Color(.darkBlueColor))
//            .cornerRadius(10)
            
            VStack(spacing: 5){
                
               
                
                HStack{
                    
                    Text("Service Charges : ")
                        .foregroundColor(Color(.darkGrayColor))
                        .font(.custom(.poppinsMedium, size: 23))
                    Spacer()
                    Text("$ \(currencyManager.serviceFee.description)")
                        .foregroundColor(Color(.white))
                        .font(.custom(.poppinsBold, size: 23))
                }
                
                HStack{
                    
                    Text("Service Fee GST")
                        .foregroundColor(Color(.darkGrayColor))
                        .font(.custom(.poppinsMedium, size: 23))
                    Spacer()
                    Text("$ \(currencyManager.serviceFeeGst.description)")
                        .foregroundColor(Color(.white))
                        .font(.custom(.poppinsBold, size: 23))
                }
                
                HStack{
                    
                    Text("Fare Inc GST :")
                        .foregroundColor(Color(.darkGrayColor))
                        .font(.custom(.poppinsMedium, size: 23))
                    Spacer()
                    Text("$ \(currencyManager.totalChargresWithTax.description)")
                        .foregroundColor(Color(.white))
                        .font(.custom(.poppinsBold, size: 23))
                }
            }
        }
        .padding(.horizontal, 10)
    }
    var keypadArea: some View{
        
        VStack(spacing: 25){
            
            HStack{
                
                Group{
                    Text("1")
                        .onTapGesture {
                            currencyManager.string += "1"
                        }
                    Text("2")
                        .onTapGesture {
                            currencyManager.string += "2"
                        }
                    Text("3")
                        .onTapGesture {
                            currencyManager.string += "3"
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
                            currencyManager.string += "4"
                        }
                    Text("5")
                        .onTapGesture {
                            currencyManager.string += "5"
                        }
                    Text("6")
                        .onTapGesture {
                            currencyManager.string += "6"
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
                            currencyManager.string += "7"
                        }
                    Text("8")
                        .onTapGesture {
                            currencyManager.string += "8"
                        }
                    Text("9")
                        .onTapGesture {
                            currencyManager.string += "9"
                        }
                }
                .font(.custom(.poppinsBold, size: 35))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            }
            
            HStack{
                
                Group{
                    
                    Text("")
                        
                    Text("0")
                        .onTapGesture {
                            currencyManager.string += "0"
                        }
                    Image(uiImage: .ic_BackSpace)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            if !currencyManager.string.isEmpty{
                                currencyManager.string.removeLast()
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
                setMainView(false)
                willMoveToPaymentDetail.toggle()
                print(currencyManager.string)
                
            } label: {
                
                Text("Pay")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(currencyManager.string == "0.00" || currencyManager.string == "" ? Color(.buttonColor).opacity(0.5) : Color(.buttonColor))
                    .cornerRadius(30)
            }
            .disabled(currencyManager.string == "0.00" || currencyManager.string == "" ? true : false)
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 20)
    }
}
