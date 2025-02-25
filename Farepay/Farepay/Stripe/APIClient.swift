//
//  APIClient.swift
//  Farepay
//
//  Created by Mursil on 24/10/2023.
//

import Foundation

import StripeTerminal

class APIClient: ConnectionTokenProvider {
static let shared = APIClient()

//static let backendUrl1 = URL(string: "https://0una8ouowh.execute-api.eu-north-1.amazonaws.com/default/CreateConnectionTokenStripe")! //General
//    static let backendUrl1 = URL(string: "https://1tntu2xw2l.execute-api.eu-north-1.amazonaws.com/default/CreateConnectionTokenStripe")! //Test
//static let backendUrl = URL(string: "https://ro20hmkti4.execute-api.eu-north-1.amazonaws.com/default/capturePaymentIntent")! //Not Used

func fetchConnectionToken(_ completion: @escaping ConnectionTokenCompletionBlock) {
    
    var fetchStripeToken = ""
    if API.App_Envir == "Production" {
        fetchStripeToken = "https://pdz0ljelt3.execute-api.eu-north-1.amazonaws.com/default/CreateConnectionTokenStripe"
    }
    else if API.App_Envir == "Dev" {
        fetchStripeToken = "https://1tntu2xw2l.execute-api.eu-north-1.amazonaws.com/default/CreateConnectionTokenStripe"
    }
    else if API.App_Envir == "Stagging" {
        fetchStripeToken = "https://0una8ouowh.execute-api.eu-north-1.amazonaws.com/default/CreateConnectionTokenStripe"
    }else{
        fetchStripeToken = "https://pdz0ljelt3.execute-api.eu-north-1.amazonaws.com/default/CreateConnectionTokenStripe"
    }
    let urlStripeToken = URL(string: fetchStripeToken)!
    
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let url = urlStripeToken //URL(string: "/connection_token", relativeTo: APIClient.backendUrl1)!
    print("URL1: ",url)
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    
    let task = session.dataTask(with: request) { (data, response, error) in
        if let data = data {
            do {
                // Warning: casting using 'as? [String: String]' looks simpler, but isn't safe:
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print("Stripe JSON: ",json)
                if let secret = json?["secret"] as? String {
//                        completion("pk_test_51NIP8NA1ElCzYWXLGk8qzA0KbU0BRdIBv1ILFkC49SnPwXZwT7kBoZa2fJtPLrBGTNGwaPwAaOBztc5HEKlbjOj800fUtGTMCq", nil)
                    completion(secret, nil)
                } else {
                    let error = NSError(domain: "com.stripe-terminal-ios.example",
                                        code: 2000,
                                        userInfo: [NSLocalizedDescriptionKey: "Missing 'secret' in ConnectionToken JSON response"])
                    completion(nil, error)
                }
            } catch {
                completion(nil, error)
            }
        } else {
            let error = NSError(domain: "com.stripe-terminal-ios.example",
                                code: 1000,
                                userInfo: [NSLocalizedDescriptionKey: "No data in response from ConnectionToken endpoint"])
            completion(nil, error)
        }
    }
    task.resume()
}

func capturePaymentIntent(_ paymentIntentId: String, completion: @escaping ErrorCompletionBlock) {
    completion(nil)
    /*let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
    let url = URL(string: "/capture_payment_intent", relativeTo: APIClient.backendUrl)!

    let parameters = "{\"payment_intent_id\": \"\(paymentIntentId)\"}"

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    request.httpBody = parameters.data(using: .utf8)

    let task = session.dataTask(with: request) {(data, response, error) in
        if let response = response as? HTTPURLResponse, let data = data {
            switch response.statusCode {
            case 200..<300:
                completion(nil)
            case 402:
                let description = String(data: data, encoding: .utf8) ?? "Failed to capture payment intent"
                completion(NSError(domain: "com.stripe-terminal-ios.example", code: 2, userInfo: [NSLocalizedDescriptionKey: description]))
            default:
                completion(error ?? NSError(domain: "com.stripe-terminal-ios.example", code: 0, userInfo: [NSLocalizedDescriptionKey: "Other networking error encountered."]))
            }
        } else {
            completion(error)
        }
    }
    task.resume()*/
}
}
