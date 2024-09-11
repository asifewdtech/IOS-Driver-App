//
//  StripeIdentityVerificationView.swift
//  Farepay
//
//  Created by Mursil on 05/09/2024.
//

import SwiftUI
import StripeCore
import StripeIdentity
import Stripe
import Alamofire
import FirebaseAuth
import FirebaseFirestore
import ActivityIndicatorView

struct StripeIdentityVerificationView: View {
    @State private var verifiStatusId: String? = nil
    @State private var verifiReportId: String? = nil
    @State private var verifiFileId1: String? = nil
    @State private var fileIdBit: String? = nil
//    @State private var verifiSessionId: String? = ""
    @State private var verifiephemeralKeySecret: String? = ""
    @State private var showLoadingIndicator: Bool = false
    @State private var goToForm2 = false
    @State private var toast: Toast? = nil
    @State var updateStripeDocs = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        NavigationView {
            ZStack{
                NavigationLink("", destination: RepresentativeView().toolbar(.hidden, for: .navigationBar), isActive: $goToForm2).isDetailLink(false)
                
                Color(.bgColor)
                    .edgesIgnoringSafeArea(.all)
                VStack{
                    topArea
                }
                .toastView(toast: $toast)
                .onAppear(){
                    Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
                        if let error = error {
                            print(error.localizedDescription)
                        }else {
                            
                            guard let snap = snapShot else { return  }
//                            verifiSessionId  = snap.get("sessionID") as? String ?? ""
                        }
                    }
                    createSessionStripeIdentity()
                }
                .fullScreenCover(isPresented: $updateStripeDocs) {
                    StripeIdentityVerificationVC()
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
        }
        .environment(\.rootPresentationMode, $goToForm2)
    }
}

struct stripeIdentityVerification_Previews: PreviewProvider {
    static var previews: some View {
        StripeIdentityVerificationView()
    }
}

extension StripeIdentityVerificationView{
    
    var topArea: some View{
        VStack {
            HStack {
                Image(uiImage: .underReviewImage)
                    .resizable()
                    .frame(width: 330, height: 268)
            }
            
            HStack {
                Text("Identity Under Verification")
                    .font(.custom(.poppinsBold, size: 24))
                    .foregroundColor(.white)
                    
            }
            
            HStack {
                Text("We're verifying your identity and we can't wait to be in touch as soon as it's verified.")
                    .font(.custom(.poppinsMedium, size: 13))
                    .foregroundColor(.gray)
                    
            }
            .frame(minWidth: 330, maxWidth: 330, minHeight: 40, maxHeight: 40, alignment: .center)
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
            }
        }
        task.resume()
    }
    
    func getVerificationStatus(){
        let verifiSessionId = UserDefaults.standard.string(forKey: "stripeSessionID")
        var statusUrl = ""
        if API.App_Envir == "Production" {
            statusUrl = "\("https://xcb4cymcy5.execute-api.eu-north-1.amazonaws.com/default/GetVerificationStatus?sessionId=")\(verifiSessionId ?? "")"
        }
        else if API.App_Envir == "Dev" {
            statusUrl = "\("https://r7w9wuoj3m.execute-api.eu-north-1.amazonaws.com/default/GetVerificationStatus?sessionId=")\(verifiSessionId ?? "")"
        }
        else if API.App_Envir == "Stagging" {
            statusUrl = "\("https://utmnlv10l8.execute-api.eu-north-1.amazonaws.com/default/GetVerificationStatus?sessionId=")\(verifiSessionId ?? "")"
        }else{
            statusUrl = "\("https://xcb4cymcy5.execute-api.eu-north-1.amazonaws.com/default/GetVerificationStatus?sessionId=")\(verifiSessionId ?? "")"
        }
         
        print("getVerificationStatus url: ",statusUrl)
        
        var request = URLRequest(url: URL(string: statusUrl)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
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
                            getVerificationReport()
                        }
                        else if verifiStatus == "requires_input"{
                            //on docs failure
                            updateStripeDocs.toggle()
                            showLoadingIndicator = false
                            print("Error failed status found.")
                        }
                        else if verifiStatus == "processing"{
                            //on docs async success/failure
                            showLoadingIndicator = false
                            print("Error async success status found.")
                        }
                        else{
                            toast = Toast(style: .error, message: "Status not found.")
                            print("Error unknown status found.")
                        }
                    }
                    else {
                        print("Error status not found.")
                    }
                }
            }
            catch{
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
            print(String(describing: error))
            return
          }
          print("Download File url: ",String(data: data, encoding: .utf8)!)
//            let fileUrl = String(data: data, encoding: .utf8)!
            
            let fileUrl = String(data: data, encoding: .utf8)!
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
            print(String(describing: error))
            return
          }
          print("Success FileUploadonStripe JSON: \(String(data: data, encoding: .utf8)!)")
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    if let verifiDict = jsonDict["id"] as? String {
                        print("Success FileUploadonStripe id: \(verifiDict)")
                        
                        UserDefaults.standard.set(verifiDict, forKey: "stripeFrontImgId")
                        Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").updateData(["frontimgid": verifiDict])
                        
                        showLoadingIndicator = false
//                        goToHome = true
                        goToForm2 = true
                    }
                    else {
                        print("Error id not foud.")
                    }
                }
            }
            catch{
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
    }
}

struct StripeIdentityVerificationVC: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}

    func makeUIViewController(context: Context) -> UIViewController {
        return verifyDocs()
    }
    
    class verifyDocs : UIViewController {
        
        override func viewDidLoad() {
            super.viewDidLoad()
            didTapVerifyButton()
            
            UserDefaults.standard.removeObject(forKey: "stripeFlowStatus")
        }
        
        func didTapVerifyButton(){
            var urlRequest = URLRequest(url: URL(string: "https://92tbqakpob.execute-api.eu-north-1.amazonaws.com/default/CreateSessionStripeIdentity")!)
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
                    Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").updateData(["sessionID": verificationSessionId])
                    
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
