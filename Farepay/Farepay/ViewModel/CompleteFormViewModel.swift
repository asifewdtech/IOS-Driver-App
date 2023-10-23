//
//  CompleteFormViewModel.swift
//  Farepay
//
//  Created by Asfand Hafeez on 22/10/2023.
//

import Foundation
import SwiftUI

class CompleteFormViewModel: ObservableObject {
    @Published var goToAccountScreen = false
    
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
                self.goToAccountScreen = false
            }
        }
      
        
        
        
        
        

    }
}


enum Methods:String {
case get = "GET"
case post = "POST"
}
