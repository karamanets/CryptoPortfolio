//
//  Double.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 19.04.2023.
//

import Foundation

extension Double {
    
    /// Convert Double into a Currency with 2-6 decimal places
    /// ```
    /// Convert 1234.56 to $1,234.56
    /// Convert 12.3456 to $12.3456
    /// Convert 0.123456 to $0.123456
    ///```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
        //formatter.locale = .current
        //formatter.currencyCode = "usd"
        formatter.currencySymbol = "$"
        formatter.minimumFractionDigits = 2 /// minimum ofter coma
        formatter.maximumFractionDigits = 6 /// maximum after coma
        return formatter
    }
    
    /// Convert Double into a Currency with 2-6 decimal places
    /// ```
    /// Convert 1234.56 to "$1,234.56"
    /// Convert 12.3456 to "$12.3456"
    /// Convert 0.123456 to "$0.123456"
    ///```
    func asCurrencyWith6() -> String {
        let number = NSNumber(value: self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    /// Convert Double into a Currency with 2-6 decimal places
    /// ```
    /// Convert 1.23456 to "1.23"
    /// ```
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    /// Convert Double into a Currency with 2-6 decimal places
    /// ```
    /// Convert 1.23456 to "1.23%"
    /// ```
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
}
