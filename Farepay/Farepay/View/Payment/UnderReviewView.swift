//
//  UnderReviewView.swift
//  Farepay
//
//  Created by Mursil on 08/01/2024.
//

import SwiftUI
import StripeCore
import StripeIdentity
import Stripe
import Alamofire
import FirebaseAuth
import FirebaseFirestore
import ActivityIndicatorView

struct UnderReviewView: View {
    
    @State private var verifiStatusId: String? = nil
    @State private var verifiReportId: String? = nil
    @State private var verifiFileId1: String? = nil
    @State private var fileIdBit: String? = nil
    @State private var isVerifiSessionId: String? = ""
    @State private var verifiephemeralKeySecret: String? = ""
    @State private var showLoadingIndicator: Bool = false
    @State private var goToHome = false
    @State private var toast: Toast? = nil
    @State var updateStripeDocs = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var willMoveToForm2 = false
    @State private var isPresentedPopUp: Bool = false
    @State private var verificaStatus: String = "Identity verification in progress"
    @State private var verifiMessage: String = "We’re verifying your identity. Please wait and do not exit the application. This may take a few minutes"
    @State private var isButtonActive: Bool = false
    
    var body: some View {
        NavigationView {
            ZStack{
                NavigationLink("", destination: MainTabbedView().toolbar(.hidden, for: .navigationBar), isActive: $goToHome).isDetailLink(false)
                NavigationLink("", destination: Farepay.RepresentativeView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToForm2 ).isDetailLink(false)
                //            NavigationLink("", destination: UnderReviewVC(), isActive: $updateStripeDocs)
                //            NavigationLink("", destination: UnderReviewVC().toolbar(.hidden, for: .navigationBar), isActive: $updateStripeDocs).isDetailLink(false)
                
                Color(.bgColor)
                    .edgesIgnoringSafeArea(.all)
                VStack{
//                    Spacer()
                    Spacer()
                    topArea
                    Spacer()
                    buttonArea
                }
                .padding(.all, 15)
                .toastView(toast: $toast)
                .onAppear(){
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("VerifiResubmitted"), object: nil, queue: .main) { (_) in
                        verificaStatus = "Identity verification in progress"
                        verifiMessage = "We’re verifying your identity. Please wait and do not exit the application. This may take a few minutes"
                        isButtonActive = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 20){
                            getVerificationStatus()
                        }
                    }
                    Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
                        if let error = error {
                            print(error.localizedDescription)
                            
                        }else {
                            
                            guard let snap = snapShot else { return  }
                            
                            DispatchQueue.main.async {
                                let identityReportID = snap.get("identityReportID") as? String
                                isVerifiSessionId = snap.get("sessionID") as? String
                                print("isVerifiSessionId is: \(isVerifiSessionId)")
                                
                                getVerificationStatus()
                            }
                        }
                    }
//                    createSessionStripeIdentity()
                    
                }
                .fullScreenCover(isPresented: $updateStripeDocs) {
                    UnderReviewVC()
                }
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
            .fullScreenCover(isPresented: $isPresentedPopUp) {
                StepsView(presentedAsModal: $isPresentedPopUp)
            }
            .onReceive(NotificationCenter.default.publisher(for: .proceedNext)) { _ in
                print("Received Custom Notification")
                willMoveToForm2.toggle()
            }
        }
//        .environment(\.rootPresentationMode, $goToHome)
//        .environment(\.rootPresentationMode, $willMoveToMainView)
    }
}

struct underReview_Previews: PreviewProvider {
    static var previews: some View {
        UnderReviewView()
    }
}

class userIdentityDetail {
    static let instance = userIdentityDetail()
    var id = ""
    var city = ""
    var country = ""
    var Street = ""
    var appartment = ""
    var postalCode = ""
    var state = ""
    var firstName = ""
    var lastName = ""
    var status = ""
    var dateOfBirth = ""
    var driverLicense = ""
}

extension UnderReviewView{
    
    var topArea: some View{
        VStack {
            HStack {
                Image(uiImage: .underReviewImage)
                    .resizable()
                    .frame(width: 330, height: 268)
            }
            
            HStack {
//                Text("Account being created")
                Text(verificaStatus)
                    .font(.custom(.poppinsBold, size: 24))
                    .foregroundColor(.white)
                    
            }
            
            HStack {
//                Text("We’re setting up your new Farepay account and we can’t wait to be in touch soon as it’s approved.")
                Text(verifiMessage)
                    .font(.custom(.poppinsMedium, size: 13))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    
            }
            .frame(minWidth: 330, maxWidth: 330, minHeight: 40, maxHeight: 80, alignment: .center)
        }
    }
    var buttonArea: some View{
        
        HStack {
                Button(action: {
                    updateStripeDocs.toggle()
                    
                }, label: {
                    Text("Verification Identity Again")
                        .font(.custom(.poppinsBold, size: 20))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(.buttonColor))
                        .cornerRadius(30)
                    
                })
                .opacity(isButtonActive ? 1 : 0)
        }
    }
    
    func createSessionStripeIdentity() {
        showLoadingIndicator = true
        let sessionUrl = "\("https://92tbqakpob.execute-api.eu-north-1.amazonaws.com/default/CreateSessionStripeIdentity")\("")"
        var request = URLRequest(url: URL(string: sessionUrl)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
              toast = Toast(style: .error, message: "createSessionStripeIdentity - \(error)")
            return
          }
          print("createSessionStripeIdentity is: ",String(data: data, encoding: .utf8)!)
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    if let statusDict = jsonDict["verificationSessionId"] as? String {
                        print("Success parsing JSON: \(statusDict)")
                        verifiStatusId = statusDict
                        getVerificationStatus()
                    }
                }
            }
            catch{
                print("Error parsing JSON: \(error)")
                toast = Toast(style: .error, message: "create Session StripeIdentity - \(error)")
            }
        }
        task.resume()
    }
    
    func getVerificationStatus(){
        
        var statusUrl = ""
        if API.App_Envir == "Production" {
            statusUrl = "\("https://xcb4cymcy5.execute-api.eu-north-1.amazonaws.com/default/GetVerificationStatus?sessionId=")\(isVerifiSessionId ?? "")"
        }
        else if API.App_Envir == "Dev" {
            statusUrl = "\("https://r7w9wuoj3m.execute-api.eu-north-1.amazonaws.com/default/GetVerificationStatus?sessionId=")\(isVerifiSessionId ?? "")"
        }
        else if API.App_Envir == "Stagging" {
            statusUrl = "\("https://utmnlv10l8.execute-api.eu-north-1.amazonaws.com/default/GetVerificationStatus?sessionId=")\(isVerifiSessionId ?? "")"
        }else{
            statusUrl = "\("https://xcb4cymcy5.execute-api.eu-north-1.amazonaws.com/default/GetVerificationStatus?sessionId=")\(isVerifiSessionId ?? "")"
        }
         
        print("getVerificationStatus url: ",statusUrl)
        
        var request = URLRequest(url: URL(string: statusUrl)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
              toast = Toast(style: .error, message: "getVerificationStatus - \(error)")
            return
          }
          print("getVerificationStatus is: ",String(data: data, encoding: .utf8)!)
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    if let verifiStatus = jsonDict["status"] as? String{
                        let verifiDict = jsonDict["last_verification_report"] as? String
                        print("Success parsing status: \(verifiStatus)")
                        print("Success parsing id: \(verifiDict)")
                        verifiReportId = verifiDict
                        if verifiStatus == "verified"{
                            verificaStatus = "Identity Verified"
                            verifiMessage = "Congratulations! Your identity is verified. Please wait a while to proceed further."
                            
                            getVerificationReport()
//                            GetVerifiedFieldsFromIdentity(reportId: verifiDict ?? "")
//                            GetSensitiveVerifiedFieldsFromIdentity(sessionId: verifiSessionId ?? "")
                        }
                        else if verifiStatus == "requires_input"{
                            verificaStatus = "Identity Verification Failed"
                            verifiMessage = "We need more input from your side to verify your account. Please click the button below to provide more information."
                            
                            //on docs failure
//                            updateStripeDocs.toggle()
                            isButtonActive = true
                            showLoadingIndicator = false
                            print("Error failed status found.")
                            toast = Toast(style: .error, message: "Verification Status - Documents failed. Please upload  the documents again.")
                        }
                        else if verifiStatus == "processing"{
                            verificaStatus = "Identity Under Processing"
                            verifiMessage = "Your identity under processing. We can't wait to be in touch as soon as it's verified."
                            
                            //on docs async success/failure
                            print("async success status found.")
                            toast = Toast(style: .error, message: "Verification Status - We're verifying your identity and please wait.")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 60){
                                getVerificationStatus()
//                                showLoadingIndicator = false
                            }
                        }
                        else{
                            isButtonActive = true
                            verificaStatus = "Identity Verification Cancel"
                            verifiMessage = "Your Identity is cancel. Please upload your documents again."
//                            updateStripeDocs.toggle()
                            toast = Toast(style: .error, message: "Verification Status - Documents Failed.")
                            print("Error unknown status found.")
                        }
                    }
                    else {
                        toast = Toast(style: .error, message: "Verification Status - Error status not found.")
                        print("Error status not found.")
                    }
                }
            }
            catch{
                toast = Toast(style: .error, message: "Verification Status - Error parsing JSON.")
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }
    
    func getVerificationReport(){
        var reportUrl = ""
        if API.App_Envir == "Production" {
            reportUrl = "\("https://hatll3jthb.execute-api.eu-north-1.amazonaws.com/default/GetVerificationReport?reportId=")\(verifiReportId ?? "")"
        }
        else if API.App_Envir == "Dev" {
            reportUrl = "\("https://vqbsvnw4t6.execute-api.eu-north-1.amazonaws.com/default/GetVerificationReport?reportId=")\(verifiReportId ?? "")"
        }
        else if API.App_Envir == "Stagging" {
            reportUrl = "\("https://twaczzdkw6.execute-api.eu-north-1.amazonaws.com/default/GetVerificationReport?reportId=")\(verifiReportId ?? "")"
        }else{
            reportUrl = "\("https://hatll3jthb.execute-api.eu-north-1.amazonaws.com/default/GetVerificationReport?reportId=")\(verifiReportId ?? "")"
        }
        
        var request = URLRequest(url: URL(string: reportUrl)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
              toast = Toast(style: .error, message: "Verification Report - \(error).")
            print(String(describing: error))
            return
          }
          print("getVerificationReport is: ",String(data: data, encoding: .utf8)!)
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    if let verifiDict = jsonDict["document"] as? [String: Any],
                       let filesDict = verifiDict["files"] as? [Any]{
                        for fileId in filesDict {
                            print("Success parsing JSON: \(fileId)")
                            verifiFileId1 = fileId as? String
                            CreateFileDownloadLink()
                        }
                        print("file 1 id: ",filesDict[0])
//                        verifiFileId1 = filesDict[0] as? String
//                        print("file 2 id: ",filesDict[1])
//                        
//                        CreateFileDownloadLink()
                    }
                }
            }
            catch{
                toast = Toast(style: .error, message: "Verification Report - Error parsing JSON: \(error).")
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }
    
    func CreateFileDownloadLink() {
        
        var fileDownloadUrl = ""
        if API.App_Envir == "Production" {
            fileDownloadUrl = "\("https://q5wc0fwfyd.execute-api.eu-north-1.amazonaws.com/default/CreateFileDownloadLink?fileId=")\(verifiFileId1 ?? "")"
        }
        else if API.App_Envir == "Dev" {
            fileDownloadUrl = "\("https://0glktbsw5a.execute-api.eu-north-1.amazonaws.com/default/CreateFileDownloadLink?fileId=")\(verifiFileId1 ?? "")"
        }
        else if API.App_Envir == "Stagging" {
            fileDownloadUrl = "\("https://qy2ghunp0m.execute-api.eu-north-1.amazonaws.com/default/CreateFileDownloadLink?fileId=")\(verifiFileId1 ?? "")"
        }else{
            fileDownloadUrl = "\("https://q5wc0fwfyd.execute-api.eu-north-1.amazonaws.com/default/CreateFileDownloadLink?fileId=")\(verifiFileId1 ?? "")"
        }
        print("CreateFileDownloadLink url: ",fileDownloadUrl)
        
        var request = URLRequest(url: URL(string: fileDownloadUrl)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
              toast = Toast(style: .error, message: "CreateFileDownloadLink - \(error).")
            print(String(describing: error))
            return
          }
          print("Download File url: ",String(data: data, encoding: .utf8)!)
//            let fileUrl = String(data: data, encoding: .utf8)!
            
            let fileUrl = String(data: data, encoding: .utf8)!
//            uploadIdentityDocument(path: fileUrl, name: "image1")
            
//            do {
//                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
//                    if let fileUrlError = jsonDict["message"] as? String{
//                        print("error: \(fileUrlError)")
//                    }
//                    else{
//                        let fileUrl = String(data: data, encoding: .utf8)!
//                        uploadIdentityDocument(path: fileUrl, name: "image1")
//                    }
//                } else {
//                    print("Image JSON error")
//                }
//            }
//            catch{
//                print("Error parsing JSON: \(error)")
//            }
            
            imageFromUrl(urlString: fileUrl)
//            let fImgUrl = "\("{")\("message")\(":")\("Internal Server Error")\("}")"
//            print("File url str: ", fileUrl)
//            print("File error url str: ", fImgUrl)
//            if fileUrl != fImgUrl {
//                uploadIdentityDocument(path: fileUrl, name: "image1")
//            }
        }
        task.resume()
    }
    
    func imageFromUrl(urlString: String){
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                
                DispatchQueue.main.async { /// execute on main thread
//                    self.imageView.image = UIImage(data: data)
                    print("Image saved")
                    saveImageToDocumentDirectory(image: UIImage(data: data)!)
                }
            }
            task.resume()
        }
    }
    
    func saveImageToDocumentDirectory(image: UIImage ) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = verifiFileId1 ?? "img01" // name of the image to be saved
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 1.0),!FileManager.default.fileExists(atPath: fileURL.path){
            do {
                try data.write(to: fileURL)
                self.loadImageFromDocumentDirectory(nameOfImage: verifiFileId1 ?? "img01")
                print("file saved")
                
//                uploadIdentityDocument(path: fileURL.absoluteString, name: "image003.jpg")
            } catch {
                toast = Toast(style: .error, message: "saveImageToDocumentDirectory - \(error).")
                print("error saving file:", error)
            }
        }
    }
    
    func loadImageFromDocumentDirectory(nameOfImage : String) {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            let image    = UIImage(contentsOfFile: imageURL.path) ?? .image_placeholder
            
//            uploadFileToStripe(image: image, name: verifiSessionId ?? "img01")
            FileUploadonStripe(fileImage: image, name: verifiFileId1 ?? "img01")
            print("file fetched")
//            return image
        }
//        return UIImage.init(named: "image002.jpg")!
    }
    
    
/*    func uploadFileToStripe(image: UIImage, name: String) {
//    func uploadIdentityDocument(path: String, name: String) {
        let debugApiKey = "pk_test_51NIP8NA1ElCzYWXLGk8qzA0KbU0BRdIBv1ILFkC49SnPwXZwT7kBoZa2fJtPLrBGTNGwaPwAaOBztc5HEKlbjOj800fUtGTMCq"
        let productionApiKey = "pk_live_51NIP8NA1ELCzYWXLithoGBwoHpD2Dpqr7E2chyCwqfTeQBVFy710g95XWnmVPT1Wj3Y5jnYKJ@eES2gxiRexpc007xB712LS"
        
        let stripeClient: STPAPIClient
                #if DEBUG
                stripeClient = STPAPIClient(publishableKey: debugApiKey)
                #else
                stripeClient = STPAPIClient(publishableKey: productionApiKey)
                #endif
//        print("fileUrl path: \(path), name: \(name)")
//        // Read the file data
//        let fileData = try! Data(contentsOf: URL(fileURLWithPath: path))
        
        let imageData = image.pngData()! as NSData
        let base64 = imageData.base64EncodedData(options: .lineLength64Characters)
        
        // Create file upload parameters
        let uploadParameters: [String: Any] = [
//            "purpose": "IdentityDocument",
            "file": base64,
            "purpose": STPFilePurpose.identityDocument
//            "file": [
//                "data": fileData,
//                "name": name,
//                "type": "application/octet-stream"
//            ]
        ]
        
        // Stripe file upload request
        let stripeHeaders: HTTPHeaders = [
            "Authorization": "Bearer \(debugApiKey)"
        ]
        print("upload File header: ",stripeHeaders)
        let parameters: [String: Any] = [
            "purpose": "STPFilePurpose.identityDocument"
        ]
        print("upload File params: ",parameters)
        let purpose: STPFilePurpose = .identityDocument
        
        
//        AF.upload(multipartFormData: { multipartFormData in
//            for (key, value) in parameters {
//                if let data = (value as? String)?.data(using: .utf8) {
//                    multipartFormData.append(data, withName: key)
//                }
//            }
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(base64, withName: "file", fileName: name, mimeType: "image/png")
            multipartFormData.append(Data("identity_document".utf8), withName: "purpose")
        }, to: "https://files.stripe.com/v1/files", headers: stripeHeaders, interceptor: nil)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                print("File upload successful: \(value)")
            case .failure(let error):
                print("File upload failed: \(error)")
            }
        }
    }*/
    
    func FileUploadonStripe(fileImage: UIImage, name: String) {
        
//        let imageData = fileImage.pngData()! as NSData
        let base64 = fileImage.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
//        print("File base64: \(base64)")
        let parameters = "{\n  \"image\": \"\(base64)\"\n}"
        
        let postData = parameters.data(using: .utf8)
        var fileUploadUrl = ""
        if API.App_Envir == "Production" {
            fileUploadUrl = "https://1n341a7030.execute-api.eu-north-1.amazonaws.com/default/FilesUploadsOnStripe"
        }
        else if API.App_Envir == "Dev" {
            fileUploadUrl = "https://kv21f5t1kc.execute-api.eu-north-1.amazonaws.com/default/FilesUploadsOnStripe"
        }
        else if API.App_Envir == "Stagging" {
            fileUploadUrl = "https://yifmrd7395.execute-api.eu-north-1.amazonaws.com/default/FilesUploadsOnStripe"
        }else{
            fileUploadUrl = "https://1n341a7030.execute-api.eu-north-1.amazonaws.com/default/FilesUploadsOnStripe"
        }
        
        var request = URLRequest(url: URL(string: fileUploadUrl)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
              toast = Toast(style: .error, message: "FileUploadonStripe - \(error).")
            print(String(describing: error))
            return
          }
          print("Success FileUploadonStripe JSON: \(String(data: data, encoding: .utf8)!)")
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    if let verifiDict = jsonDict["id"] as? String {
                        print("Success FileUploadonStripe id: \(verifiDict)")
                        
                        UserDefaults.standard.set(verifiDict, forKey: "stripeFrontImgId")
//                        Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").updateData(["frontimgid": verifiDict])
                        
                        showLoadingIndicator = false
                        
//                        isPresentedPopUp.toggle()
                        updateIdentityOnFB()
                    }
                    else {
                        toast = Toast(style: .error, message: "FileUploadonStripe - Error id not foud: \(error).")
                        print("Error id not foud.")
                    }
                }
            }
            catch{
                toast = Toast(style: .error, message: "FileUploadonStripe - Error parsing JSON: \(error).")
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }
    
    func updateIdentityOnFB(){
        Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").updateData(["identityVerified": true, "identityReportID":verifiReportId]){ error in
            if let error = error {
                // Fail Response
                print("Error writing document: \(error.localizedDescription)")
            } else {
                // Success Response
                isPresentedPopUp.toggle()
                print("Document successfully written!")
            }
        }
    }
}

struct UnderReviewVC: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeUIViewController(context: Context) -> UIViewController {
        return verifyDocs()
    }
    
    class verifyDocs : UIViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            didTapVerifyButton()
            
//            let stripeSessionID = UserDefaults.standard.string(forKey: "stripeSessionID") ?? ""
//            let stripeEphemeralKeySecret = UserDefaults.standard.string(forKey: "stripeEphemeralKeySecret") ?? ""
//            print("stripeSessionID: ",stripeSessionID)
//            print("stripeEphemeralKeySecret: ",stripeEphemeralKeySecret)
//            
//            self.presentVerificationSheet(verificationSessionId: stripeSessionID, ephemeralKeySecret: stripeEphemeralKeySecret)
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
                    //                    UserDefaults.standard.set("Completed", forKey: "stripeFlowStatus")
                    dismiss(animated: true, completion: nil)
                    Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").updateData(["sessionID": verificationSessionId])
                    NotificationCenter.default.post(name: NSNotification.Name("VerifiResubmitted"), object: nil)
                    UserDefaults.standard.set(verificationSessionId, forKey: "stripeSessionID")
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
