//
//  EditAccountView.swift
//  Farepay
//
//  Created by Arslan on 19/09/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import ActivityIndicatorView

struct EditAccountView: View {
    
    //MARK: - Variables
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var willMoveToEditInfo: Bool = false
    @State private var nameText: String = ""
    @State private var phoneText: String = ""
    @State private var emailText: String = ""
    @State private var showLoadingIndicator: Bool = false
    @State private var taxiText: String = ""
    
    // MARK: - Views
    var body: some View {
        ZStack{
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack(spacing: 40) {
                topArea
                textArea
                Spacer()
                buttonArea
            }
            .onAppear(perform: {
                Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }else {
                        
                        guard let snap = snapShot else { return  }
                        nameText  = snap.get("userName") as? String ?? ""
                        phoneText = snap.get("phonenumber") as? String ?? ""
                        taxiText = snap.get("taxiNumber") as? String ?? ""
                    }
                }
            })
            .padding(.all, 15)
            
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

struct EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
        EditAccountView()
    }
}

extension EditAccountView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            Image(uiImage: .backArrow)
                .resizable()
                .frame(width: 30, height: 25)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("Account info")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
        }
    }
    
    var textArea: some View{
        
        VStack(alignment: .leading, spacing: 20){
            
            MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_User), text: $nameText, placHolderText: .constant("Type your Name"), isSecure: .constant(false))
                .frame(height: 70)
//            MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Phone), text: $phoneText, placHolderText: .constant("Type your Phone Number"), isSecure: .constant(false))
//                .frame(height: 70)
            
            HStack {
                Image(uiImage: .ic_Mobile)
                    .resizable()
                    .frame(width: 30, height: 30)
                HStack {
                    Text("+61")
                        .foregroundStyle(Color.white)
                    TextField(
                        "Type your mobile No",
                        text: $phoneText.max(9)
                    )
                    .keyboardType(.numberPad)
                    .foregroundStyle(Color.white)
                }
                
            }
            .padding(.horizontal,10)
            .frame(height: 70)
            .background(Color(.darkBlueColor))
            .cornerRadius(10)
            
            HStack {
                Image(uiImage: .ic_taxiNumIcon)
                    .resizable()
                    .frame(width: 30, height: 30)
                HStack {
//                    Text("TXI8675")
//                        .foregroundStyle(Color.white)
                    TextField(
                        "TXI8675",
                        text: $taxiText
                    )
                    .textInputAutocapitalization(.characters)
                    .foregroundStyle(Color.white)
                }
                
            }
            .padding(.horizontal,10)
            .frame(height: 70)
            .background(Color(.darkBlueColor))
            .cornerRadius(10)
            
            MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Email), text: .constant(Auth.auth().currentUser?.email ?? ""), placHolderText: .constant(Auth.auth().currentUser?.email ?? ""), isSecure: .constant(false),isUserInteractionEnable:false)
                .frame(height: 70)
            
        }
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 20){
            Button(action: {
                showLoadingIndicator = true
                
                if !nameText.isEmpty && phoneText.count == 9  {
                    Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").updateData(["userName":nameText, "phonenumber":phoneText, "taxiNumber": taxiText])
                    showLoadingIndicator = false
                    presentationMode.wrappedValue.dismiss()
                }
                
            }, label: {
                Text("Save")
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
