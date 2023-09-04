//
//  MainTabbedView.swift
//  SideMenuSwiftUI
//
//  Created by Zeeshan Suleman on 04/03/2023.
//

import SwiftUI

struct MainTabbedView: View {
    
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
    
    var body: some View {
        ZStack{

            TabView(selection: $selectedSideMenuTab) {
                
                PaymentView(presentSideMenu: $presentSideMenu)
                    .tag(0)
                GiftCardView(presentSideMenu: $presentSideMenu)
                    .tag(1)
                PayoutView(presentSideMenu: $presentSideMenu)
                    .tag(2)
                TransactionView(presentSideMenu: $presentSideMenu)
                    .tag(3)
                ReferAFriendView(presentSideMenu: $presentSideMenu)
                    .tag(4)
            }
            
            if selectedSideMenuTab == 8{
                
                LoginView(presentSideMenu: $presentSideMenu)
                    .tag(8)
            }
            
            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
        }
    }
}
