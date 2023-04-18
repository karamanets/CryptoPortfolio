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
            NavigationStack {
                HomeView()
                    //.toolbar(.hidden, for: .navigationBar) /// hide navigation bar
            }
        }
    }
}
