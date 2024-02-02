//
//  HomeView.swift
//  Farepay
//
//  Created by Arslan on 30/08/2023.
//

import SwiftUI
import ActivityIndicatorView
import FirebaseFirestore
import FirebaseAuth

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
    @State private var willMoveToTaxiNum = false
    @State private var showLoadingIndicator: Bool = false
    @State private var locationPermission = false
    @State var showTaxi = false
    @State var taxiNumber = ""
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            NavigationLink("", destination: PaymentDetailView(farePriceText: $currencyManager.string).toolbar(.hidden, for: .navigationBar), isActive: $willMoveToPaymentDetail).isDetailLink(false)
            NavigationLink("", destination: TapToPayView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveTapToPayView).isDetailLink(false)
            NavigationLink("", destination: PayQRView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToQr).isDetailLink(false)
            NavigationLink("", destination: TaxiNumPopupView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToTaxiNum).isDetailLink(false)
            
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            VStack{
                topArea
//                calculationArea
                taxiNumberArea
                Spacer()
                
                keypadArea
                buttonArea
            }
            VStack{
                if(self.showTaxi){
                    taxiNumArea
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            .onAppear(perform: {
                showLoadingIndicator = false
//                currencyManager.string = ""
                firebaseAPI()
            })
            
            .toastView(toast: $toast)
            .padding(.all, 15)
            
            ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc(.green, lineWidth: 5))
                .frame(width: 50.0, height: 50.0)
                .foregroundColor(.white)
                .padding(.top, 400)
            
//            if(self.showTaxi){
//                VStack{
//                    CustomAlert()
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color.black.opacity(0.5))
//                .edgesIgnoringSafeArea(.all)
//                .onTapGesture {x
//                    withAnimation {
//                        let showTaxiNumPopup = UserDefaults.standard.integer(forKey: "showTaxiNumPopup")
//                        if showTaxiNumPopup == 1{
//                            self.showTaxi.toggle()
//                        }
//                    }
//                }
//            }
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
            HStack(spacing: 20){
                Image(uiImage: .logo)
                    .resizable()
                    .frame(width: 50, height: 50)
                Text("FarePay")
                    .font(.custom(.poppinsBold, size: 35))
                    .foregroundColor(.white)
                    .onAppear(){
                        setMainView(true)
                    }
            }
            
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
    
    var taxiNumberArea : some View{
//        VStack(alignment: .trailing){
        HStack(spacing: 20){
                Button("\("Taxi Number: ")\(taxiNumber)") {
                    self.showTaxi.toggle()
                    UserDefaults.standard.removeObject(forKey: "showTaxiNumPopup")
//                    self.willMoveToTaxiNum.toggle()
                }
                .font(.custom(.poppinsMedium, size: 16))
                .foregroundColor(.white)
                .frame(height: 60)
                
                .multilineTextAlignment(.trailing)
            }
            .padding(.trailing, 10)
            .frame(minWidth: 320, maxWidth: .infinity, minHeight: 30, maxHeight: 40, alignment: .trailing)
        
//        }
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
                .font(.custom(.poppinsBold, size: 35))
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
                willMoveToPaymentDetail.toggle()
                //                willMoveTapToPayView.toggle()
                
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
    
    var taxiNumArea: some View{
        VStack{
            VStack {
                
                HStack(spacing: 20) {
                    Text("Taxi Number")
                        .font(.custom(.poppinsSemiBold, size: 18))
                        .foregroundColor(Color(.darkBlueColor))
                }
                .padding(.top)
                .frame(minWidth: 0, maxWidth: 150, minHeight: 0, maxHeight: 40, alignment: .leading)
                .padding(.trailing, 170)
                
                HStack(spacing: 5){
                        Image(uiImage: .taxiNumIcon)
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(.leading, 10)
                    TextField(taxiNumber, text: $taxiNumber)
                            .font(.custom(.poppinsMedium, size: 16))
                            .foregroundColor(Color(.darkBlueColor))
                            .disabled(false)
                            .textInputAutocapitalization(.characters)
                    }
                    .frame(minWidth: 0, maxWidth: 330, minHeight: 0, maxHeight: 40, alignment: .center)
                .background(Color(.TaxiFieldColor))
                .cornerRadius(10)
                    
                    Spacer()
                
                    HStack(spacing: 20) {
                        Button {
                            print("txNmbr: ", taxiNumber)
                            self.showTaxi.toggle()
                            Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").updateData(["taxiNumber" : taxiNumber])
                            UserDefaults.standard.set(1, forKey: "showTaxiNumPopup")
                        } label: {
                            
                            Text("Update")
                                .font(.custom(.poppinsMedium, size: 15))
                                .foregroundColor(.white)
                        }
                    }
                .frame(minWidth: 120, maxWidth: 120, minHeight: 40, maxHeight: 40, alignment: .center)
                .background(Color(.buttonColor))
                .cornerRadius(40)
                Spacer()
                }
            .frame(minWidth: 320, maxWidth: 350, minHeight: 150, maxHeight: 170)
                .background(Color.white)
                .cornerRadius(20)
        }
        .frame(minWidth: 395 ,maxWidth: .infinity,minHeight: 760 ,maxHeight: .infinity)
        .background(Color.black.opacity(0.5))
    }
    
    func firebaseAPI() {
        Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
            if let error = error {
                print(error.localizedDescription)
            }else {
                
                guard let snap = snapShot else { return  }
               taxiNumber  = "\(snap.get("taxiNumber") as? String ?? "")"
                
            }
        }
    }
}

struct CustomAlert: View{
    var body:some View{
        @State var taxiNmbr: String = ""
        @State var taxiNmbr1 = ""
        
        VStack {
            
            HStack(spacing: 20) {
                
                Text("Taxi Number")
                    .font(.custom(.poppinsMedium, size: 20))
                    .foregroundColor(Color(.darkBlueColor))
            }
            .padding(.top)
        
            .frame(minWidth: 0, maxWidth: 150, minHeight: 0, maxHeight: 40, alignment: .leading)
            .padding(.trailing, 170)
            
                
            HStack(spacing: 5){
                    
//                    Image(uiImage: .taxiNumIcon)
//                        .resizable()
//                        .frame(width: 20, height: 20)
                        
//                TextField(taxiNmbr1, text: $taxiNmbr)
////                        .textInputAutocapitalization(.never)
//                        .font(.custom(.poppinsMedium, size: 16))
////                        .frame(height: 38)
//                        .foregroundColor(Color(.darkBlueColor))
//                        .disabled(false)
                MDCFilledTextFieldWrapper(leadingImage: .constant(.taxiNumIcon), text: $taxiNmbr1, placHolderText: .constant(""), isSecure: .constant(false))
                }
                .frame(minWidth: 0, maxWidth: 330, minHeight: 0, maxHeight: 40, alignment: .center)
                
            .background(Color(.TaxiFieldColor))
            .cornerRadius(10)
                
                Spacer()
        
            HStack(spacing: 20) {
                Button {
                    print("txNmbr: ", taxiNmbr , taxiNmbr1)
                    
                    Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").updateData(["taxiNumber" : taxiNmbr])
//                    showLoadingIndicator = false
                    
                    UserDefaults.standard.set(1, forKey: "showTaxiNumPopup")
                } label: {
                    
                    Text("Update")
                        .font(.custom(.poppinsMedium, size: 15))
                        .foregroundColor(.white)
                }
            }
            .frame(minWidth: 120, maxWidth: 120, minHeight: 40, maxHeight: 40, alignment: .center)
            
//            .padding(.leading, 250)
//            .multilineTextAlignment(.leading)
//            .padding(.bottom, 10)
            .background(Color(.buttonColor))
            .cornerRadius(40)
            Spacer()
            }
        .frame(minWidth: 320, maxWidth: 350, minHeight: 150, maxHeight: 170)
            .background(Color.white)
            .cornerRadius(20)
//            .padding([.leading, .trailing], 20)
//            .frame(width: 350)
//            .frame(maxHeight: 180)
    }
}

