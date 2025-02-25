//
//  AuthenticateFaceIdPswd.swift
//  Farepay
//
//  Created by Mursil on 09/10/2024.
//

import SwiftUI
import LocalAuthentication
import UIKit

struct AuthenticateFaceIdPswdView: View {
    @State private var willMoveToMainView = false
    @State private var toast: Toast? = nil
    var context = LAContext()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ZStack{
                NavigationLink("", destination: Farepay.MainTabbedView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToMainView ).isDetailLink(false)
                
                Color(.bgColor)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    Spacer()
                    topArea
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    buttonArea
                }
                .toastView(toast: $toast)
                .onAppear(){
                    authenticateAppPswd()
                }
            }
        }
    }
}

struct authenticatePswd_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticateFaceIdPswdView()
    }
}

extension AuthenticateFaceIdPswdView{
    
    var topArea: some View{
        VStack (spacing: 20) {
//            HStack {
//                Image(uiImage: .underReviewImage)
//                    .resizable()
//                    .frame(width: 330, height: 268)
//            }
            
            HStack {
                Text("Farepay Locked")
                    .font(.custom(.poppinsBold, size: 30))
                    .foregroundColor(.white)
            }
            
            HStack {
                Text("Unlock with Face ID to open Farepay")
                    .font(.custom(.poppinsMedium, size: 16))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    
            }
//            .frame(minWidth: 330, maxWidth: 330, minHeight: 40, maxHeight: 40, alignment: .center)
        }
    }
    
    
    var buttonArea: some View{
        
        VStack(spacing: 100){
            Button {
               authenticateAppPswd()
            } label: {
                Text("Use Face ID")
                    .font(.custom(.poppinsBold, size: 22))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .frame(maxWidth: 400)
                    .background(Color(.buttonColor))
                    .cornerRadius(30)
            }
        }
    }
    
    func authenticateAppPswd() {
        let context = LAContext()
        context.localizedCancelTitle = "Cancel"
        var error: NSError?
        
        // First check if biometrics is available
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    DispatchQueue.main.async {
                        let firstTimeFaceID = UserDefaults.standard.integer(forKey: "firstTimeFaceID")
                        if firstTimeFaceID == 1 {
                            willMoveToMainView = true
                            UserDefaults.standard.removeObject(forKey: "firstTimeFaceID")
                        } else {
                            dismiss()
                        }
                    }
                } else {
                    // If biometrics fails, automatically fall back to passcode
                    self.fallbackToPasscode(context: context)
                }
            }
        } else {
            // If biometrics isn't available, directly try passcode
            fallbackToPasscode(context: context)
        }
    }

    private func fallbackToPasscode(context: LAContext) {
        let reason = "Please enter your passcode to continue."
        
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
            DispatchQueue.main.async {
                if success {
                    dismiss()
                } else if let error = authenticationError as? LAError {
                    switch error.code {
                    case .userCancel:
                        print("User cancelled")
                    case .userFallback:
                        print("User tapped Enter Password")
                    case .authenticationFailed:
                        print("Authentication failed")
                    default:
                        print("Authentication failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
