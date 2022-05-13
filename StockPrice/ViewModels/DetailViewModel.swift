//
//  DetailViewModel.swift
//  StockPrice
//
//  Created by Ivan Christian on 11/05/22.
//

import Foundation

class DetailViewModel : ObservableObject{
    @Published var meta : Meta?
    @Published var quote : Quote?
    @Published var ticker : String
    @Published var range : String = "1d"
    @Published var stockProfile : AssetProfile?
    @Published var chartLoadingState : LoadingState = .idle
    
    enum LoadingState {
        case loading, idle
    }
    
    init(_ ticker : String = "AAPL"){
        self.ticker = ticker
    }
    
    func load () {
        fetchChart()
        fetchStockProfile ()
    }
    
    func fetchChart () {
        chartLoadingState = .loading
        NetworkRequest().callStockPriceAPI(ticker: self.ticker, range : self.range) { data, error in
            if let error = error {
                print(error)
            }
            
            if let data = data {
                
                do{
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(Stock.self, from: data)
                    DispatchQueue.main.async {
                        self.meta = decoded.chart.result[0].meta
                        self.quote = decoded.chart.result[0].indicators.quote[0]
                        
                        self.chartLoadingState = .idle
                    }
                }catch{
                    print("Error decoding chart \(error)")
                }
                
            }
        }
    }
    
    func fetchStockProfile () {
        NetworkRequest().callStockSummaryAPI(ticker: self.ticker) { data, error in
            if let error = error{
                print(error)
            }
            
            if let data = data {
                do{
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(StockSummary.self, from: data)
                    
                    DispatchQueue.main.async {
                        self.stockProfile = decoded.quoteSummary.result[0].assetProfile
                    }
                }catch{
                    print("Error decoding profile \(error)")
                }
            }
        }
    }
}
