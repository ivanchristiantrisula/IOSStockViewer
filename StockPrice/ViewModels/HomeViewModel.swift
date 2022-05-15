//
//  HomeViewModel.swift
//  StockPrice
//
//  Created by Ivan Christian on 14/05/22.
//

import Foundation

class HomeViewModel : ObservableObject {
    @Published var ticker : String
    @Published var quote : PriceQuote?
    
    init(_ ticker : String){
        self.ticker = ticker
        fetchChart()
    }
    
    func fetchChart(){
        NetworkRequest().callStockPriceAPI(ticker: ticker, range: "1w") { data, error in
            if let error = error {
                print(error)
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                
                do{
                    let decoded = try decoder.decode(PriceQuote.self, from: data)
                    DispatchQueue.main.async{
                        self.quote = decoded
                    }
                    
                }catch{
                    print("Error decodign chart \(error)")
                }
                
            }
        }
    }
    
}
