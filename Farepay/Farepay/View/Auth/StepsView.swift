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
        
        ZStack{
            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            VStack(spacing: 25){
                
                Image(uiImage: .stepsImage)
                    .resizable()
                    .frame(width: 200, height: 200)
                Text("Few More Steps")
                    .font(.custom(.poppinsSemiBold, size: 20))
                Text("You're on the right track! Just a few steps away from completing your registration")
                    .font(.custom(.poppinsMedium, size: 15))
                    .foregroundColor(Color(.darkGrayColor).opacity(0.7))
                    .multilineTextAlignment(.center)
                Text("Proceed")
                    .font(.custom(.poppinsSemiBold, size: 18))
                    .frame(width: 200, height: 50)
                    .foregroundColor(.white)
                    .background(Color(.buttonColor))
                    .cornerRadius(25)
                    .onTapGesture {
                        NotificationCenter.default.post(name: .proceedNext, object: nil)
                        presentedAsModal.dismiss()
                    }
            }
            .frame(width: UIScreen.main.bounds.width - 100, height: 400)
            .padding()
            .background(.white)
            .cornerRadius(15)
            
        }
        .background(ClearBackgroundView())
    }
}

struct StepsView_Previews: PreviewProvider {
    static var previews: some View {
        StepsView(presentedAsModal: .constant(false))
    }
}
