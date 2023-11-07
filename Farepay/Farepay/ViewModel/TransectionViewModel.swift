//
//  TransectionViewModel.swift
//  Farepay
//
//  Created by Asfand Hafeez on 07/11/2023.
//

import Foundation
import SwiftUI

class TransectionViewModel: ObservableObject {
   @Published var arrTransaction =  [transactionModel]()
    @Published var apiCall = false
    @MainActor
    func getAllTransection(url:String,method:Methods)  async throws{
        arrTransaction = []
        self.apiCall = true
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
//        request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions())


        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        // Handle the response data
        print("POST request succeeded. Response data: \(String(data: data, encoding: .utf8) ?? "")")
        
        guard let httpResponse = response as? HTTPURLResponse  else {return }
        DispatchQueue.main.async {
            print("statusCode \(httpResponse.statusCode)")
            if httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()

                 let jsonPetitions = try? decoder.decode([transactionModel].self, from: data)
                self.arrTransaction = jsonPetitions ?? []
                       
                self.apiCall = false

            }else {
                self.apiCall = false 
            }
            
        }


    }
}
