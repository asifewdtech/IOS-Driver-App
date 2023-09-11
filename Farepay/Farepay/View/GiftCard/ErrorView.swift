//
//  ErrorView.swift
//  Farepay
//
//  Created by Arslan on 12/09/2023.
//

import SwiftUI

struct ErrorView: View {
    
    //MARK: - Variables
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    //MARK: - Views
    var body: some View {
    
        ZStack{
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30){
                Image(uiImage: .ErrorImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
                
                VStack{
                    Text("Oops!")
                        .font(.custom(.poppinsBold, size: 60))
                        .foregroundColor(.white)
                    Text("Something went wrong!")
                        .font(.custom(.poppinsMedium, size: 20))
                        .foregroundColor(.white)
                }
                
                Text("Payout")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                    .frame(maxWidth: 350)
                    .frame(height: 60)
                    .background(Color(.buttonColor))
                    .cornerRadius(30)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }

            }
            .padding([.horizontal, .bottom], 15)
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
