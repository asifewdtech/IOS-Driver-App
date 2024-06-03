//
//  AccountView.swift
//  Farepay
//
//  Created by Arslan on 18/09/2023.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI
import FirebaseFirestore
import ActivityIndicatorView

struct AccountView: View {
    
    //MARK: - Variables
    @Binding var presentSideMenu: Bool
    @State var willMoveToAccountInfo: Bool = false
    @State var willMoveToChangePassword: Bool = false
    @State var willMoveToBankAccount: Bool = false
    @State var url :String?
    @State var showImagePicker: Bool = false
    @State var image: UIImage?
    @StateObject var storageManager = StorageManager()
    @State var userName: String = ""
    @State private var showLoadingIndicator: Bool = false
    
    // MARK: - Views
    var body: some View {
        
        ZStack{
            
            NavigationLink("", destination: AccountInfoView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToAccountInfo).isDetailLink(false)
            NavigationLink("", destination: ChangePasswordView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToChangePassword).isDetailLink(false)
            NavigationLink("", destination: BankAccountView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToBankAccount).isDetailLink(false)
            
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack(spacing: 40){
                topArea
                profileView
                listView
                Spacer()
            }
            .fullScreenCover(isPresented: $showImagePicker, content: {
                OpenGallary(isShown: $showImagePicker, image: $image)
            })
            .onAppear(perform: {
                
                Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }else {
                        guard let snap = snapShot else { return  }
                        userName  = snap.get("userName") as? String ?? ""
                        
                        if let socialUrl = Auth.auth().currentUser?.photoURL?.absoluteString {
                            url = socialUrl
                        }else {
                            url = snap.get("imageUrl") as? String ?? ""
                        }
                    }
                }
            })
            .padding(.all, 15)
            
            if showLoadingIndicator{
                VStack{
                    ActivityIndicatorView(isVisible: $showLoadingIndicator, type: .growingArc(.white, lineWidth: 5))
                        .frame(width: 50.0, height: 50.0)
                        .foregroundColor(.white)
                        .padding(.top, 350)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(presentSideMenu: .constant(false))
    }
}

extension AccountView{
    
    var topArea: some View{
        
        VStack(spacing: 30){
            HStack(spacing: 20){
                
                Image(uiImage: .menuIcon)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .onTapGesture {
                        
                        presentSideMenu.toggle()
                    }
                Text("Account")
                    .font(.custom(.poppinsBold, size: 25))
                    .foregroundColor(.white)
                Spacer()
            }
        }
    }
    
/*    var profileView: some View{
        
        VStack(spacing: 5){
//            Image(uiImage: .image_placeholder)
//                .resizable()
//                .frame(width: 150, height: 150)
//                .cornerRadius(75)
            
            if let url =  Auth.auth().currentUser?.photoURL {
//                Image(uiImage: .image_placeholder)
                WebImage(url: url)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(50)
                
            }
            Text(Auth.auth().currentUser?.displayName ?? "")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Text(verbatim: Auth.auth().currentUser?.email ?? "")
                .font(.custom(.poppinsThin, size: 18))
                .foregroundColor(.white)
        }
    }*/
    var profileView: some View{
        
        VStack(spacing: 5){
            if let urls =  URL(string: url ?? "") {
//                Image(uiImage: .image_placeholder)
                WebImage(url: urls)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .cornerRadius(50)
                    .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.white, lineWidth: 1)
                        )
                    .onTapGesture {
                        withAnimation {
                            self.showImagePicker.toggle()
                            url = nil
                        }

                    }
            }else {
                Image(uiImage: image ??  .ic_userPlaceholder)
                    .resizable()
                    .frame(width: 100, height: 100)
//                    .aspectRatio(contentMode: .fill)
                    .cornerRadius(50)
                    .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(.white, lineWidth: 1)
                        )
                    .onTapGesture {
                        withAnimation {
                            self.showImagePicker.toggle()
                        }
                    }
                
                    .onChange(of: image ?? .ic_userPlaceholder, perform: { image in
                        if image != .ic_userPlaceholder {
                            showLoadingIndicator = true
                            storageManager.upload(image: image)
                            showLoadingIndicator = false
                        }
                    })
                
            }
//            Text(Auth.auth().currentUser?.displayName ?? "")
            Text(userName)
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Text(verbatim: Auth.auth().currentUser?.email ?? "")
                .font(.custom(.poppinsThin, size: 18))
                .foregroundColor(.white)
        }
      

    }
    var listView: some View{
        
        VStack(spacing: 15){
            
            HStack{
                HStack(spacing: 20){
                    Image(uiImage: .ic_Account)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text("Account Info")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(.white)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(.darkGrayColor))
            }.onTapGesture {
                willMoveToAccountInfo.toggle()
            }
            
            if Auth.auth().currentUser?.photoURL  == nil {
                HStack{
                    HStack(spacing: 20){
                        Image(uiImage: .ic_ChangePassword)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                        Text("Change Password")
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(Color(.darkGrayColor))
                }.onTapGesture {
                    willMoveToChangePassword.toggle()
                }
                
            }
            HStack{
                HStack(spacing: 20){
                    Image(uiImage: .ic_BankAccount)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                    Text("Bank Account")
                        .font(.custom(.poppinsMedium, size: 18))
                        .foregroundColor(.white)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(.darkGrayColor))
            }.onTapGesture {
                willMoveToBankAccount.toggle()
            }
            
        }
        .padding(.horizontal, 10)
    }
}
