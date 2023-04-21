//
//  DismissKeyboard.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 21.04.2023.
//

import SwiftUI

extension View {
    
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
