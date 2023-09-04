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
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            
            HStack{

                PushView(destination: Farepay.LoginView(presentSideMenu: .constant(false)), isActive: $willMoveToLogin) {
                    Text("")
                }
                PushView(destination: Farepay.MainTabbedView(), isActive: $willMoveToMainView) {
                    Text("")
                }
                
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
            
            let isUserLogin = UserDefaults.standard.value(forKey: .isUserLogin) as? Bool ?? false
            if isUserLogin{
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
