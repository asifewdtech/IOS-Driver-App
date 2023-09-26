//
//  ImagePreView.swift
//  Farepay
//
//  Created by Arslan on 26/09/2023.
//

import SwiftUI

struct ImagePreView: View {
    //MARK: - Variables
    @Binding var presentedAsModal: Bool
    
    //MARK: - Views
    var body: some View {
        ZStack{
            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            VStack(spacing: 25){
                Text("Preview Image")
                    .font(.custom(.poppinsSemiBold, size: 20))
                Image(uiImage: .licenseImage)
                    .resizable()
                    .frame(width: 300, height: 200)
                HStack(spacing: 15){
                    Text("Delete")
                        .frame(width: 120, height: 40)
                        .foregroundColor(Color(.ErrorColor))
                        .font(.custom(.poppinsMedium, size: 16))
                        .overlay{
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Color(.ErrorColor), lineWidth: 1)
                        }
                        .onTapGesture {
                            presentedAsModal.dismiss()
                        }
                    Text("Replace")
                        .frame(width: 120, height: 40)
                        .foregroundColor(.white)
                        .background(Color(.buttonColor))
                        .font(.custom(.poppinsMedium, size: 16))
                        .cornerRadius(100)
                }
            }
            .frame(width: UIScreen.main.bounds.width - 100, height: 330)
            .padding()
            .background(.white)
            .cornerRadius(15)
        }
        .background(ClearBackgroundView())
    }
}

struct ImagePreView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePreView(presentedAsModal: .constant(false))
    }
}
