//
//  UserAuthViewModel.swift
//  Farepay
//
//  Created by Asfand Hafeez on 10/10/2023.
//

import SwiftUI
import GoogleSignIn
import AuthenticationServices
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import CryptoKit


class UserAuthViewModel:NSObject, ObservableObject,ASAuthorizationControllerDelegate {
    
    @Published var givenName: String = ""
    @Published var profilePicUrl: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    @Published var nonce: String = ""
    @Published var isGoogleLogin = false
    @Published var isAccountCreated = false
    @Published var bankAccced = false

    override init(){
        super.init()
   
    }
    
    func checkStatus(){
        if(GIDSignIn.sharedInstance.currentUser != nil){
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return }
            let givenName = user.profile?.givenName
            let profilePicUrl = user.profile!.imageURL(withDimension: 100)!.absoluteString
            self.givenName = givenName ?? ""
            self.profilePicUrl = profilePicUrl
            self.isLoggedIn = true
        }else{
            self.isLoggedIn = false
            self.givenName = "Not Logged In"
            self.profilePicUrl =  ""
        }
    }
    
    func check(){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            
            self.checkStatus()
        }
    }
    
    @MainActor
    func signIn(email:String,password:String,isSignup:Bool) async {
        do {
            
            let authDataResult = try  await  isSignup  ? Auth.auth().createUser(withEmail: email, password: password) : Auth.auth().signIn(withEmail: email, password: password)
            if isSignup == false  {
                
//                DispatchQueue.main.async {
//                    self.errorMessage = ""
//                    self.checkUserAccountCreated()
//
//                }
                
                self.isLoggedIn = true
                
            }else {
                self.isLoggedIn = true
                
            }
            
             
            
        }
        catch {
            print("There was an issue when trying to sign in: \(error)")
            self.isLoggedIn  = false
            self.errorMessage = error.localizedDescription
        }
    }
    
    
    
    func checkUserAccountCreated()  {
        Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
            if let error = error {
                print(error.localizedDescription)
                self.isLoggedIn  = false
            }else {
                
                guard let snap = snapShot else { return  }
                
                DispatchQueue.main.async {
                    self.isAccountCreated = snap.get("connectAccountCreated") as? Bool ?? false
                    self.bankAccced = snap.get("bankAdded") as? Bool ?? false
                    self.isLoggedIn = true
                }
                
                
            }
            
            
            
        }
    }
    func SocialLogin() async  {
      
        
    }
    
    func signIn(){
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            else {
                guard let auth = result?.user else { return }
                

                let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken?.tokenString ?? "", accessToken: auth.accessToken.tokenString)
                Auth.auth().signIn(with: credentials) { result, error in
                    if let error = error {
                        print("error\(error)")
                        self.errorMessage = "error: \(error.localizedDescription)"
                    }else {

                        self.checkUserAccountCreated()
                        
                        NotificationCenter.default.post(name: NSNotification.Name("SIGNIN"), object: nil)
                    }
                }
                
  
            }
            
            
            
        }
    }
    
    func signOut(){
        GIDSignIn.sharedInstance.signOut()
        self.checkStatus()
    }
    
    
    // Apple Delegates
    
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIdCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let token = appleIdCredential.identityToken  else {
                return
            }
            guard let tokenString = String(data: token, encoding: .utf8) else { return  }
            
            let fireBaseCredentials = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString,rawNonce: nonce)
            Auth.auth().signIn(with: fireBaseCredentials) { result, error in
                if let error = error {
                    print("error\(error)")
                    self.errorMessage = "error: \(error.localizedDescription)"
                }else {
                    self.isLoggedIn  = true
                    
                    NotificationCenter.default.post(name: NSNotification.Name("SIGNIN"), object: nil)
                }
                
                
                
                
            }
            
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
    }
    
    func performAppleSignIn() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        nonce = randomNonceString()
        request.nonce = sha256(nonce)
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.performRequests()
    }
}





func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    var randomBytes = [UInt8](repeating: 0, count: length)
    let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    if errorCode != errSecSuccess {
        fatalError(
            "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
    }
    
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    
    let nonce = randomBytes.map { byte in
        // Pick a random character from the set, wrapping around if needed.
        charset[Int(byte) % charset.count]
    }
    
    return String(nonce)
}


@available(iOS 13, *)
func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}



struct User {
    
    
    var givenName: String
    var profilePicUrl: String
    var email: String
    
    
    
    
}
