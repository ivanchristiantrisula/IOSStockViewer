//
//  NetworkRequest.swift
//  StockPrice
//
//  Created by Ivan Christian on 11/05/22.
//

import Foundation

class NetworkRequest {
    func callStockPriceAPI (ticker : String, range : String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let url = URL(string: "https://yfapi.net/v8/finance/chart/\(ticker)?range=\(range)") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(String(utf8String: getenv("API_KEY")), forHTTPHeaderField: "X-API-KEY")

        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data {
                completion(data, nil)
            } else {
                completion(nil, nil)
            }
        })
        task.resume()
    }
    
    func callStockSummaryAPI (ticker : String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        guard let url = URL(string: "https://yfapi.net/v11/finance/quoteSummary/\(ticker)?lang=en&region=US&modules=defaultKeyStatistics%2CassetProfile") else {return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(String(utf8String: getenv("API_KEY")), forHTTPHeaderField: "X-API-KEY")

        let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
            if let error = error {
                completion(nil, error)
            }
            
            if let data = data {
                completion(data, nil)
            } else {
                completion(nil, nil)
            }
        })
        task.resume()
    }
}
    
