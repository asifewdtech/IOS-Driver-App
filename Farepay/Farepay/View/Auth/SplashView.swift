//
//  SplashView.swift
//  Farepay
//
//  Created by Arslan on 24/08/2023.
//

import SwiftUI
import NavigationStack

struct SplashView: View {
    
    //MARK: - Variables
    @State private var LoginView: String? = nil
    @State private var willMoveToLogin = false
    @State private var willMoveToMainView = false
    @EnvironmentObject private var navigationStack: NavigationStackCompat
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
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
        }
        .onAppear(){
            navigateNext()
        }
    }
    
    //MARK: - Functions Also Implement logic of login
    func navigateNext(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if isLogin(){
                navigationStack.push(MainTabbedView(), withId: .mainTabView)
            }
            else{
                navigationStack.push(Farepay.LoginView(), withId: .loginView)
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
