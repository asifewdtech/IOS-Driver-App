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
    @State var goToHome = false
    @State var accountNumber: String = ""
    @State var bsbNumber: String = ""
    @State var accountHolderName: String = ""
    @ObservedObject var completeFormViewModel = CompleteFormViewModel()
    @AppStorage("accountId") var accountId: String = ""
    //MARK: - Views
    var body: some View {
        
        ZStack{
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack(spacing: 40){
                NavigationLink("", destination: Farepay.MainTabbedView().toolbar(.hidden, for: .navigationBar), isActive: $goToHome ).isDetailLink(false)
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

//                HStack(spacing: 10){
//                    
//                    DropdownSelector(
//                        placeholder: "Select your bank", leftImage: .ic_Bank,
//                        options: businessType,
//                        onOptionSelected: { option in
//                            print(option)
//
//                        })
//                    
//                }
//            .frame(maxWidth: .infinity)
//            .frame(height: 60)
//            .background(Color(.darkBlueColor))
//            .cornerRadius(10)
             
            MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_AccountNumber), text: $accountNumber.max(9), placHolderText: .constant("Type account number"), isSecure: .constant(false),isNumberPad: true)
                .frame(height: 70)
//            MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_BSB), text: $bsbNumber.max(3), placHolderText: .constant("Type BSB number"), isSecure: .constant(false),isNumberPad: true)
//                .frame(height: 70)
            MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_AccountHolder), text: $accountHolderName, placHolderText: .constant("Type account holder's name"), isSecure: .constant(false))
                .frame(height: 70)
        }
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 20){
                        

         
            Button(action: {
                if accountNumber.count == 9 && !accountNumber.isEmpty  {
                    Task {
                        
                        let param = [
                            "object": "bank_account",
                             "country": "AU",
                             "currency": "aud",
                             "account_holder_name": accountHolderName,
                             "account_holder_type": "individual",
                             "account_number": accountNumber,
                             "routing_number": "110000",
                             "account_id": accountId
                        
                        
                        ]
                        try await completeFormViewModel.addBankAccount(url:addBankAccountUrl,method:.post,param:param)
                        DispatchQueue.main.async {
                            if completeFormViewModel.goToHomeScreen {
                                self.goToHome = true
                            }
                        }
                        
                    }
                }else {
                    
                }
            }, label: {
                Text("Confirm")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(.buttonColor))
                    .cornerRadius(30)

            })
      
        }
    }
}
