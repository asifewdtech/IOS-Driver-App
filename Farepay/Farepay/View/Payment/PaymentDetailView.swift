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
    @State private var willMoveToQr = false
    @State var showLoadingIndicator: Bool = false
    @State private var locationPermission = false
    @State var goToHome = false
    @State var locManager = CLLocationManager()
    @State private var toast: Toast? = nil
    @State private var collectedFeeStripe: String = " "
    @StateObject private var readerManager = ReaderConnectionManager()
    @StateObject private var paymentManager = PaymentInitiationManager()
    @AppStorage("accountId") private var appAccountId: String = ""
    
    //MARK: - Views
    var body: some View {
        ZStack {
            NavigationLink("", destination: Farepay.MainTabbedView().toolbar(.hidden, for: .navigationBar), isActive: $goToHome).isDetailLink(false)
            NavigationLink("", destination: ReaderConnectView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveTapToPayView).isDetailLink(false)
            NavigationLink("", destination: PayQRView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToQr).isDetailLink(false)
            
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                topArea
                Spacer()
                buttonArea
            }
            .onAppear {
//                matrixAPICall()
                fetchFirebase()
                fetchLatLong()
                
                let connectReaderBit = UserDefaults.standard.integer(forKey: "connectReaderBit")
                if connectReaderBit == 1{
                    UserDefaults.standard.removeObject(forKey: "connectReaderBit")
                    showLoadingIndicator = true
                    readerManager.discoverReaders()
                }
                
                // Clear previous user defaults
                UserDefaults.standard.removeObject(forKey: "txNumber")
                UserDefaults.standard.removeObject(forKey: "driABN")
                UserDefaults.standard.removeObject(forKey: "driLicence")
                UserDefaults.standard.removeObject(forKey: "fareAddress")
                UserDefaults.standard.removeObject(forKey: "transHistoryFlow")
                UserDefaults.standard.removeObject(forKey: "stripeReceiptId")
                UserDefaults.standard.removeObject(forKey: "receiptCreated")
                
                // Calculate fees and amounts
//                calculateFees()
                
                NotificationCenter.default.addObserver(forName: NSNotification.Name("StopLoaderIndicator"), object: nil, queue: .main) { (_) in
                    showLoadingIndicator = false
                }
            }
            .toastView(toast: $toast)
            .padding(.all, 20)
            
            // Payment Status Handling
            paymentStatusOverlay
            
            // Loading Indicator
            if showLoadingIndicator {
                loadingIndicatorView
            }
        }
    }
    
    // Extracted payment status handling
    private var paymentStatusOverlay: some View {
        Group {
            switch paymentManager.paymentStatus {
            case .processing:
                ProgressView() // Added a loading indicator for processing state
                
            case .success:
                Text("")
//                EmptyView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                            readerManager.disconnectReader()
                            showLoadingIndicator = false
                            willMoveToQr = true
                        }
                    }
                
            case .failed:
                Text("Payment Failed")
//                EmptyView()
                    .onAppear {
                        readerManager.disconnectReader()
                        showLoadingIndicator = false
                        presentationMode.wrappedValue.dismiss()
                    }
                
            case .idle:
                EmptyView()
            }
        }
    }
    
    // Loading indicator view
    private var loadingIndicatorView: some View {
        VStack {
            ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc(.white, lineWidth: 5))
                .frame(width: 50.0, height: 50.0)
                .foregroundColor(.green)
                .padding(.top, 350)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.5))
        .edgesIgnoringSafeArea(.all)
    }
    
    // Fee calculation method
    private func calculateFees() {
        guard let cost = Double(farePriceText.trimmingCharacters(in: .whitespaces)) else { return }
        
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        
        totalAmount = cost
        AmountDetail.instance.totalAmount = formatter.string(from: (Decimal(totalAmount)) as NSNumber) ?? "0.00"
        
        let amountWithFivePercent = cost * 5 / 100
        let srvcFee = (amountWithFivePercent / 1.1).roundToDecimal(2)
        serviceFee = formatter.string(from: (Decimal(srvcFee)) as NSNumber) ?? "0.00"
        AmountDetail.instance.serviceFee = srvcFee
        
        let srvcFeeGst = (amountWithFivePercent - srvcFee).roundToDecimal(2)
        serviceFeeGst = formatter.string(from: (Decimal(srvcFeeGst)) as NSNumber) ?? "0.00"
        AmountDetail.instance.serviceFeeGst = srvcFeeGst
        
        let totalChargresWithTx = (srvcFee + srvcFeeGst + cost).roundToDecimal(2)
        let colFeeStripe = (srvcFee + srvcFeeGst).roundToDecimal(2)
        
        collectedFeeStripe = String(colFeeStripe)
        AmountDetail.instance.collectionStrFee = collectedFeeStripe
        
        totalChargresWithTax = formatter.string(from: (Decimal(totalChargresWithTx)) as NSNumber) ?? "0.00"
        AmountDetail.instance.totalChargresWithTax = totalChargresWithTax
        
        
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
                        readerManager.disconnectReader()
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
                    
                    Text("Service Fee :")
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
                
//                DispatchQueue.main.async {
//                    
//                    if readerDiscoverModel1.showPay {
//                        
//                        do {
//                            showLoadingIndicator = true
//                            try readerDiscoverModel1.collectPayment(amount: totalChargresWithTax.description, serviceFee: serviceFee.description, serviceFeeGST: collectedFeeStripe)
////                            showLoadingIndicator = false
//                        }catch{
//                            print("Payment don't transfered")
//                            showLoadingIndicator = false
//                        }
//                    }
//                    else {
//                        do {
//                            showLoadingIndicator = true
//                            try readerDiscoverModel1.discoverReaders()
////                            showLoadingIndicator = false
//                        }catch{
//                            print("Readers not discovered")
//                            showLoadingIndicator = false
//                        }
//                    }
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 40){
//                        showLoadingIndicator = false
//                    }
//                }
                
                showLoadingIndicator = true
                paymentManager.initiatePayment(
                                        amount: AmountDetail.instance.totalChargresWithTax.description,
                                        serviceFee: AmountDetail.instance.serviceFee.description,
                                        serviceFeeGST: AmountDetail.instance.collectionStrFee,
                                        appAccountId: appAccountId
                                    )
                
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
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
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
            print("fetchLatLong latitude: ",currentLocation.coordinate.latitude)
            print("fetchLatLong longitude: ",currentLocation.coordinate.longitude)
            
            getAddressFromLatLong(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
        }
    }
    
    func getAddressFromLatLong(latitude: Double, longitude : Double){
        
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=AIzaSyDvzoBJGEDZ5LpZ002k8JvKfWgnepzwxdc"
        
        AF.request(url).validate().responseJSON { response in
            switch response.result {
            case let .success(value):
                if let results = (value as AnyObject).object(forKey: "results")  as? [NSDictionary] {
//                    print("getAddressFromLatLong: ",results)
                    if let addressComponents = results[1]["address_components"] as? [NSDictionary] {
                        for component in addressComponents {
                            if let temp = component.object(forKey: "types") as? [String] {
                                if (temp[0] == "locality") {
                                    let address = component["long_name"] as? String ?? "N/A"
                                    print("city value: ",address)
                                    UserDefaults.standard.set(address, forKey: "fareAddress")
                                }
                                if (temp[0] == "administrative_area_level_1") {
                                    let address = component["long_name"] as? String ?? "N/A"
                                    print("state value: ",address)
                                    UserDefaults.standard.set(address, forKey: "fareStateAddress")
                                    matrixAPICall()
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
    
    func matrixAPICall(){
//        let fAddress = UserDefaults.standard.string(forKey: "fareStateAddress") ?? "New%20South%20Wales"
        var fAddress = ""
        if API.App_Envir == "Production" {
            fAddress = UserDefaults.standard.string(forKey: "fareStateAddress") ?? "New%20South%20Wales"
        }
        else if API.App_Envir == "Dev" {
            fAddress = "New%20South%20Wales"
        }else{
            fAddress = UserDefaults.standard.string(forKey: "fareStateAddress") ?? "New%20South%20Wales"
        }
        
        
        let latlongStr = fAddress.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
        
        var request = URLRequest(url: URL(string: "\("https://scu64u0v0g.execute-api.eu-north-1.amazonaws.com/default/CalculateFareAndFee?fareInclGST=")\(farePriceText.trimmingCharacters(in: .whitespaces))&state=\(latlongStr)")!,timeoutInterval: Double.infinity)
        print("matrixAPICall url: ",request)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            return
          }
          print("matrixAPICall is: ",String(data: data, encoding: .utf8)!)
            do {
//                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    if let statusDict = jsonDict["step4Implementation"] as? String {
//                        print("Success matrixAPICall parsing JSON: \(statusDict)")
//                        
//                        // Split the string into components
//                        let array = statusDict.split(separator: "+").map(String.init)
//                        let array1 = array[2].split(separator: "=").map(String.init)
//                        
//                        // Ensure valid numbers before formatting
//                        if let serviceFeeValue = Double(array[1].trimmingCharacters(in: .whitespaces)),
//                           let serviceFeeGstValue = Double(array1[0].trimmingCharacters(in: .whitespaces)),
//                           let totalChargesValue = Double(array1[1].trimmingCharacters(in: .whitespaces)) {
//                            
//                            let formatter = NumberFormatter()
//                            formatter.minimumFractionDigits = 2
//                            formatter.maximumFractionDigits = 2
//                            formatter.minimumIntegerDigits = 1
//                            
//                            // Format the numbers as strings
//                            serviceFee = formatter.string(for: serviceFeeValue) ?? "0.00"
//                            serviceFeeGst = formatter.string(for: serviceFeeGstValue) ?? "0.00"
//                            totalChargresWithTax = formatter.string(for: totalChargesValue) ?? "0.00"
//                            
//                            AmountDetail.instance.totalChargresWithTax = formatter.string(for: totalChargesValue) ?? "0.00"
//                            AmountDetail.instance.totalAmount = formatter.string(for: totalChargesValue) ?? "0.00"
//                            AmountDetail.instance.serviceFee = serviceFeeValue
//                            AmountDetail.instance.serviceFeeGst = serviceFeeGstValue
//                            AmountDetail.instance.collectionStrFee = array[2]
//                        } else {
//                            print("Error: Could not parse numbers from the string.")
//                        }
//                    }
//                }
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // Safely extract the values from the JSON response
                    let serviceFeeMatrix = jsonDict["serviceFee"] as? String
                    let serviceFeeGstMatrix = jsonDict["serviceFeeGst"] as? String
                    let totalFeeMatrix = jsonDict["total"] as? String

                    // Convert strings to Double for further manipulation if needed
                    let serviceFeeValue = Double(serviceFeeMatrix ?? "0") ?? 0.00
                    let serviceFeeGstValue = Double(serviceFeeGstMatrix ?? "0") ?? 0.00
                    let totalFeeValue = Double(totalFeeMatrix ?? "0") ?? 0.00

                    // Set up number formatter for consistent output
                    let formatter = NumberFormatter()
                    formatter.minimumFractionDigits = 2
                    formatter.maximumFractionDigits = 2
                    formatter.minimumIntegerDigits = 1

                    // Format and assign values
                    serviceFee = formatter.string(for: serviceFeeValue) ?? "0.00"
                    serviceFeeGst = formatter.string(for: serviceFeeGstValue) ?? "0.00"
                    totalChargresWithTax = formatter.string(for: totalFeeValue) ?? "0.00"
                    
                    let cost = Double(farePriceText.trimmingCharacters(in: .whitespaces))
                    AmountDetail.instance.totalChargresWithTax = formatter.string(for: totalFeeValue) ?? "0.00"
                    AmountDetail.instance.totalAmount = formatter.string(for: cost) ?? "0.00"
                    AmountDetail.instance.serviceFee = serviceFeeValue
                    AmountDetail.instance.serviceFeeGst = serviceFeeGstValue
                    AmountDetail.instance.collectionStrFee = serviceFeeGst
                }
            }
            catch{
                print("Error parsing JSON: \(error)")
                toast = Toast(style: .error, message: "Matrix API Call - \(error)")
            }
        }
        task.resume()
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
    var collectionStrFee = "0.0"
    var fareDateTime = Date()
    var fareDateTimeInt = 0
    var fareStripeId = ""
}

/*class ReaderDiscoverModel1:NSObject,ObservableObject ,DiscoveryDelegate{
    
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
        var isSimulator: Bool = false
        if API.App_Envir == "Production" {
            isSimulator = false
        }
        else if API.App_Envir == "Dev" {
            isSimulator = true
        }
        else if API.App_Envir == "Stagging" {
            isSimulator = false
        }else{
            isSimulator = false
        }
        
        let config = try LocalMobileDiscoveryConfigurationBuilder().setSimulated(isSimulator).build()
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
    func collectPayment(amount: String, serviceFee: String, serviceFeeGST: String) throws {
//        firebaseFetch()
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.minimumIntegerDigits = 1
        
        let developer = amount
        let array = developer.split(separator: ".").map(String.init)
        let arrAmount = "\(array[0])\(array[1])"
        print("Array amount: ",arrAmount)
          
        print("serviceFeeGST amount: ",serviceFeeGST)
        
        let srvGArray = serviceFeeGST.split(separator: ".").map(String.init)
        let srvGAmount = "\(srvGArray[0])\(srvGArray[1])"
        print("srvArray GST amount: ",srvGAmount)
        
        print("srvArr amount: ",srvGAmount.toUInt() as Any)
        let tNumber = UserDefaults.standard.string(forKey: "txNumber") ?? "0"
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
//            .setApplicationFeeAmount(srvGAmount.toUInt() as NSNumber?)
            .setApplicationFeeAmount(NumberFormatter().number(from: srvGAmount))
            .setCaptureMethod(CaptureMethod.automatic)
            .setMetadata(param)
            .setTransferDataDestination(appAccountId)
            .build()
        
        Terminal.shared.createPaymentIntent(params) {
          createResult, createError in
            if let error = createError {
                print("createPaymentIntent failed: \(error)")
                self.errorPay = true
                self.disconnectFromReader()
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                            self.PassMetaDataToConAcc(transferId: paymentIntent.stripeId ?? "", address: fAddress, tNumberId: tNumber ?? "")
                        }
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
                self.disconnectFromReader()
                NotificationCenter.default.post(name: NSNotification.Name("PAYMENTDETAIL"), object: nil)
            } else if let confirmedPaymentIntent = confirmResult {
                print("confirmedPaymentIntent", confirmedPaymentIntent)
                
                let stripeChargesArr = confirmedPaymentIntent.charges
                let stripeReceiptId = stripeChargesArr[0].stripeId
                let receiptCreated = confirmedPaymentIntent.created
                
                UserDefaults.standard.set(stripeReceiptId, forKey: "stripeReceiptId")
                UserDefaults.standard.set(receiptCreated, forKey: "receiptCreated")
                
                AmountDetail.instance.fareStripeId = stripeReceiptId
                AmountDetail.instance.fareDateTime = receiptCreated
                AmountDetail.instance.fareDateTimeInt = 0
                
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
                    self.disconnectFromReader()
                    print("connectLocalMobileReader failed: \(error)")
                }
            }
        } catch {
            print("Error creating LocalMobileConnectionConfiguration: \(error)")
        }
    }
    
    func PassMetaDataToConAcc(transferId: String, address: String, tNumberId: String){
        let transGrpId = "group_\(transferId)"
        var reportUrl = ""
        if API.App_Envir == "Production" {
            reportUrl = "https://ewlzgqybpa.execute-api.eu-north-1.amazonaws.com/default/PassMetaDataToConnectAccount?transferGroupId=\(transGrpId)&address=\(address)&taxiId=\(tNumberId)"
        }
        else if API.App_Envir == "Dev" {
            reportUrl = "https://rgvkobwnek.execute-api.eu-north-1.amazonaws.com/default/PassMetaDataToConnectAccount?transferGroupId=\(transGrpId)&address=\(address)&taxiId=\(tNumberId)"
        }
        else if API.App_Envir == "Stagging" {
            reportUrl = "https://ofrykfo9dg.execute-api.eu-north-1.amazonaws.com/default/PassMetaDataToConnectAccount?transferGroupId=\(transGrpId)&address=\(address)&taxiId=\(tNumberId)"
        }else{
            reportUrl = "https://ewlzgqybpa.execute-api.eu-north-1.amazonaws.com/default/PassMetaDataToConnectAccount?transferGroupId=\(transGrpId)&address=\(address)&taxiId=\(tNumberId)"
        }
        let urlNewAcc :String = reportUrl.replacingOccurrences(of: " ", with: "%20")
        print("reportUrl: ",urlNewAcc)
        
        guard let url = URL(string: urlNewAcc) else { return }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print("PassMetaDataToConAcc Err: ",String(describing: error))
            return
          }
          print("PassMetaDataToConAcc Scc: ",String(data: data, encoding: .utf8))
        }
        task.resume()
    }
}*/


class ReaderConnectionManager: NSObject, ObservableObject, DiscoveryDelegate {
    private var discoverCancelable: Cancelable?
    
    @Published var isReaderConnected = false
    @Published var connectionError: Error?
    
    func discoverReaders() {
        // Determine simulator status based on environment
        let isSimulator: Bool = {
            switch API.App_Envir {
            case "Dev": return true
            default: return false
            }
        }()
        
        do {
            let config = try LocalMobileDiscoveryConfigurationBuilder()
                .setSimulated(isSimulator)
                .build()
            
            self.discoverCancelable = Terminal.shared.discoverReaders(config, delegate: self) { error in
                if let error = error {
                    print("discoverReaders failed: \(error)")
                    self.connectionError = error
                    self.isReaderConnected = false
                } else {
                    print("discoverReaders succeeded")
                }
            }
        } catch {
            print("Error creating discovery configuration: \(error)")
            self.connectionError = error
        }
    }
    
    func terminal(_ terminal: Terminal, didUpdateDiscoveredReaders readers: [Reader]) {
        guard let selectedReader = readers.first else { return }
        
        let termiialLocationID: String = {
            switch API.App_Envir {
            case "Production": return "tml_Ff2ffAMANyDVrx"
            case "Dev": return "tml_FLrhpAr3WfbIVw"
            case "Stagging": return "tml_Ff2ffAMANyDVrx"
            default: return "tml_Ff2ffAMANyDVrx"
            }
        }()
        
        do {
            let connectionConfig = try LocalMobileConnectionConfigurationBuilder(
                locationId: selectedReader.locationId ?? termiialLocationID
            ).build()
            
            Terminal.shared.connectLocalMobileReader(
                selectedReader,
                delegate: LocalMobileReaderDelegateAnnouncer.shared,
                connectionConfig: connectionConfig
            ) { [weak self] reader, error in
                if let reader = reader {
                    NotificationCenter.default.post(name: NSNotification.Name("StopLoaderIndicator"), object: nil)
                    print("Successfully connected to reader: \(reader)")
                    self?.isReaderConnected = true
                } else if let error = error {
                    NotificationCenter.default.post(name: NSNotification.Name("StopLoaderIndicator"), object: nil)
                    print("connectLocalMobileReader failed: \(error)")
                    self?.connectionError = error
                }
            }
        } catch {
            NotificationCenter.default.post(name: NSNotification.Name("StopLoaderIndicator"), object: nil)
            print("Error creating LocalMobileConnectionConfiguration: \(error)")
            self.connectionError = error
        }
    }
    
    func disconnectReader() {
        Terminal.shared.disconnectReader { error in
            if let error = error {
                print("Disconnect failed: \(error)")
            } else {
                print("Reader Disconnected")
            }
        }
    }
}

// Part 2: Payment Initiation Manager
class PaymentInitiationManager: ObservableObject {
    @Published var paymentStatus: PaymentStatus = .idle
    @AppStorage("accountId") private var apAccountId: String = ""
    
    enum PaymentStatus {
        case idle, processing, success, failed
    }
    
    func initiatePayment(
        amount: String,
        serviceFee: String,
        serviceFeeGST: String,
        appAccountId: String
    ) {
        do {
            let formatter = NumberFormatter()
            formatter.minimumFractionDigits = 2
            formatter.maximumFractionDigits = 2
            formatter.minimumIntegerDigits = 1
            
            var applicationFee: String = ""
            // Parse serviceFee and serviceFeeGST as Decimal for precise calculations
            guard let serviceFeeDecimal = Decimal(string: serviceFee),
                  let serviceFeeGSTDecimal = Decimal(string: serviceFeeGST) else {
                print("Error: Unable to parse serviceFee or serviceFeeGST as Decimal")
                return
            }
            
            // Sum serviceFee and serviceFeeGST
            let totalServiceFee = serviceFeeDecimal + serviceFeeGSTDecimal
            print("Total Service Fee (sum of serviceFee and serviceFeeGST): \(totalServiceFee)")
            applicationFee = formatter.string(from: (totalServiceFee) as NSNumber) ?? "0.00" //"\(totalServiceFee)"
            
            let developer = amount
            let array = developer.split(separator: ".").map(String.init)
            let arrAmount = "\(array[0])\(array[1])"
            print("Array amount: ",arrAmount)
              
            print("serviceFeeGST amount: ",serviceFeeGST)
            
            let srvGArray = applicationFee.split(separator: ".").map(String.init)
            var srvGAmount: String = ""
            
            if srvGArray.count == 2 { // Ensure the split result has two components
                srvGAmount = "\(srvGArray[0])\(srvGArray[1])"
                print("srvArray GST amount: ", srvGAmount)
            } else {
                srvGAmount = "\(srvGArray[0])\("00")"
                print("Error: applicationFee format is invalid")
            }
            
            print("srvArr amount: ",srvGAmount.toUInt() as Any)
            let tNumber = UserDefaults.standard.string(forKey: "txNumber") ?? "0"
            let dABN = UserDefaults.standard.string(forKey: "driABN")
            let dLicence = UserDefaults.standard.string(forKey: "driLicence")
            let fAddress = UserDefaults.standard.string(forKey: "fareAddress") ?? "Australia"
            
            print("tNumber: ",tNumber, ",dABN", dABN, ",dLicence", dLicence, ",fareAddress", fAddress)
            print("appAccountId: ",appAccountId, ",srvGAmount", NumberFormatter().number(from: srvGAmount))
            let param = [
                "taxiID": tNumber,
    //            "ABN": dABN,
    //            "Driverlicence": dLicence,
                "Address": fAddress
            ] as? [String: String]
            print("metadata params: ",param)
            
            let params = try PaymentIntentParametersBuilder(amount: UInt(arrAmount) ?? 0, currency: "AUD")
                .setPaymentMethodTypes(["card_present"])
//                .setApplicationFeeAmount(srvGAmount.toUInt() as NSNumber?)
                .setApplicationFeeAmount(NumberFormatter().number(from: srvGAmount))
                .setCaptureMethod(CaptureMethod.automatic)
                .setMetadata(param)
                .setTransferDataDestination(apAccountId)
                .build()
            
            Terminal.shared.createPaymentIntent(params) {
              createResult, createError in
                if let error = createError {
                    print("createPaymentIntent failed: \(error)")
                    
//                    self.disconnectFromReader()
                    NotificationCenter.default.post(name: NSNotification.Name("PAYMENTDETAIL"), object: nil)
                } else if let paymentIntent = createResult {
                    print("createPaymentIntent succeeded")
                    Terminal.shared.collectPaymentMethod(paymentIntent) { collectResult, collectError in
                        if let error = collectError {
                            print("collectPaymentMethod failed: \(error)")
                            
//                            self.disconnectReader()
                            self.paymentStatus = .failed
                            NotificationCenter.default.post(name: NSNotification.Name("PAYMENTDETAIL"), object: nil)
                        } else if let paymentIntent = collectResult {
                            print("collectPaymentMethod succeeded", paymentIntent)
                            self.paymentStatus = .success
                            self.confirmPaymentIntent(paymentIntent)
//                            self.disconnectFromReader()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                                self.PassMetaDataToConAcc(transferId: paymentIntent.stripeId ?? "", address: fAddress, tNumberId: tNumber)
                            }
//                            NotificationCenter.default.post(name: NSNotification.Name("PAYMENTDETAIL"), object: nil)
                        }
                    }
                }
            }
        } catch {
            print("Payment initiation error: \(error)")
            paymentStatus = .failed
        }
    }
    
    private func collectPaymentMethod(paymentIntent: PaymentIntent) {
        Terminal.shared.collectPaymentMethod(paymentIntent) { [weak self] collectResult, collectError in
            if let error = collectError {
                print("collectPaymentMethod failed: \(error)")
                self?.paymentStatus = .failed
                return
            }
            
            guard let collectedPaymentIntent = collectResult else {
                self?.paymentStatus = .failed
                return
            }
            
            self?.confirmPaymentIntent(collectedPaymentIntent)
        }
    }
    
    private func confirmPaymentIntent(_ paymentIntent: PaymentIntent) {
        Terminal.shared.confirmPaymentIntent(paymentIntent) { [weak self] confirmResult, confirmError in
            if let error = confirmError {
                print("confirmPaymentIntent failed: \(error)")
                self?.paymentStatus = .failed
                return
            }
            
            guard let confirmedPaymentIntent = confirmResult else {
                self?.paymentStatus = .failed
                return
            }
            
            // Store receipt details
            if let stripeChargesArr = confirmedPaymentIntent.charges.first {
                UserDefaults.standard.set(stripeChargesArr.stripeId, forKey: "stripeReceiptId")
                UserDefaults.standard.set(confirmedPaymentIntent.created, forKey: "receiptCreated")
                
                let stripeChargesArr = confirmedPaymentIntent.charges
                let stripeReceiptId = stripeChargesArr[0].stripeId
                let receiptCreated = confirmedPaymentIntent.created
                
                AmountDetail.instance.fareStripeId = stripeReceiptId
                AmountDetail.instance.fareDateTime = receiptCreated
                AmountDetail.instance.fareDateTimeInt = 0
            }
            
            self?.paymentStatus = .success
        }
    }
    
    func PassMetaDataToConAcc(transferId: String, address: String, tNumberId: String){
        let transGrpId = "group_\(transferId)"
        var reportUrl = ""
        if API.App_Envir == "Production" {
            reportUrl = "https://ewlzgqybpa.execute-api.eu-north-1.amazonaws.com/default/PassMetaDataToConnectAccount?transferGroupId=\(transGrpId)&address=\(address)&taxiId=\(tNumberId)"
        }
        else if API.App_Envir == "Dev" {
            reportUrl = "https://rgvkobwnek.execute-api.eu-north-1.amazonaws.com/default/PassMetaDataToConnectAccount?transferGroupId=\(transGrpId)&address=\(address)&taxiId=\(tNumberId)"
        }
        else if API.App_Envir == "Stagging" {
            reportUrl = "https://ofrykfo9dg.execute-api.eu-north-1.amazonaws.com/default/PassMetaDataToConnectAccount?transferGroupId=\(transGrpId)&address=\(address)&taxiId=\(tNumberId)"
        }else{
            reportUrl = "https://ewlzgqybpa.execute-api.eu-north-1.amazonaws.com/default/PassMetaDataToConnectAccount?transferGroupId=\(transGrpId)&address=\(address)&taxiId=\(tNumberId)"
        }
        let urlNewAcc :String = reportUrl.replacingOccurrences(of: " ", with: "%20")
        print("reportUrl: ",urlNewAcc)
        
        guard let url = URL(string: urlNewAcc) else { return }
        var request = URLRequest(url: url, timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print("PassMetaDataToConAcc Err: ",String(describing: error))
            return
          }
          print("PassMetaDataToConAcc Scc: ",String(data: data, encoding: .utf8))
        }
        task.resume()
    }
}
