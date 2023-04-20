//
//  ImageViewModel.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 20.04.2023.
//

import SwiftUI
import Combine

class ImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: CoinModel
    private let dataService: CoinImageService
    private var cancellable = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        self.isLoading = true
        addSubscribers()
    }
    
    private func addSubscribers() {
        /// Subscribe on publish image CoinImageService
        dataService.$image
            .sink { [weak self] _ in
                self?.isLoading = false
            } receiveValue: { [weak self] returnImage in
                self?.image = returnImage
            }.store(in: &cancellable)
    }
}
