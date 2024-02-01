//
//  TaxiNumPopupView.swift
//  Farepay
//
//  Created by Apple on 17/01/2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct TaxiNumPopupView: View {
    var body:some View{
        @State var taxiNmbr: String = ""
        @State var taxiNmbr1 = ""
        @State var showTaxi = false
        
        ZStack {
            Color.black.opacity(0.5)
            
//            Color(.bgColor)
//                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 20) {
                
                Text("Taxi Number")
                    .font(.custom(.poppinsMedium, size: 20))
                    .foregroundColor(Color(.darkBlueColor))
            }
            .padding(.top)
        
            .frame(minWidth: 0, maxWidth: 150, minHeight: 0, maxHeight: 40, alignment: .leading)
            .padding(.trailing, 170)
            
                
            HStack(spacing: 5){
                    
                    Image(uiImage: .taxiNumIcon)
                        .resizable()
                        .frame(width: 20, height: 20)
                        
//                    Spacer()
                
                TextField(taxiNmbr, text: $taxiNmbr)
//                        .textInputAutocapitalization(.never)
                        .font(.custom(.poppinsMedium, size: 16))
//                        .frame(height: 38)
                        .foregroundColor(Color(.darkBlueColor))
//                        .disabled(false)
                
                }
                .frame(minWidth: 0, maxWidth: 330, minHeight: 0, maxHeight: 40, alignment: .center)
                
            .background(Color(.TaxiFieldColor))
            .cornerRadius(10)
                
                Spacer()
        
            HStack(spacing: 20) {
                Button {
                    print("txNmbr, ", taxiNmbr )
                    Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").updateData(["taxiNumber" : taxiNmbr])
//                    showLoadingIndicator = false
//                    presentationMode.wrappedValue.dismiss()
                    let tNum = PaymentView(presentSideMenu: .constant(false)).showTaxi
//                    if (tNum){
//                        ZStack{
//                            PayoutView(presentSideMenu: .constant(true))
//                        }
//                    }
                    
                } label: {
                    
                    Text("Update")
                        .font(.custom(.poppinsMedium, size: 15))
                        .foregroundColor(.white)
                }
            }
            .frame(minWidth: 120, maxWidth: 120, minHeight: 40, maxHeight: 40, alignment: .center)
            
//            .padding(.leading, 250)
//            .multilineTextAlignment(.leading)
//            .padding(.bottom, 10)
            .background(Color(.buttonColor))
            .cornerRadius(40)
            Spacer()
            }
//        .frame(minWidth: 320, maxWidth: 350, minHeight: 150, maxHeight: 170)
//            .background(Color.white)
//            .cornerRadius(20)
        
//            .padding([.leading, .trailing], 20)
//            .frame(width: 350)
//            .frame(maxHeight: 180)
    }
}

#Preview {
    TaxiNumPopupView()
}
