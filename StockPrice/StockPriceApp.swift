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
            switch authVM.state{
            case .signedIn:
                TabView{
                    HomeView()
                        .tabItem {
                            Label("Wishlist", systemImage: "star")
                        }
                    
                    SearchStockView()
                        .tabItem{
                            Label("Search", systemImage: "magnifyingglass")
                        }
                }
                
                    
            case.signedOut:
                WelcomeView()
                    .environmentObject(authVM)
            }
            
        }
    }
}

extension StockPriceApp {
    private func setupAuth () {
        FirebaseApp.configure()
    }
}
