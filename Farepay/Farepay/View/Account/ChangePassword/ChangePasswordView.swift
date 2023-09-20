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
                ZStack{
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Password)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(.darkGrayColor))
                        
                        if isSecureOldPassword{
                            SecureField("", text: $oldPasswordText, prompt: Text("Type your old password").foregroundColor(Color(.darkGrayColor)))
                                .font(.custom(.poppinsMedium, size: 18))
                                .frame(height: 30)
                                .foregroundColor(.white)
                        }
                        else{
                            TextField("", text: $oldPasswordText, prompt: Text("Type your old password").foregroundColor(Color(.darkGrayColor)))
                                .font(.custom(.poppinsMedium, size: 18))
                                .frame(height: 30)
                                .foregroundColor(.white)
                        }
                        
                        Image(systemName: isSecureOldPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.white)
                            .onTapGesture {
                                isSecureOldPassword.toggle()
                            }
                    }
                    .padding([.leading, .trailing], 20)
                }
                ZStack{
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Password)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(.darkGrayColor))
                        
                        if isSecureNewPassword{
                            SecureField("", text: $newPasswordText, prompt: Text("Type your new password").foregroundColor(Color(.darkGrayColor)))
                                .font(.custom(.poppinsMedium, size: 18))
                                .frame(height: 30)
                                .foregroundColor(.white)
                        }
                        else{
                            TextField("", text: $newPasswordText, prompt: Text("Type your new password").foregroundColor(Color(.darkGrayColor)))
                                .font(.custom(.poppinsMedium, size: 18))
                                .frame(height: 30)
                                .foregroundColor(.white)
                        }
                        
                        Image(systemName: isSecureNewPassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.white)
                            .onTapGesture {
                                isSecureNewPassword.toggle()
                            }
                    }
                    .padding([.leading, .trailing], 20)
                }
                ZStack{
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Password)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(.darkGrayColor))
                        
                        if isSecureReTypePassword{
                            SecureField("", text: $reTypePasswordText, prompt: Text("Re-Type your password").foregroundColor(Color(.darkGrayColor)))
                                .font(.custom(.poppinsMedium, size: 18))
                                .frame(height: 30)
                                .foregroundColor(.white)
                        }
                        else{
                            TextField("", text: $reTypePasswordText, prompt: Text("Re-Type your password").foregroundColor(Color(.darkGrayColor)))
                                .font(.custom(.poppinsMedium, size: 18))
                                .frame(height: 30)
                                .foregroundColor(.white)
                        }
                        
                        Image(systemName: isSecureReTypePassword ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.white)
                            .onTapGesture {
                                isSecureReTypePassword.toggle()
                            }
                    }
                    .padding([.leading, .trailing], 20)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(.darkBlueColor))
            .cornerRadius(10)
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
