//
//  EditAccountView.swift
//  Farepay
//
//  Created by Arslan on 19/09/2023.
//

import SwiftUI

struct EditAccountView: View {
    
    //MARK: - Variables
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var willMoveToEditInfo: Bool = false
    @State private var nameText: String = ""
    @State private var phoneText: String = ""
    @State private var emailText: String = ""
    
    // MARK: - Views
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

struct EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
        EditAccountView()
    }
}

extension EditAccountView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            Image(uiImage: .backArrow)
                .resizable()
                .frame(width: 35, height: 30)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("Account info")
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
                        
                        Image(uiImage: .ic_User)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(.darkGrayColor))
                        
                        TextField("", text: $emailText, prompt: Text("Type your Name").foregroundColor(Color(.darkGrayColor)))
                            .font(.custom(.poppinsMedium, size: 18))
                            .frame(height: 30)
                            .foregroundColor(.white)
                        
                    }
                    .padding([.leading, .trailing], 20)
                }
                ZStack{
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Phone)
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(.darkGrayColor))
                        
                        TextField("", text: $emailText, prompt: Text("Type your Phone Number").foregroundColor(Color(.darkGrayColor)))
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
                            .frame(width: 25, height: 25)
                            .foregroundColor(Color(.darkGrayColor))
                        
                        TextField("", text: $emailText, prompt: Text("Type your Email").foregroundColor(Color(.darkGrayColor)))
                            .font(.custom(.poppinsMedium, size: 18))
                            .frame(height: 30)
                            .foregroundColor(.white)
                        
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
                        
            Text("Save")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(.buttonColor))
                .cornerRadius(30)
        }
    }
}
