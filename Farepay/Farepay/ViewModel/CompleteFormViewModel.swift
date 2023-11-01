//
//  CompleteFormViewModel.swift
//  Farepay
//
//  Created by Asfand Hafeez on 22/10/2023.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
class CompleteFormViewModel: ObservableObject {
    @Published var goToAccountScreen = false
    @Published var goToHomeScreen = false
    @AppStorage("accountId") var accountId: String = ""
//    var accountId = ""
    
    let db = Firestore.firestore()
    @MainActor
    func postData(url:String,method:Methods,name:String,phone:String)  async throws{
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        // Handle the response data
        print("POST request succeeded. Response data: \(String(data: data, encoding: .utf8) ?? "")")
        
        guard let httpResponse = response as? HTTPURLResponse  else {return }
        DispatchQueue.main.async {
            print("statusCode \(httpResponse.statusCode)")
            if httpResponse.statusCode == 200 {

                
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {return}
                    guard let account = json["account"] as? [String : Any] else {return}
                    guard let id = account["id"] as? String else {return}
                    self.accountId = id
                    self.goToAccountScreen = true
                    
                    
                    self.db.collection("Users").document(Auth.auth().currentUser?.uid ?? "").setData(["isAccountCreated" : true,
                                                                                                 "accoundId":self.accountId,
                                                                                                 "name":name,
                                                                                                 "phone":phone
                                                                                                ])
                   
                    
                } catch {
                    print("errorMsg")
                }
            }else {
//                self.goToAccountScreen = true
            }
            
        }
      
        
        
        
        
        

    }
    
    @MainActor
    func addBankAccount(url:String,method:Methods,param:[String:Any])  async throws{
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions())

//        request.httpBody = try JSONSerialization.data(withJSONObject: data)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        // Handle the response data
        print("POST request succeeded. Response data: \(String(data: data, encoding: .utf8) ?? "")")
        
        guard let httpResponse = response as? HTTPURLResponse  else {return }
        DispatchQueue.main.async {
            print("statusCode \(httpResponse.statusCode)")
            if httpResponse.statusCode == 200 {

                
                self.db.collection("Users").document(Auth.auth().currentUser?.uid ?? "").updateData(["bankAccced":true])
                self.goToHomeScreen = true
            }else {
                self.goToHomeScreen = false
            }
            
        }


    }
    

}


enum Methods:String {
case get = "GET"
case post = "POST"
}
