//
//  ConfigurationManager.swift
//  Farepay
//
//  Created by Mursil on 24/07/2024.
//

import Foundation

private enum BuildConfiguration {
    enum Error: Swift.Error {
        case missingkey, invalidValue
    }
    static func value<T>(for key: String) throws -> T where T:
    LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingkey
        }
        switch object {
        case let string as String:
            guard let value = T(string) else { fallthrough}
            return value
        default:
            throw Error.invalidValue
        }
    }
}

enum API {
    static var App_Envir: String {
        do {
            
            return try BuildConfiguration.value(for: "App_Envir")
        }
        catch {
            fatalError(error.localizedDescription)
        }
    }
}
