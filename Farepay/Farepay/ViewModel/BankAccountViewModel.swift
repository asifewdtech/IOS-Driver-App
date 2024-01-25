//
//  BankAccountViewModel.swift
//  Farepay
//
//  Created by Asfand Hafeez on 10/11/2023.
//

import Foundation
import SwiftUI

class BankAccountViewModel: ObservableObject {
    @Published var goToAccountScreen = false
    @Published var goToHomeScreen = false
    @Published var bankList = [AccountModel]()
    @Published var arrBankRes =  [AccountModel1]()
    @Published var errorMsg = ""
    @AppStorage("accountId") var accountId: String = ""

    init () {
        Task {
            let param = [
                "ConnectedAccount_id":accountId
                
            ] as [String:Any]
          try await  getBankAccount(url: getBankList, method: .post, param: param)
        }
        
    }
    
    @MainActor
    func getBankAccount(url:String,method:Methods,param:[String:Any])  async throws{
        arrBankRes = []
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        request.httpBody = try JSONSerialization.data(withJSONObject: param, options: JSONSerialization.WritingOptions())

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        // Handle the response data
        print("POST request succeeded. Response data: \(String(data: data, encoding: .utf8) ?? "")")
        
        guard let httpResponse = response as? HTTPURLResponse  else {return }
        DispatchQueue.main.async {
            print("statusCode \(httpResponse.statusCode)")
            if httpResponse.statusCode == 200 {

                
//                do {
                    
                    let decoder = JSONDecoder()
                do {
//                    decoder.keyDecodingStrategy = .convertFromSnakeCase
//                    guard  let jsonPetitions = try? decoder.decode([AccountModel].self, from: data) else {return }
                    let jsonPetitions = try decoder.decode(AccountModel.self, from: data)
                    for result11 in jsonPetitions.data {
//                        self.arrBankRes = result11
                        self.arrBankRes.append(result11)
                    }
                    print(self.arrBankRes)
                       
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
}

