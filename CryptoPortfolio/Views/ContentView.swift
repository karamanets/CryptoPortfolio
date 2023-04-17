//
//  ContentView.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 17.04.2023.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        VStack {
            
            Text("Hello SwiftUi")
                .foregroundColor(Color.theme.accent)
            
            Text("Hello SwiftUi")
                .foregroundColor(Color.theme.SecondaryText)
            
            Text("Hello SwiftUi")
                .foregroundColor(Color.theme.green)
            
            Text("Hello SwiftUi")
                .foregroundColor(Color.theme.red)
            

        }
        .font(.system(size: 35) .bold())
        .background{ Color.theme.background }
    }
}

//                 🔱
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
