//
//  APIClient.swift
//  Farepay
//
//  Created by Asfand Hafeez on 24/10/2023.
//

import Foundation

import StripeTerminal

// Example API client class for communicating with your backend
class APIClient: ConnectionTokenProvider {

    // For simplicity, this example class is a singleton
    static let shared = APIClient()
    
    // Fetches a ConnectionToken from your backend
    func fetchConnectionToken(_ completion: @escaping ConnectionTokenCompletionBlock) {
     
    }
}
