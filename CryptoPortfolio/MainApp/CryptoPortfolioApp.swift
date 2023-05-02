//
//  CryptoPortfolioApp.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 17.04.2023.
//

import SwiftUI

@main
struct CryptoPortfolioApp: App {
    
    var body: some Scene {
        WindowGroup {
            
            /// Service
            let coinDataService = CoinDataService()
            
            /// MockService
            //let coinDataService = MockCoinDataService()
            
            
            Main(vm: coinDataService )
    
        }
    }
}
