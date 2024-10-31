//
//  ForgotPasswordView.swift
//  Farepay
//
//  Created by Mursil on 17/10/2024.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    //MARK: - Variables
    @State private var emailText: String = ""
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var toast: Toast? = nil
    @State private var showForgotVerifiAlert = false
    
    //MARK: - Views
    var body: some View {
        NavigationView {
            ZStack{
                Color(.bgColor)
                    .edgesIgnoringSafeArea(.all)
                VStack(spacing: 30){
                    topArea
                    textArea
                    Spacer()
                    BottomArea
                }
                .toastView(toast: $toast)
                .padding(.all, 15)
                
                .alert(
                    "Forgot Password",
                    isPresented: $showForgotVerifiAlert
                ) {
                    Button("Continue") {
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text("We have sent Resset Password link to your Email Address. Please check your email.")
                }
            }
        }
    }
}

struct ForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}

extension ForgotPasswordView{
    var topArea: some View {
        
        HStack(spacing: 50){
            Image(uiImage: .backArrow)
                .resizable()
                .frame(width: 30, height: 25)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("Forgot Password")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
        }
    }
    
    var textArea: some View{
        VStack(){
            MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Email), text: $emailText, placHolderText: .constant("Enter your Email Address"), isSecure: .constant(false)).keyboardType(.emailAddress)
        }
    }
    
    var BottomArea: some View{
        
        VStack(spacing: 20){
                        
            Button(action: {
                
                forgotPassword()
                
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
    
    func forgotPassword(){
        if emailText.isEmpty {
            toast = Toast(style: .error, message: "Email Field is Required")
        }
        else if !emailText.isValidEmail(emailText) {
            toast = Toast(style: .error, message: "Please Enter Valid Email")
        }
        else{
            Auth.auth().sendPasswordReset(withEmail: emailText) { (error) in
                if let error = error {
                        // Extract the error code using AuthErrorCode
                        let errorCode = AuthErrorCode(_nsError: error as NSError)
                        
                        switch errorCode.code {
                        case .invalidEmail:
                            print("Error: The email address is invalid.")
                            toast = Toast(style: .error, message: "The email address is invalid.")
                        case .userNotFound:
                            print("Error: No user with this email exists.")
                            toast = Toast(style: .error, message: "No user with this email exists.")
                        case .networkError:
                            print("Error: Network error. Please try again.")
                            toast = Toast(style: .error, message: "Network error. Please try again.")
                        default:
                            print("Error: \(error.localizedDescription)")
                            toast = Toast(style: .error, message: "Something went wrong. Please try again.")
                        }
                    } else {
                        print("Success: A password reset email has been sent!")
                        showForgotVerifiAlert = true
                    }
              
            }
        }
    }
}
