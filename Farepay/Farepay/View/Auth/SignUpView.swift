//
//  SignUpView.swift
//  Farepay
//
//  Created by Arslan on 25/08/2023.
//

import SwiftUI

struct SignUpView: View {
    
    //MARK: - Variables
    @State private var nameText: String = ""
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var ReTypePasswordText: String = ""
    @State private var isSecure = true
    @State private var isSecureReType = true
    @Environment(\.presentationMode) var presentationMode
    
    //MARK: - Views
    var body: some View {
        
        ZStack{

            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false){
                VStack{
                    topArea
                    Spacer(minLength: 50)
                    textArea
                    Spacer(minLength: 50)
                    buttonArea
                    Spacer(minLength: 20)
                }
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
            .ignoresSafeArea(.keyboard)
    }
}

extension SignUpView{
    
    var topArea: some View{
        
        VStack(spacing: 25){
            
            Image(uiImage: .logo)
                .resizable()
                .frame(width: 52, height: 52)
            
            Text("\(.SignUp)")
                .font(.custom(.poppinsBold, size: 20))
                .foregroundColor(.white)
            
            Text("Please enter your detail to login")
                .font(.custom(.poppinsMedium, size: 18))
                .foregroundColor(Color(.darkBrownColor))
            
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
            .padding(.horizontal, 15)
        }
    }
    
    var textArea: some View{
        
        VStack(alignment: .leading, spacing: 25){
            
            Group{
                
                ZStack{
                    
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Email)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        TextField("", text: $nameText, prompt: Text("\(.namePlaceHolder)").foregroundColor(Color(.darkBrownColor)))
                            .font(.custom(.poppinsMedium, size: 18))
                            .frame(height: 30)
                            .foregroundColor(.white)
                            
                    }
                    .padding([.leading, .trailing], 20)
                }
                
                ZStack{
                    
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Email)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        TextField("", text: $emailText, prompt: Text("\(.emailPlaceHolder)").foregroundColor(Color(.darkBrownColor)))
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
                            SecureField("", text: $passwordText, prompt: Text("\(.passwordPlaceHolder)").foregroundColor(Color(.darkBrownColor)))
                                .font(.custom(.poppinsMedium, size: 18))
                                .frame(height: 30)
                                .foregroundColor(.white)
                        }
                        else {
                            
                            TextField("", text: $passwordText, prompt: Text("\(.passwordPlaceHolder)").foregroundColor(Color(.darkBrownColor)))
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
                
                ZStack{
                    
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Password)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        if isSecureReType {
                            SecureField("", text: $ReTypePasswordText, prompt: Text("\(.reTypePasswordPlaceHolder)").foregroundColor(Color(.darkBrownColor)))
                                .font(.custom(.poppinsMedium, size: 18))
                                .frame(height: 30)
                                .foregroundColor(.white)
                        }
                        else {
                            
                            TextField("", text: $ReTypePasswordText, prompt: Text("\(.reTypePasswordPlaceHolder)").foregroundColor(Color(.darkBrownColor)))
                                .font(.custom(.poppinsMedium, size: 18))
                                .frame(height: 30)
                                .foregroundColor(.white)
                        }
                        
                        Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.white)
                            .onTapGesture {
                                isSecureReType.toggle()
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
                        
                        print("Agree")
                    }
                
                HStack {
                    
                    Text("I agree with")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(.white)
                    Text("terms")
                        .font(.custom(.poppinsBold, size: 20))
                        .foregroundColor(.white)
                        .underline()
                   Text("and")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(.white)
                    Text("privacy")
                         .font(.custom(.poppinsBold, size: 20))
                         .foregroundColor(.white)
                         .underline()
                }
            }
            
        }
        .padding(.horizontal, 15)
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 25){
            
            Text("\(.SignUp)")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(.buttonColor))
                .cornerRadius(30)
            
            HStack{
                
                Text("\(.dontHaveAccount)")
                    .font(.custom(.poppinsMedium, size: 18))
                    .foregroundColor(Color(.darkBrownColor))
                Text("\(.SignIn)")
                    .font(.custom(.poppinsBold, size: 20))
                    .foregroundColor(Color(.white))
                    .underline()
                    .onTapGesture {
                        
                        presentationMode.wrappedValue.dismiss()
                    }
            }
                
        }
        .padding(.horizontal, 15)
    }
}