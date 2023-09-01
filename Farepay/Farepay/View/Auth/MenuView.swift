//
//  MenuView.swift
//  Farepay
//
//  Created by Arslan on 01/09/2023.
//

import SwiftUI

struct MenuView: View {
    
    //MARK: - Variable
    @Binding var isShowing: Bool
    var content: AnyView
    var edgeTransition: AnyTransition = .move(edge: .leading)
    
    //MARK: - Views
    var body: some View {
        
        Color(.darkBlueColor)
            .edgesIgnoringSafeArea(.all)
        
        VStack{
            
            listView
        }
    }
}

//struct MenuView_Previews: PreviewProvider {
//    static var previews: some View {
//        MenuView(isShowing: .constant(false), content: PaymentView)
//    }
//}

extension MenuView{
    
    var listView: some View{
     
        VStack{
            
            Text("Side Menu")
                .foregroundColor(.white)
                .font(.custom(.poppinsMedium, size: 18))
//            ScrollView(.vertical, showsIndicators: false){
//
//                ForEach(0..<8) { index in
//
//                    HStack(spacing: 15){
//
//                        Image(uiImage: .ic_FareCharge)
//                            .resizable()
//                            .frame(width: 30, height: 30)
//                        Text("Arslan")
//                            .foregroundColor(.white)
//                            .font(.custom(.poppinsMedium, size: 25))
//                    }
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 60)
//                    .background(
//                        CustomRoundedRectangle(cornerRadius: 30, corners: [.topRight, .bottomRight])
//                            .fill(Color(.buttonColor)))
//                    .padding(.trailing, 70)
//                }
//            }
            
            
        }
    }
}
