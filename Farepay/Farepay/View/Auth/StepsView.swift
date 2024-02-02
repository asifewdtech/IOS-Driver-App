//
//  StepsView.swift
//  Farepay
//
//  Created by Arslan on 26/09/2023.
//

import SwiftUI

struct StepsView: View {
    
    //MARK: - Variables
    @Binding var presentedAsModal: Bool
    
    //MARK: - Views
    var body: some View {
        
        VStack( spacing: 35){
            Spacer()
            Image(uiImage: .stepsImage)
                .resizable()
                .frame(width: 280, height: 280)
            Text("Few More Steps")
                .font(.custom(.poppinsSemiBold, size: 28))
                .foregroundStyle(Color.white)
            Text("You're on the right track! Just a few steps away from completing your registration")
                .font(.custom(.poppinsMedium, size: 15))
                .foregroundColor(Color(.darkGrayColor).opacity(0.7))
                .multilineTextAlignment(.center)
            Spacer()
            Text("Proceed")
                .font(.custom(.poppinsSemiBold, size: 18))
                .frame(height: 50)
                .frame(maxWidth:.infinity)
                .foregroundColor(.white)
                .background(Color(.buttonColor))
                .cornerRadius(25)
                .onTapGesture {
                    presentedAsModal.dismiss()
                    NotificationCenter.default.post(name: .proceedNext, object: nil)
                    
                }
        }

        .padding()
//        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth:.infinity,alignment: .center)
        .background(Color(.bgColor))
    }
}

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView(presentedAsModal: .constant(false))
    }
}
