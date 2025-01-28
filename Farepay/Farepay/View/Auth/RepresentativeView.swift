//
//  Form2View.swift
//  Farepay
//
//  Created by Arslan on 28/08/2023.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import Combine
import ActivityIndicatorView
import StripeIdentity
import UIKit
import Alamofire
import MapKit

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
    @State private var driverABNText: String = ""
    @State private var driverLicenseText: String = ""
    
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
    
    @State var StIdStatus: String! = ""
    @State var streetAddr: String = ""
    @State var countryAddr: String = ""
    @State var cityAddr: String = ""
    @State var stateAddr: String = ""
    @State var postalAddr: String = ""
    @State var verifyIdetityText: String = "Verify your identity"
    @State var locManager = CLLocationManager()
    @State var currentLocation: CLLocation!
    @State var validateFormattedAddress: String = ""
    
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
            .onAppear(perform: {
//                fetchLatLong()
                
                Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
                    if let error = error {
                        print(error.localizedDescription)
                        
                    }else {
                        
                        guard let snap = snapShot else { return  }
                        
                        DispatchQueue.main.async {
                            let identityReportID = snap.get("identityReportID") as? String
                            let identitySessionID = snap.get("sessionID") as? String
                            
                            GetVerifiedFieldsFromIdentity(reportId: identityReportID ?? "")
                            GetSensitiveVerifiedFieldsFromIdentity(sessionId: identitySessionID ?? "")
                        }
                    }
                }
            })
            .padding(.all, 15)
            .toastView(toast: $toast)
            
            if showDatePicker {
                DatePickerWithButtons(showDatePicker: $showDatePicker, savedDate: $savedDate, selectedDate: savedDate, dateText: $dateText)
                    
                    .transition(.opacity)
            }
            
            if apicalled{
                VStack{
                    ActivityIndicatorView(isVisible: $apicalled, type: .growingArc(.white, lineWidth: 5))
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
            
            Text("Driver Registration")
                .font(.custom(.poppinsBold, size: 20))
                .foregroundColor(.white)
            
        }
    }
    
    var textArea: some View{
        
        VStack(alignment: .leading, spacing: 20){
            
            Group{

                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_User), text: $userText, placHolderText: .constant("Type your Full Name"), isSecure: .constant(false))
//                    .allowsHitTesting(false)
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Calander), text: $dateText, placHolderText: .constant("Type your Date of Birth"), isSecure: .constant(false))
//                    .allowsHitTesting(false)
//                    .onTapGesture {
//                        showDatePicker.toggle()
//                    }
                
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
                .frame(height: 70)
                .padding(.horizontal,10)
                .background(Color(.darkBlueColor))
                
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Authority), text: $authorityNumberText.max(10), placHolderText: .constant("Type your driver authority No"), isSecure: .constant(false),isNumberPad: true)
                
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Card), text: $driverABNText.max(11), placHolderText: .constant("Enter your driver ABN"), isSecure: .constant(false),isNumberPad: true)
                
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Contact), text: $driverLicenseText.max(11), placHolderText: .constant("Enter your Driver Licence"), isSecure: .constant(false),isNumberPad: true)
                
                Group {
                    HStack (spacing: 20){
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Home), text: $streetAddr, placHolderText: .constant("Street Address"), isSecure: .constant(false))
//                            .allowsHitTesting(false)
                    }
                    .frame(height: 70)
                    .cornerRadius(10)
                    
                    
                    HStack (spacing: 20){
                        MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Home), text: $cityAddr, placHolderText: .constant("Suburb"), isSecure: .constant(false))
                    }
                    .frame(height: 70)
                    .cornerRadius(10)
                    
                    HStack (spacing: 20){
                        HStack (spacing: 0) {
                            
                            MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Home), text: $stateAddr, placHolderText: .constant("State/Province"), isSecure: .constant(false))
//                                .allowsHitTesting(false)
                        }
                        .frame(height: 70)
                        .frame(width: 170)
                        .background(Color(.darkBlue))
                        .cornerRadius(10)
                        
                        HStack {
                            MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Home), text: $postalAddr, placHolderText: .constant("Postal Code"), isSecure: .constant(false),isNumberPad: true)
//                                .allowsHitTesting(false)
                        }
                        .frame(height: 70)
                        .cornerRadius(10)
                    }
                }
                .frame(maxWidth: .infinity)
                
            }
            .frame(maxWidth: .infinity)
//            .background(Color(.darkBlueColor))
            .cornerRadius(10)
            
            HStack(spacing: 10){
                
//                Image(uiImage: .ic_Box)
                Image(systemName: isChecked ? "square" : "checkmark.square.fill")
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
        }
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 20){
            
            NavigationLink("", destination: NewsView().toolbar(.hidden, for: .navigationBar), isActive: $goToNextView).isDetailLink(false)
            
            
            Button {
                
                
                let stripeFlowStatus = UserDefaults.standard.string(forKey: "stripeFlowStatus")
                print("stripeFlowStatus ",stripeFlowStatus)
                
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
                else if authorityNumberText.count <= 5 {
                    toast = Toast(style: .error, message: "Driver Authority No. should be between 6 to 10.")
                }
                else if (streetAddr.isEmpty || cityAddr.isEmpty || postalAddr.isEmpty) {
//                else if (streetAddr.isEmpty || cityAddr.isEmpty || countryAddr.isEmpty || postalAddr.isEmpty) {
                    toast = Toast(style: .error, message: "Address Filed cannot be empty.")
                }
                else if driverABNText.isEmpty {
                    toast = Toast(style: .error, message: "ABN field cannot be empty.")
                }
                else if driverABNText.count <= 10 {
                    toast = Toast(style: .error, message: "ABN Should be 11 Digits.")
                }
                else if driverLicenseText.isEmpty {
                    toast = Toast(style: .error, message: "Driver Licence field cannot be empty.")
                }
//                else if stripeFlowStatus != "Completed" {
//                    toast = Toast(style: .error, message: "Verification Flow is not Complete.")
//                }
//                else if frontImageId == "" {
//                    toast = Toast(style: .error, message: "Please Upload Front Driver Licence Image.")
//                }
//                else if backImageId == "" {
//                    toast = Toast(style: .error, message: "Please Upload Back Driver Licence Image.")
//                }
//                else if RepresentativeVC.verifyDocs().stripeIdentityStatus != "Completed" {
//                    toast = Toast(style: .error, message: "Please upload verification documents.")
//                }
                else {
                    apicalled = true
//                    callAddressValidationAPI()
                    callRegisterUserinfoAPI()
                }
               
            } label: {
                Text("Create Account")
                    .font(.custom(.poppinsBold, size: 22))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(.buttonColor))
                    .cornerRadius(30)
            }
        }
    }
    
//    check the user address validation
    func callAddressValidationAPI() {
        
        let userAddress = "\(streetAddr)\(", ")\(cityAddr)\(", ")\(stateAddr)\(", ")\(postalAddr)\(", ")\("Australia")"
        let parameters = "{\n  \"address\": {\n\"addressLines\": [\"\(userAddress)\"]\n  },\n}"
        
        print("address parameters: ",parameters)
        
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://addressvalidation.googleapis.com/v1:validateAddress?key=AIzaSyDvzoBJGEDZ5LpZ002k8JvKfWgnepzwxdc")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            apicalled = false
            
          guard let data = data else {
            print(String(describing: error))
              return
          }
          print(String(data: data, encoding: .utf8)!)
            
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let resultDict = jsonDict["result"] as? [String: Any],
                       let verdict = resultDict["verdict"] as? [String: Any],
                       let validationGranularity = verdict["validationGranularity"] as? String,
                       validationGranularity == "PREMISE" || validationGranularity == "SUB_PREMISE" || validationGranularity == "PREMISE_PROXIMITY" {
                        
                        if let addressDict = resultDict["address"] as? [String: Any],
                        let formattedAddress = addressDict["formattedAddress"] as? String {
                         validateFormattedAddress = formattedAddress
                         print("formattedAddress: ",formattedAddress)
                            apicalled = true
                            
                         callRegisterUserinfoAPI()
                     }
                        else {
                            toast = Toast(style: .error, message: "Address is Fake or Invalid.")
                        }
                    }
                       
                    else {
                        if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                        let errorDict = jsonDict["error"] as? [String: Any],
                           let addressDict = errorDict["message"] as? String{
                            toast = Toast(style: .error, message: addressDict)
                        }else {
                            toast = Toast(style: .error, message: "Address is Fake or Invalid.")
                        }
                    }
                } catch {
                    print("Error parsing JSON: \(error)")
                }
            
            }

        task.resume()
    }
    
//    New user Register on stripe connect account
    func callRegisterUserinfoAPI() {
        Task {
            
            var firstPart = "NA"
            var secondPart = "NA"
            var datePart = "NA"
            var monthPart = "NA"
            var yearPart = "NA"
            var streetAddress = "NA"
            
            let index = userText.components(separatedBy: " ")
            
            if  index.count > 1 {
                firstPart = index[0]
                secondPart = index[1]
            }else {
                 firstPart = userText
                 secondPart = ""
            }
            let dateIndex = dateText.components(separatedBy: "-")
            
            if  dateIndex.count > 1 {
                datePart = dateIndex[0]
                monthPart = dateIndex[1]
                yearPart = dateIndex[2]
            }
            
            let userAddress = "\(streetAddr)\(", ")\(cityAddr)\(", ")\(stateAddr)\(", ")\(postalAddr)\(", ")\("Australia")"
//            let googleAddr = "\(streetAddr)\("%20")\(cityAddr)\("%20")\(stateAddr)\("%20")\(postalAddr)\("%20")\(countryAddr)"
            let addressTextStr = validateFormattedAddress.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            let addrTextStr = addressTextStr.replacingOccurrences(of: "#", with: "%20", options: .literal, range: nil)
            
//            let driverABN = UserDefaults.standard.string(forKey: "driverABN")
            let driverLicence = UserDefaults.standard.string(forKey: "driverLicence")
            let stripeVeriSessionID = UserDefaults.standard.string(forKey: "stripeSessionID")
//            let urlStr = "\(uploadInformationUrl)username=default&userEmail=\(Auth.auth().currentUser?.email ?? "")&firstname=\(firstPart)&day=3&month=10&year=2000&address=\(addrTextStr)&phone=61\(mobileNumberText)&lastname=\(secondPart)&frontimgid=\(frontImageId)&backimgid=\(backImageId)"
            
            var uploadInformatUrl = ""
            if API.App_Envir == "Production" {
                uploadInformatUrl = "https://uvipi4nbv2.execute-api.eu-north-1.amazonaws.com/default/Test?"
            }
            else if API.App_Envir == "Dev" {
                uploadInformatUrl = "https://lojcf2xgmb.execute-api.eu-north-1.amazonaws.com/default/Test?"
            }
            else if API.App_Envir == "Stagging" {
                uploadInformatUrl = "https://koc5ifvqi7.execute-api.eu-north-1.amazonaws.com/default/Test?"
            }else{
                uploadInformatUrl = "https://uvipi4nbv2.execute-api.eu-north-1.amazonaws.com/default/Test?"
            }
            
            let urlCreateAccount = "\(uploadInformatUrl)username=\(firstPart)&userEmail=\(Auth.auth().currentUser?.email ?? "")&firstname=\(firstPart)&lastname=\(secondPart)&day=\(datePart)&month=\(monthPart)&year=\(yearPart)&address=\(streetAddr)&city=\(cityAddr)&state=\(stateAddr)&postalCode=\(postalAddr)&country=\("Australia")&phone=61\(mobileNumberText)&frontimgid=\(stripeVeriSessionID ?? "1234")&abn=\(driverABNText )&driverlicence=\(driverLicenseText)&driverauthority=\(authorityNumberText)&meta-data"
            
            let urlNewAcc :String = urlCreateAccount.replacingOccurrences(of: " ", with: "%20")
            
            print("Create Account url str: ",urlNewAcc)
            
            let url = URL(string: urlNewAcc)
            print("Create Account url: ",url)
            try  await
            completeFormViewModel.postData(url:url!,method:.post,name: userText,phone: mobileNumberText,driverID: authorityNumberText,driverABN: driverABNText)
            apicalled = false
            
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
    
//    Fetch the user current Address
    func getAddressFromLatLong(latitude: Double, longitude : Double){
        
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyDvzoBJGEDZ5LpZ002k8JvKfWgnepzwxdc"
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case let .success(value):
//                print("address value: ",value)
//                let responseJson = response.result.value! as! NSDictionary
                
                if let results = (value as AnyObject).object(forKey: "results")! as? [NSDictionary] {
                    if results.count > 0 {
                        if let addressComponents = results[1]["address_components"]! as? [NSDictionary] {
                            let address = results[0]["formatted_address"] as? String
                            for component in addressComponents {
                                if let temp = component.object(forKey: "types") as? [String] {
                                    if (temp[0] == "route") {
                                        streetAddr = component["long_name"] as? String ?? "N/A"
                                        print("street value: ",streetAddr)
                                    }
                                    if (temp[0] == "postal_code") {
                                        postalAddr = component["long_name"] as? String ?? "N/A"
                                        print("pincode value: ",postalAddr)
                                    }
                                    if (temp[0] == "locality") {
                                        cityAddr = component["long_name"] as? String ?? "N/A"
                                        print("city value: ",cityAddr)
                                    }
                                    if (temp[0] == "administrative_area_level_1") {
                                        stateAddr = component["long_name"] as? String ?? "N/A"
                                        print("state value: ",stateAddr)
                                    }
                                    if (temp[0] == "country") {
                                        countryAddr = component["long_name"] as? String ?? "N/A"
                                        print("country value: ",countryAddr)
                                    }
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func checkVerifyIden() {
        apicalled = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 25){
        let stripeIdentityStatus = UserDefaults.standard.string(forKey: "stripeFlowStatus")
        if stripeIdentityStatus == "Completed" {
            self.verifyIdetityText = "Verification Flow Completed"
        }
        else if stripeIdentityStatus == "Canceled" {
            self.verifyIdetityText = "Verification Flow Canceled"
        }
        else if stripeIdentityStatus == "Failed" {
            self.verifyIdetityText = "Verification Flow Failed"
        }
        else {
            self.verifyIdetityText = "Verify your identity"
        }
//            self._verifyIdetityText = State(initialValue: "Complete Verification")
            print("verify Idetity Text:",verifyIdetityText)
            apicalled = false
        }
    }
    
    
    func GetVerifiedFieldsFromIdentity(reportId: String) {
        
        var urlReqIs = ""
        if API.App_Envir == "Production" {
            urlReqIs = "https://41czhgdl5c.execute-api.eu-north-1.amazonaws.com/default/GetVerifiedFieldsFromIdentity?reportId=\(reportId)"
        }
        else if API.App_Envir == "Dev" {
            urlReqIs = "https://5xublp4eyd.execute-api.eu-north-1.amazonaws.com/default/GetVerifiedFieldsFromIdentity?reportId=\(reportId)"
        }
        else if API.App_Envir == "Stagging" {
            urlReqIs = "https://41czhgdl5c.execute-api.eu-north-1.amazonaws.com/default/GetVerifiedFieldsFromIdentity?reportId=\(reportId)"
        }else{
            urlReqIs = "https://41czhgdl5c.execute-api.eu-north-1.amazonaws.com/default/GetVerifiedFieldsFromIdentity?reportId=\(reportId)"
        }
        
        var request = URLRequest(url: URL(string: urlReqIs)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
              toast = Toast(style: .error, message: "GetVerifiedFieldsFromIdentity - \(error).")
            print(String(describing: error))
            return
          }
          print("GetVerifiedFieldsFromIdentity: ",String(data: data, encoding: .utf8)!)
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    if let firstName = jsonDict["first_name"] as? String,
                        let lastName = jsonDict["last_name"] as? String,
                    let document = jsonDict["address"] as? NSDictionary{
                        print("Success parsing first_name: \(firstName)")
                        print("Success parsing last_name: \(lastName)")
                        
                        let street = document["line1"] as? String
                        let appartment = document["line2"] as? String
                        let city = document["city"] as? String
                        let state = document["state"] as? String
                        let country = document["country"] as? String
                        let postalCode = document["postal_code"] as? String
                        
                        
                        userIdentityDetail.instance.firstName = firstName
                        userIdentityDetail.instance.lastName = lastName
                        userIdentityDetail.instance.Street = street ?? ""
                        userIdentityDetail.instance.appartment = appartment ?? ""
                        userIdentityDetail.instance.city = city ?? ""
                        userIdentityDetail.instance.state = state ?? ""
                        userIdentityDetail.instance.country = country ?? ""
                        userIdentityDetail.instance.postalCode = postalCode ?? ""
                        
                        
                        userText = "\(firstName)\(" ")\(lastName)"
                        streetAddr = "\(street ?? "NA")\(" ")\(appartment ?? "NA")"
                        cityAddr = city ?? "NA"
                        postalAddr = postalCode ?? "NA"
                        stateAddr = state ?? "NA"
                        countryAddr = country ?? "NA"
                    }
                    else {
                        toast = Toast(style: .error, message: "GetVerifiedFieldsFromIdentity - Error status not found: \(error).")
                        print("Error status not found.")
                    }
                }
            }
            catch{
                toast = Toast(style: .error, message: "GetVerifiedFieldsFromIdentity - Error parsing JSON: \(error).")
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }
    
    func GetSensitiveVerifiedFieldsFromIdentity(sessionId: String){
        var urlReqIs = ""
        if API.App_Envir == "Production" {
            urlReqIs = "https://cayqax63tk.execute-api.eu-north-1.amazonaws.com/default/GetSensitiveVerifiedFieldsFromIdentity?sessionId=\(sessionId)"
        }
        else if API.App_Envir == "Dev" {
            urlReqIs = "https://kuvhkqx4b7.execute-api.eu-north-1.amazonaws.com/default/GetSensitiveVerifiedFieldsFromIdentity?sessionId=\(sessionId)"
        }
        else if API.App_Envir == "Stagging" {
            urlReqIs = "https://cayqax63tk.execute-api.eu-north-1.amazonaws.com/default/GetSensitiveVerifiedFieldsFromIdentity?sessionId=\(sessionId)"
        }else{
            urlReqIs = "https://cayqax63tk.execute-api.eu-north-1.amazonaws.com/default/GetSensitiveVerifiedFieldsFromIdentity?sessionId=\(sessionId)"
        }
        print("GetSensitiveVerifiedFieldsFromIdentity urlReq: ",urlReqIs)
        var request = URLRequest(url: URL(string: urlReqIs)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
              toast = Toast(style: .error, message: "GetSensitiveVerifiedFieldsFromIdentity - \(error).")
            print(String(describing: error))
            return
          }
          print("GetSensitiveVerifiedFieldsFromIdentity: ",String(data: data, encoding: .utf8)!)
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    if let driverLicense = jsonDict["documentNumber"] as? String,
                    let document = jsonDict["dateOfBirth"] as? NSDictionary{
                        print("Success parsing documentNumber: \(driverLicense)")
                        
                        let day = document["day"] as? Int
                        let month = document["month"] as? Int
                        let year = document["year"] as? Int
                        print("Success parsing day: \(day)")
                        print("Success parsing month: \(month)")
                        print("Success parsing year: \(year)")
                        
                        userIdentityDetail.instance.driverLicense = driverLicense
                        userIdentityDetail.instance.dateOfBirth = "\(day ?? 00)-\(month ?? 00)-\(year ?? 0000)"
                        
                        
                        dateText = "\(day ?? 00)-\(month ?? 00)-\(year ?? 0000)"
                        driverLicenseText = driverLicense
                    }
                    else {
                        toast = Toast(style: .error, message: "GetSensitiveVerifiedFieldsFromIdentity - Error status not found: \(error).")
                        print("Error status not found.")
                    }
                }
            }
            catch{
                toast = Toast(style: .error, message: "GetSensitiveVerifiedFieldsFromIdentity - Error parsing JSON: \(error).")
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
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
