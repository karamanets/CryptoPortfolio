//
//  HomeViewModel.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 19.04.2023.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    
    @Published var searchText: String = ""
    
    private let dataService = CoinDataService()
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        addSubscriber()
    }
    
    /// Subscribed to publisher in DataServer allCoins ($)
    func addSubscriber() {
        dataService.$allCoins
            .sink { [weak self] returnValue in
                self?.allCoins = returnValue
            }.store(in: &cancellable)
    }
}
