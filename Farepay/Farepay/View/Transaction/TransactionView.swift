//
//  TransactionView.swift
//  Farepay
//
//  Created by Arslan on 04/09/2023.
//

import SwiftUI
import UniformTypeIdentifiers
struct TransactionView: View {
    //MARK: - Variables
    @Binding var presentSideMenu: Bool
    @State var transactionType: String = "All Transactions"
    @State var isExporting = false
    @State private var showingOptions = false
       @State private var selection = "None"
    var arrTransaction: [transactionModel] = [
        
        transactionModel(date: Date(), transactions: ["Charge Fare", "Bank Transfer", "Gift Card"]),
//        transactionModel(date: Date.yesterday, transactions: ["Fare Yesterday", "Payout Yesterday", "Refer a Friend Yesterday"]),
//        transactionModel(date: Date.twoDaysBefore, transactions: ["Fare twoDaysBefore", "Payout twoDaysBefore", "Refer a Friend twoDaysBefore"])
    ]
    @State private var isPresentedExport: Bool = false
    @State var willMoveToTransactionDetailView: Bool = false
    @State var transactions: String = ""
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            
            NavigationLink("", destination: TransactionDetailView(transactionType: transactions).toolbar(.hidden, for: .navigationBar), isActive: $willMoveToTransactionDetailView ).isDetailLink(false)
            
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack(spacing: 25){
                topArea
                listView
            }
            .padding(.all, 15)
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
//                                isPresentedExport.toggle()
                                isExporting = true
                            }
//                            .fullScreenCover(isPresented: $isPresentedExport) {
//                                ExportPopUpView(presentedAsModal: $isPresentedExport)
//                            }
                            .fileExporter(isPresented: $isExporting, document: CSVFile(initialText: "Item 1, Item2, Item3"), contentType: UTType.commaSeparatedText) { result in
                                        }
                        
                        Button {
                            showingOptions = true
                        } label: {
                            let width = "All".widthOfString(usingFont: UIFont(name: .poppinsMedium, size: 20)!) + 40.0
                            Text("All  \(Image(systemName: "chevron.down"))")
                                .font(.custom(.poppinsMedium, size: 20))
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
                
                print(Date())
            }
            
            Button("This Week") {
                
                let last7days = Date.getDates(forLastNDays: 7)
                print(last7days)
            }
            
            Button("Last 3 Months") {
                
                let last7days = Date.getDates(forLastNDays: 90)
                print(last7days)
            }
            
            Button("Lifetime Transactions") {
                print("All")
            }
        }
        
    }
    
    var listView: some View{
        
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(alignment: .leading, spacing: 10) {
                ForEach(arrTransaction, id: \.date) { transaction in
                    
                    HStack{
                        Text(formatDate(transaction.date))
                            .font(.custom(.poppinsBold, size: 22))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding([.top, .bottom], 5)
                    
                    ForEach(transaction.transactions, id: \.self) { trans in
                        
                        VStack(spacing: 5){
                            Group{
                                HStack{
                                    Text(trans)
                                        .font(.custom(.poppinsSemiBold, size: 20))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("$500.00")
                                        .font(.custom(.poppinsSemiBold, size: 20))
                                        .foregroundColor(.white)
                                }
                                HStack{
                                    Text("Sydney City")
                                        .font(.custom(.poppinsMedium, size: 15))
                                        .foregroundColor(Color(.darkGrayColor))
                                    Spacer()
                                    Text("Balance $ 100.00")
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
