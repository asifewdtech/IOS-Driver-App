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
                    

                } label: {
                    Text("Connect")
                        .foregroundStyle(Color.white)
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





class ReaderDiscoveryViewController:NSObject, DiscoveryDelegate,BluetoothReaderDelegate {
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
    }
    
    func reader(_ reader: Reader, didRequestReaderDisplayMessage displayMessage: ReaderDisplayMessage) {
        print("didRequestReaderDisplayMessage")
    }
    

    var discoverCancelable: Cancelable?

    // ...

    // Action for a "Discover Readers" button
    func discoverReadersAction() throws {
        let config = try BluetoothScanDiscoveryConfigurationBuilder().setSimulated(true).build()
        self.discoverCancelable = Terminal.shared.discoverReaders(config, delegate: self) { error in
            if let error = error {
                print("discoverReaders failed: \(error)")
            } else {
                print("discoverReaders succeeded")
            }
        }
    }

    // ...

    // MARK: DiscoveryDelegate

    // This delegate method can get called multiple times throughout the discovery process.
    // You might want to update a UITableView and display all available readers.
    // Here, we're automatically connecting to the first reader we discover.
    func terminal(_ terminal: Terminal, didUpdateDiscoveredReaders readers: [Reader]) {

        // Select the first reader we discover
        guard let selectedReader = readers.first else { return }

        // Since the simulated reader is not associated with a real location, we recommend
        // specifying its existing mock location.
        guard let locationId = selectedReader.locationId else { return }

        // Only connect if we aren't currently connected.
        guard terminal.connectionStatus == .notConnected else { return }
        
//        let connectionConfig = BluetoothConnectionConfiguration(
//          // When connecting to a physical reader, your integration should specify either the
//          // same location as the last connection (selectedReader.locationId) or a new location
//          // of your user's choosing.
//          //
//           
//        )
        
//        let connectionConfig = BluetoothConnectionConfiguration
        
        
        
        

        // Note `readerDelegate` should be provided by your application.
        // See our Quickstart guide at https://stripe.com/docs/terminal/quickstart
        // for more example code.
        
//        Terminal.shared.connectBluetoothReader(selectedReader, delegate: self, connectionConfig: connectionConfig) { <#Reader?#>, <#Error?#> in
//            if let reader = reader {
//                print("Successfully connected to reader: \(reader)")
//            } else if let error = error {
//                print("connectReader failed: \(error)")
//            }
//        }
//        Terminal.shared.connectBluetoothReader(selectedReader, delegate: self, connectionConfig: connectionConfig) { reader, error in
//            if let reader = reader {
//                print("Successfully connected to reader: \(reader)")
//            } else if let error = error {
//                print("connectReader failed: \(error)")
//            }
//        }
    }
}
