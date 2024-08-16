//
//  PayQRView.swift
//  Farepay
//
//  Created by Arslan on 01/09/2023.
//

import SwiftUI
import WebKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct PayQRView: View {
    
    //MARK: - Variables
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var showWebView = false
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
    @State var goToHome = false
    @State var taxiNumber :String?
    @State var driverABN :String?
    @State var driverID :String?
    @State var qrUrl :String?
    @State var stripeReceiptId :String?
    @State var receiptDate: String?
    @State var receiptTime: String?
    @State var receiptDateTime: String?
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            NavigationLink("", destination: Farepay.MainTabbedView().toolbar(.hidden, for: .navigationBar), isActive: $goToHome ).isDetailLink(false)
            
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            
                
                VStack{
                    topArea
                    Spacer(minLength: 10)
                    ScrollView(.vertical, showsIndicators: false){
                    successView
                    Spacer(minLength: 50)
                    listView
                    Spacer(minLength: 30)
                    qrView
                    Spacer(minLength: 80)
                    ButtonView
                    Spacer(minLength: 20)
                }
                    .onAppear(perform: {
                        Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
                            if let error = error {
                                print(error.localizedDescription)
                            }else {
                                
                                guard let snap = snapShot else { return  }
                               driverABN  = snap.get("driverABN") as? String ?? "N/A"
                                driverID = snap.get("driverID") as? String ?? "N/A"
                                taxiNumber  = snap.get("taxiID") as? String ?? "N/A"
                                
                            }
                        }
                        stripeReceiptId = AmountDetail.instance.fareStripeId.description
                        let receiptCreated = AmountDetail.instance.fareDateTime
                        let receiptCreatedInt = AmountDetail.instance.fareDateTimeInt
                        
                        
                        if receiptCreatedInt == 0 {
                            receiptDateTime = formatDateToDayDateTime(receiptCreated)
                        }else{
                            receiptDateTime = convertUnixTimestamp(receiptCreatedInt)
                        }
                        
                        
                        let rcptID = String(describing: stripeReceiptId ?? "N/A")
                        let strReceiptId = rcptID.dropLast(12)
                        
                        print("stripeReceiptId: ",stripeReceiptId as Any)
                        print("strReceiptId: ",strReceiptId)
                        print("receiptCreated: ",receiptCreated)
                        print("receiptCreatedInt: ",receiptCreatedInt)
                        print("receiptDate: ",receiptDateTime)
                        
                        qrUrl = "\("https://dev-ewdtech.org/appmob/?param1=")\(strReceiptId )\("&param2=")\(receiptDateTime ?? "N/A")\("&param3=")\( taxiNumber ?? "N/A")\("&param4=")\(driverID ?? "N/A")\("&param5=")\( driverABN ?? "N/A")\("&param6=")\(AmountDetail.instance.totalAmount.description)\("&param7=")\(AmountDetail.instance.serviceFee.description)\("&param8=")\(AmountDetail.instance.serviceFeeGst.description)\("&param9=")\(AmountDetail.instance.totalChargresWithTax.description)"
                        
                        print("qrUrl: ",qrUrl)
                    })
                .padding(.all, 20)
            }
        }
    }
}

struct PayQRView_Previews: PreviewProvider {
    static var previews: some View {
        PayQRView()
    }
}

extension PayQRView{
    
    var topArea: some View{
        
        VStack(spacing: 35){
            
            HStack(spacing: 30){
                
                Image(uiImage: .backArrow)
                    .resizable()
                    .frame(width: 25, height: 20)
                    .onTapGesture {
                        let transBit =
                        UserDefaults.standard.integer(forKey: "transHistoryFlow")
                        if transBit == 1 {
                        presentationMode.wrappedValue.dismiss()
                        }else{
//                        rootPresentationMode.wrappedValue.dismiss()
                            self.goToHome.toggle()
                        }
                    }
                Text("Receipt")
                    .foregroundColor(.white)
                    .font(.custom(.poppinsBold, size: 25))
                Spacer()
                Image(uiImage: .ic_Home2)
                    .resizable()
                    .frame(width: 45, height: 45)
                    .onTapGesture {
                        self.goToHome.toggle()
                        print("Home")
                    }
                
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
        }
    }
    
    var successView: some View{
        
        VStack(spacing: 15){
            
            Image(uiImage: .ic_Success)
                .resizable()
                .frame(width: 130, height: 130)
            Text("Payment Successful")
                .foregroundColor(.white)
                .font(.custom(.poppinsBold, size: 25))
            Text("\("$")\(AmountDetail.instance.totalChargresWithTax.description)")
                .foregroundColor(.white)
                .font(.custom(.poppinsBold, size: 50))
        }
        
    }
    
    var listView: some View{
        
        VStack(spacing: 20){
            
            Group{
                
                HStack{
                    
                    HStack{
                        
                        Image(uiImage: .ic_Discount)
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Fare Inc GST:")
                            .foregroundColor(.white)
                            .font(.custom(.poppinsBold, size: 20))
                    }
                    Spacer()
                    Text("\("$")\(AmountDetail.instance.totalAmount.description)")
                        .foregroundColor(.white)
                        .font(.custom(.poppinsBold, size: 20))
                }
                
                HStack{
                    
                    HStack{
                        
                        Image(uiImage: .ic_Wallet)
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Service Fee:")
                            .foregroundColor(.white)
                            .font(.custom(.poppinsBold, size: 20))
                    }
                    Spacer()
                    Text("\("$")\(AmountDetail.instance.serviceFee.description)")
                        .foregroundColor(.white)
                        .font(.custom(.poppinsBold, size: 20))
                }
                
                HStack{
                    
                    HStack{
                        
                        Image(uiImage: .ic_GST)
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("Service Fee GST")
                            .foregroundColor(.white)
                            .font(.custom(.poppinsBold, size: 20))
                    }
                    Spacer()
                    Text("\("$")\(AmountDetail.instance.serviceFeeGst.description)")
                        .foregroundColor(.white)
                        .font(.custom(.poppinsBold, size: 20))
                }
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(.darkBlueColor))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundColor(Color(.darkGrayColor))
            )
            
        }
    }
    
    var qrView: some View{
        
        ZStack{
            
            VStack(spacing: 20){
                let tAmount = Double( AmountDetail.instance.totalAmount.description)
                let tChargesWithTax = Double( AmountDetail.instance.totalChargresWithTax.description)
                
                let rcptID = String(describing: stripeReceiptId ?? "N/A")
                let strReceiptId = rcptID.dropLast(12)
                
                let QRUrl = "\("https://dev-ewdtech.org/appmob/?param1=")\(strReceiptId )\("&param2=")\(receiptDateTime ?? "N/A")\("&param3=")\( taxiNumber ?? "N/A")\("&param4=")\(driverID ?? "N/A")\("&param5=")\( driverABN ?? "N/A")\("&param6=")\( tAmount ?? 0.00)\("&param7=")\(AmountDetail.instance.serviceFee.description)\("&param8=")\(AmountDetail.instance.serviceFeeGst.description)\("&param9=")\(tChargesWithTax ?? 0.00)"
                
                Image(uiImage: UIImage(data: getQRCodeDate(text: QRUrl)!)!)
                
                    .resizable()
                    .frame(width: 195, height: 195)
                    .onTapGesture {
                        UIApplication.shared.open(URL(string: QRUrl)!)
                    }
                
                
//                Button {
//                    print("Scan QR for Receipt")
//                } label: {
                    
                    Text("Press or Scan QR for Receipt")
                        .font(.custom(.poppinsBold, size: 22))
                        .foregroundColor(.white)
                        .frame(width: 330)
                        .frame(height: 60)
                        
//                        .background(Color(.buttonColor))
//                        .cornerRadius(30)
//                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 330)
        .background(Color(.darkBlueColor))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                .foregroundColor(Color(.darkGrayColor))
        )
    }
    
    var ButtonView: some View {
        
        ZStack{
            Button {
                self.goToHome.toggle()
                print("Back to Home")
            } label: {
                
                Text("Back to Home")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                    .frame(width: 330)
                    .frame(height: 60)
                    
                    .background(Color(.buttonColor))
                    .cornerRadius(30)
            }
        }
    }
    struct WebView: UIViewRepresentable {
        
        let webView: WKWebView
        let webUrl = "\("https://dev-ewdtech.org/appmob/?param1=")\("value1")\("&param2=")\("123")\("&param3=")\("example")\("&param4=")\("true")\("&param5=")\("data")\("&param6=")\("42.0")\("&param7=")\("param7_value")\("&param8=")\("param8_value")\("&param9=")\("param9_valu")"
        
        init() {
            webView = WKWebView(frame: .zero)
            
        }
        
        func makeUIView(context: Context) -> WKWebView {
            return webView
        }
        func updateUIView(_ uiView: WKWebView, context: Context) {
            webView.load(URLRequest(url: URL(string: webUrl)!))
        }
    }
    
    func getQRCodeDate(text: String) -> Data? {
           guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
           let data = text.data(using: .ascii, allowLossyConversion: false)
           filter.setValue(data, forKey: "inputMessage")
           guard let ciimage = filter.outputImage else { return nil }
           let transform = CGAffineTransform(scaleX: 10, y: 10)
           let scaledCIImage = ciimage.transformed(by: transform)
           let uiimage = UIImage(ciImage: scaledCIImage)
           return uiimage.pngData()!
       }
    
    func convertUnixTimestamp(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd-MM-yyyy, HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
    
    func formatDateToDayDateTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d-MM-yyyy, HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: date)
    }
}
