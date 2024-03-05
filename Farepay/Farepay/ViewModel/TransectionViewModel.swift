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
    @Published var arrTransactionRes =  [MyResult1]()
    @Published var apiCall = false
    @MainActor
    func getAllTransection(url:String,method:Methods,account_id:String)  async throws{
        arrTransaction = []
        arrTransactionRes = []
        self.apiCall = true
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        let param = [
            "body": "{\"account_id\" : \"\(account_id)\"}"
        ] as [String:Any]
        
        request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions())


        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        // Handle the response data
        print("POST request succeeded. Response data: \(String(data: data, encoding: .utf8) ?? "")")
        
//        let decoder = JSONDecoder()
//        let places = try decoder.decode(Response12.self, from: data)
//        print(" Response data: ", places)
//        for result11 in places.data1 {
//                          print(result11.id)
//                          print(result11.currency)
//                          print(result11.amount)
//                      }
        
        
        guard let httpResponse = response as? HTTPURLResponse  else {return }
        DispatchQueue.main.async {
            print("statusCode \(httpResponse.statusCode)")
            if httpResponse.statusCode == 200 {
                let decoder = JSONDecoder()
                do {
                    let jsonPetitions = try decoder.decode(transactionModel.self, from: data)
                    for result11 in jsonPetitions.data {
                        print("Loop Response data: ", result11)
                        self.arrTransactionRes.append(result11)
                    }
                    
                    print("JsonPetitions Response data: ", self.arrTransaction)
                }catch{
                    print(error)
                }
                self.apiCall = false

            }else {
                self.apiCall = false 
            }
        }
    }
}

struct Response12: Codable {
    let data: [MyResult]
}
    
struct MyResult: Codable {
    let id:String
    let object:String
    let amount:Int
    let created:Int
    let source_type:String
    let currency:String
}
