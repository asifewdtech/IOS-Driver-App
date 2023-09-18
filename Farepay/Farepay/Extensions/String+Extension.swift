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
    static let selectCompany = "Select your Company type"
    
    static let isUserLogin = "isUserLogin"
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
}
