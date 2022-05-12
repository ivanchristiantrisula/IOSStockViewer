//
//  Stock.swift
//  StockPrice
//
//  Created by Ivan Christian on 11/05/22.
//

import Foundation

// MARK: - Stock
struct Stock: Codable {
    let chart: Chart
}

// MARK: - Chart
struct Chart: Codable {
    let result: [Result]
}

// MARK: - Result
struct Result: Codable {
    let meta: Meta
    let timestamp: [Int]?
    let indicators: Indicators
}

// MARK: - Indicators
struct Indicators: Codable {
    var quote: [Quote]
}

// MARK: - Quote
struct Quote: Codable {
    var volume : [Double?]
    var high : [Double?]
    var open : [Double?]
    var close : [Double?]
    var low : [Double?]
}

// MARK: - Meta
struct Meta: Codable {
    let currency, symbol, exchangeName, instrumentType: String
    let firstTradeDate, regularMarketTime, gmtoffset: Int
    let timezone, exchangeTimezoneName: String
    let regularMarketPrice, chartPreviousClose, previousClose: Double
    let scale, priceHint: Int
    let currentTradingPeriod: CurrentTradingPeriod
    let tradingPeriods: [[Post]]
    let dataGranularity, range: String
    let validRanges: [String]
}

// MARK: - CurrentTradingPeriod
struct CurrentTradingPeriod: Codable {
    let pre, regular, post: Post
}

// MARK: - Post
struct Post: Codable {
    let timezone: String
    let start, end, gmtoffset: Int
}
