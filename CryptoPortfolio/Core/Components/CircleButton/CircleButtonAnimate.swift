//
//  CircleButtonAnimate.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 18.04.2023.
//

import SwiftUI

struct CircleButtonAnimate: View {
    
    @Binding var animate: Bool
    
    var body: some View {
        
        Circle()
            .stroke(lineWidth: 5)
            .foregroundColor(Color.theme.red)
            .scaleEffect(animate ? 1.0 : 0)
            .opacity(animate ? 0.0 : 1.0)
            .animation(.easeInOut(duration: 0.7), value: animate)
    }
}

//                   🔱
struct CircleButtonAnimate_Previews: PreviewProvider {
    static var previews: some View {
        CircleButtonAnimate(animate: .constant(false))
    }
}
