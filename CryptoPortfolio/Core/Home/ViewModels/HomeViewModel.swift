//
//  HomeViewModel.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 19.04.2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistic: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        /// First Subscribe combine two publisher: first - searchText, second - allCoins
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main) /// Wait 0.3 second before run the code
            .map(filterCoins)
            .sink { [weak self] returnCoins in
                self?.allCoins = returnCoins
            }.store(in: &cancellable)
        
        /// Second Subscribe to MarketDataService -> marketData
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] returnStats in
                self?.statistic = returnStats
            }.store(in: &cancellable)
    }
    
    /// Publisher: first - searchText, second - allCoins
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        
        /// If textField is empty -> return coins subscriber
        guard !text.isEmpty else { return coins }
        
        /// Search with lowercased
        let lowercasedText = text.lowercased()
        
        /// Filter
        return coins.filter { coin -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    /// Convert data: MarketDataModel into array of StatisticModel
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?) -> [StatisticModel] {
        var tempStats: [StatisticModel] = []
        
        /// If marketDataModel is empty return empty array
        guard let data = marketDataModel else { return tempStats }
        
        /// SetUp sections:
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let dominance = StatisticModel(title: "BTC Dominance", value: data.BTCDominance)
        let portfolioValue = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        /// Add to tempStats
        tempStats.append(contentsOf: [marketCap, volume, dominance, portfolioValue])
        return tempStats
    }
}
