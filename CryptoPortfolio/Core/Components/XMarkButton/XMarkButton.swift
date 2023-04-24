//
//  XMarkButton.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 24.04.2023.
//

import SwiftUI

struct XMarkButton: View {
    
    @Environment(\.dismiss) var goBack
    
    var body: some View {
        Button {
            goBack()
        } label: {
            Image(systemName: "arrowshape.turn.up.backward.2")
                .font(.headline)
                .foregroundColor(Color.theme.red)
        }
        .padding(10)
    }
}

//                🔱
struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton()
    }
}
