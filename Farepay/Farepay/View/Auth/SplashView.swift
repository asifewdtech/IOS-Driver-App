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
    @State private var willMoveToLogin = false
    @State private var willMoveToMainView = false
    @State private var willMoveToCompanyView = false
    @State private var showLoadingIndicator: Bool = true
    @AppStorage("accountId") var accountId: String = ""
    
    @State private var willMoveToUnderReviewView = false
    //MARK: - Views
    var body: some View {
        NavigationView {
            ZStack{
                
                NavigationLink("", destination: Farepay.LoginView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToLogin ).isDetailLink(false)
                NavigationLink("", destination: Farepay.CompanyView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToCompanyView ).isDetailLink(false)
                
                NavigationLink("", destination: Farepay.NewsView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToBankAccount ).isDetailLink(false)
                
                NavigationLink("", destination: Farepay.MainTabbedView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToMainView ).isDetailLink(false)
                
                NavigationLink("", destination: Farepay.UnderReviewView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToUnderReviewView ).isDetailLink(false)
                
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
//            let stripeFrontImgId = UserDefaults.standard.string(forKey: "stripeFrontImgId")
//            print("stripeFrontImgId: ",stripeFrontImgId)
//            if stripeFrontImgId != nil{
//                UpdateVerificationDocs(accId: "", frontimgid: "")
//            }else {
//                print("stripeFrontImgId not found")
//                willMoveToUnderReviewView.toggle()
//            }
            
            
            print("1", Auth.auth().currentUser, ":2", isAccountCreated, ":3", isBankCreated)
            if Auth.auth().currentUser != nil {
                if isAccountCreated && isBankCreated && (isAccountApproved != ""){
//                    willMoveToLogin.toggle()
                    willMoveToMainView = true
//                    willMoveToUnderReviewView.toggle()
                }
                else if isAccountCreated == true && isBankCreated == false  {
                    willMoveToBankAccount = true
                }
                else if (isAccountCreated == true) && (isBankCreated == true) && (isAccountApproved == ""){
                    willMoveToUnderReviewView = true
                }
                else {
//                    willMoveToCompanyView = true
                    willMoveToLogin.toggle()
//                    willMoveToUnderReviewView.toggle()
                }
            }
            
            else{
                willMoveToLogin.toggle()
//                willMoveToUnderReviewView.toggle()
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
                    if emailText ==  data["email"] as? String {
                        
                        DispatchQueue.main.async {
                            print("error: ", error?.localizedDescription)
                            //
                            isAccountCreated = data["connectAccountCreated"] as? Bool ?? false
                            //                            print("login Acc response: ",isAccountCreated)
                            isBankCreated = data["bankAdded"] as? Bool ?? false
                            //                            print("login bankAcc response: ",isBankCreated)
                            isAccountApproved = data["frontimgid"] as? String ?? ""
                            let userEmail1 = data["email"] as? String
                            //                            print("Email is: ", userEmail1)
                            if accountId == "" {
                                accountId = data["accoundId"] as? String ?? ""
                            }
                            navigateNext()
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
