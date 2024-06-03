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

struct UnderReviewView: View {
    
    @State private var verifiStatusId: String? = nil
    @State private var verifiReportId: String? = nil
    @State private var verifiFileId1: String? = nil
    @State private var verifiFileId2: String? = nil
    @State private var verifiSessionId: String? = ""
    
    var body: some View {
        
        ZStack{
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
                topArea
        }
        .onAppear(){
            Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
                if let error = error {
                    print(error.localizedDescription)
                }else {
                    
                    guard let snap = snapShot else { return  }
                    verifiSessionId  = snap.get("sessionID") as? String ?? ""
                }
            }
            
//            CreateFileDownloadLink()
            createSessionStripeIdentity()
        }
    }
}

//#Preview {
//    UnderReviewView()
//}
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
                    if let verifiDict = jsonDict["last_verification_report"] as? String {
                        print("Success parsing JSON: \(verifiDict)")
                        verifiReportId = verifiDict
                        getVerificationReport()
                    }
                    else {
                        print("Error last_verification_report not foud.")
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
                        }
                        print("file 1 id: ",filesDict[0])
                        verifiFileId1 = filesDict[0] as? String
//                        print("file 2 id: ",filesDict[1])
                        
                        CreateFileDownloadLink()
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
            
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    if let fileUrlError = jsonDict["message"] as? String{
                        print("error: \(fileUrlError)")
                    }
                    else{
                        let fileUrl = String(data: data, encoding: .utf8)!
                        uploadIdentityDocument(path: fileUrl, name: "image1")
                    }
                } else {
                    print("Image JSON error")
                }
            }
            catch{
                print("Error parsing JSON: \(error)")
            }
            
//            imageFromUrl(urlString: fileUrl)
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
//                    saveImageToDocumentDirectory(image: UIImage(data: data)!)
                }
            }
            task.resume()
        }
    }
    
/*    func saveImageToDocumentDirectory(image: UIImage ) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "image001.jpg" // name of the image to be saved
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 1.0),!FileManager.default.fileExists(atPath: fileURL.path){
            do {
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            let image    = UIImage(contentsOfFile: imageURL.path)
            return image!
        }
        return UIImage.init(named: "default.png")!
    }
    */
    
    
    
//    private func uploadFileToStripe(file: URL) {
//        let debugApiKey = "sk_test_4eC39HqLyjWDarjtT1zdp7dc"
//        let productionApiKey = "sk_live_xxx"
//        
//        
//        // Initialize the Stripe object based on the build configuration
//        #if DEBUG
//        let stripeObj: () = StripeAPI.defaultPublishableKey = debugApiKey
//        #else
//        let stripe = StripeAPI.defaultPublishableKey = productionApiKey
//        #endif
//        
//        Stripe.filecrea
//        stripeObj.createFile(
//            fileURL: file,
//            purpose: .identityDocument,
//            completion: { result in
//                switch result {
//                case .success(let stripeFile):
//                    // File upload succeeded
//                    DispatchQueue.main.async {
//                        self.fileUploadResult.value = .success(stripeFile)
//                    }
//                case .failure(let error):
//                    // File upload failed
//                    DispatchQueue.main.async {
//                        self.fileUploadResult.value = .failure(error)
//                    }
//                }
//            }
//        )
//    }
//    
//    
//    func uploadFileToStripe123(fileURL: URL) {
//        // Determine the Stripe configuration (test or live)
//        let stripeClient: STPAPIClient
//        #if DEBUG
//        stripeClient = STPAPIClient(publishableKey: "your_test_publishable_key")
//        #else
//        stripeClient = STPAPIClient(publishableKey: "your_live_publishable_key")
//        #endif
//
//        // Create the file parameters
//        let fileParams = STPFileParams(file: fileURL, purpose: .identityDocument)
//        
//        // Upload the file to Stripe
//        stripeClient.upload(fileParams, completion: { (result, error) in
//            if let error = error {
//                // Handle the error
//                print("File upload failed: \(error.localizedDescription)")
//                // Post failure result if needed
//                // NotificationCenter.default.post(name: .fileUploadResult, object: Result.failure(error))
//            } else if let result = result {
//                // Handle the success
//                print("File upload succeeded: \(result)")
//                // Post success result if needed
//                // NotificationCenter.default.post(name: .fileUploadResult, object: Result.success(result))
//            }
//        })
//    }
    
    
    func uploadIdentityDocument(path: String, name: String) {
        let debugApiKey = "pk_test_51NIP8NA1ElCzYWXLGk8qZAOKbUOBRdIBv1ILFkC49SnPwXZwT7kBoZa2fJtPLBGTNGwaPwAa0Bztc5HEKLbjOj800fUtGTMCq"
        let productionApiKey = "pk_live_51NIP8NA1ELCzYWXLithoGBwoHpD2Dpqr7E2chyCwqfTeQBVFy710g95XWnmVPT1Wj3Y5jnYKJ@eES2gxiRexpc007xB712LS"
        
        let stripeClient: STPAPIClient
                #if DEBUG
                stripeClient = STPAPIClient(publishableKey: debugApiKey)
                #else
                stripeClient = STPAPIClient(publishableKey: productionApiKey)
                #endif
        
        // Read the file data
        let fileData = try! Data(contentsOf: URL(fileURLWithPath: path))
        
        // Create file upload parameters
        let uploadParameters: [String: Any] = [
            "purpose": "identity_document",
            "file": [
                "data": fileData,
                "name": name,
                "type": "application/octet-stream"
            ]
        ]
        
        // Stripe file upload request
        let stripeHeaders: HTTPHeaders = [
            "Authorization": "Bearer \(stripeClient)"
        ]
        print("upload File header: ",stripeHeaders)
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileData, withName: "file", fileName: name, mimeType: "application/octet-stream")
        }, to: "https://files.stripe.com/v1/files", headers: stripeHeaders, interceptor: nil)
        .responseJSON { response in
            switch response.result {
            case .success(let value):
                print("File upload successful: \(value)")
            case .failure(let error):
                print("File upload failed: \(error)")
            }
        }
    }
}
