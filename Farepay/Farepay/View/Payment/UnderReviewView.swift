//
//  UnderReviewView.swift
//  Farepay
//
//  Created by Mursil on 08/01/2024.
//

import SwiftUI

struct UnderReviewView: View {
    var body: some View {
        
        ZStack{
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
                topArea
        }
    }
}

//#Preview {
//    UnderReviewView()
//}
struct underReview_Previews: PreviewProvider {
    static var previews: some View {
        UnderReviewView()
    }
}

extension UnderReviewView{
    
    var topArea: some View{
        VStack {
            HStack {
                Image(uiImage: .underReviewImage)
                    .resizable()
                    .frame(width: 330, height: 268)
            }
            
            HStack {
                Text("Account being created")
                    .font(.custom(.poppinsBold, size: 24))
                    .foregroundColor(.white)
                    
            }
            
            HStack {
                Text("We’re setting up your new Farepay account and we can’t wait to be in touch soon as it’s approved.")
                    .font(.custom(.poppinsMedium, size: 13))
                    .foregroundColor(.gray)
                    
            }
            .frame(minWidth: 330, maxWidth: 330, minHeight: 40, maxHeight: 40, alignment: .center)
        }
    }
}
