//
//  CoinDataServiceProtocol.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 02/05/2023.
//

import Foundation
import Combine

protocol CoinDataServiceProtocol {
    
    var publisher: Published<[CoinModel]>.Publisher { get }
    
    var coinSubscription: AnyCancellable?           { get }
    
    func getCoins()
}
