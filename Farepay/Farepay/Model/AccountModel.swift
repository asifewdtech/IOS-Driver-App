//
//  AccountModel.swift
//  Farepay
//
//  Created by Asfand Hafeez on 10/11/2023.
//

import Foundation




struct AccountModel :Codable,Identifiable{
    let id, object, account, accountHolderName: String
    let accountHolderType: String
    let bankName, country, currency: String
    let defaultForCurrency: Bool
    let fingerprint: String
    let last4: String
    
    let routingNumber, status: String
}
