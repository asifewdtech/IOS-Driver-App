//
//  Utility.swift
//  Farepay
//
//  Created by Arslan on 24/08/2023.
//

import Foundation
import SwiftUI
import UIKit

struct CustomRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        return Path(path.cgPath)
    }
}

let userDefault = UserDefaults.standard

func isLogin() -> Bool{
    
    if userDefault.bool(forKey: .isUserLogin) == true{
        return true
    }
    else{
        return false
    }
}

func setUserLogin(_ value: Bool){
    userDefault.set(value, forKey: .isUserLogin)
}
