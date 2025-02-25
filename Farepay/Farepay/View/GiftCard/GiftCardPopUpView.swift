//
//  GiftCardPopUpView.swift
//  Farepay
//
//  Created by Mursil on 09/09/2023.
//

import SwiftUI

struct GiftCardPopUpView: View {
    //MARK: - Variable
    @Binding var presentedAsModal: Bool
    @State var isTryAgain: Bool = false
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            VStack{
                Text("")
                Spacer()
                if !isTryAgain{
                    successView
                }
                else{
                    tryAgainView
                }
            }
        }
        .background(ClearBackgroundView())
    }
}

struct GiftCardPopUpView_Previews: PreviewProvider {
    static var previews: some View {
        GiftCardPopUpView(presentedAsModal: .constant(false))
    }
}

extension GiftCardPopUpView{
    
    var successView: some View{
        HStack(alignment: .top, spacing: 15){
            Image(uiImage: .ic_SuccessTrue)
                .resizable()
                .frame(width: 30, height: 30)
            VStack(alignment: .leading){
                Text("Gift Card Redemption Successful")
                    .font(.custom(.poppinsSemiBold, size: 20))
                Text("Gift Card Redemption Successful")
                    .font(.custom(.poppinsMedium, size: 15))
                    .foregroundColor(Color(.darkGrayColor))
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .font(.custom(.poppinsMedium, size: 22))
        .background(.white)
        .onTapGesture {
            presentedAsModal.dismiss()
        }
    }
    
    var tryAgainView: some View{
        HStack(alignment: .top, spacing: 15){
            Image(uiImage: .ic_False)
                .resizable()
                .frame(width: 30, height: 30)
            VStack(alignment: .leading){
                Text("Transaction Failed")
                    .font(.custom(.poppinsSemiBold, size: 20))
                Text("Sorry, please try again later.")
                    .font(.custom(.poppinsMedium, size: 15))
                    .foregroundColor(Color(.darkGrayColor))
            }
            Text("Try Again")
                .font(.custom(.poppinsMedium, size: 18))
                .padding([.leading, .trailing], 15)
                .padding([.top, .bottom], 10)
                .foregroundColor(Color(.darkGrayColor))
                .background(Color(.lightPink))
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(.darkGrayColor), lineWidth: 2)
                )
                .onTapGesture {
                    presentedAsModal.dismiss()
                }
                
        }
        .frame(maxWidth: .infinity)
        .frame(height: 70)
        .font(.custom(.poppinsMedium, size: 22))
        .background(.white)
    }
}
