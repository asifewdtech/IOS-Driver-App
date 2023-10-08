//
//  ChangePasswordView.swift
//  Farepay
//
//  Created by Arslan on 20/09/2023.
//

import SwiftUI

struct ChangePasswordView: View {
    
    //MARK: - Variables
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var oldPasswordText: String = ""
    @State private var isSecureOldPassword: Bool = true
    @State private var newPasswordText: String = ""
    @State private var isSecureNewPassword: Bool = true
    @State private var reTypePasswordText: String = ""
    @State private var isSecureReTypePassword: Bool = true
    
    //MARK: - Views
    var body: some View {
        ZStack{
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack(spacing: 40) {
                topArea
                textArea
                Spacer()
                buttonArea
            }
            .padding(.all, 15)
        }
    }
}

struct ChangePasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordView()
    }
}

extension ChangePasswordView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            Image(uiImage: .backArrow)
                .resizable()
                .frame(width: 35, height: 30)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("Change Password")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
        }
    }
    
    var textArea: some View{
        
        VStack(alignment: .leading, spacing: 20){
            
            Group{
                Group{
                    if isSecureOldPassword{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $oldPasswordText, placHolderText: .constant("Type your old password"), isSecure: .constant(true))
                    }
                    else{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $oldPasswordText, placHolderText: .constant("Type your old password"), isSecure: .constant(false))
                    }
                }
                .overlay{
                    Text("    ")
                        .frame(width: 50, height: 50)
                        .padding(.leading, UIScreen.main.bounds.width - 90)
                        .onTapGesture {
                            isSecureOldPassword.toggle()
                        }
                }
                
                Group{
                    if isSecureNewPassword{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $newPasswordText, placHolderText: .constant("Type your new password"), isSecure: .constant(true))
                    }
                    else{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $newPasswordText, placHolderText: .constant("Type your new password"), isSecure: .constant(false))
                    }
                }
                .overlay{
                    Text("    ")
                        .frame(width: 50, height: 50)
                        .padding(.leading, UIScreen.main.bounds.width - 90)
                        .onTapGesture {
                            isSecureNewPassword.toggle()
                        }
                }
                
                Group{
                    if isSecureReTypePassword{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $reTypePasswordText, placHolderText: .constant("Re-Type your password"), isSecure: .constant(true))
                    }
                    else{
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Password), isTrailingImage: true, text: $reTypePasswordText, placHolderText: .constant("Re-Type your password"), isSecure: .constant(false))
                    }
                }
                .overlay{
                    Text("    ")
                        .frame(width: 50, height: 50)
                        .padding(.leading, UIScreen.main.bounds.width - 90)
                        .onTapGesture {
                            isSecureReTypePassword.toggle()
                        }
                }
            }
            .frame(height: 70)
        }
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 20){
                        
            Text("Confirm")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(.buttonColor))
                .cornerRadius(30)
        }
    }
}
