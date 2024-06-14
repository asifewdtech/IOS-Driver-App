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
    @State private var verifiSessionId: String? = ""
    @State private var verifiephemeralKeySecret: String? = ""
    @State private var showLoadingIndicator: Bool = false
    @State private var goToHome = false
    @State private var toast: Toast? = nil
    @State var updateStripeDocs = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    var body: some View {
//        NavigationView {
        ZStack{
            NavigationLink("", destination: MainTabbedView().toolbar(.hidden, for: .navigationBar), isActive: $goToHome).isDetailLink(false)
//            NavigationLink("", destination: UnderReviewVC(), isActive: $updateStripeDocs)
//            NavigationLink("", destination: UnderReviewVC().toolbar(.hidden, for: .navigationBar), isActive: $updateStripeDocs).isDetailLink(false)
            
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
                    verifiSessionId  = snap.get("sessionID") as? String ?? ""
                }
            }
            
            
//            let collectionRef = Firestore.firestore().collection("usersInfo")
//            collectionRef.getDocuments { (snapshot, error) in
//                
//                if let err = error {
//                    debugPrint("error fetching docs: \(err)")
//                } else {
//                    guard let snap = snapshot else {
//                        return
//                    }
//                    for document in snap.documents {
//                        let data = document.data()
//                            
////                            DispatchQueue.main.async {
//                                print("error: ", error?.localizedDescription)
//                                //
//                                verifiSessionId = data["sessionID"] as? String ?? ""
//                        print("FB verifiSessionId: ",verifiSessionId)
//                                createSessionStripeIdentity()
////                            }
//                        }
//                }
//            }
            
//            CreateFileDownloadLink()
            createSessionStripeIdentity()
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
        .environment(\.rootPresentationMode, $goToHome)
    }
}

struct underReview_Previews: PreviewProvider {
    static var previews: some View {
        UnderReviewView()
    }
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
                Text("Account being created")
                    .font(.custom(.poppinsBold, size: 24))
                    .foregroundColor(.white)
                    
            }
            
            HStack {
                Text("We’re setting up your new Farepay account and we can’t wait to be in touch soon as it’s approved.")
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
        let statusUrl = "\("https://utmnlv10l8.execute-api.eu-north-1.amazonaws.com/default/GetVerificationStatus?sessionId=")\(verifiSessionId ?? "")"
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
        let reportUrl = "\("https://twaczzdkw6.execute-api.eu-north-1.amazonaws.com/default/GetVerificationReport?reportId=")\(verifiReportId ?? "")"
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
        let fileDownloadUrl = "\("https://qy2ghunp0m.execute-api.eu-north-1.amazonaws.com/default/CreateFileDownloadLink?fileId=")\(verifiFileId1 ?? "")"
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
        
        let imageData = fileImage.pngData()! as NSData
        let base64 = fileImage.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
        print("File base64: \(base64)")
        let parameters = "{\n  \"image\": \"\(base64)\"\n}"
        
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://yifmrd7395.execute-api.eu-north-1.amazonaws.com/default/FilesUploadsOnStripe")!,timeoutInterval: Double.infinity)
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
                        goToHome = true
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
