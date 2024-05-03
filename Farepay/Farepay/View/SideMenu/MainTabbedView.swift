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
            case 2:
                PrivacyPolicyView(presentSideMenu: $presentSideMenu)
//                WebView(url: URL(string: "https://farepay.app/privacy")!)
//                BrowserWebView(url: URL(string: "https://farepay.app/privacy")!, viewModel: BrowserViewModel())
//                Link("Farepay", destination: URL(string: "https://farepay.app/privacy")!)
                    .tag(3)
            case 3:
                TermsView(presentSideMenu: $presentSideMenu)
//                WebView(url: URL(string: "https://farepay.app/terms-of-use")!)
//                BrowserWebView(url: URL(string: "https://farepay.app/terms-of-use")!, viewModel: BrowserViewModel())
                
                    .tag(4)
            case 4:
                TapToPayGuidlinesView(presentSideMenu: $presentSideMenu)
                    .tag(5)
            case 5:
                AccountView(presentSideMenu: $presentSideMenu)
                    .tag(6)
            default:
                PaymentView(presentSideMenu: $presentSideMenu)
                    .tag(0)
            }
            SideMenu(isShowing: $presentSideMenu, content: AnyView(SideMenuView(selectedSideMenuTab: $selectedSideMenuTab, presentSideMenu: $presentSideMenu)))
        }
    }
    
//    func urlSafari(url: String){
//        @Environment(\.openURL) var openURL
//        openURL(URL(string: url)!)
//    }
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

//struct BrowserView: View {
//
//    @StateObject var browserViewModel = BrowserViewModel()
//    
//    var body: some View {
//        VStack {
//            HStack {
//                Button(action: {
//                    browserViewModel.goBack()
//                }) {
//                    Image(systemName: "chevron.backward")
//                }
//                .disabled(!browserViewModel.canGoBack)
//
//                Button(action: {
//                    browserViewModel.goForward()
//                }) {
//                    Image(systemName: "chevron.forward")
//                }
//                .disabled(!browserViewModel.canGoForward)
//
//                .padding(.trailing, 5)
//
//                TextField("URL", text: $browserViewModel.urlString, onCommit: {
//                     browserViewModel.loadURLString()
//                 })
//                 .textFieldStyle(RoundedBorderTextFieldStyle())
//
//                Button(action: {
//                    browserViewModel.reload()
//                }) {
//                    Image(systemName: "arrow.clockwise")
//                }
//            }
//            .padding(.horizontal)
//
//            if let url =  URL(string: browserViewModel.urlString) {
//                BrowserWebView(url: url,
//                               viewModel: browserViewModel)
//                .edgesIgnoringSafeArea(.all)
//            } else {
//                Text("Please, enter a url.")
//            }
//        }
//    }
//}

//struct BrowserWebView: UIViewRepresentable {
//    let url: URL
//    @ObservedObject var viewModel: BrowserViewModel
//    func makeUIView(context: Context) -> WKWebView {
//        let webView = WKWebView()
//        viewModel.webView = webView
//        webView.load(URLRequest(url: url))
//        return webView
//    }
//    func updateUIView(_ uiView: WKWebView, context: Context) {
//    }
//}
//
//class BrowserViewModel: NSObject, ObservableObject, WKNavigationDelegate {
//    weak var webView: WKWebView? {
//        didSet {
//            webView?.navigationDelegate = self
//        }
//    }
//
//    @Published var urlString = "https://www.apple.com"
//    @Published var canGoBack = false
//    @Published var canGoForward = false
//
//    func loadURLString() {
//        if let url = URL(string: urlString) {
//            webView?.load(URLRequest(url: url))
//        }
//    }
//
//    func goBack() {
//        webView?.goBack()
//    }
//
//    func goForward() {
//        webView?.goForward()
//    }
//
//    func reload() {
//        webView?.reload()
//    }
//}
