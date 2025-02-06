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
        
        // First check if we have the needed hardware support for biometrics.
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                // Handle success or failure
                if success {
                    DispatchQueue.main.async {
//                        willMoveToMainView = true
                        let firstTimeFaceID = UserDefaults.standard.integer(forKey: "firstTimeFaceID")
                        if firstTimeFaceID == 1 {
                            willMoveToMainView = true
                            UserDefaults.standard.removeObject(forKey: "firstTimeFaceID")
                        }else{
                            dismiss()
                        }
                    }
                } else {
                    // Biometrics failed, fallback to passcode if needed.
                    if let authError = authenticationError {
                        print(authError.localizedDescription)
                    }
                }
            }
        } else if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // Fallback to passcode if biometrics isn't available.
            let reason = "Please authenticate to continue."
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                if success {
                    DispatchQueue.main.async {
//                        willMoveToMainView = true
                        dismiss()
                    }
                } else {
                    if let authError = authenticationError {
                        print(authError.localizedDescription)
                    }
                }
            }
        } else {
            // No biometrics or passcode available.
            print(error?.localizedDescription ?? "Can't evaluate policy")
        }
    }
}
