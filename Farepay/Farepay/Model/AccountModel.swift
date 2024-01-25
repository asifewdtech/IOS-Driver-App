//
//  AccountModel.swift
//  Farepay
//
//  Created by Asfand Hafeez on 10/11/2023.
//

import Foundation
import UIKit


struct AccountModel: Codable {
    let data: [AccountModel1]
}

struct AccountModel1: Codable {
    let id:String
    let bank_name:String
    let account_holder_name:String
    let last4:String
}

//struct AccountModel :Codable,Identifiable{
//    let id, object, account, account_holder_name: String
//    let accountHolderType: String
//    let bank_name, country, currency: String
//    let defaultForCurrency: Bool
//    let fingerprint: String
//    let last4: String
//    
//    let routingNumber, status: String
//}

//class AccountModel: NSObject, NSCoding, Identifiable {
//    var id: String!
//    var account_holder_name: String!
//    var bank_name: String!
//    var last4: String!
//    
//
//    func encode(with aCoder: NSCoder) {
//        aCoder.encode(id, forKey: "id")
//        aCoder.encode(account_holder_name, forKey: "account_holder_name")
//        aCoder.encode(bank_name, forKey: "bank_name")
//        aCoder.encode(last4, forKey: "last4")
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        id = aDecoder.decodeObject(forKey: "id") as? String
//        account_holder_name = aDecoder.decodeObject(forKey: "account_holder_name") as? String
//        bank_name = aDecoder.decodeObject(forKey: "bank_name") as? String
//        last4 = aDecoder.decodeObject(forKey: "last4") as? String
//        
//    }
//
//    init(dictionary: NSDictionary) {
//        if let customer = dictionary["data"] as? NSDictionary {
//            id = customer["id"] as? String
//            account_holder_name = customer["account_holder_name"] as? String
//            bank_name = customer["bank_name"] as? String
//            last4 = customer["last4"] as? String
//            
//        }
//    }
//    
//    func save() {
//        let defaults = UserDefaults.standard
//        let data = NSKeyedArchiver.archivedData(withRootObject: self)
//        defaults.set(data, forKey: "SPH.user")
//        defaults.synchronize()
//    }
//
//    func clear() {
//        let defaults = UserDefaults.standard
//        defaults.removeObject(forKey: "SPH.user")
//        defaults.synchronize()
//    }
//}
