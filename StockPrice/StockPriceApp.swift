//
//  StockPriceApp.swift
//  StockPrice
//
//  Created by Ivan Christian on 11/05/22.
//

import SwiftUI
import Firebase

@main
struct StockPriceApp: App {
    @StateObject var authVM = AuthViewModel()

    init(){
        setupAuth()
    }
    var body: some Scene {
        WindowGroup {
            NavigationView{
                switch authVM.state{
                case .signedIn:
                    HomeView()
                        
                case.signedOut:
                    WelcomeView()
                        .environmentObject(authVM)
                }
                
            }
            
        }
    }
}

extension StockPriceApp {
    private func setupAuth () {
        FirebaseApp.configure()
    }
}
