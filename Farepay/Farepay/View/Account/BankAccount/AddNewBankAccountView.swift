//
//  AddNewBankAccountView.swift
//  Farepay
//
//  Created by Arslan on 21/09/2023.
//

import SwiftUI

struct AddNewBankAccountView: View {
    
    //MARK: - Variables
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var bankName: String = ""
    @State var accountNumber: String = ""
    @State var bsbNumber: String = ""
    @State var accountHolderName: String = ""
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack(spacing: 40){
                topArea
                textArea
                Spacer()
                buttonArea
            }
            .padding(.all, 15)
        }
    }
}

struct AddNewBankAccountView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewBankAccountView()
    }
}

extension AddNewBankAccountView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            Image(uiImage: .backArrow)
                .resizable()
                .frame(width: 35, height: 30)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("Add New Account")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
        }
    }
    
    var textArea: some View{
        
        VStack(alignment: .leading, spacing: 20){
            
            Group{
                ZStack{
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Bank)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(.darkGrayColor))
                        
                        TextField("", text: $bankName, prompt: Text("Select your bank").foregroundColor(Color(.darkGrayColor)))
                            .font(.custom(.poppinsMedium, size: 18))
                            .frame(height: 30)
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(Image(systemName: "chevron.down"))")
                            .font(.custom(.poppinsMedium, size: 20))
                            .foregroundColor(.white)
                        
                    }
                    .padding([.leading, .trailing], 20)
                }
                
                ZStack{
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_AccountNumber)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(.darkGrayColor))
                        
                        
                        TextField("", text: $bankName, prompt: Text("Type account number").foregroundColor(Color(.darkGrayColor)))
                            .font(.custom(.poppinsMedium, size: 18))
                            .frame(height: 30)
                            .foregroundColor(.white)
                        
                    }
                    .padding([.leading, .trailing], 20)
                }
                
                ZStack{
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_BSB)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(.darkGrayColor))
                        
                        
                        TextField("", text: $bankName, prompt: Text("Type BSB number").foregroundColor(Color(.darkGrayColor)))
                            .font(.custom(.poppinsMedium, size: 18))
                            .frame(height: 30)
                            .foregroundColor(.white)
                        
                    }
                    .padding([.leading, .trailing], 20)
                }
                
                ZStack{
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_AccountHolder)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(.darkGrayColor))
                        
                        
                        TextField("", text: $bankName, prompt: Text("Type account holder's name").foregroundColor(Color(.darkGrayColor)))
                            .font(.custom(.poppinsMedium, size: 18))
                            .frame(height: 30)
                            .foregroundColor(.white)
                        
                    }
                    .padding([.leading, .trailing], 20)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(.darkBlueColor))
            .cornerRadius(10)
        }
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 20){
                        
            NavigationLink {
                OtpView().toolbar(.hidden, for: .navigationBar)
            } label: {
                Text("Confirm")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(.buttonColor))
                    .cornerRadius(30)
            }

        }
    }
}
