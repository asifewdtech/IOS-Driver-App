//
//  SideMenuView.swift
//  DripJobsTeams
//
//  Created by Zeeshan Suleman on 28/02/2023.
//

import SwiftUI

enum SideMenuRowType: Int, CaseIterable{
    
    case chargeFare = 0
    case giftCards
    case Payout
    case Transactions
    case ReferaFriend
    case PrivacyPolicy
    case TermsofUse
    
    var title: String{
        switch self {
        case .chargeFare:
            return "Charge Fare"
        case .giftCards:
            return "Gift Cards"
        case .Payout:
            return "Payout"
        case .Transactions:
            return "Transactions"
        case .ReferaFriend:
            return "Refer a Friend"
        case .PrivacyPolicy:
            return "Privacy Policy"
        case .TermsofUse:
            return "Terms of Use"
        }
    }
    
    var iconName: UIImage{
        switch self {
        case .chargeFare:
            return .ic_FareCharge
        case .giftCards:
            return .ic_GiftCards
        case .Payout:
            return .ic_Payout
        case .Transactions:
            return .ic_Transactions
        case .ReferaFriend:
            return .ic_Refer
        case .PrivacyPolicy:
            return .ic_Refer
        case .TermsofUse:
            return .ic_Refer
        }
    }
}

struct SideMenuView: View {
    
    //MARK: - Variables
    @Binding var selectedSideMenuTab: Int
    @Binding var presentSideMenu: Bool
    
    //MARK: - Views
    var body: some View {
        
        HStack {
            
            ZStack{
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    ForEach(SideMenuRowType.allCases, id: \.self){ row in
                        RowView(isSelected: selectedSideMenuTab == row.rawValue, img: row.iconName, title: row.title) {
                            selectedSideMenuTab = row.rawValue
                            presentSideMenu.toggle()
                        }
                    }
                    Spacer()
                }
                .padding(.top, 100)
                .frame(width: UIScreen.main.bounds.width - 150)
                .background(Color(.darkBlueColor))
            }
            Spacer()
        }
    }
    
    //MARK: - Functions
    func RowView(isSelected: Bool, img: UIImage, title: String, hideDivider: Bool = false, action: @escaping (()->())) -> some View{
        Button{
            action()
        } label: {
            VStack(alignment: .leading){
                
                HStack(spacing: 20){
                    
                    Image(uiImage: img)
                        .resizable()
                        .frame(width: 25, height: 25)
                    Text(title)
                        .foregroundColor(.white)
                        .font(.custom(.poppinsMedium, size: 22))
                    Spacer()
                }
                .padding(.leading, 15)
            }
        }
        .frame(height: 50)
        .background(
            CustomRoundedRectangle(cornerRadius: 30, corners: [.topRight, .bottomRight])
                .fill(isSelected ? Color(.buttonColor) : .clear)
        )
        .padding(.trailing, 30)
    }
}

