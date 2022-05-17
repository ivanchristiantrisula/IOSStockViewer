//
//  NetworkRequest.swift
//  StockPrice
//
//  Created by Ivan Christian on 11/05/22.
//

import Foundation

public enum NetworkLoadingState {
    case loading, idle, error
}

class NetworkRequest {
    
    
    func callStockPriceAPI (ticker : String, range : String, completion: @escaping (_ data: Data?, _ error: Error?) -> Void) {
        
        let res = TimeUtility().getRes(range: range)
        let fromTo = TimeUtility().getFromToTime(range: range)
        
        guard let url = URL(string: "https://finnhub.io/api/v1/stock/candle?symbol=\(ticker)&resolution=\(res)&from=\(String(fromTo[0]))&to=\(String(fromTo[1]))&token=\(String(utf8String: getenv("FINNHUB_KEY"))!)") else {return}
        
        print(url.absoluteString)
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

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
        print("fetch sumary \(ticker)")
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
    
    func callStockSearchAPI(keyword : String, completion: @escaping(_ data : Data?, _ error : Error?) -> Void){
        
        
        guard let url = URL(string: "https://finnhub.io/api/v1/search?q=\(keyword)&token=\(String(utf8String: getenv("FINNHUB_KEY"))!)") else {return}
        
        print("search stock : \(url.absoluteString)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

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
    
    func callStockNewsAPI(ticker : String, completion: @escaping(_ data : Data?, _ error : Error?) -> Void){
        guard let url = URL(string: "https://finnhub.io/api/v1/company-news?symbol=\(ticker)&from=2021-09-01&to=2021-09-09&token=ca0b02aad3i0e3caeoig") else {return}
        
        print("search news : \(url.absoluteString)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

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
    
class TimeUtility {
    func getRes (range : String) -> String{
        switch range{
        case "5m" :
            return "1"
        case "30m" :
            return "1"
        case "1h" :
            return "1"
        case "1d" :
            return "5"
        case "1w" :
            return "60"
        case "1mo" :
            return "D"
        case "1y" :
            return "D"
        default :
            return "1"
        }
    }
    
    func getFromToTime (range : String) -> [Int]{
        struct TimeDifference {
            let year = 31536000
            let month = 2592000
            let week = 604800
            let day = 86400
        }
        
        let currentTimestamp = Int(Date().timeIntervalSince1970)
        
        switch range{
        case "5m" :
            return [currentTimestamp-(5*60), currentTimestamp]
        case "30m" :
            return [currentTimestamp-(30*60), currentTimestamp]
        case "1h" :
            return [currentTimestamp-(60*60), currentTimestamp]
        case "1d" :
            return [currentTimestamp-(60*60*24), currentTimestamp]
        case "1w" :
            return [currentTimestamp-(60*60*24*7), currentTimestamp]
        case "1mo" :
            return [currentTimestamp-(60*60*24*30), currentTimestamp]
        case "1y" :
            return [currentTimestamp-(60*60*24*30*12), currentTimestamp]
        default :
            return [currentTimestamp-(60*60*24), currentTimestamp]
        }
    }
}
