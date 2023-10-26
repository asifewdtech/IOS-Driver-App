//
//  FarepayApp.swift
//  Farepay
//
//  Created by Arslan on 24/08/2023.
//

import SwiftUI
import IQKeyboardManagerSwift
import FirebaseCore
import GoogleSignIn
import StripeTerminal

@main
struct FarepayApp: App {
    
    //MARK: - Variables
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    
    
    //MARK: - Views
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        Terminal.setTokenProvider(APIClient.shared)
        makeConnection()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.toolbarTintColor = UIColor.bgColor
        return true
    }
    
    func makeConnection() {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        guard let url = URL(string: "https://0una8ouowh.execute-api.eu-north-1.amazonaws.com/default/CreateConnectionTokenStripe") else {
            fatalError("Invalid backend URL")
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = session.dataTask(with: request) { (data, response, error) in
            if let data = data {
                do {
                    // Warning: casting using `as? [String: String]` looks simpler, but isn't safe:
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    if let secret = json?["secret"] as? String {
                        print(secret)
                    }
                    else {
                        print("Error")
                        
                    }
                }
                catch {
                    
                }
            }
            else {
                print(error?.localizedDescription)
                
            }
        }
        task.resume()
    }
}
