//
//  ToastView.swift
//  ToastDemo
//
//  Created by Ondrej Kvasnovsky on 1/30/23.
//

import SwiftUI

struct ToastView: View {
  
  var style: ToastStyle
  var message: String
  var width = CGFloat.infinity
  var onCancelTapped: (() -> Void)
  
  var body: some View {
    HStack(alignment: .center, spacing: 12) {
      Image(systemName: style.iconFileName)
        .foregroundColor(style.themeColor)
        .imageScale(.large) // Increased icon size
      
      Text(message)
        .font(.system(size: 16, weight: .regular)) // Increased font size and added weight
        .foregroundColor(Color(.darkGrayColor))
      
      Spacer(minLength: 10)
      
      Button {
        onCancelTapped()
      } label: {
        Image(systemName: "xmark")
          .foregroundColor(style.themeColor)
          .imageScale(.medium) // Adjusted close button size
      }
    }
    .padding(.vertical, 12) // Slightly increased vertical padding
    .padding(.horizontal, 16) // Slightly increased horizontal padding
    .frame(minWidth: 0, maxWidth: width)
    .background(Color.white)
    .cornerRadius(8)
    .overlay(
      RoundedRectangle(cornerRadius: 8)
        .stroke(Color(.black), lineWidth: 1)
        .opacity(0.6)
    )
    .padding(.horizontal, 16)
  }
}

struct FancyToastView_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 32) {
      ToastView(
        style: .success,
        message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ") {}
      ToastView(
        style: .info,
        message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ") {}
      ToastView(
        style: .warning,
        message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ") {}
      ToastView(
        style: .error,
        message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ") {}
    }
  }
}

struct FancyToastViewDark_Previews: PreviewProvider {
  static var previews: some View {
    VStack(spacing: 32) {
      ToastView(
        style: .success,
        message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ") {}
      ToastView(
        style: .info,
        message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ") {}
      ToastView(
        style: .warning,
        message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ") {}
      ToastView(
        style: .error,
        message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. ") {}
    }
    .preferredColorScheme(.dark)
  }
}
