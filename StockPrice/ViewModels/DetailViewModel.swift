//
//  DetailViewModel.swift
//  StockPrice
//
//  Created by Ivan Christian on 11/05/22.
//

import Foundation

class DetailViewModel : ObservableObject{
    @Published var quote : PriceQuote?
    @Published var ticker : String
    @Published var range : String = "1w"
    @Published var stockProfile : AssetProfile?
    @Published var chartLoadingState : NetworkLoadingState = .idle
    @Published var newsLoadingState : NetworkLoadingState = .idle
    @Published var news : [News] = []
    
    
    
    init(_ ticker : String){
        self.ticker = ticker
    }
    
    init (_ ticker : String, quote : PriceQuote){
        self.ticker = ticker
        self.quote = quote
    }
    
    func load (withGraph : Bool = true) {
        if(withGraph){
            fetchChart()
        }
        fetchStockNews()
        fetchStockProfile ()
        
    }
    
    func fetchChart () {
        chartLoadingState = .loading
        NetworkRequest().callStockPriceAPI(ticker: self.ticker, range : self.range) { data, error in
            if let error = error {
                print(error)
                self.chartLoadingState = .error
            }
            
            if let data = data {
                
                do{
                    let decoder = JSONDecoder()
                    let decoded = try decoder.decode(PriceQuote.self, from: data)
                    DispatchQueue.main.async {
                        self.quote = decoded
                        
                        self.chartLoadingState = .idle
                    }
                }catch{
                    print("Error decoding chart \(error)")
                    
                    DispatchQueue.main.async {
                        self.chartLoadingState = .error
                    }
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
    
    func fetchStockNews() {
        print("adfsadfs")
        NetworkRequest().callStockNewsAPI(ticker: self.ticker) { data, error in
            if let error = error {
                print(error)
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                
                do{
                    print("Masokkkk")
                    let decoded = try decoder.decode([News].self, from: data)
                    DispatchQueue.main.async {
                        self.news = decoded                    }
                }catch{
                    print(error)
                }
            }
        }
    }
}
