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
    @State private var willMoveToLogin = false
    @State private var willMoveToMainView = false
    @State private var willMoveToCompanyView = false
    @State private var showLoadingIndicator: Bool = true
    @AppStorage("accountId") var accountId: String = ""
    //MARK: - Views
    var body: some View {
        NavigationView {
            ZStack{
                
                NavigationLink("", destination: Farepay.LoginView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToLogin ).isDetailLink(false)
                NavigationLink("", destination: Farepay.CompanyView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToCompanyView ).isDetailLink(false)
                
                NavigationLink("", destination: Farepay.AddNewBankAccountView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToBankAccount ).isDetailLink(false)
                
                NavigationLink("", destination: Farepay.MainTabbedView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToMainView ).isDetailLink(false)
                
                Color(.bgColor)
                    .edgesIgnoringSafeArea(.all)
                HStack{
                    Image(uiImage: .logo)
                        .resizable()
                        .frame(width: 50, height: 50)
                    Text(verbatim: .appName)
                        .font(.custom(.poppinsBold, size: 47))
                        .frame(width: 235, height: 50)
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
    }
    
    //MARK: - Functions Also Implement logic of login
    func navigateNext(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            showLoadingIndicator.toggle()
            
            if Auth.auth().currentUser != nil {
                if isAccountCreated && isBankCreated {
                    
                    willMoveToMainView = true
                }else if isAccountCreated && isBankCreated == false  {
                    willMoveToBankAccount = true
                } else {
                    willMoveToCompanyView = true
                }
            }
            
            else{
                willMoveToLogin.toggle()
            }
        }
    }
    
    func checkUserConnectAccount()  {
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
            if let error = error {
                print(error.localizedDescription)
            }else {
                
                guard let snap = snapShot else { return  }
                isAccountCreated = snap.get("isAccountCreated") as? Bool ?? false
                isBankCreated = snap.get("bankAccced") as? Bool ?? false
                if accountId == "" {
                    accountId = snap.get("accoundId") as? String ?? ""
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
