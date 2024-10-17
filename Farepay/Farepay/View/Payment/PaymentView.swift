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
import LocalAuthentication

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
    @State private var locationPermission = false
    @State var showTaxi = false
    @State var taxiNumber = ""
    @State private var showPopupView = false
    @AppStorage("accountId") private var appAccountId: String = ""
    @State private var accStatusStr = ""
    @State private var accStatusBool: Bool = false
    @State private var showFaceIDView = false
    
    //MARK: - Views
    var body: some View {
        NavigationView {
            ZStack{
                NavigationLink("", destination: PaymentDetailView(farePriceText: $currencyManager.string1).toolbar(.hidden, for: .navigationBar), isActive: $willMoveToPaymentDetail).isDetailLink(false)
                NavigationLink("", destination: TapToPayView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveTapToPayView).isDetailLink(false)
                NavigationLink("", destination: PayQRView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToQr).isDetailLink(false)
                
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
//                    NotificationCenter.default.addObserver(forName: Notification.Name("removeCurrencyFare"), object: nil, queue: .main) { _ in
////                                        showContentView = true
////                        showFaceIDView = true
////                        currencyManager.string1 = ""
//                    }
                    
                    let firstTime = UserDefaults.standard.integer(forKey: "firstTime")
                    if firstTime == 1{
                        accStatusStr = "pending"
                        accStatusBool = true
                        UserDefaults.standard.removeObject(forKey: "firstTime")
                    }else{
                        retriveAccountAPI()
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                        showLoadingIndicator = false
                        if accStatusBool {
                            if accStatusStr == "pending"{
                                let dialogMessage = UIAlertController(title: "Awaiting Approval", message: "Thank you for your application, we will be in touch within 24 hours.", preferredStyle: .alert)
                                let window = UIApplication.shared.keyWindow
                                window?.rootViewController?.present(dialogMessage, animated: true)
                                
                            }else if accStatusStr == "paused"{
                                let dialogMessage = UIAlertController(title: "Awaiting Approval", message: "Your Farepay account has been paused, please contact support.", preferredStyle: .alert)
                                let window = UIApplication.shared.keyWindow
                                window?.rootViewController?.present(dialogMessage, animated: true)
                                
                            }else{
                                print("Account Status is live.")
                            }
                        }
                    }
                    
                    print("App_Envir value: ",API.App_Envir)
                    if API.App_Envir == "Production" {
                        print("App_Envir val: Production")
                    }
                    else if API.App_Envir == "Dev" {
                        print("App_Envir val: Dev")
                    }
                    else if API.App_Envir == "Stagging" {
                        print("App_Envir val: Stagging")
                    }else{
                        print("App_Envir val: Error")
                    }
                    showLoadingIndicator = false
                    currencyManager.string1 = ""
                    firebaseAPI()
                })
                
                .toastView(toast: $toast)
                //            .padding(.all, 15)
                .fullScreenCover(isPresented: $showFaceIDView) {
                    AuthenticateFaceIdPswdView()
                }
                if showLoadingIndicator{
                    VStack{
                        ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc(.white, lineWidth: 5))
                            .frame(width: 50.0, height: 50.0)
                            .foregroundColor(.white)
                            .padding(.top, 350)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.5))
                    .edgesIgnoringSafeArea(.all)
                }
            }
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
                    
                    TextField(currencyManager.string1, text: $currencyManager.string1)
                        .font(.custom(.poppinsBold, size: 40))
                        .frame(height: 30)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .onChange(of: currencyManager.string1, perform: currencyManager.valueChanged)
                    
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
//        ZStack(alignment: .trailing){
        
        HStack(spacing: 3){
//            Image(systemName: "pencil")
            Image(uiImage: .ic_iconPencil)
                .foregroundColor(Color(.darkGrayColor))
                .frame(width: 18, height: 18)
            
                Button("\("Taxi Number: ")\(taxiNumber)") {
                    self.showTaxi.toggle()
                    UserDefaults.standard.removeObject(forKey: "showTaxiNumPopup")
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
                    Text("$ \(currencyManager.string1.description)")
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
                            currencyManager.string1 += "1"
                        }
                    Text("2")
                        .onTapGesture {
                            currencyManager.string1 += "2"
                        }
                    Text("3")
                        .onTapGesture {
                            currencyManager.string1 += "3"
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
                            currencyManager.string1 += "4"
                        }
                    Text("5")
                        .onTapGesture {
                            currencyManager.string1 += "5"
                        }
                    Text("6")
                        .onTapGesture {
                            currencyManager.string1 += "6"
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
                            currencyManager.string1 += "7"
                        }
                    Text("8")
                        .onTapGesture {
                            currencyManager.string1 += "8"
                        }
                    Text("9")
                        .onTapGesture {
                            currencyManager.string1 += "9"
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
                            currencyManager.string1 += "0"
                        }
                    Image(uiImage: .ic_BackSpace)
                        .resizable()
                        .frame(width: 50, height: 50)
                        .onTapGesture {
                            if !currencyManager.string1.isEmpty{
                                currencyManager.string1.removeLast()
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
                let asdf: String = currencyManager.string1
                print("currencyManager.st: ",asdf)
                let qwer = NumberFormatter().number(from: asdf)?.doubleValue ?? 0.51
                print("currencyManager.dbl: ",qwer as Any)
                if taxiNumber == "" {
                    toast = Toast(style: .error, message: "Taxi Number is required.")
                    self.showTaxi.toggle()
                }
                else if qwer == 0.0 {
                    toast = Toast(style: .error, message: "Please enter your Fare.")
                }
                else if qwer <= 0.5 {
                    toast = Toast(style: .error, message: "Fare should be greater than $0.50.")
                }
                else {
                setMainView(false)
                print("currencyManager.string1: ", currencyManager.string1)
                willMoveToPaymentDetail.toggle()
            }
//                willMoveTapToPayView.toggle()
                
                //                if currencyManager.string.count == 2 && currencyManager.string.count <= 2 {
                //                    toast = Toast(style: .error, message: "Fare Pay should be minimum 10 AUD.")
                //                }else {
                //                    willMoveToPaymentDetail.toggle()
                //                    print(currencyManager.string)
                //                }
            } label: {
                
                Text("CHARGE")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(currencyManager.string1 == "0.00" || currencyManager.string1 == "" ? Color(.buttonColor).opacity(0.5) : Color(.buttonColor))
                    .cornerRadius(30)
            }
            .disabled(currencyManager.string1 == "0.00" || currencyManager.string1 == "0" || currencyManager.string1 == "" ? true : false)
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
                            if taxiNumber.isValidTaxiNum(taxiNumber) == true{
                                print("txNmbr: ", taxiNumber)
                                self.showTaxi.toggle()
                                Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").updateData(["taxiID" : taxiNumber])
                                UserDefaults.standard.set(1, forKey: "showTaxiNumPopup")
                                
                            }else {
                                toast = Toast(style: .error, message: "Taxi Number Field only contain uppercase Characters and Digits.")
                            }
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
        .frame(minWidth: 300 ,maxWidth: .infinity,minHeight: 700 ,maxHeight: .infinity)
        .background(Color.black.opacity(0.5))
    }
    
    func firebaseAPI() {
//        Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
//            if let error = error {
//                print(error.localizedDescription)
//            }else {
//                
//                guard let snap = snapShot else { return  }
//               taxiNumber  = "\(snap.get("taxiID") as? String ?? "")"
//                print("taxiNumber: ",taxiNumber)
//            }
//        }
        
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
                            taxiNumber  = data["taxiID"] as? String ?? ""
                            //                        print("taxiNumber: ",taxiNumber)
                        }
                    }
                }
            }
        }
    }
    
    func transactionSuccess() {
        showLoadingIndicator = false
//        presentationMode.wrappedValue.dismiss()
        willMoveToQr = true
    }
    
    func retriveAccountAPI () {
        showLoadingIndicator = true
        var reportUrl = ""
        if API.App_Envir == "Production" {
            reportUrl = "https://v2ycufp3t0.execute-api.eu-north-1.amazonaws.com/default/RetriveAccount?accountId=\(appAccountId)"
        }
        else if API.App_Envir == "Dev" {
            reportUrl = "https://tv2wmq0d74.execute-api.eu-north-1.amazonaws.com/default/RetriveAccount?accountId=\(appAccountId)"
        }
        else if API.App_Envir == "Stagging" {
            reportUrl = "https://pucqerawzi.execute-api.eu-north-1.amazonaws.com/default/RetriveAccount?accountId=\(appAccountId)"
        }else{
            reportUrl = "https://v2ycufp3t0.execute-api.eu-north-1.amazonaws.com/default/RetriveAccount?accountId=\(appAccountId)"
        }
        
        var request = URLRequest(url: URL(string: reportUrl)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                return
            }
//            showLoadingIndicator = false
            print("retriveAccountAPI: ",String(data: data, encoding: .utf8)!)
            do {
                if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]{
                    if let accStatus = jsonDict["accountStatus"] as? String {
                        print("Success accStatus parsing JSON: \(accStatus)")
                        if accStatus == "pending"{
                            accStatusStr = "pending"
                            accStatusBool = true
                            
                        }else if accStatus == "paused"{
                            accStatusStr = "paused"
                            accStatusBool = true
                            
                        }else{
                            print("Account API Status is live.")
                            accStatusStr = "live"
                            accStatusBool = false
                        }
                    }
                }
            }
            catch{
                print("Error parsing JSON: \(error)")
            }
        }
        task.resume()
        
    }
}

