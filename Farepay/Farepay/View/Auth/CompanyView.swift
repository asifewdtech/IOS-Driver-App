//
//  Form1View.swift
//  Farepay
//
//  Created by Arslan on 25/08/2023.
//

import SwiftUI

struct CompanyView: View {
    
    //MARK: - Variable
    @State private var companyText: String = ""
    @State private var cardText: String = ""
    @State private var contactText: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var willMoveToNextScreen = false
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            
            Color(.bgColor)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView(.vertical, showsIndicators: false){
                
                VStack{
                    
                    topArea
                    Spacer(minLength: 50)
                    textArea
                    Spacer(minLength: 50)
                    buttonArea
                    Spacer(minLength: 20)
                }
            }
            
        }
        .navigationDestination(isPresented: $willMoveToNextScreen) {
            
            Farepay.RepresentativeView().toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct Form1View_Previews: PreviewProvider {
    static var previews: some View {
        CompanyView()
    }
}

extension CompanyView{
    
    var topArea: some View{
        
        VStack(spacing: 25){
            
            Text("Fill in the form below")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            
            VStack{
                
                Text("to get your own farepay account!")
                    .font(.custom(.poppinsMedium, size: 18))
                    .foregroundColor(Color(.darkBrownColor))
                Color(.darkBrownColor)
                    .frame(maxWidth: 300)
                    .frame(height: 1)
            }
            
            HStack(spacing: 5){
                
                Color(.ErrorColor)
                    .frame(height: 5)
                Color(.darkBrownColor)
                    .frame(height: 5)
            }
            .frame(width: 250)
            
            Text("COMPANY INFORMATION")
                .font(.custom(.poppinsBold, size: 20))
                .foregroundColor(.white)
            
        }
        .padding(.horizontal, 15)
    }
    
    var textArea: some View{
        
        VStack(alignment: .leading, spacing: 25){
            
            Group{
                
                ZStack{
                    
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Company)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        TextField("", text: $companyText, prompt: Text("\(.selectCompany)").foregroundColor(Color(.darkBrownColor)))
                            .font(.custom(.poppinsMedium, size: 18))
                            .frame(height: 30)
                            .foregroundColor(.white)
                            
                        Image(uiImage: .ic_DropDown)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                    }
                    .padding([.leading, .trailing], 20)
                }
                
                ZStack{
                    
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Card)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        TextField("", text: $cardText, prompt: Text("XYZ123456789").foregroundColor(Color(.darkBrownColor)))
                            .font(.custom(.poppinsMedium, size: 18))
                            .frame(height: 30)
                            .foregroundColor(.white)
                        
                    }
                    .padding([.leading, .trailing], 20)
                }
                
                ZStack{
                    
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Contact)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        TextField("", text: $contactText, prompt: Text("XYZ123456789").foregroundColor(Color(.darkBrownColor)))
                            .font(.custom(.poppinsMedium, size: 18))
                            .frame(height: 30)
                            .foregroundColor(.white)
                        
                    }
                    .padding([.leading, .trailing], 20)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(Color(.darkBlueColor))
            .cornerRadius(10)
            
        }
        .padding(.horizontal, 15)
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 25){
            
            Text("Proceed")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(.buttonColor))
                .cornerRadius(30)
                .onTapGesture {
                    
                    willMoveToNextScreen.toggle()
                }
                
        }
        .padding(.horizontal, 15)
    }
}