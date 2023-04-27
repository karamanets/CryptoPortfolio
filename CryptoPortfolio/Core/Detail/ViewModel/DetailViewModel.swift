//
//  DetailViewModel.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 27.04.2023.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    
    private let coinDetailDataService: CoinDetailDataService
    private var cancellable = Set<AnyCancellable>()
    
    /// inject CoinModel
    init(coin: CoinModel) {
        self.coinDetailDataService = CoinDetailDataService(coin: coin)
        addSubscriber()
    }
    
    private func addSubscriber() {
        coinDetailDataService.$coinDetails
            .sink { returnCoinDetails in
               // print("[🔥]Received coinDetail \(returnCoinDetails )")
            }.store(in: &cancellable)
    }
}
