//
//  TransactionDetailView.swift
//  Farepay
//
//  Created by Arslan on 12/09/2023.
//

import SwiftUI

struct TransactionDetailView: View {
    
    //MARK: - Variable
    var transactionType: String = .giftCard
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var willMoveToQr = false
    
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
            .padding(.all, 15)
        }
    }
}

struct TransactionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionDetailView()
    }
}

extension TransactionDetailView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            
            Image(uiImage: .backArrow)
                .resizable()
                .frame(width: 35, height: 30)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text(transactionType == .giftCard ? "Gift Card" : transactionType == .chargeFare ? "Charge Fare" : "Bank Transfer")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
            Image(uiImage: .ic_Home2)
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .onTapGesture {

                    presentationMode.wrappedValue.dismiss()
                }
        }
    }
    
    var cardView: some View{
        
        VStack(spacing: 15){
            Text(transactionType == .giftCard ? "$500.00" : transactionType == .chargeFare ? "$100.00" : "$715.00")
                .font(.custom(.poppinsBold, size: 50))
                .foregroundColor(.white)
            Text(transactionType == .giftCard ? "Gift Card" : transactionType == .chargeFare ? "Charge Fare" : "Bank Transfer")
                .font(.custom(.poppinsBold, size: 20))
                .foregroundColor(.white)
            Text("Monday 07, 2023  01:32 PM")
                .font(.custom(.poppinsMedium, size: 18))
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 200)
        .background(Color(.buttonColor))
        .cornerRadius(10)
    }
    
    var detailView: some View{
        VStack{
            if transactionType == .giftCard{
                Group{
                    HStack{
                        Text("Payout Type")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text("Gift Card")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Gift Name")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text("Apple eGift")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Total Discount")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text("3%")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Amount Saved")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text("$ 15")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Balance before Purchase")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text(" $500")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Balance after Purchase")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text("$ 0")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                }
                .padding(.vertical, 5)
            }
            else if transactionType == .chargeFare{
                Group{
                    HStack{
                        Text("Fare Inc GST")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text("$ 98.68")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Service Charges :")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text("$ 1.23")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Service Fee GST")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text("0.21%")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Balance before Fare")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text("$ 0")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Balance after Fare")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text("$ 100")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("View Receipt")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text("\(Image(systemName: "chevron.right"))")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                    .onTapGesture {
                        willMoveToQr.toggle()
                    }
                }
                .padding(.vertical, 5)
            }
            else{
                Group{
                    HStack{
                        Text("Payout Type")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text("Bank Transfer")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Bank Name")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text("Bank of America")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Balance before Transfer")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text("$ 715")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                    HStack{
                        Text("Balance after Purchase")
                            .font(.custom(.poppinsBold, size: 20))
                            .foregroundColor(.white)
                        Spacer()
                        Text("$ 0")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                }
                .padding(.vertical, 5)
            }
        }
        .frame(maxWidth: .infinity)
    }
}
