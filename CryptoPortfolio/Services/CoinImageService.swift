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
    private let fileManager = LocalFileManager.instance
    
    private let folderName = "Crypto_Images"
    private let coinName: String
    
    init(coin: CoinModel) {
        self.coin = coin
        self.coinName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        /// If can get image from fileManager just -> return,  if can't -> download image and save in fileManager
        if let savedImage = fileManager.getImage(imageName: coinName, folderName: folderName) {
            image = savedImage
            //print("Get Saved Image")
        } else {
            downloadCoinImage()
            //print("download Coin Image")
        }
    }
    
    private func downloadCoinImage() {
        /// URL CoinGecko coin image
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscriber = NetworkingManager.download(url: url)
            .tryMap({ data -> UIImage? in
                return UIImage(data: data)
            })
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion:(NetworkingManager.handleCompletion(_:)), receiveValue: { [weak self] returnImage in
                
                guard let self = self, let downloadImage = returnImage else { return }
                
                self.image = downloadImage
                self.imageSubscriber?.cancel()
                
                /// Save in FileManager
                self.fileManager.saveImage(image: downloadImage, imageName: self.coinName, folderName: self.folderName)
            })
    }
}
