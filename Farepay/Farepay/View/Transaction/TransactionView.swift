//
//  TransactionView.swift
//  Farepay
//
//  Created by Arslan on 04/09/2023.
//

import SwiftUI
import ActivityIndicatorView
import UniformTypeIdentifiers
import Alamofire
import CoreLocation

struct TransactionView: View {
    //MARK: - Variables
    @Binding var presentSideMenu: Bool
    @State var transactionType: String = "History"
    @State var isExporting = false
    @State private var showingOptions = false
    @State private var selection = "None"
    @StateObject var  transectionViewModel = TransectionViewModel()
    @State private var isPresentedExport: Bool = false
    @State var willMoveToTransactionDetailView: Bool = false
    @State var transactions: MyResult1?
    @State private var csvFile: String = ""
    @State private var showShareSheet = false
    @AppStorage("accountId") var accountId: String = ""
    @State private var dropdownlbl: String = "1 Week"
    @State var weeklyTransection: String = ""
    @State var todayTransection: String = ""
    @State var threeMonthlyTransection: String = ""
    @State var lifeTimeTransection: String = ""
    @State private var userAddress: String = ""
    @State var locManager = CLLocationManager()
    @AppStorage("accountId") private var appAccountId: String = ""
    
    //MARK: - Views
    var body: some View {
        
        ZStack {
            ZStack{
                if let transactions = transactions {
                    NavigationLink("", destination: TransactionDetailView(transactionType: transactions).toolbar(.hidden, for: .navigationBar), isActive: $willMoveToTransactionDetailView ).isDetailLink(false)
                }
                Color(.bgColor).edgesIgnoringSafeArea(.all)
                VStack(spacing: 25){
                    topArea
                    Spacer()
                    listView
                    Spacer()
                }
                .onAppear(perform: {
                    print("appAccountId: ",appAccountId)
                    if API.App_Envir == "Production" {
                        weeklyTransection = "https://96ezrwsgj5.execute-api.eu-north-1.amazonaws.com/default/FetchTransactionsThisWeek"
                        todayTransection = "https://kmmtbm0rte.execute-api.eu-north-1.amazonaws.com/default/TransctionFilters"
                        threeMonthlyTransection = "https://oluufhjc1g.execute-api.eu-north-1.amazonaws.com/default/FetchTransactions3Months"
                        lifeTimeTransection = "https://kpi4pdf421.execute-api.eu-north-1.amazonaws.com/default/FetchTransactions"
                    }
                    else if API.App_Envir == "Dev" {
                        weeklyTransection = "https://x02ddaa9ca.execute-api.eu-north-1.amazonaws.com/default/FetchTransactionsThisWeek"
                        todayTransection = "https://vdyw74ja9a.execute-api.eu-north-1.amazonaws.com/default/TransctionFilters"
                        threeMonthlyTransection = "https://04ko8qhlhd.execute-api.eu-north-1.amazonaws.com/default/FetchTransactions3Months"
                        lifeTimeTransection = "https://v5z0r5d2h6.execute-api.eu-north-1.amazonaws.com/default/FetchTransactions"
                    }
                    else if API.App_Envir == "Stagging" {
                        weeklyTransection = "https://4zuaerxbi8.execute-api.eu-north-1.amazonaws.com/default/FetchTransactionsThisWeek"
                        todayTransection = "https://grmekt3mra.execute-api.eu-north-1.amazonaws.com/default/TransctionFilters"
                        threeMonthlyTransection = "https://lset9smj75.execute-api.eu-north-1.amazonaws.com/default/FetchTransactions3Months"
                        lifeTimeTransection = "https://cr5q5qoocb.execute-api.eu-north-1.amazonaws.com/default/FetchTransactions"
                    }else{
                        weeklyTransection = "https://96ezrwsgj5.execute-api.eu-north-1.amazonaws.com/default/FetchTransactionsThisWeek"
                        todayTransection = "https://kmmtbm0rte.execute-api.eu-north-1.amazonaws.com/default/TransctionFilters"
                        threeMonthlyTransection = "https://oluufhjc1g.execute-api.eu-north-1.amazonaws.com/default/FetchTransactions3Months"
                        lifeTimeTransection = "https://kpi4pdf421.execute-api.eu-north-1.amazonaws.com/default/FetchTransactions"
                    }
                    
                    Task {
                        try await transectionViewModel.getAllTransection(url: weeklyTransection, method: .post, account_id: accountId)
                        
                    }
                    UserDefaults.standard.removeObject(forKey: "fareAddress")
                })
                
                
                .onChange(of: transectionViewModel.apiCall, perform: { newValue in
                    
                    
                    if let csv = transectionViewModel.arrTransaction.toCSV() {
                        //                            print(csv)
                        
                        csvFile = csv
                        print("csvFile22: ",csvFile)
                        
                        //                        if let fileURL = saveCSVStringToFile(csv, filename: "data.csv") {
                        //                            csvURL = fileURL
                        //
                        //                            print(csvURL)
                        //
                        //
                        //                        }
                    }
                    
                })
                .padding(.all, 15)
            }
            
            if transectionViewModel.apiCall{
                VStack{
                    ActivityIndicatorView(isVisible: $transectionViewModel.apiCall, type: .growingArc(.white, lineWidth: 5))
                        .frame(width: 50.0, height: 50.0)
                        .foregroundColor(.white)
                        .padding(.top, 350)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView(presentSideMenu: .constant(false))
    }
}

extension TransactionView{
    
    var topArea: some View{
        
        VStack(spacing: 30){
            HStack(spacing: 20){
                
                Image(uiImage: .menuIcon)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .onTapGesture {
                        
                        presentSideMenu.toggle()
                    }
                Text("Transactions")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                Spacer()
            }
            
            VStack(spacing: 10){
                HStack{
                    Text(transactionType)
                        .font(.custom(.poppinsSemiBold, size: 23))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    Spacer()
                    HStack(spacing: 15){
                        Text("Export")
                            .font(.custom(.poppinsMedium, size: 20))
                            .foregroundColor(.white)
                            .frame(width: 110, height: 50)
                            .background(Color(.buttonColor))
                            .cornerRadius(10)
                            .onTapGesture {
                                
                                isExporting = true
                                
                                //                                DispatchQueue.main.async {
                                //                                    showShareSheet.toggle()
                                //                                }
                                //
                            }
                        
                        //                            .sheet(isPresented: $showShareSheet) {
                        //                                           if let url = csvURL {
                        //                                               ShareSheet(fileURL: url)
                        //                                           }
                        //                                       }
                        //                            .fullScreenCover(isPresented: $isPresentedExport) {
                        //                                ExportPopUpView(presentedAsModal: $isPresentedExport)
                        //                            }
                            .fileExporter(isPresented: $isExporting, document: CSVFile(initialText: csvFile), contentType: UTType.commaSeparatedText) { result in
                                
                            }
                        
                        Button {
                            showingOptions = true
                        } label: {
                            let width = dropdownlbl.widthOfString(usingFont: UIFont(name: .poppinsMedium, size: 15)!) + 20.0
                            Text("\(dropdownlbl)  \(Image(systemName: "chevron.down"))")
                                .font(.custom(.poppinsMedium, size: 12))
                                .foregroundColor(.white)
                                .frame(width: width, height: 50)
                                .padding(.horizontal)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(.darkGrayColor), lineWidth: 2)
                                )
                        }
                        
                        
                        
                    }
                }
                Color(.darkGrayColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 2)
            }
        }
        .confirmationDialog("Select", isPresented: $showingOptions) {
            Button("Today") {
                
                dropdownlbl = "Today"
                Task {
                    try await transectionViewModel.getAllTransection(url: todayTransection, method: .post, account_id: accountId)
                }
            }
            
            Button("This Week") {
                
                dropdownlbl = "1 Week"
                
                Task {
                    try await transectionViewModel.getAllTransection(url: weeklyTransection, method: .post, account_id: accountId)
                }
            }
            
            Button("Last 3 Months") {
                dropdownlbl = "3 Months"
                Task {
                    try await transectionViewModel.getAllTransection(url: threeMonthlyTransection, method: .post, account_id: accountId)
                }
            }
            
            Button("Lifetime Transactions") {
                dropdownlbl = "All"
                print("All")
                Task {
                    try await transectionViewModel.getAllTransection(url: lifeTimeTransection, method: .post, account_id: accountId)
                }
            }
        }
        
    }
    func saveCSVStringToFile(_ csvString: String, filename: String) -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = paths[0].appendingPathComponent(filename)
        
        do {
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
            return fileURL
        } catch {
            print("Error saving file: \(error)")
            return nil
        }
    }
    
    var listView: some View{
        
        VStack{
        
            if (transectionViewModel.arrTransactionRes.count == 0) {
                VStack(alignment: .center, spacing: 200){
                Text("No Record Found")
                    .font(.custom(.poppinsMedium, size: 25))
                    .foregroundColor(Color(.darkGrayColor))
                    .multilineTextAlignment(.center)
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 10) {
                //                ForEach(transectionViewModel.arrTransaction, id: \.id) { transaction in
                
                //                    HStack{
                //                        Text(formatDate(Date.now)
                //                            .font(.custom(.poppinsBold, size: 22))
                //                            .foregroundColor(.white)
                //                        Spacer()
                //                    }
                //                    .frame(maxWidth: .infinity)
                //                    .padding([.top, .bottom], 5)
                //
                
                
                    ForEach(transectionViewModel.arrTransactionRes, id: \.id) { trans in
                        
                        VStack(spacing: 5){
                            Group{
                                HStack{
                                    Text(trans.metadata.Address)
//                                    Text(userAddress)
                                        .font(.custom(.poppinsSemiBold, size: 20))
                                        .foregroundColor(.white)
                                    Spacer()
//                                    Text("$\(Double( trans.amount) / 100)".description)
                                    Text("$\(excldeFareTaxes(fareAmount: trans.amount))".description)
                                        .font(.custom(.poppinsSemiBold, size: 20))
                                        .foregroundColor(.white)
                                }
                                HStack{
//                                    Text(dateToString(date:Date(timeIntervalSince1970: TimeInterval(trans.created))))
                                    Text("\(convertUnixTimestamp(trans.created))".description)
                                        .font(.custom(.poppinsMedium, size: 12))
                                        .foregroundColor(Color(.darkGrayColor))
                                    Spacer()
                                    //                                Text(trans.currency)
                                    Text("Fare")
                                        .font(.custom(.poppinsMedium, size: 15))
                                        .foregroundColor(Color(.darkGrayColor))
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(Color(.darkBlueColor))
                        .cornerRadius(10)
                        .onTapGesture {
                            transactions = trans
                            willMoveToTransactionDetailView.toggle()
                        }
                    }
                    
                    Spacer().frame(height: 10)
                }
            }
            }
        }
    }
    
    func convertUnixTimestamp(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMM yyyy, hh:mm a"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    func excldeFareTaxes(fareAmount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .decimal
        
        let amount = Double( fareAmount) / 100
            let totalAmount = amount
//        print("totalAmount: \(amount)")
        
            let amountWithFivePercent = amount * 5 / 100
//            print("amountWithFivePercent \(amountWithFivePercent)")
            let serviceFee = (amountWithFivePercent / 1.1).roundToDecimal(2)
            
            AmountDetail.instance.serviceFee = serviceFee
//            print("serviceFee\(serviceFee)")
            
            let serviceFeeGst = (amountWithFivePercent - serviceFee).roundToDecimal(2)
            AmountDetail.instance.serviceFeeGst = serviceFeeGst
//            print("serviceFeeGst \(serviceFeeGst)")
            let totalChargresWithTax = (serviceFee + serviceFeeGst + amount).roundToDecimal(2)
            
            AmountDetail.instance.totalChargresWithTax = String(totalAmount) //String(totalChargresWithTax)
//            print("totalCharges \(totalChargresWithTax)")
            
        let totalFareAmount = (amount - serviceFee - serviceFeeGst).roundToDecimal(2)
        let qwe = formatter.string(from: totalFareAmount as NSNumber) ?? "N/A"
        return qwe
    }
}


extension Date {
    static func getDates(forLastNDays nDays: Int) -> [String] {
        let cal = Calendar.current
        // start with today
        var date = cal.startOfDay(for: Date())
        
        var arrDates = [String]()
        
        for _ in 1 ... nDays {
            // move back in time by one day:
            date = cal.date(byAdding: Calendar.Component.day, value: -1, to: date)!
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateString = dateFormatter.string(from: date)
            arrDates.append(dateString)
        }
        
        return arrDates
    }
}



struct CSVFile: FileDocument {
    // tell the system we support only plain text
    static var readableContentTypes = [UTType.commaSeparatedText]
    static var writableContentTypes = [UTType.commaSeparatedText]
    
    // by default our document is empty
    var text = ""
    
    // a simple initializer that creates new, empty documents
    init(initialText: String = "") {
        text = initialText
    }
    
    // this initializer loads data that has been saved previously
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }
    
    // this will be called when the system wants to write our data to disk
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}


extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }
}


extension Array where Element: Codable {
    func toCSV() -> String? {
        guard let first = self.first else { return nil }
        
        let encoder = JSONEncoder()
        
        // Convert to header
        guard let firstData = try? encoder.encode(first),
              let firstDict = try? JSONSerialization.jsonObject(with: firstData, options: []) as? [String: Any] else { return nil }
        
        // Use ordered keys to ensure consistent column order
        let orderedKeys = firstDict.keys.sorted()
        let header = orderedKeys.joined(separator: ",")
        
        // Convert to rows
        let rows = self.compactMap { element -> String? in
            guard let data = try? encoder.encode(element),
                  let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return nil }
            
            return orderedKeys.compactMap { key in
                return dict[key].map { "\($0)" }
            }.joined(separator: ",")
        }
        
        return ([header] + rows).joined(separator: "\n")
    }
}


struct ShareSheet: UIViewControllerRepresentable {
    var fileURL: URL
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIActivityViewController(activityItems: [fileURL], applicationActivities: nil)
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}


