//
//  SplashView.swift
//  Farepay
//
//  Created by Arslan on 24/08/2023.
//

import SwiftUI

struct SplashView: View {
    
    @State private var LoginView: String? = nil
    @State private var willMoveToNextScreen = false
    
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
        .navigationDestination(isPresented: $willMoveToNextScreen) {
            
            Farepay.LoginView().toolbar(.hidden, for: .navigationBar)
        }
        
    }
    
    func navigateNext(){
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            willMoveToNextScreen.toggle()
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
