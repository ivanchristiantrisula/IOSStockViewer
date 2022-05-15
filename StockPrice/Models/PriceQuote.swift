//
//  PriceQuote.swift
//  StockPrice
//
//  Created by Ivan Christian on 15/05/22.
//

import Foundation

struct PriceQuote: Decodable {
    let c : [Double]
    let h : [Double]
    let l : [Double]
    let o : [Double]
    let t : [Double]
    let v : [Double]
}
