//
//  Form2View.swift
//  Farepay
//
//  Created by Arslan on 28/08/2023.
//

import SwiftUI
import NavigationStack

struct RepresentativeView: View {
    
    //MARK: - Variable
    @State private var userText: String = ""
    @State private var dateText: String = ""
    @State private var emailText: String = ""
    @State private var addressText: String = ""
    @State private var businessNumberText: String = ""
    @State private var authorityNumberText: String = ""
    @State private var mobileNumberText: String = ""
    @EnvironmentObject private var navigationStack: NavigationStackCompat
    
    //MARK: - Views
    var body: some View {
        
        ZStack{
            Color(.bgColor)
                .ignoresSafeArea(.all)
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
    }
}

struct Form2View_Previews: PreviewProvider {
    static var previews: some View {
        RepresentativeView()
    }
}

extension RepresentativeView{
    
    var topArea: some View{
        
        VStack(spacing: 25){
            
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
                
                Color(.SuccessColor)
                    .frame(height: 5)
                Color(.darkGrayColor)
                    .frame(height: 5)
            }
            .frame(width: 250)
            
            Text("REPRESENTIVE INFORMATION")
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
                        
                        Image(uiImage: .ic_User)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        TextField("", text: $userText, prompt:
                                    Text("Type your name").foregroundColor(Color(.darkGrayColor)))
                        .font(.custom(.poppinsMedium, size: 18))
                        .frame(height: 30)
                        .foregroundColor(.white)
                    }
                    .padding([.leading, .trailing], 20)
                }
                .frame(height: 60)
                
                ZStack{
                    
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Calander)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        TextField("", text: $dateText, prompt:
                                    Text("Type your Date of Birth").foregroundColor(Color(.darkGrayColor)))
                        .font(.custom(.poppinsMedium, size: 18))
                        .frame(height: 30)
                        .foregroundColor(.white)
                        
                    }
                    .padding([.leading, .trailing], 20)
                }
                .frame(height: 60)
                
                ZStack{
                    
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Email)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        TextField("", text: $emailText, prompt:
                                    Text("Type your email").foregroundColor(Color(.darkGrayColor)))
                        .font(.custom(.poppinsMedium, size: 18))
                        .frame(height: 30)
                        .foregroundColor(.white)
                        
                    }
                    .padding([.leading, .trailing], 20)
                }
                .frame(height: 60)
                
                ZStack{
                    
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Number)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        TextField("", text: $businessNumberText, prompt:
                                    Text("Type Australian Business Number")
                            .foregroundColor(Color(.darkGrayColor)))
                        .font(.custom(.poppinsMedium, size: 18))
                        .frame(height: 30)
                        .foregroundColor(.white)
                        
                    }
                    .padding([.leading, .trailing], 20)
                }
                .frame(height: 60)
                
                ZStack{
                    
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Authority)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        TextField("", text: $authorityNumberText, prompt:
                                    Text("Type your authority No")
                            .foregroundColor(Color(.darkGrayColor)))
                        .font(.custom(.poppinsMedium, size: 18))
                        .frame(height: 30)
                        .foregroundColor(.white)
                        
                    }
                    .padding([.leading, .trailing], 20)
                }
                .frame(height: 60)
                
                ZStack{
                    
                    HStack(spacing: 10){
                        
                        Image(uiImage: .ic_Mobile)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        TextField("", text: $mobileNumberText, prompt:
                                    Text("Type your mobile No")
                            .foregroundColor(Color(.darkGrayColor)))
                        .font(.custom(.poppinsMedium, size: 18))
                        .frame(height: 30)
                        .foregroundColor(.white)
                        
                    }
                    .padding([.leading, .trailing], 20)
                }
                .frame(height: 60)
                
                ZStack{

                    HStack(alignment: .top, spacing: 10){
                        
                        Image(uiImage: .ic_Mobile)
                            .resizable()
                            .frame(width: 30, height: 30)
                        
                        
                        TextEditor(text: $addressText)
                            .font(.custom(.poppinsMedium, size: 18))
                            .foregroundColor(.white)
                            .scrollContentBackground(.hidden)
                            .padding(.vertical, -10)
                            .overlay(

                                VStack{

                                    Text(addressText == "" ? "Type your Postal Address" : "")
                                        .font(.custom(.poppinsMedium, size: 18))
                                        .foregroundColor(Color(.darkGrayColor))
                                    Spacer()
                                },
                                alignment: .leading
                            )
                    }
                    .padding([.all], 20)
                }
                .frame(height: 100)
                
            }
            .frame(maxWidth: .infinity)
            .background(Color(.darkBlueColor))
            .cornerRadius(10)
            
            HStack(spacing: 10){
                
                Image(uiImage: .ic_Box)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .onTapGesture {
                        
                        print("Tick if Same as physical Address")
                    }
                Text("Tick if Same as physical Address")
                    .font(.custom(.poppinsMedium, size: 20))
                    .foregroundColor(.white)
            }
            
            HStack{
                
                VStack(spacing: 20){
                    
                    Image(uiImage: .ic_Upload)
                        .resizable()
                        .frame(width: 40, height: 30)
                    Text("Driver License Image")
                        .foregroundColor(Color(.darkGrayColor))
                        .font(.custom(.poppinsMedium, size: 18))
                        
                }
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color(.darkBlueColor))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: StrokeStyle(lineWidth: 2, dash: [5]))
                    .foregroundColor(Color(.buttonColor))
            )
            
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
                    
                    setUserLogin(true)
                    navigationStack.push(MainTabbedView(), withId: .mainTabView)
                }
            
        }
        .padding(.horizontal, 15)
    }
}
