//
//  HomeViewModel.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 19.04.2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    let statistic: [StatisticModel] = [
        StatisticModel(title: "Total", value: "$1.23Bn", percentageChange: 12.33),
        StatisticModel(title: "Total", value: "$1.23Bn"),
        StatisticModel(title: "Total", value: "$1.23Bn"),
        StatisticModel(title: "Total", value: "$1.23Bn", percentageChange: -7.19)
    ]
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    /// Subscribed to publisher and searchText
    func addSubscriber() {
        /// Combine two publisher: first - searchText, second - allCoins
        $searchText
            .combineLatest(dataService.$allCoins)
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main) /// Wait 0.3 second before run the code
            .map(filterCoins)
            .sink { [weak self] returnCoins in
                self?.allCoins = returnCoins
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
}
