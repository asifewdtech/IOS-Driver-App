//
//  TapToPayView.swift
//  Farepay
//
//  Created by Arslan on 31/08/2023.
//

import SwiftUI
import UIKit
import StripeTerminal
import ActivityIndicatorView
import CoreLocation

struct TapToPayView: View {
    
    //MARK: - Variables
    @State var farePriceText = ""
    @State private var isDisabled: Bool = true
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var willMoveToQr = false
    @StateObject var readerDiscoverModel = ReaderDiscoverModel()
    @State private var showLoadingIndicator: Bool = false
    @State private var toast: Toast? = nil
    @State var fareBit = 0
    @ObservedObject var locationManager = LocationManager()
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            
            NavigationLink("", destination: PayQRView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToQr).isDetailLink(false)
            
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                /*topArea
                Spacer()*/
                tapArea
                /*Spacer()
                textArea
                Spacer()
                Button {
                    print("Connect")
                    Task {
                        if readerDiscoverModel.showPay {
                            try readerDiscoverModel.checkoutAction(amount: farePriceText)
                        }else {
                            try readerDiscoverModel.discoverReadersAction()
                        }
                    }
                    

                } label: {
                    if readerDiscoverModel.showPay {
                        Text("Pay Amount")
                            .foregroundStyle(Color.white)
                    }else{
                        Text("Connect")
                            .foregroundStyle(Color.white)
                    }
                    
                }
                
                if readerDiscoverModel.showPay {
                    Button {
                        print("Connect")
                        Task {
                            try readerDiscoverModel.checkoutAction(amount: farePriceText)
                            
                        }
                        
                    } label: {
                        Text("Pay Amount")
                            .foregroundStyle(Color.white)
                    }
                }*/
            }
            .onAppear(perform: {
                farePriceText = AmountDetail.instance.totalChargresWithTax.description
                showLoadingIndicator = true
                
                
                DispatchQueue.main.async {
                    if readerDiscoverModel.showPay {
                        do {
                            willMoveToQr.toggle()
                            //                        try readerDiscoverModel.checkoutAction(amount: farePriceText)
                            //                        showLoadingIndicator = true
                        }catch{
                            print("Payment don't transfered")
                        }
                    }
                    else {
                        do {
                            try readerDiscoverModel.discoverReadersAction()
                        }catch{
                            print("Readers not discovered")
                        }
                    }
                }
                
//                showLoadingIndicator = false
            })
            .toastView(toast: $toast)
            .padding(.all, 20)
            
            ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc(.green, lineWidth: 5))
                .frame(width: 50.0, height: 50.0)
                .foregroundColor(.white)
                .padding(.top, 400)
        }
        
    
    }
}

struct TapToPayView_Previews: PreviewProvider {
    static var previews: some View {
        TapToPayView()
    }
}

extension TapToPayView{
    
    var topArea: some View{
        
        VStack(spacing: 35){
            
            HStack(spacing: 30){
                
                Image(uiImage: .backArrow)
                    .resizable()
                    .frame(width: 35, height: 30)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
                
                Text("Tap to Pay")
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
                    
                    TextField("", text: $farePriceText, prompt: Text("0.00").foregroundColor(Color(.white)))
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
        }
    }
    
    var tapArea: some View{
        
        Image(uiImage: .ic_Tap)
            .resizable()
            .frame(width: 280, height: 280)
            .onTapGesture {
//                willMoveToQr.toggle()
//                do {
//                    try readerDiscoverModel.discoverReadersAction()
//                }catch{
//                    
//                }
            }
    }
    
    var textArea: some View{
        
        Text("Tap here to pay")
            .foregroundColor(.white)
            .font(.custom(.poppinsBold, size: 25))
        
    }
}




class ReaderDiscoverModel:NSObject,ObservableObject ,DiscoveryDelegate{
    
    /*@Published var discoverCancelable: Cancelable?
    @Published var readerMsgLbl = ""
    @Published var showPay = false
    
    func discoverReadersAction() throws {
        let config = try BluetoothScanDiscoveryConfigurationBuilder().setSimulated(true).build()
        self.discoverCancelable = Terminal.shared.discoverReaders(config, delegate: self, completion: { error in
            if let error = error {
                print("discoverReaders failed: \(error)")
            } else {
                print("discoverReaders succeeded")
                self.showPay = true
            }
        })
    }
    
    func terminal(_ terminal: Terminal, didUpdateDiscoveredReaders readers: [Reader]) {
//        print("readers")
//        print(readers)
        guard let selectedReader = readers.first else {return}
        guard let locationId = selectedReader.locationId else { return }
        guard terminal.connectionStatus == .notConnected else { return }
        
        let connectionConfigs = BluetoothConnectionConfigurationBuilder(locationId: locationId)
        do {
            let configss = try connectionConfigs.build()
            Terminal.shared.connectBluetoothReader(selectedReader, delegate: self, connectionConfig: configss ) {  reader, error in
                if let reader = reader {
                    print("Successfully connected to reader: \(reader)")
                } else if let error = error {
                    print("connectReader failed: \(error)")
                }
            }
            
        }catch  {
            print(error.localizedDescription)
        }
         
    }
    
    func checkoutAction() throws {
         let params = try PaymentIntentParametersBuilder(amount: 1000, currency: "AUD").build()
         Terminal.shared.createPaymentIntent(params) { createResult, createError in
             if let error = createError {
                 print("createPaymentIntent failed: \(error)")
             }
             else if let paymentIntent = createResult {
                 print("createPaymentIntent succeeded")
                 self.discoverCancelable = Terminal.shared.collectPaymentMethod(paymentIntent) { collectResult, collectError in
                     if let error = collectError {
                         print("collectPaymentMethod failed: \(error)")
                     }
                     else if let paymentIntent = collectResult {
                         print("collectPaymentMethod succeeded")
                         // ... Confirm the payment
                     }
                 }
             }

         }
     }

    
    
    func reader(_ reader: Reader, didReportAvailableUpdate update: ReaderSoftwareUpdate) {
        print("didReportAvailableUpdate")
    }
    
    func reader(_ reader: Reader, didStartInstallingUpdate update: ReaderSoftwareUpdate, cancelable: Cancelable?) {
        print("didStartInstallingUpdate")
    }
    
    func reader(_ reader: Reader, didReportReaderSoftwareUpdateProgress progress: Float) {
        print("didReportReaderSoftwareUpdateProgress")
    }
    
    func reader(_ reader: Reader, didFinishInstallingUpdate update: ReaderSoftwareUpdate?, error: Error?) {
        print("didFinishInstallingUpdate")
    }
    
    func reader(_ reader: Reader, didRequestReaderInput inputOptions: ReaderInputOptions = []) {
        print("didRequestReaderInput")
        readerMsgLbl = Terminal.stringFromReaderInputOptions(inputOptions)
    }
    
    func reader(_ reader: Reader, didRequestReaderDisplayMessage displayMessage: ReaderDisplayMessage) {
        print("didRequestReaderDisplayMessage")
        readerMsgLbl = Terminal.stringFromReaderDisplayMessage(displayMessage)
    }*/
    
    
    var discoverCancelable: Cancelable?
    var collectCancelable: Cancelable?

    var nextActionButton = UIButton(type: .system)
    var readerMessageLabel = UILabel()
    var readerMsgLbl = ""
    
    
    @Published var showPay = false
    
    
    @objc
    func discoverReadersAction() throws {
        
        let config = try LocalMobileDiscoveryConfigurationBuilder().setSimulated(false).build()
        self.discoverCancelable = Terminal.shared.discoverReaders(config, delegate: self) { error in
            if let error = error {
                print("discoverReaders failed: \(error)")
            } else {
                print("discoverReaders succeeded")
                self.showPay = true
                do {
                    try self.checkoutAction(amount: AmountDetail.instance.totalChargresWithTax.description)
                } catch {
                    print("not found")
                }
            }
        }
    }
    
    @objc
    func checkoutAction(amount: String) throws {
        
        let developer = amount
        let array = developer.split(separator: ".").map(String.init)
        let arrAmount = "\(array[0])\(array[1])"
        print("Array amount: ",arrAmount)
//        let myUInt = uint(arrAmount)
//        let myUInt1 = arrAmount.toUInt()!
//        
//        print("fare payment", myUInt1)
        
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
                                
                            }
                        }
                    }
                } else {
                    print("Payment collected offline")
                }
            }
        }
    }
    
//    func setUpInterface() {
//      readerMessageLabel.textAlignment = .center
//      readerMessageLabel.numberOfLines = 0
//
//      nextActionButton.setTitle("Connect to a reader", for: .normal)
//      nextActionButton.addTarget(self, action: #selector(discoverReaders), for: .touchUpInside)
//
//      let stackView = UIStackView(arrangedSubviews: [nextActionButton, readerMessageLabel])
//      stackView.axis = .vertical
//      stackView.translatesAutoresizingMaskIntoConstraints = false
//      view.addSubview(stackView)
//      NSLayoutConstraint.activate([
//          stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//          stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//          stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//          stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//      ])
//    }
    
    func terminal(_ terminal: Terminal, didUpdateDiscoveredReaders readers: [Reader]) {
        guard let selectedReader = readers.first else { return }
        guard let locationId = selectedReader.locationId else { return }
        do {
            let connectionConfig = try LocalMobileConnectionConfigurationBuilder(locationId: locationId).build()
            
            Terminal.shared.connectLocalMobileReader(selectedReader, delegate: LocalMobileReaderDelegateAnnouncer.shared, connectionConfig: connectionConfig) { reader, error in
                if let reader = reader {
                    print("Successfully connected to reader: \(reader)")
                    
                    do {
                        try self.checkoutAction(amount: AmountDetail.instance.totalChargresWithTax.description)
                    } catch {
                        print("Successfully connected to error")
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

extension String {
    func toUInt() -> UInt? {
        return self.toUInt().flatMap { $0 < 0 ? nil : UInt($0) }
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()
    @Published var degrees: Double = 0
    
    override init() {
        super.init()
        manager.delegate = self
        manager.startUpdatingHeading()
        manager.requestWhenInUseAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        degrees = newHeading.trueHeading
    }
}
