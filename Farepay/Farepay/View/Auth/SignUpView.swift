//
//  SignUpView.swift
//  Farepay
//
//  Created by Arslan on 25/08/2023.
//

import SwiftUI
import ActivityIndicatorView

struct SignUpView: View {
    
    //MARK: - Variables
    @State private var nameText: String = ""
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var ReTypePasswordText: String = ""
    @State private var isSecure = true
    @State private var isSecureReType = true
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var toast: Toast? = nil
    @State private var showCompany = false
    @State private var goToLogin = false
    @State private var isChecked = false
    @StateObject var userAuth =  UserAuthViewModel()
    @AppStorage("username") var username: String = ""
    @State private var showLoadingIndicator: Bool = false
    
    //MARK: - Views
    var body: some View {
        
        ZStack{

            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            VStack{
                ScrollView(showsIndicators: false){
                    VStack(spacing: 40){
                        topArea
                        textArea
                        buttonArea
                    }
                }
            }
            
            .toastView(toast: $toast)
            .padding(.all, 15)
            
            ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc(.white, lineWidth: 5))
                .frame(width: 50.0, height: 50.0)
                .foregroundColor(.white)
                .padding(.top, 350)
            
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
        
        VStack(spacing: 20){
            
            Image(uiImage: .logo)
                .resizable()
                .frame(width: 52, height: 52)
            
            Text("\(.SignUp)")
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
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Email), text: $nameText, placHolderText: .constant("Type your username (optional)"), isSecure: .constant(false))
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Email), text: $emailText, placHolderText: .constant("Enter your Email Address"), isSecure: .constant(false))
                Group{
                    if isSecure{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $passwordText, placHolderText: .constant("Type your password"), isSecure: .constant(true))
                    }
                    else{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $passwordText, placHolderText: .constant("Type your password"), isSecure: .constant(false))
                    }
                }
                .overlay{
                    Text("    ")
                        .frame(width: 50, height: 50)
                        .padding(.leading, UIScreen.main.bounds.width - 90)
                        .onTapGesture {
                            isSecure.toggle()
                        }
                }
            }
                Text("Password must have more than 6 characters, contain one digit, one uppercase letter and a special character.")
                    .font(.custom(.poppinsMedium, size: 12))
                    .foregroundColor(Color(.darkGrayColor))
                    
            Group {
                Group{
                    if isSecureReType{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $ReTypePasswordText, placHolderText: .constant("Re-Type your password"), isSecure: .constant(true))
                    }
                    else{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $ReTypePasswordText, placHolderText: .constant("Re-Type your password"), isSecure: .constant(false))
                    }
                }
                .overlay{
                    Text("    ")
                        .frame(width: 50, height: 50)
                        .padding(.leading, UIScreen.main.bounds.width - 90)
                        .onTapGesture {
                            isSecureReType.toggle()
                        }
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color(.darkBlueColor))
            .cornerRadius(10)
            
            HStack(spacing: 10){
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
                    .onTapGesture {
                        isChecked.toggle()
                        print("Agree")
                    }
                Text("I agree with terms and privacy")
                    .font(.custom(.poppinsMedium, size: 18))
                    .foregroundColor(.white)
            }
        }
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 20){
            
            NavigationLink("", destination: LoginView().toolbar(.hidden, for: .navigationBar), isActive: $goToLogin).isDetailLink(false)
            Button(action: {
                username = nameText
                callFirebaseRegisterAuth()
                
                
            }, label: {
                Text("\(.SignUp)")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(.buttonColor))
                    .cornerRadius(30)
            })
            
            
            HStack{
                
                Text("\(.dontHaveAccount)")
                    .font(.custom(.poppinsMedium, size: 18))
                    .foregroundColor(Color(.darkGrayColor))
                
                Text("\(.SignIn)")
                    .font(.custom(.poppinsBold, size: 20))
                    .foregroundColor(Color(.white))
                    .underline()
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            }
                
        }
    }

    // Create User on Firebase
    func callFirebaseRegisterAuth()  {
        if emailText.isEmpty {
            toast = Toast(style: .error, message: "Email field cannot be empty.")
        }
        else if !emailText.isValidEmail(emailText) {
            toast = Toast(style: .error, message: "Please Enter Valid Email")
        } 
        else if passwordText.isEmpty {
            toast = Toast(style: .error, message: "Password field cannot be empty.")
        }
        else if !passwordText.isValidPassword(passwordText) {
            toast = Toast(style: .error, message: "Password must have more than 6 characters, contain one digit, one uppercase letter and a special character.")
        }
        else if ReTypePasswordText.isEmpty {
            toast = Toast(style: .error, message: "Re-Password field cannot be empty.")
        }else {
            if passwordText != ReTypePasswordText {
                toast = Toast(style: .error, message: "Both Password Should be matched.")
            }else if isChecked {
                
                Task {
                    showLoadingIndicator = true
                    
                    await userAuth.signIn(email:emailText,password:passwordText,isSignup:true)
                    showLoadingIndicator = false
                    
                    if userAuth.isLoggedIn == false  {
                        toast = Toast(style: .error, message: userAuth.errorMessage)
                    }else {
//                        showCompany.toggle()
                          
                        goToLogin.toggle()
                    }
                }
            }else {
                showLoadingIndicator = false
                toast = Toast(style: .error, message: "Accept the Term and Privacy")
            }
                
        }
        

    }
}

//var userName = ""
