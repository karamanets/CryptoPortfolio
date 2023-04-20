//
//  CoinImageService.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 20.04.2023.
//

import SwiftUI
import Combine

class CoinImageService {
    
    @Published var image: UIImage? = nil
    
    private var imageSubscriber: AnyCancellable?
    private var coin: CoinModel
    
    init(coin: CoinModel) {
        self.coin = coin
        getCoinImage()
    }
    
    private func getCoinImage() {
        /// URL CoinGecko
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscriber = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion:(NetworkingManager.handleCompletion(_:)), receiveValue: { [weak self] returnImage in
                self?.image = returnImage
                self?.imageSubscriber?.cancel()
            })
    }
}
