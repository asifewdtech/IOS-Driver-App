//
//  SignUpView.swift
//  Farepay
//
//  Created by Arslan on 25/08/2023.
//

import SwiftUI
import ActivityIndicatorView
import AuthenticationServices
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore

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
    @Environment(\.openURL) var openURL
    @State private var willMoveToBankAccount: Bool = false
    @State private var isAccountCreated: Bool = false
    @State private var isBankCreated: Bool = false
    @State private var goToHome = false
    @State private var showEmailVerifiAlert = false
    
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
            
                .onAppear(perform: {
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("SIGNUP"), object: nil, queue: .main) { (_) in
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if userAuth.isLoggedIn == false  {
    //                            toast = Toast(style: .error, message: userAuth.errorMessage)
                                print("error")
                            }else {
                                Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
                                    if let error = error {
                                        print(error.localizedDescription)
                                        
                                    }else {
                                        
                                        guard let snap = snapShot else { return  }
                                        
                                        DispatchQueue.main.async {
                                            isAccountCreated = snap.get("connectAccountCreated") as? Bool ?? false
                                            isBankCreated = snap.get("bankAdded") as? Bool ?? false
                                            if isAccountCreated  && isBankCreated {
                                                goToHome = true
                                                
                                            }else if isAccountCreated && isBankCreated == false  {
                                                willMoveToBankAccount = true
                                            }
                                            else {
                                                showCompany = true
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                })
                .alert(
                    "Sign up successful",
                    isPresented: $showEmailVerifiAlert
                ) {
                    Button("Continue") {
                        presentationMode.wrappedValue.dismiss()
                    }
                } message: {
                    Text("Thank you for signing up to Farepay. We have sent you an email verification. Please check your email and follow the instructions to continue.")
                }
            if showLoadingIndicator{
                VStack{
                    ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc(.white, lineWidth: 5))
                        .frame(width: 50.0, height: 50.0)
                        .foregroundColor(.white)
                        .padding(.top, 350)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
                .edgesIgnoringSafeArea(.all)
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
        
        VStack(spacing: 20){
            
            Image(uiImage: .logo)
                .resizable()
                .frame(width: 52, height: 52)
            
            Text("\(.SignUp)")
                .font(.custom(.poppinsBold, size: 20))
                .foregroundColor(.white)
            
            Text("Please enter your detail to sign up")
                .font(.custom(.poppinsMedium, size: 18))
                .foregroundColor(Color(.darkGrayColor))
            
/*            HStack(spacing: 15){
                // Google Apple Sign in
                Button(action: {
                    userAuth.isGoogleLogin = false
                    showLoadingIndicator = true
                    userAuth.performAppleSignIn()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 15){
//                        showLoadingIndicator = false
//                        if userAuth.isGoogleLogin == true{
//                            showCompany.toggle()
//                        }
//                    }
                }, label: {
                    ZStack{
                        
                        Image(uiImage: .AppleLogo)
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color(.darkBlueColor))
                    .cornerRadius(10)
                })
                
                // Google Sign In
                Button(action: {
                    googleSignIn()
                    
                }, label: {
                    ZStack{
                        
                        Image(uiImage: .GoogleLogo)
                            .resizable()
                            .frame(width: 35, height: 35)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color(.darkBlueColor))
                    .cornerRadius(10)
                })
            }*/
        }
    }
    
    var textArea: some View{
        
        VStack(alignment: .leading, spacing: 20){
            
            Group{
//                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Email), text: $nameText, placHolderText: .constant("Type your username (optional)"), isSecure: .constant(false))
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Email), text: $emailText, placHolderText: .constant("Enter your Email Address"), isSecure: .constant(false))
                    .keyboardType(.emailAddress)
                Group{
                    if isSecure{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $passwordText, placHolderText: .constant("Type your password"), isSecure: .constant(true))
                    }
                    else{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $passwordText, placHolderText: .constant("Type your password"), isSecure: .constant(false))
                    }
                }
                .overlay{
                    Text("        ")
                        .frame(width: 70, height: 70)
                        .padding(.leading, UIScreen.main.bounds.width - 100)
                        .onTapGesture {
                            isSecure.toggle()
                        }
                }
            }
                Text("Password must have more than 6 characters, contain one digit and a special character.")
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
                    Text("        ")
                        .frame(width: 70, height: 70)
                        .padding(.leading, UIScreen.main.bounds.width - 100)
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
                HStack {
                            Button(action: {
                                if let url = URL(string: "https://farepay.app/terms-of-use") {
                                    UIApplication.shared.open(url)
                                }
                            }) {
                                Text("I agree with Farepay’s Terms of Use and Privacy Policy")
                                    .font(.custom("Poppins-Bold", size: 16))
                                    .foregroundColor(.white)
                                    .underline()
                                    .multilineTextAlignment(.leading) // Aligns text to leading
                                    .frame(maxWidth: .infinity, alignment: .leading) // Expands and aligns text
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                
//                HStack(spacing: 4) {
//                    Text("I agree with")
//                        .font(.custom(.poppinsMedium, size: 18))
//                        .foregroundColor(.white)
//                    Button(action: {
////                        Link("Farepay", destination: URL(string: "https://farepay.app/terms-of-use")!)
//                        openURL(URL(string: "https://farepay.app/terms-of-use")!)
//                    }, label: {
//                        Text("\("terms")")
//                            .font(.custom(.poppinsBold, size: 18))
//                            .foregroundColor(.white)
//                            .underline()
//                    })
//                    Text("and")
//                        .font(.custom(.poppinsMedium, size: 18))
//                        .foregroundColor(.white)
//                    
//                    Button(action: {
////                        Link("Farepay", destination: URL(string: "https://farepay.app/privacy")!)
//                        openURL(URL(string: "https://farepay.app/privacy")!)
//                    }, label: {
//                        Text("\("privacy.")")
//                            .font(.custom(.poppinsBold, size: 18))
//                            .foregroundColor(.white)
//                            .underline()
//                    })
//                }
            }
        }
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 20){
            
            NavigationLink("", destination: LoginView().toolbar(.hidden, for: .navigationBar), isActive: $goToLogin).isDetailLink(false)
            
            NavigationLink("", destination: CompanyView().toolbar(.hidden, for: .navigationBar), isActive: $showCompany).isDetailLink(false)
            
            NavigationLink("", destination: MainTabbedView().toolbar(.hidden, for: .navigationBar), isActive: $goToHome).isDetailLink(false)
            
            NavigationLink("", destination: Farepay.NewsView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToBankAccount ).isDetailLink(false)
            
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
                
                Text("\(.alreadyHaveAccount)")
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
            toast = Toast(style: .error, message: "Password must have more than 6 characters, contain one digit and a special character.")
        }
        else if ReTypePasswordText.isEmpty {
            toast = Toast(style: .error, message: "Re-Password field cannot be empty.")
        }else {
            if passwordText != ReTypePasswordText {
                toast = Toast(style: .error, message: "Both passwords must match")
            }else if isChecked {
                
                Task {
                    showLoadingIndicator = true
                    
                    await userAuth.signIn(email:emailText,password:passwordText,isSignup:true)
                    showLoadingIndicator = false
                    
                    if userAuth.isLoggedIn == false  {
                        toast = Toast(style: .error, message: userAuth.errorMessage)
                    }else {
//                        showCompany.toggle()
//                        goToLogin.toggle()
//                        toast = Toast(style: .success, message: "Registration Successfully.")
//                        presentationMode.wrappedValue.dismiss()
                        showEmailVerifiAlert  = true
                    }
                }
            }else {
                showLoadingIndicator = false
                toast = Toast(style: .error, message: "To sign up, you must accept Farepay’s Terms of Use")
            }
        }
    }
    
    func googleSignIn(){
        showLoadingIndicator = true
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { result, error in
            if let error = error {
                showLoadingIndicator = false
//                self.errorMessage = "error: \(error.localizedDescription)"
                toast = Toast(style: .error, message: error.localizedDescription)
            }
            else {
                guard let auth = result?.user else { return }
                
                let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken?.tokenString ?? "", accessToken: auth.accessToken.tokenString)
                print("Google credentials: ",credentials)
                Auth.auth().signIn(with: credentials) { result, error in
                    if let error = error {
                        showLoadingIndicator = false
                        print("error\(error)")
//                        self.errorMessage = "error: \(error.localizedDescription)"
                        toast = Toast(style: .error, message: error.localizedDescription)
                    }else {
                        showLoadingIndicator = false
                        
                        print("isAccountCreated: ",isAccountCreated)
                        print("isBankCreated: ",isBankCreated)
                        let isEmail = GIDSignIn.sharedInstance.currentUser?.profile?.email
                        let exisEmail = Auth.auth().currentUser?.email ?? ""
                        if isEmail == exisEmail{
                            Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
                                if let error = error {
                                    print(error.localizedDescription)
                                    
                                }else {
                                    guard let snap = snapShot else { return  }
                                    
                                    DispatchQueue.main.async {
                                        isAccountCreated = snap.get("connectAccountCreated") as? Bool ?? false
                                        isBankCreated = snap.get("bankAdded") as? Bool ?? false
                                        if isAccountCreated  && isBankCreated {
                                            toast = Toast(style: .success, message: "Google SignIn Successfully.")
                                            goToHome = true
                                            
                                        }else if isAccountCreated && isBankCreated == false  {
                                            willMoveToBankAccount = true
                                        }
                                        else {
                                            showCompany = true
                                        }
                                    }
                                }
                            }
                        }else {
                            userAuth.checkUserAccountCreated()
                            showCompany = true
                        }
                        
                        NotificationCenter.default.post(name: NSNotification.Name("SIGNUP"), object: nil)
                    }
                }
            }
        }
    }
    
    func appleSocialSignup(){
        showLoadingIndicator = true
//        showCompany = true
        let existEmail = Auth.auth().currentUser?.email ?? ""
        print("existEmail: ",existEmail)
        if existEmail != ""{
            
            if isAccountCreated  && isBankCreated {
                showLoadingIndicator = false
                goToHome = true
                toast = Toast(style: .success, message: "Apple SignIn Successfully.")
            }else if isAccountCreated && isBankCreated == false  {
                showLoadingIndicator = false
                willMoveToBankAccount = true
            }
            else {
                showLoadingIndicator = false
                showCompany = true
            }
        }else {
            userAuth.checkUserAccountCreated()
            showCompany = true
        }
    }
}
