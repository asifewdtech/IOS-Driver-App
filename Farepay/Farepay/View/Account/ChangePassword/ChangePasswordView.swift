//
//  ChangePasswordView.swift
//  Farepay
//
//  Created by Arslan on 20/09/2023.
//

import SwiftUI
import FirebaseAuth
import ActivityIndicatorView

struct ChangePasswordView: View {
    
    //MARK: - Variables
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var oldPasswordText: String = ""
    @State private var isSecureOldPassword: Bool = true
    @State private var newPasswordText: String = ""
    @State private var isSecureNewPassword: Bool = true
    @State private var reTypePasswordText: String = ""
    @State private var isSecureReTypePassword: Bool = true
    let user = Auth.auth().currentUser
    var credential: AuthCredential?
    @State private var toast: Toast? = nil
    @State private var showLoadingIndicator: Bool = false
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
    
    //MARK: - Views
    var body: some View {
        ZStack{
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack(spacing: 40) {
                topArea
                textArea
                Spacer()
                buttonArea
            }
            .toastView(toast: $toast)
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

//struct ChangePasswordView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChangePasswordView()
//    }
//}

extension ChangePasswordView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            Image(uiImage: .backArrow)
                .resizable()
                .frame(width: 30, height: 25)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("Change Password")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
        }
    }
    
    var textArea: some View{
        
        VStack(alignment: .leading, spacing: 20){
            
            Group{
                Group{
                    if isSecureOldPassword{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $oldPasswordText, placHolderText: .constant("Type your old password"), isSecure: .constant(true))
                    }
                    else{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $oldPasswordText, placHolderText: .constant("Type your old password"), isSecure: .constant(false))
                    }
                }
                .overlay{
                    Text("    ")
                        .frame(width: 50, height: 50)
                        .padding(.leading, UIScreen.main.bounds.width - 90)
                        .onTapGesture {
                            isSecureOldPassword.toggle()
                        }
                }
//                
                Group{
                    if isSecureNewPassword{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $newPasswordText, placHolderText: .constant("Type your new password"), isSecure: .constant(true))
                    }
                    else{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $newPasswordText, placHolderText: .constant("Type your new password"), isSecure: .constant(false))
                    }
                }
                .overlay{
                    Text("    ")
                        .frame(width: 50, height: 50)
                        .padding(.leading, UIScreen.main.bounds.width - 90)
                        .onTapGesture {
                            isSecureNewPassword.toggle()
                        }
                }
                
                Group{
                    if isSecureReTypePassword{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $reTypePasswordText, placHolderText: .constant("Re-Type your password"), isSecure: .constant(true))
                    }
                    else{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $reTypePasswordText, placHolderText: .constant("Re-Type your password"), isSecure: .constant(false))
                    }
                }
                .overlay{
                    Text("    ")
                        .frame(width: 50, height: 50)
                        .padding(.leading, UIScreen.main.bounds.width - 90)
                        .onTapGesture {
                            isSecureReTypePassword.toggle()
                        }
                }
            }
            .frame(height: 70)
        }
    }
    
    
    var buttonArea: some View{
        
        
        
        VStack(spacing: 20){
                        
            Button(action: {
                

                // Prompt the user to re-provide their sign-in credentials
//                guard let credential else {return}
                
//                if oldPasswordText.count != 0 && newPasswordText.count >= 6  {
//                    if newPasswordText == reTypePasswordText {
//                        updatePass()
//                    }
//                }
            
                updatePass()
                
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
    
    
    
    func updatePass()  {
        if oldPasswordText.isEmpty {
            toast = Toast(style: .error, message: "Old Password field cannot be empty.")
        }
        else if newPasswordText.isEmpty {
            toast = Toast(style: .error, message: "New Password field cannot be empty.")
        }
        else if !newPasswordText.isValidPassword(newPasswordText) {
            toast = Toast(style: .error, message: "Password must have more than 6 characters, contain one digit, one uppercase letter and a special character.")
        }
        else if reTypePasswordText.isEmpty {
            toast = Toast(style: .error, message: "New Password field cannot be empty.")
        }
        else if newPasswordText != reTypePasswordText {
            toast = Toast(style: .error, message: "Both Password Should be matched.")
        }
        else {
            showLoadingIndicator = true
            let cred = EmailAuthProvider.credential(withEmail: Auth.auth().currentUser?.email ?? "", password: oldPasswordText)
            user?.reauthenticate(with: cred, completion: { auths, errors in
                showLoadingIndicator = false
                if let errors = errors {
                    toast = Toast(style: .error, message: errors.localizedDescription)
                }else {
                    user?.updatePassword(to: newPasswordText, completion: { error in
                        if let err = error {
                            
                            toast = Toast(style: .error, message: err.localizedDescription)
                        }else {
                            
                            toast = Toast(style: .success, message: "Password Changed Successfully")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                presentationMode.wrappedValue.dismiss()
//                                setUserLogin(false)
//                                                do {
//                                                   try  Auth.auth().signOut()
//                                
//                                                } catch  {
//                                                    print("error")
//                                                }
//                                rootPresentationMode.wrappedValue.dismiss()
                            }
                        }
                        
                    })
                }
                
            })
        }

    }
}
