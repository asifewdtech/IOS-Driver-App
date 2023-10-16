//
//  OtpViewModel.swift
//  Farepay
//
//  Created by Asfand Hafeez on 16/10/2023.
//

import Foundation

import Foundation
import Firebase
import SwiftUI

class OtpViewModel: ObservableObject {
    @Published var isVerify: Bool = false
    @Published var isVerified: Bool = false
    
    @Published var isError: Bool = false
    @Published var errorMsg: String = ""
}

extension OtpViewModel {
    
    func sendCode(phoneNumber:String) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationId, error) in
            if error != nil {
                self.isError.toggle()
                self.errorMsg = error?.localizedDescription ?? ""
                return
            }else {
                UserDefaults.standard.set(verificationId, forKey: "verificationId")
                self.isVerify.toggle()
            }
            
            
        }
    }
    
    func verifyCode(code: String) {
        let verificationId = UserDefaults.standard.string(forKey: "verificationId") ?? ""
        let credentials = PhoneAuthProvider.provider().credential(withVerificationID: verificationId, verificationCode: code)
    
        Auth.auth().signIn(with: credentials) { (authResult, error) in
            
            if error != nil {
                self.isError.toggle()
                self.errorMsg = error?.localizedDescription ?? ""
                return
            }else {
                print(authResult ?? "")
                
                self.isVerified.toggle()
            }
            
            
        }
        
    }
}

