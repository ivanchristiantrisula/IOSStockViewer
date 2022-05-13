//
//  HomeView.swift
//  StockPrice
//
//  Created by Ivan Christian on 13/05/22.
//

import SwiftUI

struct HomeView: View {
    let stocks = ["MSFT","AAPL","GOOGL","FB","TWTR","TSLA"]
    @State var openDetail : Bool = false
    @State var selectedTicker : String = ""
    
    var body: some View {
        List{
            ForEach(stocks, id: \.self){ stock in
                NavigationLink(stock) {
                    StockDetailView(detailViewModel: DetailViewModel(stock))
                }
            }
        }
        .navigationTitle("Top Stocks")
        .toolbar {
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
