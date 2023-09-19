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
    @State private var willMoveToRepresentativeView: Bool = false
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            
            NavigationLink("", destination: RepresentativeView().toolbar(.hidden, for: .navigationBar), isActive: $willMoveToRepresentativeView).isDetailLink(false)
            Color(.bgColor).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 40){
                topArea
                ScrollView(showsIndicators: false){
                    textArea
                }
                .disabled(true)
                buttonArea
            }
            .padding(.all, 15)
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
        
        VStack(spacing: 20){
            
            Text("Fill in the form below")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
            
            VStack{
                
                Text("to get your own farepay account!")
                    .font(.custom(.poppinsMedium, size: 18))
                    .foregroundColor(Color(.darkGrayColor))
                Color(.darkGrayColor)
                    .frame(maxWidth: 300)
                    .frame(height: 1)
            }
            
            HStack(spacing: 5){
                
                Color(.ErrorColor)
                    .frame(height: 5)
                Color(.darkGrayColor)
                    .frame(height: 5)
            }
            .frame(width: 250)
            
            Text("COMPANY INFORMATION")
                .font(.custom(.poppinsBold, size: 20))
                .foregroundColor(.white)
            
        }
    }
    
    var textArea: some View{
        
        VStack(alignment: .leading, spacing: 20){
            
            Group{
                
                ZStack{
                    
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Company)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        TextField("", text: $companyText, prompt: Text("\(.selectCompany)").foregroundColor(Color(.darkGrayColor)))
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
                        
                        TextField("", text: $cardText, prompt: Text("XYZ123456789").foregroundColor(Color(.darkGrayColor)))
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
                        
                        TextField("", text: $contactText, prompt: Text("XYZ123456789").foregroundColor(Color(.darkGrayColor)))
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
    }
    
    var buttonArea: some View{
        
        VStack(spacing: 20){
 
            Text("Proceed")
                .font(.custom(.poppinsBold, size: 25))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color(.buttonColor))
                .cornerRadius(30)
                .onTapGesture {
                    willMoveToRepresentativeView.toggle()
                }
        }
    }
}
