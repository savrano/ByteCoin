
import Foundation
import UIKit

protocol CoinManagerDelegate {
    func didUpdateCurrency(price : String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "579C6924-BF2A-4233-AAD7-2BD02857AFE5"
    
    let currencyArray = ["TRY","AUD","USD","EUR", "BRL","CAD","CNY","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func getCoinPrice(for currency: String){
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
 
                    
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        delegate?.didUpdateCurrency(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> Double? {
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}

