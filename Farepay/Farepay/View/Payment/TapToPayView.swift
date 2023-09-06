//
//  TapToPayView.swift
//  Farepay
//
//  Created by Arslan on 31/08/2023.
//

import SwiftUI
import NavigationStack

struct TapToPayView: View {
    
    //MARK: - Variables
    @State private var farePriceText: String = ""
    @State private var isDisabled: Bool = true
    @State private var willMoveToTryAgain = false
    @EnvironmentObject private var navigationStack: NavigationStackCompat
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            VStack{
                
                topArea
                Spacer()
                tapArea
                Spacer()
                textArea
                Spacer()
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
                        navigationStack.pop()
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
                navigationStack.push(PayQRView())
            }
    }
    
    var textArea: some View{
        
        Text("Tap here to pay")
            .foregroundColor(.white)
            .font(.custom(.poppinsBold, size: 25))
        
    }
}
