//
//  SwiftUIView.swift
//  StockPrice
//
//  Created by Ivan Christian on 13/05/22.
//

import SwiftUI
import GoogleSignIn

struct WelcomeView: View {
    @EnvironmentObject var authVM: AuthViewModel

     var body: some View {
       VStack {
         Spacer()

         // 2
//         Image("header_image")
//           .resizable()
//           .aspectRatio(contentMode: .fit)

         Text("Welcome to Stock Watcher!")
           .fontWeight(.black)
           .foregroundColor(Color(.systemIndigo))
           .font(.largeTitle)
           .multilineTextAlignment(.center)

         Text("Lorem ipsum sit dolor amet Lorem ipsum sit dolor amet Lorem ipsum sit dolor amet Lorem ipsum sit dolor amet")
           .fontWeight(.light)
           .multilineTextAlignment(.center)
           .padding()

         Spacer()

         GoogleSignInButton()
           .padding()
           .onTapGesture {
               authVM.signIn()
           }
       }
     }
}

struct GoogleSignInButton: UIViewRepresentable {
  @Environment(\.colorScheme) var colorScheme
  
  private var button = GIDSignInButton()

  func makeUIView(context: Context) -> GIDSignInButton {
    button.colorScheme = colorScheme == .dark ? .dark : .light
    return button
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    button.colorScheme = colorScheme == .dark ? .dark : .light
  }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
