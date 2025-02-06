//
//  FarepayApp.swift
//  Farepay
//
//  Created by Arslan on 24/08/2023.
//

import SwiftUI
import WebKit

struct MainTabbedView: View {
    
    //MARK: - Variable
    @State var presentSideMenu = false
    @State var selectedSideMenuTab = 0
//    @Environment(\.openURL) var openURL
    @State private var showFaceIDPswdView = false
    
    //MARK: - Views
    var body: some View {
        ZStack{
//            Color(.bgColor)
//            .edgesIgnoringSafeArea(.all)
            switch selectedSideMenuTab{
            case 0:
                PaymentView(presentSideMenu: $presentSideMenu)
                    .tag(1)
//            case 1:
//                GiftCardView(presentSideMenu: $presentSideMenu)
//                    .tag(1)
//            case 1:
//                PayoutView(presentSideMenu: $presentSideMenu)
//                    .tag(2)
            case 1:
                TransactionView(presentSideMenu: $presentSideMenu)
                    .tag(2)
//            case 3:
//                ReferAFriendView(presentSideMenu: $presentSideMenu)
//                    .tag(3)
//            case 2:
//                PrivacyPolicyView(presentSideMenu: $presentSideMenu)
////                WebView(url: URL(string: "https://farepay.app/privacy")!)
////                BrowserWebView(url: URL(string: "https://farepay.app/privacy")!, viewModel: BrowserViewModel())
////                Link("Farepay", destination: URL(string: "https://farepay.app/privacy")!)
//                    .tag(3)
            case 2:
                TermsView(presentSideMenu: $presentSideMenu)
//                WebView(url: URL(string: "https://farepay.app/terms-of-use")!)
//                BrowserWebView(url: URL(string: "https://farepay.app/terms-of-use")!, viewModel: BrowserViewModel())
                
                    .tag(3)
            case 3:
                TapToPayGuidlinesView(presentSideMenu: $presentSideMenu)
                    .tag(4)
            case 5:
                AccountView(presentSideMenu: $presentSideMenu)
                    .tag(6)
            default:
                PaymentView(presentSideMenu: $presentSideMenu)
                    .tag(0)
            }
            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
        }
        
        .onAppear {
            NotificationCenter.default.addObserver(forName: Notification.Name("appDidBecomeActive"), object: nil, queue: .main) { _ in
                showFaceIDPswdView = true
            }
        }
        .fullScreenCover(isPresented: $showFaceIDPswdView) {
            AuthenticateFaceIdPswdView()
        }
    }
    
}
struct WebView: UIViewRepresentable {
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
       
    }
    
    let url: URL
    func makeUIView(context: Context) -> WKWebView  {
        let wkwebView = WKWebView()
        let request = URLRequest(url: url)
        wkwebView.load(request)
        return wkwebView
    }
}
