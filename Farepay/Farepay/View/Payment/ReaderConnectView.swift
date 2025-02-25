//
//  ReaderConnectView.swift
//  Farepay
//
//  Created by Mursil on 14/11/2023.
//

import SwiftUI
import FirebaseAuth
struct ReaderConnectView: View {
    @State var noDevice = false
    @State var connecting = false
    @State var connected = false 
    @State var readerState :ReaderState = .notConnected
    var body: some View {
        VStack {
            switch readerState {
            case .notConnected:
                topArea
            case .noDevice:
                NoDeviceArea
            case .connecting:
                ConnectingArea
            case .connected:
                ConnectingArea
            }
            
        }
        .frame(maxWidth:.infinity,maxHeight:.infinity)

        .background(Color(.bgColor))
            
    }
}

extension ReaderConnectView {
    
    var topArea: some View {
        
        ZStack(alignment:.center) {
         
            VStack {
                Spacer()
                Button(action: {
                    readerState = .noDevice
                }, label: {
                    Text("Connect Reader")
                        .font(.custom(.poppinsBold, size: 25))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(.buttonColor))
                        .cornerRadius(30)
                })
            }
            
            VStack {
                Image("reader")
                    .resizable()
                    .frame(width: 240, height: 161, alignment: .center)
                Text("No Reader Connected ")
                    .foregroundColor(.white)
                    .font(.custom(.poppinsBold, size: 25))
                
                Text("Please wait, while we are connecting you with the reader")
                    .foregroundColor(Color(.darkGray))
                    .font(.custom(.poppinsMedium, size: 15))
                    .multilineTextAlignment(.center)
                
            }
        }
        .padding(.horizontal,20)
        
    }
    
    
    var NoDeviceArea: some View {
        
        ZStack(alignment:.center) {


            VStack {
                
                
                Spacer()
                Button(action: {
                    readerState = .connecting
                }, label: {
                    Text("Try Again")
                        .font(.custom(.poppinsBold, size: 25))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color(.buttonColor))
                        .cornerRadius(30)
                })

                Button(action: {
                    
                }, label: {
                    Text("Back to Home")
                        .font(.custom(.poppinsBold, size: 25))
                        .foregroundColor(.white)
                })
            }

            .padding(.horizontal,20)
            
            VStack {

                Image("noDevice")
                    .resizable()
                    .frame(width: 205, height: 205)
                Text("No Device Detected")
                    .foregroundColor(.white)
                    .font(.custom(.poppinsBold, size: 25))
                
                Text("Please make sure you have a stable and reliable internet connection before you try to connect with the other device.")
                    .foregroundColor(Color(.darkGray))
                    .font(.custom(.poppinsMedium, size: 15))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal,20)
            
        }
        
    }
    
    var ConnectingArea: some View {
        
        ZStack(alignment:.center) {
            
            VStack {

                Image( connected ? "connected" : "connecting")
                    .resizable()
                    .frame(width: 205, height: 205)
                Text(connected ? "Connected": "Connecting...")
                    .foregroundColor(.white)
                    .font(.custom(.poppinsBold, size: 25))
                
                Text( connected ? "You are successfully connected to a reader. The name of the reader is \(Auth.auth().currentUser?.displayName ?? "")" : "Please wait, while we are connecting you with the reader")
                    .foregroundColor(Color(.darkGray))
                    .font(.custom(.poppinsMedium, size: 15))
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal,20)
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    connected = true
                }
            })
            
        }
        
    }
}

#Preview {
    ReaderConnectView()
}


enum ReaderState {
case notConnected
case noDevice
case connecting
case connected
}
