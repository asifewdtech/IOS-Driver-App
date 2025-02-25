//
//  GiftCardView.swift
//  Farepay
//
//  Created by Mursil on 02/09/2023.
//

import SwiftUI

struct GiftCardView: View {
    
    //MARK: - Variables
    @Binding var presentSideMenu: Bool
    @State var isBankTransfer: Bool = false
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30){
                topArea
                priceView
                segmentView
                if isBankTransfer{
                    Spacer()
                    bankTransferView
                    Spacer()
                }
                else{
                    giftCardView
                }
            }
            .padding([.horizontal, .bottom], 15)
            
        }
    }
}

struct GiftCardView_Previews: PreviewProvider {
    static var previews: some View {
        GiftCardView(presentSideMenu: .constant(false))
    }
}

extension GiftCardView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            
            Image(uiImage: .menuIcon)
                .resizable()
                .frame(width: 25, height: 25)
                .onTapGesture {
                    
                    presentSideMenu.toggle()
                }
            Text("Gift Cards")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
        }
    }
    
    var priceView: some View{
        
        VStack(spacing: 10){
            Group{
                HStack{
                    Text("Today’s Fees")
                        .font(.custom(.poppinsMedium, size: 20))
                        .foregroundColor(.white)
                    Spacer()
                    Text("$ 888.88")
                        .font(.custom(.poppinsMedium, size: 20))
                        .foregroundColor(.white)
                }
                HStack{
                    Text("Lifetime Savings")
                        .font(.custom(.poppinsMedium, size: 20))
                        .foregroundColor(.white)
                    Spacer()
                    Text("$ 1068.88")
                        .font(.custom(.poppinsMedium, size: 20))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 15)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(Color(.buttonColor))
        .cornerRadius(10)
    }
    
    var segmentView: some View{
        
        VStack(spacing: 10){
            HStack{
                Text("Bank Transfer")
                    .font(.custom( isBankTransfer ? .poppinsSemiBold : .poppinsMedium, size: 20))
                    .foregroundColor(isBankTransfer ? .white : Color(.darkGrayColor))
                    .onTapGesture {
                        withAnimation {
                            isBankTransfer = true
                        }
                    }
                Spacer()
                Text("Gift Cards")
                    .font(.custom( isBankTransfer ? .poppinsMedium : .poppinsSemiBold, size: 20))
                    .foregroundColor(isBankTransfer ? Color(.darkGrayColor) : .white)
                    .onTapGesture {
                        withAnimation {
                            isBankTransfer = false
                        }
                    }
            }
            .padding(.horizontal, 20)
            
            HStack(spacing: 0){
                Color(isBankTransfer ? .buttonColor : .darkGrayColor)
                Color(isBankTransfer ? .darkGrayColor : .buttonColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 2)
            .background(Color(.darkGrayColor))
        }
    }
    
    var bankTransferView: some View{
        
        Text("Your Balance    $888.88    will be automatically transferred bank account ending with  **** **** **** 1564  within the next business day")
            .font(.custom(.poppinsMedium, size: 20))
            .foregroundColor(Color(.darkGrayColor))
            .multilineTextAlignment(.center)
    }
    
    var giftCardView: some View{
        
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(0..<10){ i in
                HStack(alignment: .center, spacing: 20){
                    ForEach(0..<2){ j in
                        
//                        let index = i+j+i
                        let width = (UIScreen.main.bounds.width/CGFloat(2))-25
                        NavigationLink {
                            GiftCardDetailView().toolbar(.hidden, for: .navigationBar)
                        } label: {
                            VStack{
                                Image(uiImage: .ic_Apple)
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .padding(.top, 20)
                                    .padding(.bottom, 10)
                                
                                VStack{
                                    HStack{
                                        VStack(alignment: .leading, spacing: 10){
                                            Text("Apple Store")
                                                .font(.custom(.poppinsSemiBold, size: 22))
                                                .foregroundColor(.white)
                                            Text("eGift (7)")
                                                .font(.custom(.poppinsMedium, size: 18))
                                                .foregroundColor(Color(.darkGrayColor))
                                        }
                                        Spacer()
                                    }
                                    .padding(.horizontal, 10)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 100)
                                .background(Color(.darkBlueColor))
                            }
                            .frame(width: width, height: width)
                            .background(.white)
                            .cornerRadius(10)
                        }
                    }
                }
                .padding(.bottom, 15)
            }
        }
    }
}
