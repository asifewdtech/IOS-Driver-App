//
//  TransactionModel.swift
//  Farepay
//
//  Created by Mursil on 12/09/2023.
//

import UIKit

//class transactionModel: NSObject {
//
//    let id = UUID()
//    let date: Date
//    let transactions: [String]
//    
//    init(date: Date, transactions: [String]) {
//        self.date = date
//        self.transactions = transactions
//    }
//}


//struct transactionModel:Codable {
//    let id:String
//    let object:String
//    let amount:Int
//    let created:Int
//    let source_type:String
//    let currency:String
//}


struct transactionModel: Codable {
    let data: [MyResult1]
    
}

struct MyResult1: Codable {
    let id:String?
    let object:String?
    let amount:Int?
    let created:Int?
    let source_type:String?
    let currency:String?
    let source_transaction:String?
    let destination:String?
    let metadata: metaData?
}

struct metaData: Codable {
    let Address: String?
    let TaxiId: String?
}
