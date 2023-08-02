//
//  CoinDataService.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 19.04.2023.
//

import Foundation
import Combine

final class CoinDataService: CoinDataServiceProtocol {
    
    @Published var allCoins: [CoinModel] = []
    
    /// insert protocol
    var publisher: Published<[CoinModel]>.Publisher { $allCoins }
    
    /// Single subscriber
    var coinSubscription: AnyCancellable?
    
    init() {
        getCoins()
    }
    
    func getCoins() {
        /// URL CoinGecko
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&locale=en") else {
            return
        }
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion:(NetworkingManager.handleCompletion(_:)), receiveValue: { [weak self] returnValue in
                self?.allCoins = returnValue
                self?.coinSubscription?.cancel()
            })
    }
}
