//
//  PrivacyPolicyView.swift
//  Farepay
//
//  Created by Arslan on 13/09/2023.
//

import SwiftUI

struct PrivacyPolicyView: View {
    
    //MARK: - Variables
    @Binding var presentSideMenu: Bool
    
    //MARK: - Views
    var body: some View {
        ZStack{
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack{
                topArea
                Spacer()
            }
            .padding(.all, 15)
        }
    }
}

struct PrivacyPolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicyView(presentSideMenu: .constant(false))
    }
}

extension PrivacyPolicyView{

    var topArea: some View{
        
        VStack(spacing: 30){
            HStack(spacing: 20){
                
                Image(uiImage: .menuIcon)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .onTapGesture {
                        
                        presentSideMenu.toggle()
                    }
                Text("Privacy Policy")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                Spacer()
            }
            
            Text("Please read these terms and conditions Carefully before using the application.")
                .font(.custom(.poppinsMedium, size: 20))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
        }
    }
}
