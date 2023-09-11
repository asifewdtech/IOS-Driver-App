//
//  FarepayApp.swift
//  Farepay
//
//  Created by Arslan on 24/08/2023.
//

import SwiftUI

struct MainTabbedView: View {
    
    //MARK: - Variable
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    //MARK: - Views
    var body: some View {
        ZStack{
            switch selectedSideMenuTab{
            case 0:
                PaymentView(presentSideMenu: $presentSideMenu)
                    .tag(0)
            case 1:
                GiftCardView(presentSideMenu: $presentSideMenu)
                    .tag(1)
            case 2:
                PayoutView(presentSideMenu: $presentSideMenu)
                    .tag(2)
            case 3:
                TransactionView(presentSideMenu: $presentSideMenu)
                    .tag(3)
            case 4:
                ReferAFriendView(presentSideMenu: $presentSideMenu)
                    .tag(4)
            default:
                PaymentView(presentSideMenu: $presentSideMenu)
                    .tag(0)
            }
            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
        }
    }
}
