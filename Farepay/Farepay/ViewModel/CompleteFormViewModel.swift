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
    
    @Published var errorMsg = ""
    @AppStorage("accountId") var accountId: String = ""
    @AppStorage("email") var email: String = ""
//    var accountId = ""
    
    let db = Firestore.firestore()
    @MainActor
    func postData(url:String,method:Methods,name:String,phone:String, email:String)  async throws{
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
                    self.email = email
                    
                    self.db.collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").setData(["connectAccountCreated" : true,
                                                                                                 "accoundId":self.accountId,
                                                                                                 "userName":name,
                                                                                                 "phonenumber":phone,
                                                                                                          "email": email,
                                                                                                          "bankAdded": false
                                                                                                ])
                   
                    
                } catch {
                    print("errorMsg")
                }
            }else {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {return}
                    print(json)
                    guard let errors = json["error"] as? [String : Any] else {return}
                    
                    guard let raw = errors["raw"] as? [String : Any] else {return}
                    
                    guard let error = raw["message"] as? String else {return}
                    print(error)
                    self.errorMsg = error
                }
                catch {
                    self.errorMsg = "Server Error"
                }
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

                
                self.db.collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").updateData(["bankAdded":true])
                self.goToHomeScreen = true
            }else {
                self.goToHomeScreen = false
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] else {return}
                    print(json)
                    guard let errors = json["error"] as? [String : Any] else {return}
                    
                    guard let raw = errors["raw"] as? [String : Any] else {return}
                    
                    guard let error = raw["message"] as? String else {return}
                    print(error)
                    self.errorMsg = error
                }
                catch {
                    self.errorMsg = "Server Error"
                }
            }
            
        }


    }
    

}


enum Methods:String {
case get = "GET"
case post = "POST"
}
