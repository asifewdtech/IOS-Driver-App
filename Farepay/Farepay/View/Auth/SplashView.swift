//
//  SplashView.swift
//  Farepay
//
//  Created by Arslan on 24/08/2023.
//

import SwiftUI
import ActivityIndicatorView
import FirebaseAuth
import FirebaseFirestore
struct SplashView: View {
    
    //MARK: - Variables
    @State private var LoginView: String? = nil
    @State private var isAccountCreated: Bool = false
    @State private var willMoveToBankAccount: Bool = false
    @State private var isBankCreated: Bool = false
    @State private var isAccountApproved: String = ""
    @State private var isSessionID: String = ""
    @State private var isIdentityVerified: Bool = false
    @State private var willMoveToLogin = false
    @State private var willMoveToMainView = false
    @State private var willMoveToCompanyView = false
    @State private var showLoadingIndicator: Bool = true
    @AppStorage("accountId") var accountId: String = ""
    @State private var willMoveToUnderReviewView = false
//    @EnvironmentObject private var appRootManager: AppRootManager
    @State private var willMoveToAuthPswd = false
    @State private var willMoveToForm2: Bool = false
    
    //MARK: - Views
    var body: some View {
        NavigationView {
            ZStack{
                
                NavigationLink("", destination: Farepay.LoginView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToLogin ).isDetailLink(false)
                NavigationLink("", destination: Farepay.CompanyView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToCompanyView ).isDetailLink(false)
                
                NavigationLink("", destination: Farepay.NewsView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToBankAccount ).isDetailLink(false)
                
                NavigationLink("", destination: Farepay.MainTabbedView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToMainView ).isDetailLink(false)
                
                NavigationLink("", destination: Farepay.UnderReviewView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToUnderReviewView ).isDetailLink(false)
                
                NavigationLink("", destination: Farepay.AuthenticateFaceIdPswdView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToAuthPswd ).isDetailLink(false)
                
                NavigationLink("", destination: Farepay.RepresentativeView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToForm2 ).isDetailLink(false)
                
                Color(.bgColor)
                    .edgesIgnoringSafeArea(.all)
                HStack(spacing: 20){
                    Image(uiImage: .logo)
                        .resizable()
                        .frame(width: 60, height: 60)
                    Text(verbatim: .appName)
                        .font(.custom(.poppinsBold, size: 45))
//                        .frame(width: 235, height: 50)
                        .foregroundColor(.white)
                }
                
                ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc(.white, lineWidth: 5))
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(.white)
                    .padding(.top, 350)
            }
            .onAppear(){
//                do {
//
//                   try  Auth.auth().signOut()
//
//                } catch  {
//                    print("error")
//                }


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
    
    //MARK: - Functions Also Implement logic of login
    func navigateNext(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showLoadingIndicator.toggle()
            
            print("1", Auth.auth().currentUser, ":2", isAccountCreated, ":3", isBankCreated, ":4", isAccountApproved, ":5", isSessionID, ":6", isIdentityVerified)
            if Auth.auth().currentUser != nil {
                if !(isSessionID == "") && (isAccountCreated == true) && (isBankCreated == true) && (isIdentityVerified == true) {
                    //                    willMoveToMainView = true
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
            }
            
            else{
                willMoveToLogin.toggle()
            }
        }
    }
    
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
    
    func checkUserConnectAccount()  {
//        Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
//            if let error = error {
//                print(error.localizedDescription)
//            }else {
//                
//                guard let snap = snapShot else { return  }
//                isAccountCreated = snap.get("connectAccountCreated") as? Bool ?? false
//                isBankCreated = snap.get("bankAdded") as? Bool ?? false
//                if accountId == "" {
//                    accountId = snap.get("accoundId") as? String ?? ""
//                }
//                print("splash connectAccountCreated: ",isAccountCreated)
//                print("splash bankAdded: ",isBankCreated)
//                print("splash accoundId: ",accountId)
//                navigateNext()
//
//            }
//        }
        
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
                                print("error: ", error?.localizedDescription)
                                
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
