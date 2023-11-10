//
//  CurrencyManager.swift
//  Farepay
//
//  Created by Arslan on 14/09/2023.
//

import UIKit

class CurrencyManager: ObservableObject {
    
    @Published var string: String = "0.0"
    private var amount: Decimal = .zero
    private let formatter = NumberFormatter(numberStyle: .currency)
    private var maximum: Decimal = 999_999_999.99
    private var lastValue: String = ""
    
    
    @Published  var totalChargresWithTax = 0.0
    @Published  var totalAmount = 0.0
    @Published  var serviceFee = 0.0
    @Published  var serviceFeeGst = 0.0
    
    init(amount: Decimal, maximum: Decimal = 999_999_999.99, locale: Locale = .current) {
        formatter.locale = locale
//        self.string = formatter.string(for: amount) ?? "$0.00"
        let formattedString = formatter.string(for: amount) ?? "$0.00"
        string = formattedString.replacingOccurrences(of: formatter.currencySymbol, with: "")
        self.lastValue = string
        self.amount = amount
        self.maximum = maximum
    }
    
    func valueChanged(_ value: String) {
        let newValue = (value.decimal ?? .zero) / pow(10, formatter.maximumFractionDigits)
        if newValue > maximum {
            string = lastValue
        } else {
            
//            string = formatter.string(for: newValue) ?? "$0.00"
            let formattedString = formatter.string(for: newValue) ?? "$0.00"
            string = formattedString.replacingOccurrences(of: formatter.currencySymbol, with: "")
            lastValue = string
            
            if let cost = Double(lastValue.trimmingCharacters(in: .whitespaces)) {
                totalAmount = cost
                AmountDetail.instance.totalAmount = cost
                let amountWithFivePercent = cost * 5 / 100
                print("amountWithFivePercent \(amountWithFivePercent)")
                serviceFee = (amountWithFivePercent / 1.1).roundToDecimal(2)
                
                AmountDetail.instance.serviceFee = serviceFee
                print("serviceFee\(serviceFee)")
                
                serviceFeeGst = (amountWithFivePercent - serviceFee).roundToDecimal(2)
                AmountDetail.instance.serviceFeeGst = serviceFeeGst
                print("serviceFeeGst \(serviceFeeGst)")
                totalChargresWithTax = (serviceFee + serviceFeeGst + cost).roundToDecimal(2)
                
                AmountDetail.instance.totalChargresWithTax = totalChargresWithTax
                print("totalCharges \(totalChargresWithTax)")
                
            }
        }
    }
}

extension NumberFormatter {
    
    convenience init(numberStyle: Style, locale: Locale = .current) {
        self.init()
        self.locale = locale
        self.numberStyle = numberStyle
    }
}

extension Character {
    
    var isDigit: Bool { "0"..."9" ~= self }
}

extension LosslessStringConvertible {
    
    var string: String { .init(self) }
}

extension StringProtocol where Self: RangeReplaceableCollection {
    
    var digits: Self { filter (\.isDigit) }
    
    var decimal: Decimal? { Decimal(string: digits.string) }
}


//class CurrencyManager: ObservableObject {
//    
//    @Published var string: String = ""
//    @Published  var amount: Decimal = .zero
//    private let formatter = NumberFormatter(numberStyle: .currency)
//    private var maximum: Decimal = 999_999_999.99
//    private var lastValue: String = ""
//    
//    init(amount: Decimal, maximum: Decimal = 999_999_999.99, locale: Locale = .current) {
//        formatter.locale = locale
////        self.string = formatter.string(for: amount) ?? "$0.00"
//        let formattedString = formatter.string(for: amount) ?? "$0.00"
//        string = formattedString.replacingOccurrences(of: formatter.currencySymbol, with: "")
//        self.lastValue = string
//        self.amount = amount
//        self.maximum = maximum
//    }
//    
//    func valueChanged(_ value: String) {
//        let newValue = (value.decimal ?? .zero) / pow(10, formatter.maximumFractionDigits)
//        if newValue > maximum {
//            string = lastValue
//        } else {
//            
////            string = formatter.string(for: newValue) ?? "$0.00"
//            let formattedString = formatter.string(for: newValue) ?? "$0.00"
//            string = formattedString.replacingOccurrences(of: formatter.currencySymbol, with: "")
//            lastValue = string
//        }
//    }
//}
//
//extension NumberFormatter {
//    
//    convenience init(numberStyle: Style, locale: Locale = .current) {
//        self.init()
//        self.locale = locale
//        self.numberStyle = numberStyle
//    }
//}
//
//extension Character {
//    
//    var isDigit: Bool { "0"..."9" ~= self }
//}
//
//extension LosslessStringConvertible {
//    
//    var string: String { .init(self) }
//}
//
//extension StringProtocol where Self: RangeReplaceableCollection {
//    
//    var digits: Self { filter (\.isDigit) }
//    
//    var decimal: Decimal? { Decimal(string: digits.string) }
//}
