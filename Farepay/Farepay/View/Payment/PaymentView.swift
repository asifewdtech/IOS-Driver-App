//
//  HomeView.swift
//  Farepay
//
//  Created by Arslan on 30/08/2023.
//

import SwiftUI
import StripeTerminal
import UIKit
import ActivityIndicatorView

struct PaymentView: View {
    
    //MARK: - Variables
    @ObservedObject private var currencyManager = CurrencyManager(amount: 0)
    @State private var willMoveToPaymentDetail = false
    @State private var FareAmount: String = ""
    @Binding var presentSideMenu: Bool
    @State private var toast: Toast? = nil
    @State private var willMoveTapToPayView = false
    @StateObject var readerDiscoverModel1 = ReaderDiscoverModel1()
    @State private var willMoveToQr = false
    @State private var showLoadingIndicator: Bool = false
//    @State private var totalChargresWithTax = 0.0
//    @State private var totalAmount = 0.0
//    @State private var serviceFee = 0.0
//    @State private var serviceFeeGst = 0.0
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
//            NavigationLink("", destination: PaymentDetailView(farePriceText: $currencyManager.string).toolbar(.hidden, for: .navigationBar), isActive: $willMoveToPaymentDetail).isDetailLink(false)
            NavigationLink("", destination: TapToPayView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveTapToPayView).isDetailLink(false)
            NavigationLink("", destination: PayQRView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToQr).isDetailLink(false)
            
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            VStack{
                topArea
                calculationArea
                Spacer()
                
                keypadArea
                buttonArea
            }
            .onAppear(perform: {
                showLoadingIndicator = false
//                currencyManager.string = ""
                if readerDiscoverModel1.showPay {
                    do {
                        willMoveToQr.toggle()
                    }catch{
                        print("Payment don't transfered")
                    }
                }
            })
            
            .toastView(toast: $toast)
            .padding(.all, 15)
            
            ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc(.green, lineWidth: 5))
                .frame(width: 50.0, height: 50.0)
                .foregroundColor(.white)
                .padding(.top, 400)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentView(presentSideMenu: .constant(false))
    }
}

extension PaymentView{
    
    var topArea: some View{
        
        VStack(spacing: 20){
//            HStack(spacing: 20){
//                Image(uiImage: .logo)
//                    .resizable()
//                    .frame(width: 50, height: 50)
//                Text("FarePay")
//                    .font(.custom(.poppinsBold, size: 35))
//                    .foregroundColor(.white)
//                    .onAppear(){
//                        setMainView(true)
//                    }
//            }
            
            HStack(spacing: 20){
                
                Image(uiImage: .menuIcon)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .onTapGesture {
                        
                        presentSideMenu.toggle()
                    }
                Text("Charge Fare")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                Spacer()
            }
            
            ZStack{
                
                HStack{
                    
                    Text("$")
                        .font(.custom(.poppinsMedium, size: 25))
                        .foregroundColor(Color(.darkGrayColor))
                    Spacer()
                    
                    TextField(currencyManager.string, text: $currencyManager.string)
                        .font(.custom(.poppinsBold, size: 40))
                        .frame(height: 30)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: currencyManager.string, perform: currencyManager.valueChanged)
                        
                        .disabled(true)
                }
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(.darkBlueColor))
            .cornerRadius(10)
        }
        .padding(.horizontal, 10)
    }
    
    var calculationArea : some View {
        VStack{
            
//            HStack(spacing: 30){
//                
//                
//                
//                Text("Charge Fare ")
//                    .foregroundColor(.white)
//                    .font(.custom(.poppinsBold, size: 25))
//                
//                Spacer()
//            }
//            .frame(maxWidth: .infinity)
//            
//            ZStack{
//                HStack{
//                    
//                    Text("$")
//                        .font(.custom(.poppinsMedium, size: 25))
//                        .foregroundColor(Color(.darkGrayColor))
//                    Spacer()
//                    
//                    //                    TextField("", text: $totalChargresWithTax, prompt: Text("0.00").foregroundColor(Color(.white)))
//                    
//                    Text(totalChargresWithTax.description)
//                        .font(.custom(.poppinsBold, size: 40))
//                        .frame(height: 30)
//                        .foregroundColor(.white)
//                        .multilineTextAlignment(.trailing)
//                        .lineLimit(1)
////                        .disabled(isDisabled)
//                }
//                .padding(.horizontal, 20)
//            }
//            .frame(maxWidth: .infinity)
//            .frame(height: 80)
//            .background(Color(.darkBlueColor))
//            .cornerRadius(10)
            
            VStack(spacing: 5){
                
                
                HStack{
                    
                    Text("Fare Incl. GST")
                        .foregroundColor(Color(.darkGrayColor))
                        .font(.custom(.poppinsMedium, size: 23))
                    Spacer()
                    Text("$ \(currencyManager.string.description)")
                        .foregroundColor(Color(.white))
                        .font(.custom(.poppinsBold, size: 23))
                }
                
                HStack{
                    
                    Text("Service Charges : ")
                        .foregroundColor(Color(.darkGrayColor))
                        .font(.custom(.poppinsMedium, size: 23))
                    Spacer()
                    Text("$ \(currencyManager.serviceFee.description)")
                        .foregroundColor(Color(.white))
                        .font(.custom(.poppinsBold, size: 23))
                }
                
                HStack{
                    
                    Text("Service Fee GST")
                        .foregroundColor(Color(.darkGrayColor))
                        .font(.custom(.poppinsMedium, size: 23))
                    Spacer()
                    Text("$ \(currencyManager.serviceFeeGst.description)")
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
                    Text("$ \(currencyManager.totalChargresWithTax.description)")
                        .foregroundColor(Color(.white))
                        .font(.custom(.poppinsBold, size: 23))
                }

            }
        }
        .padding(.horizontal, 10)
    }
    var keypadArea: some View{
        
        VStack(spacing: 20){
            
            HStack{
                
                Group{
                    Text("1")
                        .onTapGesture {
                            currencyManager.string += "1"
                        }
                    Text("2")
                        .onTapGesture {
                            currencyManager.string += "2"
                        }
                    Text("3")
                        .onTapGesture {
                            currencyManager.string += "3"
                        }
                }
                .font(.custom(.poppinsBold, size: 35))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            }

            HStack{
                Group{
                    
                    Text("4")
                        .onTapGesture {
                            currencyManager.string += "4"
                        }
                    Text("5")
                        .onTapGesture {
                            currencyManager.string += "5"
                        }
                    Text("6")
                        .onTapGesture {
                            currencyManager.string += "6"
                        }
                }
                .font(.custom(.poppinsBold, size: 35))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            }
            
            HStack{
                Group{
                    
                    Text("7")
                        .onTapGesture {
                            currencyManager.string += "7"
                        }
                    Text("8")
                        .onTapGesture {
                            currencyManager.string += "8"
                        }
                    Text("9")
                        .onTapGesture {
                            currencyManager.string += "9"
                        }
                }
                .font(.custom(.poppinsBold, size: 35))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            }
            
            HStack{
                
                Group{
                    
                    Text("")
                        
                    Text("0")
                        .onTapGesture {
                            currencyManager.string += "0"
                        }
                    Image(uiImage: .ic_BackSpace)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            if !currencyManager.string.isEmpty{
                                currencyManager.string.removeLast()
                            }
                        }
                }
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 10)
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 25){
            Button {
                setMainView(false)
//                willMoveToPaymentDetail.toggle()
//                willMoveTapToPayView.toggle()
                print(currencyManager.string)
                DispatchQueue.main.async {
                    if readerDiscoverModel1.showPay {
                        do {
                            try readerDiscoverModel1.collectPayment()
                            showLoadingIndicator = true
                        }catch{
                            print("Payment don't transfered")
                        }
                    }
                    else {
                        do {
                            try readerDiscoverModel1.discoverReaders()
                            showLoadingIndicator = true
                        }catch{
                            print("Readers not discovered")
                        }
                    }
                }
                showLoadingIndicator = false
//                if currencyManager.string.count == 2 && currencyManager.string.count <= 2 {
//                    toast = Toast(style: .error, message: "Fare Pay should be minimum 10 AUD.")
//                }else {
//                    willMoveToPaymentDetail.toggle()
//                    print(currencyManager.string)
//                }
            } label: {
                 
                Text("PAY")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(currencyManager.string == "0.00" || currencyManager.string == "" ? Color(.buttonColor).opacity(0.5) : Color(.buttonColor))
                    .cornerRadius(30)
            }
            .disabled(currencyManager.string == "0.00" || currencyManager.string == "" ? true : false)
        }
        .padding(.horizontal, 15)
        .padding(.bottom, 20)
    }
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
                self.showPay = true
            }
        }
    }
    
    @objc
    func collectPayment() throws {
        let developer = AmountDetail.instance.totalChargresWithTax.description
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
//        guard let locationId = selectedReader.locationId else { return }
        do {
            let connectionConfig = try LocalMobileConnectionConfigurationBuilder(locationId: "tml_FT7fjwaDmbKQ06").build()
            
            Terminal.shared.connectLocalMobileReader(selectedReader, delegate: LocalMobileReaderDelegateAnnouncer.shared, connectionConfig: connectionConfig) { reader, error in
                if let reader = reader {
                    print("Successfully connected to reader: \(reader)")
                    do {
                        try self.collectPayment()
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
