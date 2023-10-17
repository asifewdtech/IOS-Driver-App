//
//  LoginView.swift
//  Farepay
//
//  Created by Arslan on 24/08/2023.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth
struct LoginView: View {
    
    //MARK: - Variables
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    @State private var isSecure = true
    @StateObject var userAuth =  UserAuthViewModel()
    @State private var toast: Toast? = nil
    @State private var showCompany = false
    
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
                    }
                }
                buttonArea
            }
            
            .toastView(toast: $toast)
            .padding(.all, 15)
            .onAppear(perform: {
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("SIGNIN"), object: nil, queue: .main) { (_) in
                    
                    
                    if userAuth.isLoggedIn == false  {
                        toast = Toast(style: .error, message: userAuth.errorMessage)
                    }else {
                        showCompany.toggle()
                    }
                        
                }
            })
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
                .onAppear(){
                    setMainView(false)
                }
            
            Text("Please enter your detail to login")
                .font(.custom(.poppinsMedium, size: 18))
                .foregroundColor(Color(.darkGrayColor))
            
            HStack(spacing: 15){
                // Google Apple Sign in
                Button(action: {
                    userAuth.performAppleSignIn()
                
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
                    userAuth.signIn()
                  
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
            .frame(maxWidth: .infinity)
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
            
            NavigationLink("", destination: CompanyView().toolbar(.hidden, for: .navigationBar), isActive: $showCompany).isDetailLink(false)
            
            Button(action: {
                if !emailText.isEmpty && passwordText.count >= 6 {
                    Task {
                        await userAuth.signIn(email:emailText,password:passwordText,isSignup:false)
                        if userAuth.isLoggedIn == false  {
                            toast = Toast(style: .error, message: userAuth.errorMessage)
                        }else {
                            showCompany.toggle()
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
                
                NavigationLink(destination: {
                    Farepay.SignUpView().toolbar(.hidden, for: .navigationBar)
                }, label: {
                    Text("\(.SignUp)")
                        .font(.custom(.poppinsBold, size: 20))
                        .foregroundColor(Color(.white))
                        .underline()
                })
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
                    .font(.system(size: 14))
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
//            .padding(
//                // Check if options list is open or not
//                .bottom, self.shouldShowDropdown
//                // If options list is open, then check if options size is greater
//                // than 300 (MAX HEIGHT - CONSTANT), or not
//                ? CGFloat(self.options.count * 15) > 100
//                // IF true, then set padding to max height 300 points
//                ? 50 + 30 // max height + more padding to set space between borders and text
//                // IF false, then calculate options size and set padding
//                : CGFloat(self.options.count * 15) + 30
//                // If option list is closed, then don't set any padding.
//                : 0
//            )
            
            
            Button(action: {
                withAnimation {
                    self.shouldShowDropdown.toggle()
                }
                
            }) {
                HStack {
                    
                    Image(uiImage: .ic_Company)
                        .resizable()
                        .frame(width: 30, height: 30)
                    
                    Text(selectedOption == nil ? placeholder : selectedOption!.value)
                        .font(.system(size: 14))
                        .foregroundColor(Color.gray)
                    
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
//        .background(
////            RoundedRectangle(cornerRadius: 5).fill(Color(.clear))
//        )
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
        DropdownOption(key: UUID().uuidString, value: "individual"),
        DropdownOption(key: UUID().uuidString, value: "Business")
    ]
