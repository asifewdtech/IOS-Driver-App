//
//  GiftCardDetailView.swift
//  Farepay
//
//  Created by Mursil on 09/09/2023.
//

import SwiftUI

struct GiftCardDetailView: View {
    
    //MARK: - Variables
    @State var giftValue: Int = 0
    @State var presentingModal = false
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    //MARK: - Views
    var body: some View {
        ZStack{
                        
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15){
                topArea
                VStack{
                    ScrollView(showsIndicators: false) {
                        priceView
                    }
                    .disabled(true)
                }
                buttonArea
            }
            .padding(.all, 15)
        }
    }
    
    //MARK: - Functions
}

struct GiftCardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GiftCardDetailView()
    }
}

extension GiftCardDetailView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            
            Image(uiImage: .backArrow)
                .resizable()
                .frame(width: 35, height: 30)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            
            Text("Gift Card")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
        }
    }
    
    var priceView: some View{
        
        VStack(spacing: 20){
            
            ZStack{
                Image(uiImage: .ic_Apple)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
            }
            .frame(width: 100, height: 100)
            .background(.white)
            .cornerRadius(60)

            Text("Apple eGift")
                .font(.custom(.poppinsSemiBold, size: 22))
                .foregroundColor(.white)
            VStack(spacing: 10){
                Text("3% Discount")
                    .font(.custom(.poppinsMedium, size: 20))
                    .foregroundColor(.white)
                Text("$ 500.00")
                    .font(.custom(.poppinsBold, size: 50))
                    .foregroundColor(.white)
                Color(.darkGrayColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 1)
                    .padding(.horizontal, 40)
                Text("You will save $15")
                    .font(.custom(.poppinsSemiBold, size: 22))
                    .foregroundColor(.white)
                Text("$485.00 will be deducted from  today’s Fares")
                    .font(.custom(.poppinsMedium, size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .frame(width: UIScreen.main.bounds.width - 50, height: 270)
            .background(Color(.darkBlueColor))
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundColor(Color(.darkGrayColor))
            )
        }
        .frame(maxWidth: .infinity)
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 25){
            
            NavigationLink {
                ErrorView().toolbar(.hidden, for: .navigationBar)
            } label: {
                Text("Confirm")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 65)
                    .background(Color(.buttonColor))
                    .cornerRadius(30)
            }
            .fullScreenCover(isPresented: $presentingModal, content: {
                GiftCardPopUpView(presentedAsModal: $presentingModal, isTryAgain: false)
            })
        }
    }
}
