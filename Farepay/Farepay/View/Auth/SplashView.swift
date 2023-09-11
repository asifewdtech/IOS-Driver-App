//
//  SplashView.swift
//  Farepay
//
//  Created by Arslan on 24/08/2023.
//

import SwiftUI

struct SplashView: View {
    
    //MARK: - Variables
    @State private var LoginView: String? = nil
    @State private var willMoveToLogin = false
    @State private var willMoveToMainView = false
    
    //MARK: - Views
    var body: some View {
        NavigationView {
            ZStack{
                
                NavigationLink("", destination: Farepay.LoginView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToLogin ).isDetailLink(false)
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
            }
            .onAppear(){
                navigateNext()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .environment(\.rootPresentationMode, $willMoveToLogin)
        .environment(\.rootPresentationMode, $willMoveToMainView)
    }
    
    //MARK: - Functions Also Implement logic of login
    func navigateNext(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if isLogin(){
                
                willMoveToMainView.toggle()
            }
            else{
                willMoveToLogin.toggle()
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
