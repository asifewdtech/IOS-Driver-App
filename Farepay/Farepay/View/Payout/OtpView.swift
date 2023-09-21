//
//  OtpView.swift
//  Farepay
//
//  Created by Arslan on 21/09/2023.
//

import SwiftUI

struct OtpView: View {
    
    //MARK: - Variable
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    @State private var currentlySelectedCell = 0
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            VStack{
                topArea
                Spacer()
                otpView
                Spacer()
            }
            .padding(.all, 15)
        }
    }
}

struct OtpView_Previews: PreviewProvider {
    static var previews: some View {
        OtpView()
    }
}

extension OtpView{
    
    var topArea: some View{
        
        HStack(spacing: 20){
            Image(uiImage: .backArrow)
                .resizable()
                .frame(width: 35, height: 30)
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            Text("Payout")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            Spacer()
            
            Image(uiImage: .optionIcon)
        }
    }
    
    var otpView: some View{
        
        VStack(spacing: 30){
            
            Text("Enter the 4-digit code (Company name) sent to +32-3213409")
                .font(.custom(.poppinsMedium, size: 18))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
            
            HStack (spacing: 10){
                ForEach(0..<4) { index in
                    otpTextFields(currentlySelectedCell: self.$currentlySelectedCell, index: index)
                }
            }
            
            HStack{
                Text("Didn’t receive the code?")
                    .font(.custom(.poppinsMedium, size: 14))
                    .foregroundColor(.white)
                Text("Resend")
                    .font(.custom(.poppinsBold, size: 15))
                    .foregroundColor(.white)
            }
        }
    }
}

struct otpTextFields: View {
    @State private var textValue: String = ""
    @Binding var currentlySelectedCell: Int
    
    var index: Int
    
    var responder: Bool {
        return index == currentlySelectedCell
    }
    
    var body: some View {
        CustomTextField(text: $textValue, currentlySelectedCell: $currentlySelectedCell, isFirstResponder: responder)
            .frame(width: 50, height: 55)
            .font(.custom(.poppinsBold, size: 20))
            .foregroundColor(.white)
            .lineLimit(1)
            .multilineTextAlignment(.center)
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
            
            if string == "" { // Backspace key was pressed
                if currentText.count <= 1 {
                    self.currentlySelectedCell += 1
                }
                textField.layer.borderColor = UIColor.gray.cgColor
                return true
            }
            else {
                guard let stringRange = Range(range, in: currentText) else { return false }
                let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
                
                if updatedText.count <= 1 {
                    self.currentlySelectedCell += 1
                    textField.layer.borderColor = UIColor.green.cgColor
                }
                return updatedText.count <= 1
            }
        }
    }
    
    @Binding var text: String
    @Binding var currentlySelectedCell: Int
    var isFirstResponder: Bool = false
    
    func makeUIView(context: UIViewRepresentableContext<CustomTextField>) -> UITextField {
        
        let textField = UITextField(frame: .zero)
        textField.delegate = context.coordinator
        textField.textAlignment = .center
        textField.textColor = .white
        textField.font = UIFont(name: .poppinsBold, size: 25)
        textField.attributedPlaceholder = NSAttributedString(
            string: "_",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        textField.layer.cornerRadius = 5.0
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.borderWidth = 1.0
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
