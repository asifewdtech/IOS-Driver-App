//
//  PrivacyPolicyView.swift
//  Farepay
//
//  Created by Arslan on 13/09/2023.
//

import SwiftUI
import WebKit

struct PrivacyPolicyView: View {
    
    //MARK: - Variables
    @Binding var presentSideMenu: Bool
    @Environment(\.openURL) var openURL
    
    //MARK: - Views
    var body: some View {
        ZStack{
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack{
                topArea
                Spacer()
//                ButtonArea
            }
            .padding(.all, 15)
            
            .onAppear( perform: {
                UIApplication.shared.open(URL(string: "https://farepay.app/privacy")!)
                presentSideMenu.toggle()
            })
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
        
        VStack(alignment: .leading, spacing: 300){
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
            
//            Text("Please read these terms and conditions Carefully before using the application.")
//                .font(.custom(.poppinsMedium, size: 20))
//                .foregroundColor(.white)
//                .multilineTextAlignment(.leading)
            
            
            VStack(spacing: 30){
                HStack(){
                    Text("Please read the")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(.white)
                    Button(action: {
                        openURL(URL(string: "https://farepay.app/privacy")!)
                        presentSideMenu.toggle()
                    }, label: {
                        Text("\("Privacy Policy")")
                            .font(.custom(.poppinsBold, size: 18))
                            .foregroundColor(.white)
                            .underline()
                    })
                    Text("Carefully.")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(.white)
                }
            }
        }
    }
}
