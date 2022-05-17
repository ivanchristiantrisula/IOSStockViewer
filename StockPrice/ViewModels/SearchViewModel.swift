//
//  SearchViewModel.swift
//  StockPrice
//
//  Created by Ivan Christian on 17/05/22.
//

import Foundation

class SearchViewModel:ObservableObject {
    @Published var searchResult : [StockSearchResult] = []
    @Published var loadingState : NetworkLoadingState = .idle
    @Published var keyword : String = ""
    
    func getSearchResult() {
        NetworkRequest().callStockSearchAPI(keyword: keyword) { data, error in
            if let error = error {
                self.loadingState = .error
                print(error)
            }
            
            if let data = data {
                
                let decoder = JSONDecoder()
                
                do{
                    let decoded = try decoder.decode(OuterStockSearch.self, from: data)

                    DispatchQueue.main.async {
                        self.searchResult = decoded.result ?? []
                        self.loadingState = .idle
                    }
                }catch{
                    DispatchQueue.main.async {
                        self.loadingState = .error
                    }
                    
                    print("\(error)")
                }
                
            }
        }
    }
}
