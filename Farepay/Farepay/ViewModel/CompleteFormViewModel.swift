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
import UIKit
import Alamofire

class CompleteFormViewModel: ObservableObject {
    @Published var goToAccountScreen = false
    @Published var goToHomeScreen = false
    
    @Published var errorMsg = ""
    @AppStorage("accountId") var accountId: String = ""
    @AppStorage("email") var email: String = ""
//    var accountId = ""
    
    let db = Firestore.firestore()
    @MainActor
    func postData(url:URL,method:Methods,name:String,phone:String,driverID:String,driverABN:String)  async throws{
        print("url is: ",url)
//        guard let url = URL(string: url) else {
//            throw URLError(.badURL)
//        }
        
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
                    self.email = Auth.auth().currentUser?.email ?? ""
                    
                    self.db.collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").setData(["connectAccountCreated" : true,
                                                                                                 "accoundId":self.accountId,
                                                                                                 "userName":name,
                                                                                                 "phonenumber":"\("+61")\(phone)",
                                                                                                          "email": self.email,
                                                                                                          "bankAdded": false,
                                                                                                          "driverID": driverID,
                                                                                                          "driverABN":driverABN
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
    
//    @MainActor
//    func getAddressFromLatLong(latitude: Double, longitude : Double){
//        @State var streetAddr: String!
//        @State var countryAddr: String!
//        @State var cityAddr: String!
//        @State var stateAddr: String!
//        @State var postalAddr: String!
//        
//        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyDvzoBJGEDZ5LpZ002k8JvKfWgnepzwxdc"
//        
//        AF.request(url).validate().responseJSON { response in
//            switch response.result {
//            case let .success(value):
//                print("address value: ",value)
////                let responseJson = response.result.value! as! NSDictionary
//                
//                if let results = (value as AnyObject).object(forKey: "results")! as? [NSDictionary] {
//                    if results.count > 0 {
//                        if let addressComponents = results[0]["address_components"]! as? [NSDictionary] {
//                            let address = results[0]["formatted_address"] as? String
//                            for component in addressComponents {
//                                if let temp = component.object(forKey: "types") as? [String] {
//                                    if (temp[0] == "street_number") {
//                                        streetAddr = component["long_name"] as? String
//                                        print("street value: ",streetAddr)
//                                    }
//                                    if (temp[0] == "postal_code") {
//                                        postalAddr = component["long_name"] as? String
//                                        print("pincode value: ",postalAddr)
//                                    }
//                                    if (temp[0] == "locality") {
//                                        cityAddr = component["long_name"] as? String
//                                        print("city value: ",cityAddr)
//                                    }
//                                    if (temp[0] == "administrative_area_level_1") {
//                                        stateAddr = component["long_name"] as? String
//                                        print("state value: ",stateAddr)
//                                    }
//                                    if (temp[0] == "country") {
//                                        countryAddr = component["long_name"] as? String
//                                        print("country value: ",countryAddr)
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
    
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
