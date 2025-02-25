//
//  TermsView.swift
//  Farepay
//
//  Created by Mursil on 13/09/2023.
//

import SwiftUI

struct TermsView: View {
    
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
                UIApplication.shared.open(URL(string: "https://farepay.app/terms-of-use")!)
                presentSideMenu.toggle()
            })
        }
    }
}

struct TermsView_Previews: PreviewProvider {
    static var previews: some View {
        TermsView(presentSideMenu: .constant(false))
    }
}

extension TermsView{
    
    var topArea: some View{
        
        VStack(alignment: .leading, spacing: 300){
            HStack(spacing: 20){
                Image(uiImage: .menuIcon)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .onTapGesture {
                        
                        presentSideMenu.toggle()
                    }
                
                Text("Terms of Use")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                
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
                        openURL(URL(string: "https://farepay.app/terms-of-use")!)
                        presentSideMenu.toggle()
                    }, label: {
                        Text("\("Terms of Use")")
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
