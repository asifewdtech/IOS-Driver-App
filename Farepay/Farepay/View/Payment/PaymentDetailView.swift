//
//  PaymentDetailView.swift
//  Farepay
//
//  Created by Arslan on 31/08/2023.
//

import SwiftUI

struct PaymentDetailView: View {
    
    //MARK: - Variables
    @Binding var farePriceText: String
    @State private var isDisabled: Bool = true
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var willMoveTapToPayView = false
    @State private var totalChargresWithTax = 0.0
    @State private var totalAmount = 0.0
    @State private var serviceFee = 0.0
    @State private var serviceFeeGst = 0.0
    
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            
            NavigationLink("", destination: ReaderConnectView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveTapToPayView).isDetailLink(false)
            
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                topArea
                Spacer()
                buttonArea
            }
            .onAppear(perform: {
                
                if let cost = Double(farePriceText.trimmingCharacters(in: .whitespaces)) {
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
                
            })
            .padding(.all, 20)
        }
    }
}

struct PaymentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetailView(farePriceText: .constant("0.0"))
    }
}

extension PaymentDetailView{
    
    var topArea: some View{
        
        VStack(spacing: 35){
            
            HStack(spacing: 30){
                
                Image(uiImage: .backArrow)
                    .resizable()
                    .frame(width: 35, height: 30)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                
                Text("Charge Fare ")
                    .foregroundColor(.white)
                    .font(.custom(.poppinsBold, size: 25))
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            
            ZStack{
                HStack{
                    
                    Text("$")
                        .font(.custom(.poppinsMedium, size: 25))
                        .foregroundColor(Color(.darkGrayColor))
                    Spacer()
                    
                    //                    TextField("", text: $totalChargresWithTax, prompt: Text("0.00").foregroundColor(Color(.white)))
                    
                    Text(totalAmount.description)
                        .font(.custom(.poppinsBold, size: 40))
                        .frame(height: 30)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(1)
                        .disabled(isDisabled)
                }
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 80)
            .background(Color(.darkBlueColor))
            .cornerRadius(10)
            
            VStack(spacing: 30){
                
                HStack{
                    
                    Text("Fare Inc GST :")
                        .foregroundColor(Color(.darkGrayColor))
                        .font(.custom(.poppinsMedium, size: 23))
                    Spacer()
                    Text("$ \(totalAmount.description)")
                        .foregroundColor(Color(.white))
                        .font(.custom(.poppinsBold, size: 23))
                }
                
                HStack{
                    
                    Text("Service Charges : ")
                        .foregroundColor(Color(.darkGrayColor))
                        .font(.custom(.poppinsMedium, size: 23))
                    Spacer()
                    Text("$ \(serviceFee.description)")
                        .foregroundColor(Color(.white))
                        .font(.custom(.poppinsBold, size: 23))
                }
                
                HStack{
                    
                    Text("Service Fee GST")
                        .foregroundColor(Color(.darkGrayColor))
                        .font(.custom(.poppinsMedium, size: 23))
                    Spacer()
                    Text("$ \(serviceFeeGst.description)")
                        .foregroundColor(Color(.white))
                        .font(.custom(.poppinsBold, size: 23))
                }
                
                HStack{
                }
                .frame(maxWidth: .infinity)
                .frame(height: 2)
                .background(Color(.darkBlueColor))
                
                HStack{
                    
                    Text("Total")
                        .foregroundColor(Color(.darkGrayColor))
                        .font(.custom(.poppinsMedium, size: 23))
                    Spacer()
                    Text("$ \(totalChargresWithTax.description)")
                        .foregroundColor(Color(.white))
                        .font(.custom(.poppinsBold, size: 23))
                }
            }
        }
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 25){
            
            Text("Edit")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(.buttonColor))
                .cornerRadius(30)
                .onTapGesture {
                    
                    print("Edit")
                    
                    presentationMode.wrappedValue.dismiss()
                    
                }
            
            Button {
                willMoveTapToPayView.toggle()
            } label: {
                
                Text("Confirm")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                //                    .background(farePriceText == "0" || farePriceText == "" ? Color(.buttonColor).opacity(0.5) : Color(.buttonColor))
                    .background(Color(.buttonColor))
                    .cornerRadius(30)
            }
            //            .disabled(farePriceText == "0" || farePriceText == "" ? true : false)
            
        }
        .padding(.bottom, 20)
    }
}


extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}


class AmountDetail {

    static let instance = AmountDetail()
    var totalChargresWithTax = 0.0
    
    
    var serviceFeeGst = 0.0
    var totalAmount = 0.0
    
    

    var serviceFee = 0.0
    
    
}
