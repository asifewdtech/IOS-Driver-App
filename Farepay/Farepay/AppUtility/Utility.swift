//
//  Utility.swift
//  Farepay
//
//  Created by Arslan on 24/08/2023.
//

import Foundation
import SwiftUI
import UIKit
import Combine
import MaterialComponents

//MARK: - Custom Views Modifier
struct CustomRoundedRectangle: Shape {
    var cornerRadius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)
        )
        return Path(path.cgPath)
    }
}

struct ClearBackgroundView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return InnerView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
    }
    
    private class InnerView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            
            superview?.superview?.backgroundColor = .clear
        }
        
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

struct OtpModifer: ViewModifier {
    
    @Binding var pin : String
    
    var textLimt = 1
    
    func limitText(_ upper : Int) {
        if pin.count > upper {
            self.pin = String(pin.prefix(upper))
        }
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
            .onReceive(Just(pin)) {_ in limitText(textLimt)}
            .frame(width: 50, height: 55)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(pin == "" ? Color(.darkGrayColor) : Color(.SuccessColor), lineWidth: 2)
            )
    }
}

struct MDCFilledTextFieldWrapper: UIViewRepresentable {
    
    @Binding var leadingImage: UIImage
    @State var isTrailingImage: Bool?
    @Binding var text: String
    @Binding var placHolderText: String
    @Binding var isSecure: Bool
    
    func makeUIView(context: Context) -> MDCFilledTextField {
        let textField = MDCFilledTextField()
        
        // Left Image
        textField.leadingView = UIImageView(image: leadingImage)
        textField.leadingView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        textField.leadingViewMode = .always
        
        // Right Image
        if isTrailingImage == true{
            textField.trailingView = UIImageView(image: UIImage(systemName: isSecure ? "eye.slash.fill" : "eye.fill"))
            textField.trailingView?.tintColor = .white
            textField.trailingView?.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
            textField.trailingViewMode = .always
        }
        
        // PlaceHolder
        textField.label.text = placHolderText
        textField.setNormalLabelColor(.darkGrayColor, for: .normal)
        textField.setFloatingLabelColor(.darkGrayColor, for: .normal)
        textField.setFloatingLabelColor(.white, for: .editing)
        
        // Text
        textField.setTextColor(.white, for: .normal)
        textField.font = UIFont(name: .poppinsMedium, size: 18)
        textField.setTextColor(.white, for: .editing)
        
        // BackGround and Underline
        textField.setFilledBackgroundColor(.darkBlueColor, for: .normal)
        textField.setFilledBackgroundColor(.darkBlueColor, for: .editing)
        textField.setUnderlineColor(.buttonColor, for: .editing)
        textField.setUnderlineColor(.clear, for: .normal)
        
        textField.isSecureTextEntry = isSecure
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: MDCFilledTextField, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: MDCFilledTextFieldWrapper
        
        init(_ parent: MDCFilledTextFieldWrapper) {
            self.parent = parent
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }
}
struct CharacterInputCell: View {
    @State private var textValue: String = ""
    @Binding var currentlySelectedCell: Int
    
    var index: Int
    
    var responder: Bool {
        return index == currentlySelectedCell
    }
    
    var body: some View {
        CustomTextField(text: $textValue, currentlySelectedCell: $currentlySelectedCell, isFirstResponder: responder)
            .frame(width: 50, height: 50)
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color.black.opacity(0.5), lineWidth: 2)
            )
    }
}

struct CustomTextField: UIViewRepresentable {
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        @Binding var currentlySelectedCell: Int
        
        var didBecomeFirstResponder = false
        
        init(text: Binding<String>, currentlySelectedCell: Binding<Int>) {
            _text = text
            _currentlySelectedCell = currentlySelectedCell
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            DispatchQueue.main.async {
                self.text = textField.text ?? ""
            }
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            let currentText = textField.text ?? ""
            
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.count <= 1 {
                self.currentlySelectedCell += 1
            }
            
            return updatedText.count <= 1
        }
    }
    
    @Binding var text: String
    @Binding var currentlySelectedCell: Int
    var isFirstResponder: Bool = false
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        return textField
    }
    
    func makeCoordinator() -> CustomTextField.Coordinator {
        return Coordinator(text: $text, currentlySelectedCell: $currentlySelectedCell)
    }
    
    func updateUIView(_ uiView: UITextField, context: UIViewRepresentableContext<CustomTextField>) {
        uiView.text = text
        if isFirstResponder && !context.coordinator.didBecomeFirstResponder  {
            uiView.becomeFirstResponder()
            context.coordinator.didBecomeFirstResponder = true
        }
    }
}


//MARK: - Custom Methods
let userDefault = UserDefaults.standard

func isLogin() -> Bool{
    
    if userDefault.bool(forKey: .isUserLogin) == true{
        return true
    }
    else{
        return false
    }
}

func setUserLogin(_ value: Bool){
    userDefault.set(value, forKey: .isUserLogin)
}

func isMainView() -> Bool{
    
    if userDefault.bool(forKey: .isMainView) == true{
        return true
    }
    else{
        return false
    }
}

func setMainView(_ value: Bool){
    userDefault.set(value, forKey: .isMainView)
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE dd, yyyy"
    return formatter.string(from: date)
}
