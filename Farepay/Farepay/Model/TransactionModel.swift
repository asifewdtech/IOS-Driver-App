//
//  TransactionModel.swift
//  Farepay
//
//  Created by Arslan on 12/09/2023.
//

import UIKit

class transactionModel: NSObject {

    let id = UUID()
    let date: Date
    let transactions: [String]
    
    init(date: Date, transactions: [String]) {
        self.date = date
        self.transactions = transactions
    }
}
