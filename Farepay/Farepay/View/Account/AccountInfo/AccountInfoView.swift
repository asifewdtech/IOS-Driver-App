//
//  AccountInfoView.swift
//  Farepay
//
//  Created by Mursil on 19/09/2023.
//

import SwiftUI
import FirebaseAuth
import SDWebImageSwiftUI
import FirebaseFirestore
import Firebase
import FirebaseStorage
import ActivityIndicatorView

struct AccountInfoView: View {
    
    //MARK: - Variables
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State var willMoveToEditInfo: Bool = false
    @State var userName: String = ""
    @State var phone: String = ""
    @State var showImagePicker: Bool = false
    @State var image: UIImage?
    @State var url :String?
    @State var tNumber :String?
   @StateObject var storageManager = StorageManager()
    @State private var showLoadingIndicator: Bool = false
    
    // MARK: - Views
    var body: some View {
        
        ZStack{
            
            NavigationLink("", destination: EditAccountView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToEditInfo).isDetailLink(false)
            
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack{
                topArea
                ScrollView(showsIndicators: false){
                    Spacer()
                    VStack(spacing: 40){
                        profileView
                        infoView
                    }
                }
                buttonArea
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
                       userName  = snap.get("userName") as? String ?? "N/A"
                        phone = snap.get("phonenumber") as? String ?? "N/A"
                        tNumber  = snap.get("taxiID") as? String ?? "N/A"
                        
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
                    .frame(width: 30, height: 25)
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
                Image(uiImage: image ??  .image_placeholder)
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
                
                    .onChange(of: image ?? .image_placeholder, perform: { image in
                        if image != .image_placeholder {
                            showLoadingIndicator = true
                            storageManager.upload(image: image)
                            showLoadingIndicator = false
//                            presentationMode.wrappedValue.dismiss()
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
                    Text("\(phone)")
                        .font(.custom(.poppinsMedium, size: 15))
                        .foregroundColor(.white)
                }
                HStack{
                    Text("Taxi Number")
                        .font(.custom(.poppinsMedium, size: 15))
                        .foregroundColor(.white)
                    Spacer()
                    Text(tNumber ?? "N/A")
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




struct OpenGallary: UIViewControllerRepresentable {

    let isShown: Binding<Bool>
    let image: Binding<UIImage?>

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        let isShown: Binding<Bool>
        let image: Binding<UIImage?>

        init(isShown: Binding<Bool>, image: Binding<UIImage?>) {
            self.isShown = isShown
            self.image = image
        }

        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            self.image.wrappedValue =  uiImage
            self.isShown.wrappedValue = false
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            isShown.wrappedValue = false
        }

    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(isShown: isShown, image: image)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<OpenGallary>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<OpenGallary>) {

    }
}


class StorageManager: ObservableObject {
    let storage = Storage.storage()
    
    func upload(image: UIImage) {
        let storageRef = storage.reference().child("images/image.jpg")
//        let resizedImage = image.
        let data = image.jpegData(compressionQuality: 0.2)
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"

        if let data = data {
                storageRef.putData(data, metadata: metadata) { (metadata, error) in
                        if let error = error {
                                print("Error while uploading file: ", error)
                        }

                        if let metadata = metadata {
                                print("Metadata: ", metadata)
                            
                            storageRef.downloadURL { url, error in
                                print(url)
                                guard let url = url?.absoluteString else {return}
                                Firestore.firestore().collection("usersInfo").document(Auth.auth().currentUser?.uid ?? "").updateData(["imageUrl":url])
                            }
                        }
                }
        }
    }
    
    
    
    
    
}
