//
//  Form1View.swift
//  Farepay
//
//  Created by Arslan on 25/08/2023.
//

import SwiftUI
import Combine

struct CompanyView: View {
    
    //MARK: - Variable
    @State var companyText: String = ""
    @State private var cardText: String = ""
    @State private var contactText: String = ""
    @State private var willMoveToRepresentativeView: Bool = false
    @State private var isPresentedPopUp: Bool = false
    @State private var toast: Toast? = nil
    
    //MARK: - Views
    var body: some View {
        
        NavigationStack {
            ZStack{
                
                NavigationLink("", destination: RepresentativeView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToRepresentativeView).isDetailLink(false)
                
                Color(.bgColor).edgesIgnoringSafeArea(.all)
                VStack{
                    ScrollView(showsIndicators: false){
                        VStack(spacing: 40) {
                            topArea
                            textArea
                        }
                    }
                    buttonArea
                }
                .onAppear(perform: {
                    UserDefaults.standard.removeObject(forKey: "driverABN")
                })
                .toastView(toast: $toast)
                .padding(.all, 15)
            }
            .onReceive(NotificationCenter.default.publisher(for: .proceedNext)) { _ in
                print("Received Custom Notification")
                willMoveToRepresentativeView.toggle()
            }
        }
    }
}

struct Form1View_Previews: PreviewProvider {
    static var previews: some View {
        CompanyView()
    }
}

extension CompanyView{
    
    var topArea: some View{
        
        VStack(spacing: 20){
            
            Text("Fill in the form below")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            
            VStack{
                
                Text("to get your own farepay account!")
                    .font(.custom(.poppinsMedium, size: 18))
                    .foregroundColor(Color(.darkGrayColor))
                Color(.darkGrayColor)
                    .frame(maxWidth: 300)
                    .frame(height: 1)
            }
            
            HStack(spacing: 5){
                
                Color(.ErrorColor)
                    .frame(height: 5)
                Color(.darkGrayColor)
                    .frame(height: 5)
            }
            .frame(width: 250)
            
            Text("COMPANY INFORMATION")
                .font(.custom(.poppinsBold, size: 20))
                .foregroundColor(.white)
            
        }
    }
    
    var textArea: some View{
        
        VStack(alignment: .leading, spacing: 20){
            
            Group{
                
//                ZStack{
//                    
//                    HStack(spacing: 10){
//                        
//                        Image(uiImage: .ic_Company)
//                            .resizable()
//                            .frame(width: 30, height: 30)
//                        
//                        TextField("", text: $companyText, prompt: Text("\(.selectCompany)").foregroundColor(Color(.darkGrayColor)))
//                            .font(.custom(.poppinsMedium, size: 18))
//                            .frame(height: 30)
//                            .foregroundColor(.white)
//                            .disabled(true)
//                        
//                        Image(uiImage: .ic_DropDown)
//                            .resizable()
//                            .frame(width: 30, height: 30)
//                        
//                    }
//                    .padding([.leading, .trailing], 20)
//                }
//                .frame(height: 60)
                
                HStack(spacing: 10){
                    
                    DropdownSelector(
                        placeholder: .selectCompany, leftImage: .ic_Company,
                        options: businessType,
                        onOptionSelected: { option in
                            print(option)
                            self.companyText = option.value
                        })
                    .foregroundColor(.white)
                }
                
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Card), text: $cardText.max(11), placHolderText: .constant("Enter your ABN"), isSecure: .constant(false),isNumberPad: true)
                    
                MDCFilledTextFieldWrapper(leadingImage: .constant(.ic_Contact), text: $contactText.max(11), placHolderText: .constant("Enter your Drivers Licence"), isSecure: .constant(false),isNumberPad: true)
            }
            .frame(maxWidth: .infinity)
            .background(Color(.darkBlueColor))
            .cornerRadius(10)
        }
    }
    
    
    var buttonArea: some View{
        
        VStack(spacing: 20){
            Button(action: {
                PresentedPopUp()
            }, label: {
                Text("Proceed")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color(.buttonColor))
                    .cornerRadius(30)
                    
                    
            })
                .fullScreenCover(isPresented: $isPresentedPopUp) {
                    StepsView(presentedAsModal: $isPresentedPopUp)
                }
        }
    }
    
    func PresentedPopUp()  {
        if (companyText != "Sole Trader") && (companyText != "Business") {
            toast = Toast(style: .error, message: "Company Type field cannot be empty.")
        }
        else if cardText.isEmpty {
            toast = Toast(style: .error, message: "ABN field cannot be empty.")
        }
        else if cardText.count <= 10 {
            toast = Toast(style: .error, message: "ABN Should be 11 Digits.")
        }
        else if contactText.isEmpty {
            toast = Toast(style: .error, message: "Driver Licence field cannot be empty.")
        }
        else if contactText.count <= 7 {
            toast = Toast(style: .error, message: "Driver Licence Should be 8-11 Digits.")
        }
        else{
            UserDefaults.standard.removeObject(forKey: "stripeFlowStatus")
            UserDefaults.standard.set(cardText, forKey: "driverABN")
            isPresentedPopUp.toggle()
        }
    }
}


extension Binding where Value == String {
    func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}
