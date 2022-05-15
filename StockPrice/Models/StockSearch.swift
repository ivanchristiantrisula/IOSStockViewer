//
//  StockSearch.swift
//  StockPrice
//
//  Created by Ivan Christian on 15/05/22.
//

import Foundation

struct OuterStockSearch : Decodable {
    let count : Int
    let result : [StockSearchResult]?
}

struct StockSearchResult : Decodable {
    let description : String
    let displaySymbol : String
    let symbol : String
    let type : String
}
