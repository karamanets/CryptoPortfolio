//
//  CoinDetailDataServiceProtocol.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 02/05/2023.
//

import Foundation
import Combine

protocol CoinDetailDataServiceProtocol {
    
    var publisher: Published<CoinDetailsModel?>.Publisher { get }
    
    var coinDetailSubscription: AnyCancellable? { get }
    var coin: CoinModel { get }
    
    func getCoinDetails()
    
}
