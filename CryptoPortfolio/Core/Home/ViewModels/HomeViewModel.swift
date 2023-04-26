//
//  HomeViewModel.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 19.04.2023.
// .refreshable() add

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistic: [StatisticModel] = []
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioCoreDataService = PortfolioCoreDataService()
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
        
        /// SecondSubscriber Portfolio CoreData combine with allCoin (latest filtered coins in search bar)
        $allCoins
            .combineLatest(portfolioCoreDataService.$savedEntity)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnValue in
                self?.portfolioCoins = returnValue
            }.store(in: &cancellable)
        
        /// Third Subscribe to MarketDataService -> marketData and portfolioCoins -> get current amount of portfolio
        marketDataService.$marketData
            .combineLatest($portfolioCoins)
            .map(mapGlobalMarketData)
            .sink { [weak self] returnStats in
                self?.statistic = returnStats
                self?.isLoading = false /// make animation for refresh
            }.store(in: &cancellable)
    }
    
    /// Update Coin Portfolio in CoreData
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioCoreDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    /// Reload Data for refresh
    func reloadData() {
        isLoading = true
        coinDataService.getCoins()
        marketDataService.getData()
        HapticManager.notification(type: .success)
    }
    
    /// Map all coins to portfolio coins
    private func mapAllCoinsToPortfolioCoins(allCoins: [CoinModel], portfolioCoins: [PortfolioEntity] ) -> [CoinModel] {
        allCoins
               .compactMap { (coin) -> CoinModel? in
                   guard let entity = portfolioCoins.first(where: { $0.coinID == coin.id }) else {
                       return nil
                   }
                   return coin.updateHoldings(amount: entity.amount)
               }
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
    private func mapGlobalMarketData(marketDataModel: MarketDataModel?, coins: [CoinModel]) -> [StatisticModel] {
        var tempStats: [StatisticModel] = []
        
        /// If marketDataModel is empty return empty array
        guard let data = marketDataModel else { return tempStats }
        
        /// SetUp  for first three sections:
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let dominance = StatisticModel(title: "BTC Dominance", value: data.BTCDominance)
        
        /// SetUp for portfolio all -> value
        let portfolioValue =
            coins
            .map({ $0.currentHoldingsValue })
            .reduce(0, +)
        
        /// SetUp for portfolio all -> percentageChange 24h
        let previousValue =
            coins
            .map { (coin) -> Double in
                let currentValue = coin.currentHoldingsValue
                let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
                let previousValue = currentValue / (1 + percentChange)
                return previousValue
            }
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / previousValue) * 100
        
        /// SetUp Last section:
        let portfolio = StatisticModel(title: "Portfolio Value",
                                            value: portfolioValue.asCurrencyWith2(),
                                            percentageChange: percentageChange)
        
        /// Add to tempStats
        tempStats.append(contentsOf: [marketCap, volume, dominance, portfolio])
        return tempStats
    }
}
