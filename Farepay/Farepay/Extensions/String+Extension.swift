//
//  String+Extension.swift
//  Farepay
//
//  Created by Arslan on 24/08/2023.
//

import Foundation
import SwiftUI


extension String{
    
    static let appName = "Farepay"
    static let poppinsBold = "Poppins-Bold"
    static let poppinsSemiBold = "Poppins-SemiBold"
    static let poppinsMedium = "Poppins-Medium"
    static let poppinsThin = "Poppins-Thin"
    
    static let namePlaceHolder = "Type your username"
    static let emailPlaceHolder = "Enter your Email Address"
    static let passwordPlaceHolder = "Type your password"
    static let reTypePasswordPlaceHolder = "Re-Type your password"
    static let RememberMe = "Remember Me"
    static let SignUp = "Sign Up"
    static let SignIn = "Sign in"
    static let dontHaveAccount = "Don't have an account?"
    static let alreadyHaveAccount = "Already have an account?"
    static let selectCompany = "Select your Company type"
    
    static let isUserLogin = "isUserLogin"
    static let isMainView = "isMainView"
    static let mainTabView = "MainTabbedView"
    static let loginView = "LoginView"
    static let signUpView = "SignUpView"
    static let representativeView = "RepresentativeView"
    
    static let giftCard = "Gift Card"
    static let chargeFare = "Charge Fare"
    static let bankTransfer = "Bank Transfer"
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        //let passwordRegex = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{6,}$"
        let passwordRegex = "^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{6,}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
    }
}
