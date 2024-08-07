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
import FirebaseFirestore
import FirebaseAuth
import Alamofire

struct PaymentDetailView: View {
    
    //MARK: - Variables
    @Binding var farePriceText: String
    @State private var isDisabled: Bool = true
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var willMoveTapToPayView = false
    @State private var totalChargresWithTax = "0.00"
    @State private var totalAmount = 0.0
    @State private var serviceFee = "0.00"
    @State private var serviceFeeGst = "0.00"
    @State var txNumber = ""
    @State var driABN = ""
    @State var driLicence = ""
    @StateObject var readerDiscoverModel1 = ReaderDiscoverModel1()
    @State private var willMoveToQr = false
    @State var showLoadingIndicator: Bool = false
    @State private var locationPermission = false
    @State var goToHome = false
    @State var locManager = CLLocationManager()
    @State private var toast: Toast? = nil
    @State private var collectedFeeStripe: Double = 0.0
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            NavigationLink("", destination: Farepay.MainTabbedView().toolbar(.hidden, for: .navigationBar), isActive: $goToHome ).isDetailLink(false)
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
                UserDefaults.standard.removeObject(forKey: "txNumber")
                UserDefaults.standard.removeObject(forKey: "driABN")
                UserDefaults.standard.removeObject(forKey: "driLicence")
                UserDefaults.standard.removeObject(forKey: "fareAddress")
                
                if let cost = Double(farePriceText.trimmingCharacters(in: .whitespaces)) {
                    let formatter = NumberFormatter()
                    formatter.minimumFractionDigits = 2
                    formatter.maximumFractionDigits = 2
                    formatter.minimumIntegerDigits = 1
                    
                    totalAmount = cost
                    AmountDetail.instance.totalAmount = String(cost)
                    print("amountWith \(cost)")
                    let amountWithFivePercent = cost * 5 / 100
                    print("amountWithFivePercent \(amountWithFivePercent)")
                    let srvcFee = (amountWithFivePercent / 1.1).roundToDecimal(2)
                    if let srvcFeeString = formatter.string(from: (Decimal(srvcFee)) as NSNumber) {
                        serviceFee = srvcFeeString
                    }
                    AmountDetail.instance.serviceFee = srvcFee
                    print("serviceFee\(serviceFee)")
                    
                    let srvcFeeGst = (amountWithFivePercent - srvcFee).roundToDecimal(2)
                    //                    let y = srvcFeeGst.rounded()
                    if let srvcFeeGstString = formatter.string(from: (Decimal(srvcFeeGst)) as NSNumber) {
                        serviceFeeGst = srvcFeeGstString
                    }
                    AmountDetail.instance.serviceFeeGst = srvcFeeGst
                    print("serviceFeeGst \(serviceFeeGst)")
                    let totalChargresWithTx = (srvcFee + srvcFeeGst + cost).roundToDecimal(2)
                    
//                    AmountDetail.instance.totalChargresWithTax = totalChargresWithTax
//                    print("totalCharges \(totalChargresWithTax)")
                    collectedFeeStripe = srvcFee + srvcFeeGst
                    AmountDetail.instance.collectionStrFee = collectedFeeStripe
                    
                    if let formattedString = formatter.string(from: (Decimal(totalChargresWithTx)) as NSNumber) {
                        totalChargresWithTax = formattedString
                        AmountDetail.instance.totalChargresWithTax = formattedString
                    } else {
                        print("Failed to format the decimal value")
                    }
                    fetchFirebase()
                    fetchLatLong()
                }
                
                UserDefaults.standard.removeObject(forKey: "stripeReceiptId")
                UserDefaults.standard.removeObject(forKey: "receiptCreated")
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("PAYMENTDETAIL"), object: nil, queue: .main) { (_) in
                        if readerDiscoverModel1.showPay {
                            do {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5){
                                    willMoveToQr = true
                                    showLoadingIndicator = false
                                }
                            }catch{
                                print("Payment don't transfered")
                            }
                        }
                        if readerDiscoverModel1.cancelPay {
                            showLoadingIndicator = false
                            toast = Toast(style: .error, message: "Paymet could not successful, Please try again!")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    
                    if readerDiscoverModel1.errorPay {
                        showLoadingIndicator = false
                        toast = Toast(style: .error, message: "Something went wrong, Please try again!")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
            })
            .toastView(toast: $toast)
            .padding(.all, 20)
            
            if showLoadingIndicator{
                VStack{
                    ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc(.white, lineWidth: 5))
                        .frame(width: 50.0, height: 50.0)
                        .foregroundColor(.green)
                        .padding(.top, 350)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct PaymentDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PaymentDetailView(farePriceText: .constant("0.00"))
    }
}

extension PaymentDetailView{
    
    var topArea: some View{
        
        VStack(spacing: 20){
            
            HStack(spacing: 30){
                
                Image(uiImage: .backArrow)
                    .resizable()
                    .frame(width: 30, height: 25)
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
                    
                    Text(farePriceText.description)
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
                    Text("$ \(farePriceText.description)")
                        .foregroundColor(Color(.white))
                        .font(.custom(.poppinsBold, size: 23))
                }
                
                HStack{
                    
                    Text("Service Charges :")
                        .foregroundColor(Color(.darkGrayColor))
                        .font(.custom(.poppinsMedium, size: 23))
                    Spacer()
                    Text("$ \(serviceFee.description)")
                        .foregroundColor(Color(.white))
                        .font(.custom(.poppinsBold, size: 23))
                }
                
                HStack{
                    
                    Text("Service Fee GST :")
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
                            try readerDiscoverModel1.collectPayment(amount: totalChargresWithTax.description, serviceFee: serviceFee.description, serviceFeeGST: collectedFeeStripe)
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + 40){
                        showLoadingIndicator = false
                    }
                }
                
            } label: {
                
//                Text("\("Charge ")\("$") \(totalChargresWithTax.description)")
                Text ("Tap to Pay on iPhone")
                    .font(.custom(.poppinsBold, size: 22))
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
    
    func fetchFirebase() {
        let collectionRef = Firestore.firestore().collection("usersInfo")
        collectionRef.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("error fetching docs: \(err)")
            } else {
                guard let snap = snapshot else {
                    return
                }
                for document in snap.documents {
                    let data = document.data()
                    let emailText = Auth.auth().currentUser?.email ?? ""
                    if emailText ==  data["email"] as? String {
                        DispatchQueue.main.async {
                            print("error: ", error?.localizedDescription)
                            self.txNumber  = data["taxiID"] as? String ?? ""
                            self.driABN  = data["driverABN"] as? String ?? ""
                            self.driLicence  = data["driverID"] as? String ?? ""
                            UserDefaults.standard.set(txNumber, forKey: "txNumber")
                            UserDefaults.standard.set(driABN, forKey: "driABN")
                            UserDefaults.standard.set(driLicence, forKey: "driLicence")
                            print("tNumber: ",txNumber, " ,dABN: ", driABN, " ,dLicence: ", driLicence)
                        }
                    }
                }
            }
        }
    }
    
    func fetchLatLong() {
        locManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locManager.location else {
                return
            }
            print(currentLocation.coordinate.latitude)
            print(currentLocation.coordinate.longitude)
            
            getAddressFromLatLong(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        }
    }
    
    func getAddressFromLatLong(latitude: Double, longitude : Double){
        
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyDvzoBJGEDZ5LpZ002k8JvKfWgnepzwxdc"
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case let .success(value):
                if let results = (value as AnyObject).object(forKey: "results")! as? [NSDictionary] {
//                    if results.count > 0 {
//                        if results[1]["address_components"]! is [NSDictionary] {
//                            let address = results[0]["formatted_address"] as? String
//                            print("fareAddress: ",results[0])
//                            UserDefaults.standard.set(address, forKey: "fareAddress")
//                        }
//                    }
                    if let addressComponents = results[1]["address_components"]! as? [NSDictionary] {
                        for component in addressComponents {
                            if let temp = component.object(forKey: "types") as? [String] {
                                if (temp[0] == "locality") {
                                    let address = component["long_name"] as? String ?? "N/A"
                                    print("city value: ",address)
                                    UserDefaults.standard.set(address, forKey: "fareAddress")
                                }
                            }
                        }
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func navigateToInvoiice() {
//        UINavigationController.ins
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
    var totalChargresWithTax = "0.0"
    var serviceFeeGst = 0.0
    var totalAmount = "0.0"
    var serviceFee = 0.0
    var collectionStrFee = 0.0
}

class ReaderDiscoverModel1:NSObject,ObservableObject ,DiscoveryDelegate{
    
    var discoverCancelable: Cancelable?
    var collectCancelable: Cancelable?
    @ObservedObject private var currencyManager = CurrencyManager(amount: 0)
    var nextActionButton = UIButton(type: .system)
    var readerMessageLabel = UILabel()
    var readerMsgLbl = ""
    @Published var showPay = false
    @Published var cancelPay = false
    @Published var errorPay = false
    @State private var showInvoice = false
    @State var taxiNumber : String = ""
    @State var driverABN : String = ""
    @State var driverLicence : String = ""
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @Published var paymentView = PaymentView(presentSideMenu: .constant(false))
    @Published var paymentDetail = PaymentDetailView(farePriceText: .constant("0.00"))
    @State var locManager = CLLocationManager()
    @State var fareAddress: String = ""
    @AppStorage("accountId") private var appAccountId: String = ""
    
    @objc
    func discoverReaders() throws {
        let config = try LocalMobileDiscoveryConfigurationBuilder().setSimulated(true).build()
        self.discoverCancelable = Terminal.shared.discoverReaders(config, delegate: self) { error in
            if let error = error {
                print("discoverReaders failed: \(error)")
                self.disconnectFromReader()
                self.errorPay = true
                NotificationCenter.default.post(name: NSNotification.Name("PAYMENTDETAIL"), object: nil)
            } else {
                print("discoverReaders succeeded")
            }
            
//            self.showPay = true
//            NotificationCenter.default.post(name: NSNotification.Name("PAYMENTDETAIL"), object: nil)
        }
    }
    
    @objc
    func disconnectFromReader() {
        Terminal.shared.disconnectReader { error in
            if let error = error {
                print("Disconnect failed: \(error)")
            } else {
                print("Reader Disconnect")
            }
        }
    }
    
    @objc
    func collectPayment(amount: String, serviceFee: String, serviceFeeGST: Double) throws {
//        firebaseFetch()
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        
        let developer = amount
        let array = developer.split(separator: ".").map(String.init)
        let arrAmount = "\(array[0])\(array[1])"
        print("Array amount: ",arrAmount)
          
        let srvGDeveloper = String(serviceFeeGST)
        let srvGArray = srvGDeveloper.split(separator: ".").map(String.init)
        let srvGAmount = "\(srvGArray[0])\(srvGArray[1])"
        print("srvArray amount: ",UInt(srvGAmount) as? NSNumber)
        
        let tNumber = UserDefaults.standard.string(forKey: "txNumber")
        let dABN = UserDefaults.standard.string(forKey: "driABN")
        let dLicence = UserDefaults.standard.string(forKey: "driLicence")
        let fAddress = UserDefaults.standard.string(forKey: "fareAddress") ?? "Australia"
        
        print("tNumber: ",tNumber, "dABN", dABN, "dLicence", dLicence, "fareAddress", fAddress)
        let param = [
            "taxiID": tNumber,
//            "ABN": dABN,
//            "Driverlicence": dLicence,
            "Address": fAddress
        ] as? [String: String]
        print("metadata params: ",param)
        
        let params = try PaymentIntentParametersBuilder(amount: UInt(arrAmount) ?? 0, currency: "AUD")
            .setPaymentMethodTypes(["card_present"])
            .setApplicationFeeAmount(UInt(srvGAmount) as? NSNumber)
            .setCaptureMethod(CaptureMethod.automatic)
            .setMetadata(param)
            .setTransferDataDestination(appAccountId)
            .build()
        
        Terminal.shared.createPaymentIntent(params) {
          createResult, createError in
            if let error = createError {
                print("createPaymentIntent failed: \(error)")
                self.errorPay = true
                NotificationCenter.default.post(name: NSNotification.Name("PAYMENTDETAIL"), object: nil)
            } else if let paymentIntent = createResult {
                print("createPaymentIntent succeeded")
                Terminal.shared.collectPaymentMethod(paymentIntent) { collectResult, collectError in
                    if let error = collectError {
                        print("collectPaymentMethod failed: \(error)")
//                        self.showPay = true
                        self.disconnectFromReader()
                        self.cancelPay = true
                        NotificationCenter.default.post(name: NSNotification.Name("PAYMENTDETAIL"), object: nil)
                    } else if let paymentIntent = collectResult {
                        print("collectPaymentMethod succeeded", paymentIntent)
                        self.showPay = true
                        self.confirmPaymentIntent(paymentIntent)
                        self.disconnectFromReader()
                        NotificationCenter.default.post(name: NSNotification.Name("PAYMENTDETAIL"), object: nil)
                    }
                }
            }
        }
    }

    private func confirmPaymentIntent(_ paymentIntent: PaymentIntent) {
        Terminal.shared.confirmPaymentIntent(paymentIntent) { confirmResult, confirmError in
            if let error = confirmError {
                print("confirmPaymentIntent failed: \(error)")
                self.cancelPay = true
                NotificationCenter.default.post(name: NSNotification.Name("PAYMENTDETAIL"), object: nil)
            } else if let confirmedPaymentIntent = confirmResult {
                print("c", confirmedPaymentIntent)
                
                let stripeChargesArr = confirmedPaymentIntent.charges
                let stripeReceiptId = stripeChargesArr[0].stripeId
                let receiptCreated = confirmedPaymentIntent.created
                
                UserDefaults.standard.set(stripeReceiptId, forKey: "stripeReceiptId")
                UserDefaults.standard.set(receiptCreated, forKey: "receiptCreated")
                
                
//                self.showPay = true
//                NotificationCenter.default.post(name: NSNotification.Name("PAYMENTDETAIL"), object: nil)
                
                
//                if let stripeId = confirmedPaymentIntent.stripeId {
//                    APIClient.shared.capturePaymentIntent(stripeId) { captureError in
//                        if let error = captureError {
//                            print("capture failed: \(error)")
//                        } else {
//                            print("capture succeeded")
//                            self.readerMessageLabel.text = "Payment captured"
//                            if let paymentMethod = paymentIntent.paymentMethod,
//                               let card = paymentMethod.cardPresent ?? paymentMethod.interacPresent {
//                                // ... Perform business logic on card
//                                print ("payment card res: ",card, paymentMethod)
//                            }
//                        }
//                    }
//                } else {
//                    print("Payment collected offline")
//                }
            }
        }
    }
    
    func terminal(_ terminal: Terminal, didUpdateDiscoveredReaders readers: [Reader]) {
        
        guard let selectedReader = readers.first else { return }
         let locationId = selectedReader.locationId
        print("locationId: ",locationId as Any)
        
        do {
            var termiialLocationID = ""
            if API.App_Envir == "Production" {
                termiialLocationID = "tml_Ff2ffAMANyDVrx"
            }
            else if API.App_Envir == "Dev" {
                termiialLocationID = "tml_FLrhpAr3WfbIVw"
            }
            else if API.App_Envir == "Stagging" {
                termiialLocationID = "tml_Ff2ffAMANyDVrx"
            }else{
                termiialLocationID = "tml_Ff2ffAMANyDVrx"
            }
            
//            let connectionConfig = try LocalMobileConnectionConfigurationBuilder(locationId: locationId ?? "tml_FLrhpAr3WfbIVw").build() // test
            let connectionConfig = try LocalMobileConnectionConfigurationBuilder(locationId: locationId ?? termiialLocationID).build() // production
            
            Terminal.shared.connectLocalMobileReader(selectedReader, delegate: LocalMobileReaderDelegateAnnouncer.shared, connectionConfig: connectionConfig) { reader, error in
                if let reader = reader {
                    print("Successfully connected to reader: \(reader)")
                    do {
                        try self.collectPayment(amount: AmountDetail.instance.totalChargresWithTax.description, serviceFee: AmountDetail.instance.serviceFee.description, serviceFeeGST: AmountDetail.instance.collectionStrFee)
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

