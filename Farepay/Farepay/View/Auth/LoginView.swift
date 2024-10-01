//
//  LoginView.swift
//  Farepay
//
//  Created by Arslan on 24/08/2023.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore
import ActivityIndicatorView
import AuthenticationServices
import LocalAuthentication

struct LoginView: View {
    
    //MARK: - Variables
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var isSecure = true
    @StateObject var userAuth =  UserAuthViewModel()
    @State private var toast: Toast? = nil
    @State private var showCompany = false
    @State private var goToHome = false
    @State private var willMoveToBankAccount: Bool = false
    @State private var willMoveToUnderReviewView = false
    @State private var showLoadingIndicator: Bool = false
    @State private var isAccountCreated: Bool = false
    @State private var isBankCreated: Bool = false
    @State private var moveToSignup: Bool = false
    @State var isChecked = false
    @AppStorage("accountId") var appAccountId: String = ""
    
    //MARK: - Views
    var body: some View {
        NavigationView {
            ZStack{
                Color(.bgColor)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    ScrollView(showsIndicators: false){
                        VStack(spacing: 40){
                            topArea
                            textArea
                        }
                        buttonArea
                    }
                }
                .toastView(toast: $toast)
                .padding(.all, 15)
                .environment(\.rootPresentationMode, $userAuth.isAccountCreated)
                
                .onAppear(perform: {
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("SIGNIN"), object: nil, queue: .main) { (_) in
                        
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
//        .environment(\.rootPresentationMode, $moveToSignup)
        .environment(\.rootPresentationMode, $goToHome)
//        .environment(\.rootPresentationMode, $showCompany)
//        .environment(\.rootPresentationMode, $willMoveToBankAccount)
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
                .onAppear(){
                    setMainView(false)
                }
            
            Text("Please enter your detail to login")
                .font(.custom(.poppinsMedium, size: 18))
                .foregroundColor(Color(.darkGrayColor))
            
            HStack(spacing: 15){
                // Google Apple Sign in
                Button(action: {
                    showLoadingIndicator = true
                    userAuth.performAppleSignIn()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 5){
//                        showLoadingIndicator = false
////                        showCompany.toggle()
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
//                    userAuth.signIn()
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
            }
        }
    }
    
    var textArea: some View{
        
        VStack(alignment: .leading, spacing: 20){
            
            Group{
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
                    }
                Text("\(.RememberMe)")
                    .font(.custom(.poppinsMedium, size: 20))
                    .foregroundColor(.white)
            }
        }
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 20){
            
            NavigationLink("", destination: CompanyView().toolbar(.hidden, for: .navigationBar), isActive: $showCompany).isDetailLink(false)
            NavigationLink("", destination: MainTabbedView().toolbar(.hidden, for: .navigationBar), isActive: $goToHome).isDetailLink(false)
            NavigationLink("", destination: Farepay.NewsView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToBankAccount ).isDetailLink(false)
            NavigationLink("", destination: SignUpView().toolbar(.hidden, for: .navigationBar), isActive: $moveToSignup ).isDetailLink(false)
            NavigationLink("", destination: Farepay.UnderReviewView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToUnderReviewView ).isDetailLink(false)
            
            Button(action: {
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
                else if !emailText.isEmpty && passwordText.count >= 6 {
                    Task {
                        showLoadingIndicator = true
                        
                        await userAuth.signIn(email:emailText,password:passwordText,isSignup:false)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showLoadingIndicator = false
                            
                            if userAuth.isLoggedIn == false  {
                                toast = Toast(style: .error, message: userAuth.errorMessage)
//                            }
//                            else if( !Auth.auth().currentUser!.isEmailVerified) {
//                                toast = Toast(style: .error, message: "Please verify your email address.")
                            }else {
//                                let collectionRef = Firestore.firestore().collection("usersInfo")
//                                collectionRef.getDocuments { (snapshot, error) in
                                Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
                                    
                                    if let error = error {
                                        print(error.localizedDescription)
                                        
                                    }else {
                                        guard let snap = snapShot else { return  }
                                        
                                        DispatchQueue.main.async {
                                            print("error: ", error?.localizedDescription)
                                            
                                            let isAccountId = snap.get("accountId") as? String ?? ""
                                            let isAccountCreated = snap.get("connectAccountCreated") as? Bool ?? false
                                            print("login Acc response: ",isAccountCreated)
                                            let bankAccced = snap.get("bankAdded") as? Bool  ?? false
                                            print("login bankAcc response: ",bankAccced)
                                            let isAccountApproved = snap.get("frontimgid") as? String ?? ""
                                            print("login accApproved response: ",isAccountApproved)
                                            let userEmail = snap.get("email") as? String
                                            print("Email is: ", userEmail)
                                            if userEmail == nil {
                                                print("Email not found")
                                                //                                            toast = Toast(style: .error, message: "Something went wrong, Please try again.")
                                            }
                                            if isAccountCreated == false{
                                                
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
                                                            if emailText ==  data["email"] as? String {
                                                                
                                                                DispatchQueue.main.async {
                                                                    print("error: ", error?.localizedDescription)
                                                                    
                                                                    let isAccountCreated1 = data["connectAccountCreated"] as? Bool ?? false
                                                                    print(" Acc response: ",isAccountCreated)
                                                                    let bankAccced1 = data["bankAdded"] as? Bool ?? false
                                                                    print(" bankAcc response: ",bankAccced)
                                                                    let userEmail1 = data["email"] as? String
                                                                    print("Email exist: ", userEmail)
                                                                    
                                                                    appAccountId = isAccountId
                                                                    if isAccountCreated1 && bankAccced1 {
                                                                        goToHome = true
                                                                        
                                                                    }else if isAccountCreated1 == false{
//                                                                        willMoveToBankAccount = true
                                                                        showCompany = true
                                                                    }
                                                                    else if bankAccced1 == false  {
                                                                        willMoveToBankAccount = true
                                                                    }
                                                                    else if (isAccountCreated == true) && (isBankCreated == true) && (isAccountApproved == ""){
                                                                        willMoveToUnderReviewView = true
                                                                    }
                                                                    else {
                                                                        toast = Toast(style: .error, message: "Something went wrong. Please try again.")
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        showCompany = true
                                                    }
                                                }
                                            }
                                            else if bankAccced == false  {
                                                willMoveToBankAccount = true
                                            }
                                            else if (isAccountCreated == true) && (isBankCreated == true) && (isAccountApproved == ""){
                                                willMoveToUnderReviewView = true
                                            }
                                            else if isAccountCreated == true  && bankAccced == true {
                                                goToHome = true
                                            }
                                            else {
                                                print("cannot proceed")
                                                showCompany = true
                                            }
                                            appAccountId = isAccountId
                                        }
                                    }
                                }
                                UserDefaults.standard.set(true, forKey: "isNewUser")
                            }
                        }
                    }
                }else {
                    toast = Toast(style: .error, message: "Please Enter and Password Should be minium 6 character")
                }
            }, label: {
                Text("\(.SignIn)")
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
                
//                NavigationLink(destination: {
//                    Farepay.SignUpView().toolbar(.hidden, for: .navigationBar)
//                }, label: {
//                    Text("\(.SignUp)")
//                        .font(.custom(.poppinsBold, size: 20))
//                        .foregroundColor(Color(.white))
//                        .underline()
//                })
                
                Button(action: {
                    moveToSignup = true
                }, label: {
                    Text("\(.SignUp)")
                        .font(.custom(.poppinsBold, size: 20))
                        .foregroundColor(.white)
                        .underline()
                })
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
//                        showLoadingIndicator = false
                        
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
//                            if isAccountCreated  && isBankCreated == true{
//                                goToHome = true
//                                
//                            }else if isAccountCreated && isBankCreated == false  {
//                                willMoveToBankAccount = true
//                            }
//                            else {
//                                showCompany = true
//                            }
//                            goToHome = true
                        }else {
                            userAuth.checkUserAccountCreated()
                            showCompany = true
                        }
                        showLoadingIndicator = false
                        NotificationCenter.default.post(name: NSNotification.Name("SIGNIN"), object: nil)
                    }
                }
            }
        }
    }
    
    func appleSocialLogin(){
//        showLoadingIndicator = true
//        showCompany = true
        let existEmail = Auth.auth().currentUser?.email ?? ""
        if existEmail != ""{
            
            if isAccountCreated  && isBankCreated {
                showLoadingIndicator = false
                toast = Toast(style: .success, message: "Apple SignIn Successfully.")
                goToHome = true
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
    
    func authenticateAppPswd (){
        var context = LAContext()
        
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        context.localizedCancelTitle = "Enter Username/Password"
        // First check if we have the needed hardware support.
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
            
            // Fall back to a asking for username and password.
            // ...
            return
        }
        Task {
            do {
                try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Log in to your account")
//                state = .loggedin
                moveToSignup = true
            } catch let error {
                print(error.localizedDescription)
                
            }
        }
    }
}


//MARK: - Drop Down
struct DropdownOption: Hashable {
    let key: String
    let value: String

    public static func == (lhs: DropdownOption, rhs: DropdownOption) -> Bool {
        return lhs.key == rhs.key
    }
}

struct DropdownRow: View {
    var option: DropdownOption
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?

    var body: some View {
        Button(action: {
            if let onOptionSelected = self.onOptionSelected {
                onOptionSelected(self.option)
            }
        }) {
            HStack {
                Text(self.option.value)
                    .font(.system(size: 16))
                    .foregroundColor(Color.white)
                Spacer()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
}

struct Dropdown: View {
    var options: [DropdownOption]
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(self.options, id: \.self) { option in
                    DropdownRow(option: option, onOptionSelected: self.onOptionSelected)
                }
            }
        }
        .frame(minHeight: CGFloat(options.count) * 30, maxHeight: 250)
        .padding(.vertical, 5)
        .background(Color(.bgColor))
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}

struct DropdownSelector: View {
    @State private var shouldShowDropdown = false
    @State private var selectedOption: DropdownOption? = nil
    var placeholder: String
    var leftImage :UIImage
    var options: [DropdownOption]
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?
    private let buttonHeight: CGFloat = 60

    var body: some View {
        ZStack(alignment:.top) {
            VStack {
                if self.shouldShowDropdown {
                    Spacer(minLength: buttonHeight + 10)
                    Dropdown(options: self.options, onOptionSelected: { option in
                        shouldShowDropdown = false
                        selectedOption = option
                        self.onOptionSelected?(option)
                    })
                }
            }
            
            Button(action: {
                withAnimation {
                    self.shouldShowDropdown.toggle()
                }
            }) 
            {
                HStack {
                    Image(uiImage: .ic_Company)
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Text(selectedOption == nil ? placeholder : selectedOption!.value)
                        .font(.system(size: 14))
                        .foregroundColor(Color.white)
                    Spacer()
                    
                    Image(systemName: self.shouldShowDropdown ? "arrowtriangle.up.fill" : "arrowtriangle.down.fill")
                        .resizable()
                        .frame(width: 9, height: 5)
                        .font(Font.system(size: 9, weight: .medium))
                        .foregroundColor(Color.white)
                }
            }
            .padding(.horizontal)
            .cornerRadius(5)
            .frame( height: self.buttonHeight)
            .frame(maxWidth:.infinity)
        }
    }
}

//struct DropdownSelector_Previews: PreviewProvider {
//    @State private static var address: String = ""
//
//    static var uniqueKey: String {
//        UUID().uuidString
//    }
//
//    static let options: [DropdownOption] = [
//        DropdownOption(key: uniqueKey, value: "Sunday"),
//        DropdownOption(key: uniqueKey, value: "Monday"),
//        DropdownOption(key: uniqueKey, value: "Tuesday"),
//        DropdownOption(key: uniqueKey, value: "Wednesday"),
//        DropdownOption(key: uniqueKey, value: "Thursday"),
//        DropdownOption(key: uniqueKey, value: "Friday"),
//        DropdownOption(key: uniqueKey, value: "Saturday")
//    ]
//    static var previews: some View {
//        
//        VStack(spacing: 20) {
//            DropdownSelector(
//                placeholder: "Day of the week",
//                options: options,
//                onOptionSelected: { option in
//                    print(option)
//            })
//            .padding(.horizontal)
//            .zIndex(1)
//        }
//    }
//}

let businessType: [DropdownOption] = [
        DropdownOption(key: UUID().uuidString, value: "Individual"),
        DropdownOption(key: UUID().uuidString, value: "Business")
    ]

let provinceType: [DropdownOption] = [
        DropdownOption(key: UUID().uuidString, value: "Queensland"),
        DropdownOption(key: UUID().uuidString, value: "Tasmania"),
        DropdownOption(key: UUID().uuidString, value: "New South Wales"),
        DropdownOption(key: UUID().uuidString, value: "Victoria"),
        DropdownOption(key: UUID().uuidString, value: "Westren Australia"),
        DropdownOption(key: UUID().uuidString, value: "South Australia")
    ]
