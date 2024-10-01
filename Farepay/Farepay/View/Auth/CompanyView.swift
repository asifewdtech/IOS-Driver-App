//
//  Form1View.swift
//  Farepay
//
//  Created by Arslan on 25/08/2023.
//

import SwiftUI
import Combine
import StripeIdentity

struct CompanyView: View {
    
    //MARK: - Variable
    @State var companyText: String = "Individual"
    @State private var cardText: String = ""
    @State private var contactText: String = ""
    @State private var willMoveToRepresentativeView: Bool = false
    @State private var willMoveToUnderReviewView: Bool = false
    @State private var isPresentedPopUp: Bool = false
    @State private var toast: Toast? = nil
    @State private var licenseFrontImage: UIImage? = nil
    @State private var isStripeIdentityPickerPresented = false
    @State var isChecked = false
    
    //MARK: - Views
    var body: some View {
        
        NavigationView {
            ZStack{
                
                NavigationLink("", destination: RepresentativeView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToRepresentativeView).isDetailLink(false)
                NavigationLink("", destination: UnderReviewView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToUnderReviewView).isDetailLink(false)
                
                Color(.bgColor).edgesIgnoringSafeArea(.all)
                VStack{
                    ScrollView(showsIndicators: false){
                        VStack(spacing: 40) {
                            topArea
//                            textArea
                            Spacer()
                            stripeIdentityView
                        }
                    }
                    buttonArea
                }
                .onAppear(perform: {
                    UserDefaults.standard.removeObject(forKey: "stripeFlowStatus")
                    UserDefaults.standard.removeObject(forKey: "driverABN")
                    UserDefaults.standard.removeObject(forKey: "driverLicence")
                    UserDefaults.standard.removeObject(forKey: "stripeSessionID")
                    
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("VerifiComplete"), object: nil, queue: .main) { (_) in
                        isChecked.toggle()
                    }
                })
                .toastView(toast: $toast)
                .padding(.all, 15)
            }
            .onReceive(NotificationCenter.default.publisher(for: .proceedNext)) { _ in
                print("Received Custom Notification")
                willMoveToRepresentativeView.toggle()
            }
        }
    }
}

struct Form1View_Previews: PreviewProvider {
    static var previews: some View {
        CompanyView()
    }
}

extension CompanyView{
    
    var topArea: some View{
        
        VStack(spacing: 20){
            
            Text("Verify your Identity")
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
                
                Color(.ErrorColor)
                    .frame(height: 5)
                Color(.darkGrayColor)
                    .frame(height: 5)
            }
            .frame(width: 250)
            
//            Text("COMPANY INFORMATION")
            Text("Tap below for Identity Verification")
                .font(.custom(.poppinsBold, size: 18))
                .foregroundColor(.white)
            
        }
    }
    
    var textArea: some View{
        
        VStack(alignment: .leading, spacing: 20){
            
            Group{
                
//                ZStack{
//                    
//                    HStack(spacing: 10){
//                        
//                        Image(uiImage: .ic_Company)
//                            .resizable()
//                            .frame(width: 30, height: 30)
//                        
//                        TextField("", text: $companyText, prompt: Text("\(.selectCompany)").foregroundColor(Color(.darkGrayColor)))
//                            .font(.custom(.poppinsMedium, size: 18))
//                            .frame(height: 30)
//                            .foregroundColor(.white)
//                            .disabled(true)
//                        
//                        Image(uiImage: .ic_DropDown)
//                            .resizable()
//                            .frame(width: 30, height: 30)
//                        
//                    }
//                    .padding([.leading, .trailing], 20)
//                }
//                .frame(height: 60)
                
                HStack(spacing: 10){
                    
                    DropdownSelector(
                        placeholder: .selectCompany, leftImage: .ic_Company,
                        options: businessType,
                        onOptionSelected: { option in
                            print(option)
                            self.companyText = option.value
                        })
                    .foregroundColor(.white)
                }
                
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Card), text: $cardText.max(11), placHolderText: .constant("Enter your ABN"), isSecure: .constant(false),isNumberPad: true)
                    
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Contact), text: $contactText.max(11), placHolderText: .constant("Enter your Drivers Licence"), isSecure: .constant(false),isNumberPad: true)
            }
            .frame(maxWidth: .infinity)
            .background(Color(.darkBlueColor))
            .cornerRadius(10)
        }
    }
    
    var stripeIdentityView: some View{
        VStack(spacing: 50) {
            ZStack{
                if let image = licenseFrontImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                else{
                    Image(uiImage: .ic_UploadImage)
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(width: 120, height: 120)
            .background(Color(.darkBlueColor))
            .cornerRadius(20)
            .onReceive(Just(licenseFrontImage)) { newImage in
                if let newImage = newImage {
//                    if frontImageId == "" && uploadFrontImage == nil  {
//                        uploadImage(image: newImage, isFront: true)
//                    }
                }
            }
            .onTapGesture {
                isStripeIdentityPickerPresented.toggle()
            }
            .fullScreenCover(isPresented: $isStripeIdentityPickerPresented) {
                StripeIdentityVC()
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundColor(licenseFrontImage != nil ? Color(.darkGrayColor) : Color(.buttonColor))
            )
            
            
            HStack(spacing: 10){
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
                    
                Text("Identity Verified")
                    .font(.custom(.poppinsMedium, size: 20))
                    .foregroundColor(.white)
            }
        }
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 20){
            Button(action: {
                PresentedPopUp()
            }, label: {
                Text("PROCEED")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(.buttonColor))
                    .cornerRadius(30)
                    
                    
            })
                .fullScreenCover(isPresented: $isPresentedPopUp) {
                    StepsView(presentedAsModal: $isPresentedPopUp)
                }
        }
    }
    
    func PresentedPopUp()  {
//        if (companyText != "Individual") && (companyText != "Business") {
//            toast = Toast(style: .error, message: "Company Type field cannot be empty.")
//        }
//        else if cardText.isEmpty {
//            toast = Toast(style: .error, message: "ABN field cannot be empty.")
//        }
//        else if cardText.count <= 10 {
//            toast = Toast(style: .error, message: "ABN Should be 11 Digits.")
//        }
//        else if contactText.isEmpty {
//            toast = Toast(style: .error, message: "Driver Licence field cannot be empty.")
//        }
//        else if contactText.count <= 7 {
//            toast = Toast(style: .error, message: "Driver Licence Should be 8-11 Digits.")
//        }
//        else{
//            UserDefaults.standard.removeObject(forKey: "stripeFlowStatus")
//            UserDefaults.standard.set(cardText, forKey: "driverABN")
//            UserDefaults.standard.set(contactText, forKey: "driverLicence")
        let stripeFlowStatus = UserDefaults.standard.string(forKey: "stripeFlowStatus")
        print("stripeFlowStatus ",stripeFlowStatus)
        if stripeFlowStatus != "Completed" {
            toast = Toast(style: .error, message: "Verification Flow is not Complete.")
        }else{
//            isPresentedPopUp.toggle()
            willMoveToUnderReviewView.toggle()
        }
    }
}


extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}

struct StripeIdentityVC: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeUIViewController(context: Context) -> UIViewController {
        
        return verifyDocs()
    }
    
    class verifyDocs : UIViewController {
        @State private var showCompany = false
        @Environment(\.presentationMode) private var presentationMode
        @State var repView = RepresentativeView()
        @State var stripeIdStatus: String = "NA"
        
        override func viewDidLoad() {
            super.viewDidLoad()
            didTapVerifyButton()
//            self.presentVerificationSheet(verificationSessionId: "vs_1PQjBDA1ElCzYWXL9YzcEG9n", ephemeralKeySecret: "ek_test_YWNjdF8xTklQOE5BMUVsQ3pZV1hMLDQ2OFdwV0hJSUh3U2wxMENXMW0wQm1iTDQyUWFEMzU_00PTrJTVci")
            UserDefaults.standard.removeObject(forKey: "stripeFlowStatus")
        }
        
        func didTapVerifyButton(){
            var urlReqIs = ""
            if API.App_Envir == "Production" {
                urlReqIs = "https://zj921xefzb.execute-api.eu-north-1.amazonaws.com/default/CreateSessionStripeIdentity"
            }
            else if API.App_Envir == "Dev" {
                urlReqIs = "https://rpljmup273.execute-api.eu-north-1.amazonaws.com/default/CreateSessionStripeIdentity"
                UserDefaults.standard.set("Completed", forKey: "stripeFlowStatus")
            }
            else if API.App_Envir == "Stagging" {
                urlReqIs = "https://92tbqakpob.execute-api.eu-north-1.amazonaws.com/default/CreateSessionStripeIdentity"
            }else{
                urlReqIs = "https://zj921xefzb.execute-api.eu-north-1.amazonaws.com/default/CreateSessionStripeIdentity"
            }
            
            var urlRequest = URLRequest(url: URL(string: urlReqIs)!)
        
            urlRequest.httpMethod = "POST"
            
            let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, response, error in
                DispatchQueue.main.async { [weak self] in
                    
                    let data1 = data
                    let responseJson1 = try? JSONDecoder().decode([String: String].self, from: data1!)
                    print("responseJson1: ",responseJson1)
                    guard error == nil,
                          let data = data,
                          let responseJson = try? JSONDecoder().decode([String: String].self, from: data),
                          let verificationSessionId = responseJson["verificationSessionId"],
                          let ephemeralKeySecret = responseJson["ephemeralKeySecret"] else {
                        // Handle error
                        print(error as Any)
                        return
                    }
                    print("stripeSessionID: ",verificationSessionId)
                    print("stripeEphemeralKeySecret: ",ephemeralKeySecret)
                    
                    self?.presentVerificationSheet(verificationSessionId: verificationSessionId, ephemeralKeySecret: ephemeralKeySecret)
                }
            }
            task.resume()
        }
        
        func presentVerificationSheet(verificationSessionId: String, ephemeralKeySecret: String){
            let configuration = IdentityVerificationSheet.Configuration(
                brandLogo: UIImage(named: "licenseImage")!
            )
            
            let verificationSheet = IdentityVerificationSheet(
                verificationSessionId: verificationSessionId,
                ephemeralKeySecret: ephemeralKeySecret,
                configuration: configuration
            )
            
            verificationSheet.present(from: self, completion: { [self] result in
                switch result {
                case .flowCompleted:
                    print("Verification Flow Completed!")
                    UserDefaults.standard.set("Completed", forKey: "stripeFlowStatus")
                    dismiss(animated: true, completion: nil)
                    UserDefaults.standard.set(verificationSessionId, forKey: "stripeSessionID")
                    UserDefaults.standard.set(ephemeralKeySecret, forKey: "stripeEphemeralKeySecret")
                    NotificationCenter.default.post(name: NSNotification.Name("VerifiComplete"), object: nil)
                    print("sessionID: \(verificationSessionId)")
                case .flowCanceled:
                    print("Verification Flow Canceled!")
                    UserDefaults.standard.set("Canceled", forKey: "stripeFlowStatus")
                    dismiss(animated: true, completion: nil)
                case .flowFailed(let error):
                    print("Verification Flow Failed!")
                    UserDefaults.standard.set("Failed", forKey: "stripeFlowStatus")
                    print(error.localizedDescription)
                    dismiss(animated: true, completion: nil)
                }
            })
        }
    }
}
