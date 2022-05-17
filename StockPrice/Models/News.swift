//
//  News.swift
//  StockPrice
//
//  Created by Ivan Christian on 18/05/22.
//

import Foundation

struct News : Decodable, Identifiable {
    let id : Int
    let category : String?
    let datetime : Int
    let headline : String
    let image : String?
    let source : String
    let summary : String?
    let url : String
}
