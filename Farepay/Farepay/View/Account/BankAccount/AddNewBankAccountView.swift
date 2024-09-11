//
//  AddNewBankAccountView.swift
//  Farepay
//
//  Created by Arslan on 21/09/2023.
//

import SwiftUI
import ActivityIndicatorView
import FirebaseAuth
import FirebaseFirestore

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
    @State private var toast: Toast? = nil
    @State var apicalled = false
    @State private var isBankCreated: Bool = false
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
    
    //MARK: - Views
    var body: some View {
            ZStack{
                Color(.bgColor).edgesIgnoringSafeArea(.all)
                VStack(spacing: 40){
                    NavigationLink("", destination: MainTabbedView().toolbar(.hidden, for: .navigationBar), isActive: $goToHome ).isDetailLink(false)
//                    NavigationLink("", destination: UnderReviewView().toolbar(.hidden, for: .navigationBar), isActive: $goToHome ).isDetailLink(false)
                    
                    topArea
                    textArea
                    Spacer()
                    buttonArea
                }
                .toastView(toast: $toast)
                .onAppear(perform: {
                    let stripeSessionID = UserDefaults.standard.string(forKey: "stripeSessionID")
                    let stripeEphemeralKeySecret = UserDefaults.standard.string(forKey: "stripeEphemeralKeySecret")
                    
                    print("stripeSessionID: ",stripeSessionID ?? "")
                    print("stripeEphemeralKeySecret: ",stripeEphemeralKeySecret ?? "")
                    
                    Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").updateData(["sessionID": stripeSessionID ?? "", "ephemeralKeySecret": stripeEphemeralKeySecret ?? ""])
//                    Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").updateData(["ephemeralKeySecret": stripeEphemeralKeySecret ?? ""])
                    
                    checkUserBankAccount()
                })
                .padding(.all, 15)
                
                if apicalled{
                    VStack{
                        ActivityIndicatorView(isVisible: $apicalled, type: .growingArc(.white, lineWidth: 5))
                            .frame(width: 50.0, height: 50.0)
                            .foregroundColor(.white)
                            .padding(.top, 350)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
                }
            }
            .environment(\.rootPresentationMode, $goToHome)
            .edgesIgnoringSafeArea(.top)
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
                .frame(width: 30, height: 25)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("Add Bank Account")
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
             
            MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_AccountHolder), text: $accountHolderName, placHolderText: .constant("Type account holder's name"), isSecure: .constant(false))
                .frame(height: 70)
            
            MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_BSB), text: $bsbNumber.max(6), placHolderText: .constant("Type BSB number"), isSecure: .constant(false),isNumberPad: true)
                .frame(height: 70)
            
            MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_AccountNumber), text: $accountNumber.max(10), placHolderText: .constant("Type account number"), isSecure: .constant(false),isNumberPad: true)
                .frame(height: 70)
        }
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 20){
         
            Button(action: {
                if accountHolderName.isEmpty {
                    toast = Toast(style: .error, message: "Account Holder Name Field cannnot be empty.")
                }
                else if bsbNumber.isEmpty {
                    toast = Toast(style: .error, message: "BSB Number Field cannnot be empty.")
                }
                else if bsbNumber.count <= 5 {
                    toast = Toast(style: .error, message: "BSB Number Should be 6 Digits.")
                }
                else if accountNumber.isEmpty {
                    toast = Toast(style: .error, message: "Account Number Field cannnot be empty.")
                }
                else if (accountNumber.count <= 5 || accountNumber.count >= 11) {
                    toast = Toast(style: .error, message: "Account Number must between 6-10 Digits.")
                }
                else {
                    var addNewBankAcc = ""
                    if API.App_Envir == "Production" {
                        addNewBankAcc = "https://uz86aloftd.execute-api.eu-north-1.amazonaws.com/default/CreateBankAccount"
                    }
                    else if API.App_Envir == "Dev" {
                        addNewBankAcc = "https://mtp8jkyhyc.execute-api.eu-north-1.amazonaws.com/default/CreateBankAccount"
                    }
                    else if API.App_Envir == "Stagging" {
                        addNewBankAcc = "https://eqhs4ooew2.execute-api.eu-north-1.amazonaws.com/default/CreateBankAccount"
                    }else{
                        addNewBankAcc = "https://uz86aloftd.execute-api.eu-north-1.amazonaws.com/default/CreateBankAccount"
                    }
                    
                    Task {
                        apicalled = true
                        let param = [
                            "object": "bank_account",
                             "country": "AU",
                             "currency": "aud",
                             "account_holder_name": accountHolderName,
                            "account_holder_type":  CompanyView().companyText,
                             "account_number": accountNumber,
                             "routing_number": bsbNumber,
                             "account_id": accountId,
//                             "bsb": bsbNumber
                        ]
                        print("create bank account params: \(param)")
                        try await completeFormViewModel.addBankAccount(url:addNewBankAcc,method:.post,param:param)
                        DispatchQueue.main.async {
                            apicalled = false
                            
                            if completeFormViewModel.goToHomeScreen {
                                if isBankCreated {
                                    presentationMode.wrappedValue.dismiss()
                                }else {
                                    self.goToHome = true
                                }
                            }else {
                                toast = Toast(style: .error, message: completeFormViewModel.errorMsg)
                            }
                        }
                    }
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
            
            Button(action: {
                setUserLogin(false)
                do {
                    try  Auth.auth().signOut()
                } catch  {
                    print("error")
                }
                
                rootPresentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Logout")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(.buttonColor))
                    .cornerRadius(30)
            })
        }
    }
    
    func checkUserBankAccount()  {
        Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
            if let error = error {
                print(error.localizedDescription)
            }else {
                
                guard let snap = snapShot else { return  }
                isBankCreated = snap.get("bankAdded") as? Bool ?? false
                
                print("splash bankAdded: ",isBankCreated)
                
            }
        }
    }
}
