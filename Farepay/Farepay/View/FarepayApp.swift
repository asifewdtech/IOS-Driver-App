//
//  FarepayApp.swift
//  Farepay
//
//  Created by Arslan on 24/08/2023.
//

import SwiftUI
import NavigationStack

@main
struct FarepayApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStackView{
                SplashView()
//                MainTabbedView()
            }
        }
    }
}
