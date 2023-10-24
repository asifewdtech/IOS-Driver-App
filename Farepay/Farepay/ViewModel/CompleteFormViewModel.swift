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
    let db = Firestore.firestore()
    @MainActor
    func postData(url:String,method:Methods)  async throws{
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        
//        request.httpBody = try JSONSerialization.data(withJSONObject: data)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        // Handle the response data
        print("POST request succeeded. Response data: \(String(data: data, encoding: .utf8) ?? "")")
        
        guard let httpResponse = response as? HTTPURLResponse  else {return }
        DispatchQueue.main.async {
            print("statusCode \(httpResponse.statusCode)")
            if httpResponse.statusCode == 200 {
                self.goToAccountScreen = true
            }else {
                self.goToAccountScreen = true
            }
            self.setUserCompleteConnectOnFireStore()
        }
      
        
        
        
        
        

    }
    
    func setUserCompleteConnectOnFireStore()  {
         db.collection("Users").document(Auth.auth().currentUser?.uid ?? "").setData(["isAccountCreated" : true])
        
        
    
        
    }
}


enum Methods:String {
case get = "GET"
case post = "POST"
}
