//
//  Form2View.swift
//  Farepay
//
//  Created by Arslan on 28/08/2023.
//

import SwiftUI
import FirebaseAuth
import Combine
import ActivityIndicatorView
struct RepresentativeView: View {
    
    //MARK: - Variable
    @State private var userText: String = ""
    @State private var dateText: String = ""
    @State private var emailText: String = Auth.auth().currentUser?.email ?? ""
    @State private var addressText: String = ""
    @State private var postalAddressText: String = ""
    @State private var businessNumberText: String = ""
    @State private var authorityNumberText: String = ""
    @State private var mobileNumberText: String = ""
    
    @State private var licenseFrontImage: UIImage? = nil
    @State private var islicenseFrontImagePickerPresented = false
    @State private var licenseBackImage: UIImage? = nil
    @State private var islicenseBackImagePickerPresented = false
    @State private var isPresentedPreview = false
    
    @State var showDatePicker: Bool = false
    
    @State var apicalled = false
    @State var uploadFrontImage : Bool?
    @State var uploadBackImage : Bool?
    @State var goToNextView = false
    @State var isChecked = false
    @State var savedDate: Date = Date().noon
    
    @State var frontImageId = ""
    @State var backImageId = ""
    @StateObject var completeFormViewModel = CompleteFormViewModel()
    @State private var toast: Toast? = nil
    @AppStorage("username") var username: String = ""
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
//            .onAppear(perform: {
//                userText = username
//            })
            .padding(.all, 15)
            .toastView(toast: $toast)
            
            if showDatePicker {
                DatePickerWithButtons(showDatePicker: $showDatePicker, savedDate: $savedDate, selectedDate: savedDate, dateText: $dateText)
                    
                    .transition(.opacity)
            }
            
            if apicalled {
                ActivityIndicatorView(isVisible: $apicalled, type: .growingArc(.white, lineWidth: 5))
                    .frame(width: 50.0, height: 50.0)
                    .foregroundColor(.white)
                    .padding(.top, 350)
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

                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_User), text: $userText, placHolderText: .constant("Type your Full Name"), isSecure: .constant(false))
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
                            text: $mobileNumberText.max(9)
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
                
//                Image(uiImage: .ic_Box)
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
                    .onTapGesture {
                        
                        isChecked.toggle()
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
                
                .onReceive(Just(licenseFrontImage)) { newImage in
                    if let newImage = newImage {
                        
                        if frontImageId == "" && uploadFrontImage == nil  {

                            
                            uploadImage(image: newImage, isFront: true)
                        }

                    }
                }
                .onTapGesture {
                    uploadFrontImage = nil
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
                                    frontImageId = ""
                                    uploadFrontImage = nil
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
                .onReceive(Just(licenseBackImage)) { newImage in
                    if let newImage = newImage {
                        
                        
                        if backImageId == "" && uploadBackImage  == nil  {
                            uploadImage(image: newImage, isFront: false)
                            
                        }

                    }
                }
                .onTapGesture {
                    uploadBackImage = nil
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
                                    backImageId = ""
                                    uploadBackImage = nil
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
                            

            
            
            NavigationLink("", destination: NewsView().toolbar(.hidden, for: .navigationBar), isActive: $goToNextView).isDetailLink(false)
            
            
            Button {
                
                
                var firstPart = ""
                var secondPart = ""
                
                if let index = userText.firstIndex(of: " "){
                    firstPart = String(userText.prefix(upTo: index))
                    secondPart = userText[index...].string
                } else {
                    firstPart = userText
                    secondPart = ""
                }
                
                if userText.isEmpty {
                    toast = Toast(style: .error, message: "Name Field cannot be empty.")
                }
                else if dateText.isEmpty {
                    toast = Toast(style: .error, message: "DOB Field cannot be empty.")
                }
                else if mobileNumberText.isEmpty {
                    toast = Toast(style: .error, message: "Phone Number Field cannot be empty.")
                }
                else if mobileNumberText.count <= 8 {
                    toast = Toast(style: .error, message: "Please enter Valid Australian Phone Number.")
                }
                else if authorityNumberText.isEmpty {
                    toast = Toast(style: .error, message: "Driver Authority No. Field cannot be empty.")
                }
                else if authorityNumberText.count <= 9 {
                    toast = Toast(style: .error, message: "Driver Authority No. should be 10.")
                }
                else if addressText.isEmpty {
                    toast = Toast(style: .error, message: "Physical Address Filed cannot be empty.")
                }
                else if frontImageId == "" {
                    toast = Toast(style: .error, message: "Please Upload Front Driver Licence Image.")
                }
                else if backImageId == "" {
                    toast = Toast(style: .error, message: "Please Upload Back Driver Licence Image.")
                }
                else {
                    Task {
                        
                        try  await completeFormViewModel.postData(url:"\(uploadInformationUrl)username=default&userEmail=\(Auth.auth().currentUser?.email ?? "")&firstname=\(firstPart.string)&day=3&month=10&year=2000&address=\(addressText)&phone=61\(mobileNumberText)&lastname=\(secondPart.string)&frontimgid=\(frontImageId)&backimgid=\(backImageId)",method:.post,name: userText,phone: mobileNumberText, email: (Auth.auth().currentUser?.email ?? ""))
                        
                        DispatchQueue.main.async {
                            if completeFormViewModel.goToAccountScreen {
                                goToNextView = true
                            }else {
                                toast = Toast(style: .error, message: completeFormViewModel.errorMsg    )
                                frontImageId = ""
                                backImageId = ""
                                uploadFrontImage = nil
                                
                                uploadBackImage = nil
                                licenseFrontImage = nil
                                licenseBackImage  = nil
                            }
                        }
                        
                    }
                }
               
            } label: {
                Text("Create Connect Account")
                    .font(.custom(.poppinsBold, size: 22))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(.buttonColor))
                    .cornerRadius(30)
            }

        }
    }
    
 
    
    
    func uploadImage(image:UIImage,isFront:Bool) {
        
    

        apicalled = true
        if isFront {
            uploadFrontImage = true
        }else {
            uploadBackImage = true
        }

        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let base64String = imageData.base64EncodedString()

            // Create an API request with the Base64 image data
            if let url = URL(string: imageUploadStripeUrl) {
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                let imageUploadData = ["image": base64String]
//                print(imageUploadData)
                if let jsonData = try? JSONSerialization.data(withJSONObject: imageUploadData) {
                    request.httpBody = jsonData
                    
                }

                URLSession.shared.dataTask(with: request) { data, response, error in

                    
                    guard let data = data else { return  }
                    
                    
                    do {
                        // make sure this JSON is in the format we expect
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            // try to read out a string array
                            if let imageId = json["id"] as? String {
                                print(imageId)
                                if isFront {
                                    frontImageId = imageId

                                }else {
                                    backImageId = imageId

                                }
                            }
                        }
                        apicalled = false
                    } catch let error as NSError {
                        print("Failed to load: \(error.localizedDescription)")
                        apicalled = false
                        
                    }
                    
//                    apicalled = false
                    
                }.resume()
            }
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
                    .colorInvert()
                    .colorMultiply(Color.blue)
                            
                
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


