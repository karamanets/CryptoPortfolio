//
//  Color.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 17.04.2023.
//

import Foundation
import SwiftUI

struct ColorTheme {
    
    let accent = Color("AccentColor")
    let background = Color("BackgroundColor")
    let green = Color("GreenColor")
    let red = Color("RedColor")
    let SecondaryText = Color("SecondaryTextColor")
}

extension Color {
    
    /// Color setUp for app
    static let theme = ColorTheme()
}
