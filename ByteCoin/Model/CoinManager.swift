//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    let apiKey = "NTFkMTRhYjM1ZTJkNDlmNzk4OGQ3MTdhNWJmZGIwNDY"
    var delegate: CoinManagerDelegate?
    let currencyURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"

    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(currencyURL)\(currency)"
        performRequest(with: urlString)
    }
        
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let conf = URLSessionConfiguration.default
            conf.httpAdditionalHeaders = ["x-ba-key": apiKey]
            let session = URLSession(configuration: conf)
            let task = session.dataTask(with: url) { (data, response, error) in
                if(error != nil){
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coinData = self.parseJSON(safeData) {
                        self.delegate?.didUpdateCurrency(self, lastPrice: coinData)
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            return decodedData.last
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
