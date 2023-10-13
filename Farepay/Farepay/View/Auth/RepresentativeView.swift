//
//  Form2View.swift
//  Farepay
//
//  Created by Arslan on 28/08/2023.
//

import SwiftUI

struct RepresentativeView: View {
    
    //MARK: - Variable
    @State private var userText: String = ""
    @State private var dateText: String = ""
    @State private var emailText: String = ""
    @State private var addressText: String = ""
    @State private var businessNumberText: String = ""
    @State private var authorityNumberText: String = ""
    @State private var mobileNumberText: String = ""
    
    @State private var licenseFrontImage: UIImage? = nil
    @State private var islicenseFrontImagePickerPresented = false
    @State private var licenseBackImage: UIImage? = nil
    @State private var islicenseBackImagePickerPresented = false
    @State private var isPresentedPreview = false
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack{
                
                ScrollView(showsIndicators: false){
                    VStack(spacing: 40){
                        topArea
                        textArea
                        buttonArea
                    }
                }
            }
            .padding(.all, 15)
        }
    }
}

struct Form2View_Previews: PreviewProvider {
    static var previews: some View {
        RepresentativeView()
    }
}

extension RepresentativeView{
    
    var topArea: some View{
        
        VStack(spacing: 20){
            
            Text("Fill in the form below")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            
            VStack{
                
                Text("to get your own farepay account!")
                    .font(.custom(.poppinsMedium, size: 18))
                    .foregroundColor(Color(.darkGrayColor))
                Color(.darkGrayColor)
                    .frame(maxWidth: 300)
                    .frame(height: 1)
            }
            
            HStack(spacing: 5){
                
                Color(.SuccessColor)
                    .frame(height: 5)
                Color(.darkGrayColor)
                    .frame(height: 5)
            }
            .frame(width: 250)
            
            Text("REPRESENTIVE INFORMATION")
                .font(.custom(.poppinsBold, size: 20))
                .foregroundColor(.white)
            
        }
    }
    
    var textArea: some View{
        
        VStack(alignment: .leading, spacing: 20){
            
            Group{

                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_User), text: $userText, placHolderText: .constant("Type your name"), isSecure: .constant(false))
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Calander), text: $dateText, placHolderText: .constant("Type your Date of Birth"), isSecure: .constant(false))
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Email), text: $emailText, placHolderText: .constant("Type your email"), isSecure: .constant(false))
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Mobile), text: $mobileNumberText, placHolderText: .constant("Type your mobile No"), isSecure: .constant(false))
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Authority), text: $authorityNumberText, placHolderText: .constant("Type your driver authority No"), isSecure: .constant(false))
                ZStack{

                    HStack(alignment: .top, spacing: 10){
                        
                        Image(uiImage: .ic_Home)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        
                        TextEditor(text: $addressText)
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                            .padding(.vertical, -10)
                            .overlay(

                                VStack{

                                    Text(addressText == "" ? "Type your Physical Address" : "")
                                        .font(.custom(.poppinsMedium, size: 18))
                                        .foregroundColor(Color(.darkGrayColor))
                                    Spacer()
                                },
                                alignment: .leading
                            )
                    }
                    .padding([.all], 20)
                }
                .frame(height: 100)
                ZStack{
                    HStack(alignment: .top, spacing: 10){
                        
                        Image(uiImage: .ic_Home)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        
                        TextEditor(text: $addressText)
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                            .padding(.vertical, -10)
                            .overlay(

                                VStack{

                                    Text(addressText == "" ? "Type your Postal Address" : "")
                                        .font(.custom(.poppinsMedium, size: 18))
                                        .foregroundColor(Color(.darkGrayColor))
                                    Spacer()
                                },
                                alignment: .leading
                            )
                    }
                    .padding([.all], 20)
                }
                .frame(height: 100)
                
            }
            .frame(maxWidth: .infinity)
            .background(Color(.darkBlueColor))
            .cornerRadius(10)
            
            HStack(spacing: 10){
                
                Image(uiImage: .ic_Box)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        
                        print("Tick if Same as physical Address")
                    }
                Text("Tick if Same as physical Address")
                    .font(.custom(.poppinsMedium, size: 17))
                    .foregroundColor(.white)
            }
            
            HStack(spacing: 15){
                ZStack{
                    if let image = licenseFrontImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    else{
                        Image(uiImage: .ic_UploadImage)
                            .resizable()
                            .frame(width: 30, height: 25)
                    }

                }
                .frame(maxWidth: .infinity)
                .frame(width: 80, height: 80)
                .background(Color(.darkBlueColor))
                .onTapGesture {
                    islicenseFrontImagePickerPresented.toggle()
                }
                .fullScreenCover(isPresented: $islicenseFrontImagePickerPresented) {
                    ImagePicker(selectedImage: $licenseFrontImage)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundColor(licenseFrontImage != nil ? Color(.darkGrayColor) : Color(.buttonColor))
                )
                
                if licenseFrontImage != nil{
                    VStack(alignment: .leading, spacing: 12){
                        Text("imageName.jpg")
                            .foregroundColor(.white)
                            .font(.custom(.poppinsMedium, size: 16))
                            .lineLimit(1)
                        HStack(spacing: 15){
                            Text("Delete")
                                .frame(width: 90, height: 30)
                                .foregroundColor(Color(.ErrorColor))
                                .font(.custom(.poppinsMedium, size: 16))
                                .overlay{
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color(.ErrorColor), lineWidth: 1)
                                }
                                .onTapGesture {
                                    licenseFrontImage = nil
                                }
                            Text("View")
                                .frame(width: 90, height: 30)
                                .foregroundColor(Color(.buttonColor))
                                .font(.custom(.poppinsMedium, size: 16))
                                .overlay{
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color(.buttonColor), lineWidth: 1)
                                }
                                .onTapGesture {
                                    isPresentedPreview.toggle()
                                }
                                .fullScreenCover(isPresented: $isPresentedPreview) {
                                    ImagePreView(presentedAsModal: $isPresentedPreview,image: $licenseFrontImage)
                                }
                        }
                    }
                }
                else{
                    Text("Driver License Image \n(Front)")
                        .foregroundColor(Color(.darkGrayColor))
                        .font(.custom(.poppinsMedium, size: 16))
                }
            }
            
            HStack(spacing: 15){
                ZStack{
                    
                    if let image = licenseBackImage{
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    else{
                        Image(uiImage: .ic_UploadImage)
                            .resizable()
                            .frame(width: 30, height: 25)
                    }
               
                }
                .frame(maxWidth: .infinity)
                .frame(width: 80, height: 80)
                .background(Color(.darkBlueColor))
                .onTapGesture {
                    islicenseBackImagePickerPresented.toggle()
                }
                .fullScreenCover(isPresented: $islicenseBackImagePickerPresented) {
                    ImagePicker(selectedImage: $licenseBackImage)
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .foregroundColor(licenseBackImage != nil ? Color(.darkGrayColor) : Color(.buttonColor))
                )
                
                if licenseBackImage != nil{
                    VStack(alignment: .leading, spacing: 12){
                        Text("imageName.jpg")
                            .foregroundColor(.white)
                            .font(.custom(.poppinsMedium, size: 16))
                            .lineLimit(1)
                        HStack(spacing: 15){
                            Text("Delete")
                                .frame(width: 90, height: 30)
                                .foregroundColor(Color(.ErrorColor))
                                .font(.custom(.poppinsMedium, size: 16))
                                .overlay{
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color(.ErrorColor), lineWidth: 1)
                                }
                                .onTapGesture {
                                    licenseBackImage = nil
                                }
                            Text("View")
                                .frame(width: 90, height: 30)
                                .foregroundColor(Color(.buttonColor))
                                .font(.custom(.poppinsMedium, size: 16))
                                .overlay{
                                    RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color(.buttonColor), lineWidth: 1)
                                }
                                .onTapGesture {
                                    isPresentedPreview.toggle()
                                }
                                .fullScreenCover(isPresented: $isPresentedPreview) {
                                    ImagePreView(presentedAsModal: $isPresentedPreview,image: $licenseBackImage)
                                }
                        }
                    }
                }
                else{
                    Text("Driver License Image \n(Back)")
                        .foregroundColor(Color(.darkGrayColor))
                        .font(.custom(.poppinsMedium, size: 16))
                }
            }
        }
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 20){
            
            NavigationLink(destination: {
                NewsView().toolbar(.hidden, for: .navigationBar)
            }, label: {
                Text("Create Connect Account")
                    .font(.custom(.poppinsBold, size: 22))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(.buttonColor))
                    .cornerRadius(30)
            })
        }
    }
}
