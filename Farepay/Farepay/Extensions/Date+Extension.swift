//
//  Date+Extension.swift
//  Farepay
//
//  Created by Arslan on 12/09/2023.
//

import Foundation
import SwiftUI

extension Date {
    static var twoDaysBefore: Date { return Date().twoDayBefore }
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var twoDayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
}
