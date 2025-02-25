//
//  TapToPayGuidlinesView.swift
//  Farepay
//
//  Created by Mursil on 24/04/2024.
//

import SwiftUI

struct TapToPayGuidlinesView: View {
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
                UIApplication.shared.open(URL(string: "https://farepay.app/how-to-tap-on-iphone")!)
                presentSideMenu.toggle()
            })
        }
    }
}

struct TapToPayGuidlinesView_Previews: PreviewProvider {
    static var previews: some View {
        TapToPayGuidlinesView(presentSideMenu: .constant(false))
    }
}

extension TapToPayGuidlinesView{
    
    var topArea: some View{
        
        VStack(alignment: .leading, spacing: 300){
            HStack(spacing: 20){
                Image(uiImage: .menuIcon)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .onTapGesture {
                        
                        presentSideMenu.toggle()
                    }
                
                Text("How to Tap To Pay")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                
            }
//            .frame(width: UIScreen.main.bounds.width,alignment: .leading)
//            .padding(.leading,20)
//            VStack(spacing: 30){
            VStack(spacing: 15){
                
                    Text("       You can read the user guidlines here.       ")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(.white)
                
                    Button(action: {
                        openURL(URL(string: "https://farepay.app/how-to-tap-on-iphone")!)
                        presentSideMenu.toggle()
                    }, label: {
                        Text("\("How to Tap To Pay.")")
                            .font(.custom(.poppinsBold, size: 18))
                            .foregroundColor(.white)
                            .underline()
                    })
                }
//            .frame(width: UIScreen.main.bounds.width,alignment: .center)
//            .padding(.leading,20)
//            }
        }
    }
}


