//
//  LoginView.swift
//  Farepay
//
//  Created by Arslan on 24/08/2023.
//

import SwiftUI

struct LoginView: View {
    
    //MARK: - Variables
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var isSecure = true
    @State var willMoveToCompanyView: Bool = false
    @State var willMoveToSignUp: Bool = false
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            
            NavigationLink("", destination: Farepay.SignUpView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToSignUp).isDetailLink(false)
            NavigationLink("", destination: Farepay.CompanyView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToCompanyView).isDetailLink(false)
            
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 40){
                topArea
                ScrollView(.vertical, showsIndicators: false){
                        textArea
                }
                buttonArea
            }
            .padding(.all, 15)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

extension LoginView{
    
    var topArea: some View{
        
        VStack(spacing: 25){
            
            Image(uiImage: .logo)
                .resizable()
                .frame(width: 52, height: 52)
            
            Text("\(.SignIn)")
                .font(.custom(.poppinsBold, size: 20))
                .foregroundColor(.white)
            
            Text("Please enter your detail to login")
                .font(.custom(.poppinsMedium, size: 18))
                .foregroundColor(Color(.darkGrayColor))
            
            HStack(spacing: 15){
                
                ZStack{
                    
                    Image(uiImage: .AppleLogo)
                        .resizable()
                        .frame(width: 35, height: 35)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color(.darkBlueColor))
                .cornerRadius(10)
                
                ZStack{
                    
                    Image(uiImage: .GoogleLogo)
                        .resizable()
                        .frame(width: 35, height: 35)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 55)
                .background(Color(.darkBlueColor))
                .cornerRadius(10)
            }
        }
    }
    
    var textArea: some View{
        
        VStack(alignment: .leading, spacing: 20){
            
            Group{
                
                ZStack{
                    
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Email)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        TextField("", text: $emailText, prompt: Text("\(.emailPlaceHolder)").foregroundColor(Color(.darkGrayColor)))
                            .font(.custom(.poppinsMedium, size: 18))
                            .frame(height: 30)
                            .foregroundColor(.white)
                        
                    }
                    .padding([.leading, .trailing], 20)
                }
                
                ZStack{
                    
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Password)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        if isSecure {
                            SecureField("", text: $passwordText, prompt: Text("\(.passwordPlaceHolder)").foregroundColor(Color(.darkGrayColor)))
                                .font(.custom(.poppinsMedium, size: 18))
                                .frame(height: 30)
                                .foregroundColor(.white)
                        }
                        else {
                            
                            TextField("", text: $passwordText, prompt: Text("\(.passwordPlaceHolder)").foregroundColor(Color(.darkGrayColor)))
                                .font(.custom(.poppinsMedium, size: 18))
                                .frame(height: 30)
                                .foregroundColor(.white)
                        }
                        
                        Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.white)
                            .onTapGesture {
                                isSecure.toggle()
                                print("Hahahahzcsacds")
                            }
                        
                    }
                    .padding([.leading, .trailing], 20)
                }
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(.darkBlueColor))
            .cornerRadius(10)
            
            HStack(spacing: 10){
                
                Image(uiImage: .ic_Box)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        
                        print("Remember Me")
                    }
                Text("\(.RememberMe)")
                    .font(.custom(.poppinsMedium, size: 20))
                    .foregroundColor(.white)
            }
            
        }
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 20){
                        
            Text("\(.SignIn)")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(.buttonColor))
                .cornerRadius(30)
                .onTapGesture {
                    willMoveToCompanyView.toggle()
                }
            HStack{
                
                Text("\(.dontHaveAccount)")
                    .font(.custom(.poppinsMedium, size: 18))
                    .foregroundColor(Color(.darkGrayColor))
                
                Text("\(.SignUp)")
                    .font(.custom(.poppinsBold, size: 20))
                    .foregroundColor(Color(.white))
                    .underline()
                    .onTapGesture {
                        willMoveToSignUp.toggle()
                    }
            }
        }
    }
}
