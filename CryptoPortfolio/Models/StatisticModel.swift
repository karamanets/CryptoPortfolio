//
//  StatisticModel.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 21.04.2023.
//

import Foundation

struct StatisticModel: Identifiable {
    
    var id = UUID().uuidString
    let title: String
    let value: String
    let percentageChange: Double?
    
    /// Make two type of init:  with percentageChange and with percentageChange = nil
    init(title: String, value: String, percentageChange: Double? = nil) {
        self.title = title
        self.value = value
        self.percentageChange = percentageChange
    }
}
