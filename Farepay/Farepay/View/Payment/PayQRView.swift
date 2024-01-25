//
//  PayQRView.swift
//  Farepay
//
//  Created by Arslan on 01/09/2023.
//

import SwiftUI
import WebKit

struct PayQRView: View {
    
    //MARK: - Variables
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var showWebView = false
    @Environment(\.rootPresentationMode) private var rootPresentationMode: Binding<RootPresentationMode>
    @State var goToHome = false
    
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
                    Spacer(minLength: 50)
                    qrView
                    Spacer(minLength: 20)
                }
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
//                        presentationMode.wrappedValue.dismiss()
//                        rootPresentationMode.wrappedValue.dismiss()
                        self.goToHome.toggle()
                    }
                Text("Receipt")
                    .foregroundColor(.white)
                    .font(.custom(.poppinsBold, size: 25))
                Spacer()
//                Image(uiImage: .ic_Home2)
//                    .resizable()
//                    .frame(width: 45, height: 45)
//                    .onTapGesture {
//                        
//                        print("Home")
//                    }
                
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
            Text("\(AmountDetail.instance.totalChargresWithTax.description)")
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
                            .frame(width: 40, height: 40)
                        Text("Fare Inc GST:")
                            .foregroundColor(.white)
                            .font(.custom(.poppinsBold, size: 20))
                    }
                    Spacer()
                    Text("\(AmountDetail.instance.totalAmount.description)")
                        .foregroundColor(.white)
                        .font(.custom(.poppinsBold, size: 20))
                }
                
                HStack{
                    
                    HStack{
                        
                        Image(uiImage: .ic_Discount)
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("Service Fee:")
                            .foregroundColor(.white)
                            .font(.custom(.poppinsBold, size: 20))
                    }
                    Spacer()
                    Text("\(AmountDetail.instance.serviceFee.description)")
                        .foregroundColor(.white)
                        .font(.custom(.poppinsBold, size: 20))
                }
                
                HStack{
                    
                    HStack{
                        
                        Image(uiImage: .ic_Discount)
                            .resizable()
                            .frame(width: 40, height: 40)
                        Text("Service Fee GST")
                            .foregroundColor(.white)
                            .font(.custom(.poppinsBold, size: 20))
                    }
                    Spacer()
                    Text("\(AmountDetail.instance.serviceFeeGst.description)")
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
            
            VStack(spacing: 40){
                
                
                let QRUrl = "\("https://dev-ewdtech.org/appmob/?param1=")\("123456")\("&param2=")\("20/12")\("&param3=")\("1234")\("&param4=")\("1234")\("&param5=")\("1234")\("&param6=")\(AmountDetail.instance.totalAmount.description)\("&param7=")\(AmountDetail.instance.serviceFee.description)\("&param8=")\(AmountDetail.instance.serviceFeeGst.description)\("&param9=")\(AmountDetail.instance.totalChargresWithTax.description)"
                
                Image(uiImage: UIImage(data: getQRCodeDate(text: QRUrl)!)!)
                
                    .resizable()
                    .frame(width: 175, height: 175)
                
                
//                Button {
//                    print("Scan QR for Receipt")
//                } label: {
//                    
//                    Text("Scan QR for Receipt")
//                        .font(.custom(.poppinsBold, size: 25))
//                        .foregroundColor(.white)
//                        .frame(width: 330)
//                        .frame(height: 60)
//                        
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

}
