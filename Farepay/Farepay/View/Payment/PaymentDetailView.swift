//
//  PaymentDetailView.swift
//  Farepay
//
//  Created by Arslan on 31/08/2023.
//

import SwiftUI
import StripeTerminal
import UIKit
import ActivityIndicatorView
import CoreLocation

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
    @StateObject var readerDiscoverModel1 = ReaderDiscoverModel1()
    @State private var willMoveToQr = false
    @State var showLoadingIndicator: Bool = false
    @State private var locationPermission = false
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            
            NavigationLink("", destination: ReaderConnectView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveTapToPayView).isDetailLink(false)
            NavigationLink("", destination: PayQRView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToQr).isDetailLink(false)
            
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
                    print("amountWith \(cost)")
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
                
                if readerDiscoverModel1.showPay {
                    do {
                        willMoveToQr.toggle()
                    }catch{
                        print("Payment don't transfered")
                    }
                }
            })
            .padding(.all, 20)
            
            ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc(.green, lineWidth: 5))
                .frame(width: 50.0, height: 50.0)
                .foregroundColor(.white)
                .padding(.top, 400)        }
    }
}

struct PaymentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetailView(farePriceText: .constant("0.0"))
    }
}

extension PaymentDetailView{
    
    var topArea: some View{
        
        VStack(spacing: 20){
            
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
            
//            Text("Edit")
//                .font(.custom(.poppinsBold, size: 25))
//                .foregroundColor(.white)
//                .frame(maxWidth: .infinity)
//                .frame(height: 60)
//                .background(Color(.buttonColor))
//                .cornerRadius(30)
//                .onTapGesture {
//                    
//                    print("Edit")
//                    
//                    presentationMode.wrappedValue.dismiss()
//                    
//                }
            
            Button {
//                willMoveTapToPayView.toggle()
//                print(currencyManager.string)
                
                DispatchQueue.main.async {
                    
                    if readerDiscoverModel1.showPay {
                        
                        do {
                            showLoadingIndicator = true
                            try readerDiscoverModel1.collectPayment(amount: totalChargresWithTax.description)
//                            showLoadingIndicator = false
                        }catch{
                            print("Payment don't transfered")
                            showLoadingIndicator = false
                        }
                    }
                    else {
                        do {
                            showLoadingIndicator = true
                            try readerDiscoverModel1.discoverReaders()
//                            showLoadingIndicator = false
                        }catch{
                            print("Readers not discovered")
                            showLoadingIndicator = false
                        }
                    }
                    
                }
                
            } label: {
                
                Text("\("Charge ")\("$") \(totalChargresWithTax.description)")
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
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        guard status == .authorizedAlways || status == .authorizedWhenInUse else {
            if status == .denied || status == .notDetermined || status == .restricted || status == .authorizedWhenInUse {
                
                let alert = UIAlertController(title: "Title", message:"Location is require to proceed further." , preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                    let url = URL(string: UIApplication.openSettingsURLString)!
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }))
                //                                try present(alert, animated: true, completion: nil)
            }
            return
        }
        
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

class ReaderDiscoverModel1:NSObject,ObservableObject ,DiscoveryDelegate{
    
    var discoverCancelable: Cancelable?
    var collectCancelable: Cancelable?
    @ObservedObject private var currencyManager = CurrencyManager(amount: 0)
    var nextActionButton = UIButton(type: .system)
    var readerMessageLabel = UILabel()
    var readerMsgLbl = ""
    @Published var showPay = false
    
    
    @objc
    func discoverReaders() throws {
        let config = try LocalMobileDiscoveryConfigurationBuilder().setSimulated(false).build()
        self.discoverCancelable = Terminal.shared.discoverReaders(config, delegate: self) { error in
                    if let error = error {
                        print("discoverReaders failed: \(error)")
                    } else {
                        print("discoverReaders succeeded")
                    }
        }
    }
    
    @objc
    func collectPayment(amount: String) throws {
        let developer = amount
        let array = developer.split(separator: ".").map(String.init)
        let arrAmount = "\(array[0])\(array[1])"
        print("Array amount: ",arrAmount)
        
        let params = try PaymentIntentParametersBuilder(amount: UInt(arrAmount) ?? 0, currency: "AUD")
            .setPaymentMethodTypes(["card_present"])
            .setCaptureMethod(CaptureMethod.automatic)
            .build()
        
        Terminal.shared.createPaymentIntent(params) {
          createResult, createError in
            if let error = createError {
                print("createPaymentIntent failed: \(error)")
            } else if let paymentIntent = createResult {
                print("createPaymentIntent succeeded")
                Terminal.shared.collectPaymentMethod(paymentIntent) { collectResult, collectError in
                    if let error = collectError {
                        print("collectPaymentMethod failed: \(error)")
                    } else if let paymentIntent = collectResult {
                        print("collectPaymentMethod succeeded", paymentIntent)
                        
                        self.confirmPaymentIntent(paymentIntent)
                    }
                }
            }
        }
    }

    private func confirmPaymentIntent(_ paymentIntent: PaymentIntent) {
        Terminal.shared.confirmPaymentIntent(paymentIntent) { confirmResult, confirmError in
            if let error = confirmError {
                print("confirmPaymentIntent failed: \(error)")
            } else if let confirmedPaymentIntent = confirmResult {
                print("confirmPaymentIntent succeeded")

                if let stripeId = confirmedPaymentIntent.stripeId {
                    // Notify your backend to capture the PaymentIntent.
                    // PaymentIntents processed with Stripe Terminal must be captured
                    // within 24 hours of processing the payment.
                    APIClient.shared.capturePaymentIntent(stripeId) { captureError in
                        if let error = captureError {
                            print("capture failed: \(error)")
                        } else {
                            print("capture succeeded")
                            self.readerMessageLabel.text = "Payment captured"
                            if let paymentMethod = paymentIntent.paymentMethod,
                                                        let card = paymentMethod.cardPresent ?? paymentMethod.interacPresent {

                                                        // ... Perform business logic on card
                                                    }
                        }
                    }
                } else {
                    print("Payment collected offline")
                }
            }
        }
    }
    
    func terminal(_ terminal: Terminal, didUpdateDiscoveredReaders readers: [Reader]) {
        
        guard let selectedReader = readers.first else { return }
         let locationId = selectedReader.locationId
        print("locationId: ",locationId)
        do {
            let connectionConfig = try LocalMobileConnectionConfigurationBuilder(locationId: locationId ?? "tml_FLrhpAr3WfbIVw").build()
            
            Terminal.shared.connectLocalMobileReader(selectedReader, delegate: LocalMobileReaderDelegateAnnouncer.shared, connectionConfig: connectionConfig) { reader, error in
                if let reader = reader {
                    print("Successfully connected to reader: \(reader)")
                    do {
                        try self.collectPayment(amount: AmountDetail.instance.totalChargresWithTax.description)
                    }catch{
                        print("collect payment not call")
                    }
                } else if let error = error {
                    print("connectLocalMobileReader failed: \(error)")
                }
            }
        } catch {
            print("Error creating LocalMobileConnectionConfiguration: \(error)")
        }
    }
    
}

