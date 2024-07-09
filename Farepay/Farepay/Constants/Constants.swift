//
//  Constants.swift
//  Farepay
//
//  Created by Arslan on 13/09/2023.
//

import Foundation
import SwiftUI

enum FocusPin {
    case  pinOne, pinTwo, pinThree, pinFour
}


let imageUploadStripeUrl = "https://yf476ojrmb.execute-api.eu-north-1.amazonaws.com/default/FileUploadFromStripe"
let uploadInformationUrl = "https://koc5ifvqi7.execute-api.eu-north-1.amazonaws.com/default/Test?" //General
//let uploadInformationUrl = "https://lojcf2xgmb.execute-api.eu-north-1.amazonaws.com/default/Test?" //Test
let addBankAccountUrl = "https://eqhs4ooew2.execute-api.eu-north-1.amazonaws.com/default/CreateBankAccount" //General
//let addBankAccountUrl = "https://mtp8jkyhyc.execute-api.eu-north-1.amazonaws.com/default/CreateBankAccount" //Test

let weeklyTransection = "https://4zuaerxbi8.execute-api.eu-north-1.amazonaws.com/default/FetchTransactionsThisWeek"
let todayTransection = "https://grmekt3mra.execute-api.eu-north-1.amazonaws.com/default/TransctionFilters"
let threeMonthlyTransection = "https://lset9smj75.execute-api.eu-north-1.amazonaws.com/default/FetchTransactions3Months"

let getBankList = "https://sfr1m5jk5l.execute-api.eu-north-1.amazonaws.com/default/RetriveBankAccount"
