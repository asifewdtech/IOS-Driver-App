//
//  TapToPayView.swift
//  Farepay
//
//  Created by Arslan on 31/08/2023.
//

import SwiftUI
import StripeTerminal

struct TapToPayView: View {
    
    //MARK: - Variables
    @State private var farePriceText: String = ""
    @State private var isDisabled: Bool = true
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var willMoveToQr = false
    @StateObject var readerDiscoverModel = ReaderDiscoverModel()
    

    //MARK: - Views
    var body: some View {
        
        ZStack{
            
            NavigationLink("", destination: PayQRView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToQr).isDetailLink(false)
            
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                topArea
                Spacer()
                tapArea
                Spacer()
                textArea
                Spacer()
                Button {
                    print("Connect")
                    Task {
                        try readerDiscoverModel.discoverReadersAction()
                        
                    }
                    

                } label: {
                    Text("Connect")
                        .foregroundStyle(Color.white)
                }
                
                if readerDiscoverModel.showPay {
                    Button {
                        print("Connect")
                        Task {
                            try readerDiscoverModel.checkoutAction()
                            
                        }
                        
                        
                    } label: {
                        Text("Pay")
                            .foregroundStyle(Color.white)
                    }
                }
            }
            .padding(.all, 20)
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
                willMoveToQr.toggle()
            }
    }
    
    var textArea: some View{
        
        Text("Tap here to pay")
            .foregroundColor(.white)
            .font(.custom(.poppinsBold, size: 25))
        
        
      

        
    }
}




class ReaderDiscoverModel:NSObject,ObservableObject ,DiscoveryDelegate, BluetoothReaderDelegate{
  
   
    
    
    @Published var discoverCancelable: Cancelable?
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
         let params = try PaymentIntentParametersBuilder(amount: 1000, currency: "gbp").build()
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
    }
    
}

