//
//  HapticManager.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 26.04.2023.
//

import Foundation
import SwiftUI

final class HapticManager {
    
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        generator.notificationOccurred(type)
    }
    
    private init() { }
}
