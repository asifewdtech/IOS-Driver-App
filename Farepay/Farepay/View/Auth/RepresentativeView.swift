//
//  Form2View.swift
//  Farepay
//
//  Created by Arslan on 28/08/2023.
//

import SwiftUI
import FirebaseAuth
struct RepresentativeView: View {
    
    //MARK: - Variable
    @State private var userText: String = ""
    @State private var dateText: String = ""
    @State private var emailText: String = Auth.auth().currentUser?.email ?? ""
    @State private var addressText: String = ""
    @State private var businessNumberText: String = ""
    @State private var authorityNumberText: String = ""
    @State private var mobileNumberText: String = ""
    
    @State private var licenseFrontImage: UIImage? = nil
    @State private var islicenseFrontImagePickerPresented = false
    @State private var licenseBackImage: UIImage? = nil
    @State private var islicenseBackImagePickerPresented = false
    @State private var isPresentedPreview = false
    
    @State var showDatePicker: Bool = false
    @State var savedDate: Date = Date().noon
    
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
            
            if showDatePicker {
                DatePickerWithButtons(showDatePicker: $showDatePicker, savedDate: $savedDate, selectedDate: savedDate, dateText: $dateText)
                    
                    .transition(.opacity)
            }
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
                    .onTapGesture {
                        showDatePicker.toggle()
                    }
                
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Email), text: $emailText, placHolderText: .constant("Type your email"), isSecure: .constant(false))
                    .allowsHitTesting(false)
                    
//                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Mobile), text: $mobileNumberText.max(11), placHolderText: .constant("Type your mobile No"), isSecure: .constant(false),isNumberPad: true)
                HStack {
                    Image(uiImage: .ic_Mobile)
                        .resizable()
                        .frame(width: 30, height: 30)
                    HStack {
                        Text("+61")
                            .foregroundStyle(Color.white)
                        TextField(
                            "Type your mobile No",
                            text: $mobileNumberText.max(11)
                        )
                        .keyboardType(.numberPad)
                        .foregroundStyle(Color.white)
                    }
                    
                }
                .frame(height: 60)
                .padding(.horizontal,10)
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Authority), text: $authorityNumberText.max(10), placHolderText: .constant("Type your driver authority No"), isSecure: .constant(false),isNumberPad: true)
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

            // Split first and last name
            //                if let index = userText.firstIndex(of: " ") {
            //                    let firstPart = userText.prefix(upTo: index)
            //
            //                    print(firstPart)
            //                    print(userText[index...])
            //
            //
            //                }

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



struct DatePickerWithButtons: View {
    
    @Binding var showDatePicker: Bool
    @Binding var savedDate: Date
    @State var selectedDate: Date = Date()
    @Binding var dateText:String
    var minimumDate: Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .year, value: -18, to: Date.now)!
    }


    var body: some View {
        ZStack {
            
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
            
            
            VStack {
                DatePicker("Test", selection: $selectedDate,in: ...minimumDate, displayedComponents: [.date])
                    .datePickerStyle(GraphicalDatePickerStyle())
                
                Divider()
                HStack {
                    
                    Button(action: {
                        showDatePicker = false
                    }, label: {
                        Text("Cancel")
                    })
                    
                    Spacer()
                    
                    Button(action: {
                        savedDate = selectedDate
                        dateText = savedDate.dateToString()
                        showDatePicker = false
                        
                    }, label: {
                        Text("Save".uppercased())
                            .bold()
                    })
                    
                }
                .padding(.horizontal)

            }
            .padding()
            .background(
                Color.white
                    .cornerRadius(30)
            )

            
        }

    }
}



extension Date {
    
    func dateToString() -> String {
        let dateFormatter = DateFormatter()
        // Set Date Format
        dateFormatter.dateFormat = "dd-MM-YYYY"
        // Convert Date to String
        return dateFormatter.string(from: self)
    }
    
}


