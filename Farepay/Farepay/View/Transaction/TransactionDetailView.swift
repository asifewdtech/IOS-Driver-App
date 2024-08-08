//
//  TransactionDetailView.swift
//  Farepay
//
//  Created by Arslan on 12/09/2023.
//

import SwiftUI

struct TransactionDetailView: View {
    
    //MARK: - Variable
//    var transactionType: String = .giftCard
    var transactionType: MyResult1
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var willMoveToQr = false
    @State private var totalChargresWithTax = 0.0
    @State private var totalAmount = 0.0
    @State private var serviceFee = 0.0
    @State private var serviceFeeGst = 0.0
    @State var amount = 0.0
    //MARK: - Views
    var body: some View {
        
        ZStack{
            NavigationLink("", destination: PayQRView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToQr).isDetailLink(false)
            
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack(spacing: 40){
                topArea
                cardView
                detailView
                Spacer()
            }
            .onAppear(perform: {
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 2
                formatter.minimumIntegerDigits = 1
                
                amount = Double( transactionType.amount) / 100
                    totalAmount = amount
                
                    AmountDetail.instance.totalAmount = String(amount)
                    let amountWithFivePercent = amount * 5 / 100
                    print("amountWithFivePercent \(amountWithFivePercent)")
                    serviceFee = (amountWithFivePercent / 1.1).roundToDecimal(2)
                    
                    AmountDetail.instance.serviceFee = serviceFee
                    print("serviceFee\(serviceFee)")
                    
                    serviceFeeGst = (amountWithFivePercent - serviceFee).roundToDecimal(2)
                    AmountDetail.instance.serviceFeeGst = serviceFeeGst
                    print("serviceFeeGst \(serviceFeeGst)")
                    totalChargresWithTax = (serviceFee + serviceFeeGst + amount).roundToDecimal(2)
                    
                    AmountDetail.instance.totalChargresWithTax = String(totalChargresWithTax)
                    print("totalCharges \(totalChargresWithTax)")
                    
                let stripeReceiptId = transactionType.source_transaction
                UserDefaults.standard.set(stripeReceiptId, forKey: "stripeReceiptId")
                
                let stripeReceiptDate = transactionType.created
                UserDefaults.standard.set(stripeReceiptDate, forKey: "receiptCreated")
                
            })
            .padding(.all, 15)
        }
    }
}
//
//struct TransactionDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        TransactionDetailView()
//    }
//}

extension TransactionDetailView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            
            Image(uiImage: .backArrow)
                .resizable()
                .frame(width: 35, height: 30)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
//            Text(transactionType.source_type == .giftCard ? "Gift Card" : transactionType.source_type == .chargeFare ? "Charge Fare" : "Bank Transfer")
            Text("Charge Fare")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
//            Image(uiImage: .ic_Home2)
//                .resizable()
//                .scaledToFit()
//                .frame(width: 40, height: 40)
//                .onTapGesture {
//
//                    presentationMode.wrappedValue.dismiss()
//                }
        }
    }
    
    var cardView: some View{
        
        VStack(spacing: 15){
//            Text(transactionType == .giftCard ? "$500.00" : transactionType == .chargeFare ? "$100.00" : "$715.00")
            Text("$\(totalAmount.description)")
                .font(.custom(.poppinsBold, size: 50))
                .foregroundColor(.white)
//            Text(transactionType == .giftCard ? "Gift Card" : transactionType == .chargeFare ? "Charge Fare" : "Bank Transfer")
//            Text(transactionType.source_type)
            Text("Charge Fare")
                .font(.custom(.poppinsBold, size: 20))
                .foregroundColor(.white)
            Text(dateToString(date:Date(timeIntervalSince1970: TimeInterval(transactionType.created))))
                .font(.custom(.poppinsMedium, size: 12))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(Color(.buttonColor))
        .cornerRadius(10)
    }
    
    var detailView: some View{
        VStack{
            
            Group{
//                HStack{
//                    Text("Payout Type")
//                        .font(.custom(.poppinsBold, size: 20))
//                        .foregroundColor(.white)
//                    Spacer()
//                    Text(transactionType.source_type)
//                        .font(.custom(.poppinsMedium, size: 18))
//                        .foregroundColor(.white)
//                }
//                    HStack{
//                        Text("Gift Name")
//                            .font(.custom(.poppinsBold, size: 20))
//                            .foregroundColor(.white)
//                        Spacer()
//                        Text("Apple eGift")
//                            .font(.custom(.poppinsMedium, size: 18))
//                            .foregroundColor(.white)
//                    }
//                    HStack{
//                        Text("Total Discount")
//                            .font(.custom(.poppinsBold, size: 20))
//                            .foregroundColor(.white)
//                        Spacer()
//                        Text("3%")
//                            .font(.custom(.poppinsMedium, size: 18))
//                            .foregroundColor(.white)
//                    }
//                    HStack{
//                        Text("Amount Saved")
//                            .font(.custom(.poppinsBold, size: 20))
//                            .foregroundColor(.white)
//                        Spacer()
//                        Text("$ 15")
//                            .font(.custom(.poppinsMedium, size: 18))
//                            .foregroundColor(.white)
//                    }
                
                HStack{
                    Text("Fare Inc GST")
                        .font(.custom(.poppinsBold, size: 20))
                        .foregroundColor(.white)
                    Spacer()
                    Text("$ \(totalAmount.description)")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(.white)
                }
                HStack{
                    Text("Service Fee")
                        .font(.custom(.poppinsBold, size: 20))
                        .foregroundColor(.white)
                    Spacer()
                    Text("$ \(serviceFee.description)")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(.white)
                }
                HStack{
                    Text("Service Fee GST")
                        .font(.custom(.poppinsBold, size: 20))
                        .foregroundColor(.white)
                    Spacer()
                    Text("$ \(serviceFeeGst.description)")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(.white)
                }
//                HStack{
//                    Text("Balance before Purchase")
//                        .font(.custom(.poppinsBold, size: 20))
//                        .foregroundColor(.white)
//                    Spacer()
//                    Text("$\(totalAmount.description)")
//                        .font(.custom(.poppinsMedium, size: 18))
//                        .foregroundColor(.white)
//                }
                
                
                NavigationLink {
                    PayQRView().toolbar(.hidden, for: .navigationBar)
                } label: {
                    HStack {
                        Text("View Receipt")
                            
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .font(.custom(.poppinsBold, size: 20))
                    .foregroundColor(.white)
                }

                
                
                
//                    HStack{
//                        Text("Balance after Purchase")
//                            .font(.custom(.poppinsBold, size: 20))
//                            .foregroundColor(.white)
//                        Spacer()
//                        Text("$ 0")
//                            .font(.custom(.poppinsMedium, size: 18))
//                            .foregroundColor(.white)
//                    }
            }
            .padding(.vertical, 5)
//            if transactionType.source_type == .giftCard{
//                
//            }
//            else if transactionType.source_type == .chargeFare{
//                Group{
//
//                    HStack{
//                        Text("Balance before Fare")
//                            .font(.custom(.poppinsBold, size: 20))
//                            .foregroundColor(.white)
//                        Spacer()
//                        Text("$ 0")
//                            .font(.custom(.poppinsMedium, size: 18))
//                            .foregroundColor(.white)
//                    }
//                    HStack{
//                        Text("Balance after Fare")
//                            .font(.custom(.poppinsBold, size: 20))
//                            .foregroundColor(.white)
//                        Spacer()
//                        Text("$ 100")
//                            .font(.custom(.poppinsMedium, size: 18))
//                            .foregroundColor(.white)
//                    }
//                    HStack{
//                        Text("View Receipt")
//                            .font(.custom(.poppinsBold, size: 20))
//                            .foregroundColor(.white)
//                        Spacer()
//                        Text("\(Image(systemName: "chevron.right"))")
//                            .font(.custom(.poppinsMedium, size: 18))
//                            .foregroundColor(.white)
//                    }
//                    .onTapGesture {
//                        willMoveToQr.toggle()
//                    }
//                }
//                .padding(.vertical, 5)
//            }
//            else{
//                Group{
//                    HStack{
//                        Text("Payout Type")
//                            .font(.custom(.poppinsBold, size: 20))
//                            .foregroundColor(.white)
//                        Spacer()
//                        Text("Bank Transfer")
//                            .font(.custom(.poppinsMedium, size: 18))
//                            .foregroundColor(.white)
//                    }
//                    HStack{
//                        Text("Bank Name")
//                            .font(.custom(.poppinsBold, size: 20))
//                            .foregroundColor(.white)
//                        Spacer()
//                        Text("Bank of America")
//                            .font(.custom(.poppinsMedium, size: 18))
//                            .foregroundColor(.white)
//                    }
//                    HStack{
//                        Text("Balance before Transfer")
//                            .font(.custom(.poppinsBold, size: 20))
//                            .foregroundColor(.white)
//                        Spacer()
//                        Text("$ 715")
//                            .font(.custom(.poppinsMedium, size: 18))
//                            .foregroundColor(.white)
//                    }
//                    HStack{
//                        Text("Balance after Purchase")
//                            .font(.custom(.poppinsBold, size: 20))
//                            .foregroundColor(.white)
//                        Spacer()
//                        Text("$ 0")
//                            .font(.custom(.poppinsMedium, size: 18))
//                            .foregroundColor(.white)
//                    }
//                }
//                .padding(.vertical, 5)
//            }
        }
        .frame(maxWidth: .infinity)
    }
}


extension View {
    
    func dateToString(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .full
        formatter.timeZone = TimeZone.current
        return formatter.string(from: date)
    }
}
