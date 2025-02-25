//
//  SplashView.swift
//  Farepay
//
//  Created by Mursil on 24/08/2023.
//

import SwiftUI
import ActivityIndicatorView
import FirebaseAuth
import FirebaseFirestore

struct SplashView: View {
    
    // MARK: - State Variables
    
    /// Navigation state variables to control view routing
    @State private var LoginView: String? = nil
    @State private var willMoveToLogin = false
    @State private var willMoveToMainView = false
    @State private var willMoveToCompanyView = false
    @State private var willMoveToBankAccount: Bool = false
    @State private var willMoveToUnderReviewView = false
    @State private var willMoveToAuthPswd = false
    @State private var willMoveToForm2: Bool = false
    
    /// User account state tracking variables
    @State private var isAccountCreated: Bool = false
    @State private var isBankCreated: Bool = false
    @State private var isAccountApproved: String = ""
    @State private var isSessionID: String = ""
    @State private var isIdentityVerified: Bool = false
    
    /// UI state variable for loading indicator
    @State private var showLoadingIndicator: Bool = true
    
    /// Persistent storage for user's account ID
    @AppStorage("accountId") var accountId: String = ""
    
    // MARK: - View Body
    
    var body: some View {
        NavigationView {
            ZStack{
                // Navigation links for different possible routes
                // Each link is hidden initially and activated based on user state
                NavigationLink("", destination: Farepay.LoginView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToLogin ).isDetailLink(false)
                NavigationLink("", destination: Farepay.CompanyView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToCompanyView ).isDetailLink(false)
                NavigationLink("", destination: Farepay.NewsView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToBankAccount ).isDetailLink(false)
                NavigationLink("", destination: Farepay.MainTabbedView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToMainView ).isDetailLink(false)
                NavigationLink("", destination: Farepay.UnderReviewView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToUnderReviewView ).isDetailLink(false)
                NavigationLink("", destination: Farepay.AuthenticateFaceIdPswdView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToAuthPswd ).isDetailLink(false)
                NavigationLink("", destination: Farepay.RepresentativeView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToForm2 ).isDetailLink(false)
                
                // Splash screen UI elements
//                Color(.bgColor)
//                    .edgesIgnoringSafeArea(.all)
                // Gradient background
//                LinearGradient(
//                    gradient: Gradient(colors: [
//                        Color(red: 0.8, green: 0, blue: 0.8),      // Brighter purple
//                        Color(red: 0.4, green: 0, blue: 0.4),      // Darker purple transition
//                        Color(red: 0, green: 0, blue: 0.15),       // Very dark blue/black
//                        Color(red: 0, green: 0.15, blue: 0.25)     // Deep teal-blue
//                    ]),
//                    startPoint: .bottom,
//                    endPoint: .top
//                )
                Image(uiImage: .splashBg)
                    .resizable()
                    .scaledToFill()
                .ignoresSafeArea()
                HStack(spacing: 20){
                    Image(uiImage: .splashLogo)
                        .resizable()
                        .frame(width: 300, height: 300)
//                    Text(verbatim: .appName)
//                        .font(.custom(.poppinsBold, size: 45))
//                        .foregroundColor(.white)
                }
                
                // Loading indicator
                ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc(.white, lineWidth: 5))
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(.white)
                    .padding(.top, 350)
            }
            .onAppear(){
                // Check authentication state when view appears
                if Auth.auth().currentUser != nil {
                    checkUserConnectAccount()
                }else {
                    navigateNext()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environment(\.rootPresentationMode, $willMoveToLogin)
        .environment(\.rootPresentationMode, $willMoveToMainView)
        .environment(\.rootPresentationMode, $willMoveToCompanyView)
        .environment(\.rootPresentationMode, $willMoveToBankAccount)
        .environment(\.rootPresentationMode, $willMoveToUnderReviewView)
    }
    
    // MARK: - Navigation Functions
    
    func navigateNext(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showLoadingIndicator.toggle()
            
            if Auth.auth().currentUser != nil {
                // Complex routing logic based on multiple account setup flags
                if !(isSessionID == "") && (isAccountCreated == true) && (isBankCreated == true) && (isIdentityVerified == true) {
                    UserDefaults.standard.set(1, forKey: "firstTimeFaceID")
                    willMoveToAuthPswd = true
                }
                else if !(isSessionID == "") && (isAccountCreated == false) && (isBankCreated == false) && (isIdentityVerified == false) {
                    willMoveToUnderReviewView = true
                }
                else if !(isSessionID == "") && (isAccountCreated == false) && (isBankCreated == false) && (isIdentityVerified == true) {
                    willMoveToForm2 = true
                }
                else if !(isSessionID == "") && (isAccountCreated == true) && (isBankCreated == false) && (isIdentityVerified == true)  {
                    willMoveToBankAccount = true
                }
                else if !(isSessionID == "") && (isAccountCreated == true) && (isBankCreated == true) && (isIdentityVerified == true) {
                    willMoveToMainView = true
                }
                else {
                    willMoveToLogin.toggle()
                }
            } else {
                willMoveToLogin.toggle()
            }
        }
    }
    
    // Updates verification documents for a user's account
    func UpdateVerificationDocs(accId: String, frontimgid: String) {
        var request = URLRequest(url: URL(string: "https://7mvvg9bock.execute-api.eu-north-1.amazonaws.com/default/UpdateVerificationDocs?accountId=acct_1PQkjIPSlpHJllKG&frontimgid=file_1PQkk5A1ElCzYWXLZorlbFf9")!,timeoutInterval: Double.infinity)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
            print("UpdateVerificationDocs: ",String(data: data, encoding: .utf8)!)
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    if let verifiDict = jsonDict["id"] as? String {
                        print("Success UpdateVerificationDocs Acc id: \(verifiDict)")
                        showLoadingIndicator = false
                        willMoveToMainView = true
                    }
                    else {
                        print("Error id not foud.")
                    }
                }
            }
            catch{
                print("Error parsing JSON: \(error)")
            }
        }
        
        task.resume()
    }
    
    /// Checks the user's connected account status in Firestore
    /// Retrieves account creation status, bank details, and other verification flags
    func checkUserConnectAccount()  {
        let collectionRef = Firestore.firestore().collection("usersInfo")
        collectionRef.getDocuments { (snapshot, error) in
            
            if let err = error {
                debugPrint("error fetching docs: \(err)")
            } else {
                guard let snap = snapshot else {
                    return
                }
                for document in snap.documents {
                    let data = document.data()
                    let emailText = Auth.auth().currentUser?.email ?? ""
                    if UserDefaults.standard.bool(forKey: "isNewUser") == true {
                        if emailText ==  data["email"] as? String {
                            print("emailText: ",emailText)
                            DispatchQueue.main.async {
                                // Update local state with user's account status
                                isIdentityVerified = data["identityVerified"] as? Bool ?? false
                                isSessionID = data["sessionID"] as? String ?? ""
                                isAccountCreated = data["connectAccountCreated"] as? Bool ?? false
                                isBankCreated = data["bankAdded"] as? Bool ?? false
                                isAccountApproved = data["frontimgid"] as? String ?? ""
                                if accountId == "" {
                                    accountId = data["accountId"] as? String ?? ""
                                }
                                navigateNext()
                            }
                        }
                    }
                }
                navigateNext()
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
