//
//  DetailView.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 27.04.2023.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject private var vm: DetailViewModel
    
    /// inject CoinModel
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
        //print("[🔥] Coin downloaded: \(coin.name)")
    }
    
    var body: some View {
        VStack {
           
            XMarkButton()
            
        }
            .navigationBarBackButtonHidden()
    }
}

//                🔱
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(coin: dev.coin)
    }
}




