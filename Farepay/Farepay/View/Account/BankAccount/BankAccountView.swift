//
//  BankAccountView.swift
//  Farepay
//
//  Created by Arslan on 20/09/2023.
//

import SwiftUI
import ActivityIndicatorView

struct BankAccountView: View {
    
    //MARK: - Variables
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var willMoveToNewAccount: Bool = false
    @StateObject var bankAccountViewModel = BankAccountViewModel()
    @State var showLoadingIndicator: Bool = false
    
    //MARK: - Views
    var body: some View {
        ZStack{
            
            NavigationLink("", destination: AddNewBankAccountView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToNewAccount).isDetailLink(false)
            
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack(spacing: 10){
                topArea
                Spacer()
                listView
                Spacer()
//                buttonArea
                bottomTextArea
            }
            .padding(.all, 15)
            .onAppear(perform: {
                showLoadingIndicator = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                    showLoadingIndicator = false
                }
            })
            
            if showLoadingIndicator{
                VStack{
                    ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc(.white, lineWidth: 5))
                        .frame(width: 50.0, height: 50.0)
                        .foregroundColor(.white)
                        .padding(.top, 350)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct BankAccountView_Previews: PreviewProvider {
    static var previews: some View {
        BankAccountView()
    }
}

extension BankAccountView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            Image(uiImage: .backArrow)
                .resizable()
                .frame(width: 30, height: 25)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("Bank Account")
                .font(.custom(.poppinsBold, size: 22))
                .foregroundColor(.white)
            Spacer()
        }
    }
    
    var listView: some View{
        
        VStack{
                if (bankAccountViewModel.arrBankRes.count == 0) {
                    VStack{
                    Text("No Record Found")
                        .font(.custom(.poppinsMedium, size: 25))
                        .foregroundColor(Color(.darkGrayColor))
                        .multilineTextAlignment(.center)
                    }
                } else {
                    ScrollView(showsIndicators: false){
                    ForEach(bankAccountViewModel.arrBankRes, id: \.id) { bank in
                        VStack{
                            HStack(spacing: 15){
                                Image(uiImage: .image_placeholder)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(25)
                                VStack(alignment: .leading, spacing: 10){
                                    Text(bank.bank_name)
                                        .font(.custom(.poppinsSemiBold, size: 16))
                                        .foregroundColor(.white)
                                        .lineLimit(2)
                                    HStack{
                                        Text("**** **** **** \(bank.last4)")
                                            .font(.custom(.poppinsMedium, size: 14))
                                            .foregroundColor(Color(.darkGrayColor))
                                        Spacer()
                                        Image(uiImage: .ic_StarUnFilled)
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                    }
                                }
                            }
                            .padding(.horizontal, 15)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .background(Color(.darkBlueColor))
                        .cornerRadius(10)
                        .padding(.bottom, 5)
                    }
                }
            }
        }
    }
    
    var buttonArea: some View{
        Text("Add New Account")
            .font(.custom(.poppinsBold, size: 25))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(.buttonColor))
            .cornerRadius(30)
            .onTapGesture {
                willMoveToNewAccount.toggle()
            }
    }
    
    var bottomTextArea: some View{
        Text("Please email base@farepay.app if you need to update your bank account details.")
            .font(.custom(.poppinsBold, size: 12))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
    }
}
