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
    @Published var sortOptions: SortOptions = .holdings
    
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioCoreDataService = PortfolioCoreDataService()
    private var cancellable = Set<AnyCancellable>()
    
    enum SortOptions {
        case rank, rankReversed, holdings, holdingsReversed, price, priceReversed
    }
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        /// First Subscribe combine  publisher: first - searchText, second - allCoins, third - sort
        $searchText
            .combineLatest(coinDataService.$allCoins, $sortOptions)
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main) /// Wait 0.3 second before run the code
            .map(filterAndSort)
            .sink { [weak self] returnCoins in
                self?.allCoins = returnCoins
            }.store(in: &cancellable)
        
        /// SecondSubscriber Portfolio CoreData combine with allCoin (latest filtered coins in search bar)
        $allCoins
            .combineLatest(portfolioCoreDataService.$savedEntity)
            .map(mapAllCoinsToPortfolioCoins)
            .sink { [weak self] returnValue in
                guard let self = self else { return }
                self.portfolioCoins = self.sortPortfolioCoins(coins: returnValue)
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
    
    /// Return -> Filter and Sort
    private func filterAndSort(text: String, coins: [CoinModel], sort: SortOptions) -> [CoinModel] {
        /// Filter coins
        var updateCoins = filterCoins(text: text, coins: coins)
    
        /// Sort Coins with the same array use inout parameter and sort(by: ...) instead sorted(by: ... )
        sortCoins(sort: sort, coins: &updateCoins)
        
        return updateCoins
    }
    
    /// Sort Coins : rank, rankReversed, price, priceReversed
    private func sortCoins(sort: SortOptions, coins: inout [CoinModel]) {
        switch sort {
            /// holdings and holdingsReversed doesn't need in first list, only in second list (portfolio)
        case .rank, .holdings:
            coins.sort(by: { $0.rank < $1.rank })
        case .rankReversed, .holdingsReversed:
            coins.sort(by: { $0.rank > $1.rank })
        case .price:
            coins.sort(by: { $0.currentPrice > $1.currentPrice })
        case .priceReversed:
            coins.sort(by: { $0.currentPrice < $1.currentPrice })
        }
    }
    
    /// Sort for portfolio coins: holdings, holdingsReversed
    private func sortPortfolioCoins(coins: [CoinModel]) -> [CoinModel] {
        switch sortOptions {
        case .holdings:
            return coins.sorted(by: { $0.currentHoldingsValue > $1.currentHoldingsValue })
        case .holdingsReversed:
            return coins.sorted(by: { $0.currentHoldingsValue < $1.currentHoldingsValue })
        default :
            return coins
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
