//
//  FarepayApp.swift
//  Farepay
//
//  Created by Mursil on 24/08/2023.
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
    @Environment(\.scenePhase) var scenePhase
    @State private var showAuthenticationView = false
    @ObservedObject private var currencyManager = CurrencyManager(amount: 0)
    @State private var showContentView = false
    
    
    //MARK: - Views
    var body: some Scene {
        WindowGroup {
            SplashView()
//            Group {
//                switch appRootManager.currentRoot {
//                case .splash:
//                    SplashView()
//                    
//                case .authentication:
//                    LoginView()
//                    
//                case .home:
//                    MainTabbedView()
//                }
//            }
//            .environmentObject(appRootManager)
            
                .onChange(of: scenePhase, perform: { newScenePhase in
                    switch newScenePhase {
                    case .active:
                        let callFaceID = UserDefaults.standard.integer(forKey: "callFaceID")
                        if callFaceID == 1 {
                            NotificationCenter.default.post(name: Notification.Name("appDidBecomeActive"), object: nil)
//                            NotificationCenter.default.post(name: Notification.Name("removeCurrencyFare"), object: nil)
//                            currencyManager.string1 = ""
                            UserDefaults.standard.removeObject(forKey: "callFaceID")
                        }
                        print ("AppState: active")
//                        showAuthenticationView = true
                    case .background:
                        UserDefaults.standard.set(1, forKey: "callFaceID")
//                        showAuthenticationView = true
//                        NotificationCenter.default.post(name: Notification.Name("appDidBecomeActive"), object: nil)
                        print ("AppState: background")
                    case .inactive:
                        print("AppState: inactive")
                    default:
                        print( "AppState: unknown")
                    }
                })
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
//        IQKeyboardManager.shared.toolbarTintColor = UIColor.bgColor
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
