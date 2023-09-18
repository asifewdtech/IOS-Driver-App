//
//  ExportPopUpView.swift
//  Farepay
//
//  Created by Arslan on 12/09/2023.
//

import SwiftUI

struct ExportPopUpView: View {
    
    //MARK: - Variables
    @Binding var presentedAsModal: Bool
    
    //MARK: - Views
    var body: some View {
        ZStack{
            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 25){
                Text("Export Transaction History")
                    .font(.custom(.poppinsSemiBold, size: 20))
                
                Text("Download a copy of your transaction history to your registered email address")
                    .font(.custom(.poppinsMedium, size: 15))
                    .foregroundColor(Color(.darkGrayColor))
                    .multilineTextAlignment(.center)
                
                HStack(spacing: 20){
                    Text("Cancel")
                        .font(.custom(.poppinsMedium, size: 18))
                        .frame(width: 130, height: 50)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color(.buttonColor), lineWidth: 2)
                        )
                        .onTapGesture {
                            presentedAsModal.dismiss()
                        }
                    
                    let width = "Email Summary".widthOfString(usingFont: UIFont(name: .poppinsMedium, size: 20)!) + 20
                    Text("Email Summary")
                        .font(.custom(.poppinsSemiBold, size: 18))
                        .frame(width: width, height: 50)
                        .foregroundColor(.white)
                        .background(Color(.buttonColor))
                        .cornerRadius(width/2)
                }
            }
            .frame(width: 350, height: 200)
            .padding()
            .background(.white)
            .cornerRadius(15)
        }
        .background(ClearBackgroundView())
    }
}

struct ExportPopUpView_Previews: PreviewProvider {
    static var previews: some View {
        ExportPopUpView(presentedAsModal: .constant(false))
    }
}
