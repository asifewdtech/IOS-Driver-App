//
//  OtpView.swift
//  Farepay
//
//  Created by Arslan on 21/09/2023.
//

import SwiftUI
import Combine

struct OtpView: View {
    
    //MARK: - Variable
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @FocusState private var pinFocusState : FocusPin?
    @State var pinOne: String = ""
    @State var pinTwo: String = ""
    @State var pinThree: String = ""
    @State var pinFour: String = ""
    @State private var willMoveToMainView = false
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            NavigationLink("", destination: Farepay.MainTabbedView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToMainView ).isDetailLink(false)
            
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack{
                topArea
                Spacer()
                otpView
                Spacer()
            }
            .padding(.all, 15)
        }
    }
}

struct OtpView_Previews: PreviewProvider {
    static var previews: some View {
        OtpView()
    }
}

extension OtpView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            Image(uiImage: .backArrow)
                .resizable()
                .frame(width: 35, height: 30)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("Payout")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
            
            Image(uiImage: .optionIcon)
        }
    }
    
    var otpView: some View{
        
        VStack(spacing: 30){
            
            Text("Enter the 4-digit code (Company name) sent to +32-3213409")
                .font(.custom(.poppinsMedium, size: 18))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            HStack(spacing:15){
                
                TextField("", text: $pinOne, prompt: Text("-").foregroundColor(Color(.darkGrayColor)))
                    .font(.custom(.poppinsBold, size: 20))
                    .modifier(OtpModifer(pin:$pinOne))
                    .onChange(of:pinOne){ newVal in
                        if (newVal.count == 1) {
                            pinFocusState = .pinTwo
                        }
                    }
                    .focused($pinFocusState, equals: .pinOne)
                
                TextField("", text:  $pinTwo, prompt: Text("-").foregroundColor(Color(.darkGrayColor)))
                    .font(.custom(.poppinsBold, size: 20))
                    .modifier(OtpModifer(pin:$pinTwo))
                    .onChange(of:pinTwo){ newVal in
                        if (newVal.count == 1) {
                            pinFocusState = .pinThree
                        }
                        else {
                            if (newVal.count == 0) {
                                pinFocusState = .pinOne
                            }
                        }
                    }
                    .focused($pinFocusState, equals: .pinTwo)

                TextField("", text:$pinThree, prompt: Text("-").foregroundColor(Color(.darkGrayColor)))
                    .font(.custom(.poppinsBold, size: 20))
                    .modifier(OtpModifer(pin:$pinThree))
                    .onChange(of:pinThree){ newVal in
                        if (newVal.count == 1) {
                            pinFocusState = .pinFour
                        }
                        else {
                            if (newVal.count == 0) {
                                pinFocusState = .pinTwo
                            }
                        }
                    }
                    .focused($pinFocusState, equals: .pinThree)
                
                TextField("", text:$pinFour, prompt: Text("-").foregroundColor(Color(.darkGrayColor)))
                    .font(.custom(.poppinsBold, size: 20))
                    .modifier(OtpModifer(pin:$pinFour))
                    .onChange(of:pinFour){ newVal in
                        if (newVal.count == 0) {
                            pinFocusState = .pinThree
                        }
                        else{
                            setUserLogin(true)
                            willMoveToMainView.toggle()
                        }
                    }
                    .focused($pinFocusState, equals: .pinFour)
                
            }

            HStack{
                Text("Didn’t receive the code?")
                    .font(.custom(.poppinsMedium, size: 14))
                    .foregroundColor(.white)
                Text("Resend")
                    .font(.custom(.poppinsBold, size: 15))
                    .foregroundColor(.white)
            }
        }
    }
}
