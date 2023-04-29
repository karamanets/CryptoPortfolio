//
//  String.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 29.04.2023.
//

import Foundation

extension String {
    
    var removingHTMLOccurrences: String {
        /// Replace HTML code to ---> Void
        return self.replacingOccurrences(of: "<[^>]+>", with: "" ,options: .regularExpression)
    }
}
