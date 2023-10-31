//
//  AccountInfoView.swift
//  Farepay
//
//  Created by Arslan on 19/09/2023.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI
import FirebaseFirestore
struct AccountInfoView: View {
    
    //MARK: - Variables
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var willMoveToEditInfo: Bool = false
    @State var userName: String = ""
    @State var phone: String = ""
    // MARK: - Views
    var body: some View {
        
        ZStack{
            
            NavigationLink("", destination: EditAccountView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToEditInfo).isDetailLink(false)
            
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack{
                topArea
                ScrollView(showsIndicators: false){
                    VStack(spacing: 40){
                        profileView
                        infoView
                    }
                }
                buttonArea
            }
            .onAppear(perform: {
                Firestore.firestore().collection("Users").document(Auth.auth().currentUser?.uid ?? "").getDocument { snapShot, error in
                    if let error = error {
                        print(error.localizedDescription)
                    }else {
                        
                        guard let snap = snapShot else { return  }
                       userName  = snap.get("name") as? String ?? ""
                        phone = snap.get("phone") as? String ?? ""
                        

                    }
                    
                    
                }

            })
            .padding(.all, 15)
        }
    }
}

struct AccountInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AccountInfoView()
    }
}

extension AccountInfoView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            
                Image(uiImage: .backArrow)
                    .resizable()
                    .frame(width: 35, height: 30)
                    .onTapGesture {
                        presentationMode.wrappedValue.dismiss()
                    }
            
            Text("Account info")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
        }
    }
    
    var profileView: some View{
        
        VStack(spacing: 5){
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
    }
    
    var infoView: some View{
        
        VStack(spacing: 20){
            
            HStack{
                Text("Personal Info")
                    .font(.custom(.poppinsSemiBold, size: 18))
                    .foregroundColor(.white)
                Spacer()
            }
            HStack{
                Text("Your name")
                    .font(.custom(.poppinsMedium, size: 15))
                    .foregroundColor(.white)
                Spacer()
                Text(userName)
                    .font(.custom(.poppinsMedium, size: 15))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 10)
            Color(.darkGrayColor).frame(height: 1)
            HStack{
                Text("Contact Info")
                    .font(.custom(.poppinsSemiBold, size: 18))
                    .foregroundColor(.white)
                Spacer()
            }
            VStack(spacing: 20){
                HStack{
                    Text("Phone Number")
                        .font(.custom(.poppinsMedium, size: 15))
                        .foregroundColor(.white)
                    Spacer()
                    Text("+61 \(phone)")
                        .font(.custom(.poppinsMedium, size: 15))
                        .foregroundColor(.white)
                }
                HStack{
                    Text("Email Address")
                        .font(.custom(.poppinsMedium, size: 15))
                        .foregroundColor(.white)
                    Spacer()
                    Text(verbatim: Auth.auth().currentUser?.email ?? "")
                        .font(.custom(.poppinsMedium, size: 15))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 10)
        }
    }
    
    var buttonArea: some View{
        Text("Edit")
            .font(.custom(.poppinsBold, size: 25))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(.buttonColor))
            .cornerRadius(30)
            .onTapGesture {
                willMoveToEditInfo.toggle()
            }
    }
}
