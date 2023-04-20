//
//  ImageView.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 20.04.2023.
//

import SwiftUI

struct CoinImageView: View {
    
    @StateObject private var vm: ImageViewModel
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: ImageViewModel(coin: coin))
    }
    
    var body: some View {
        ZStack {
            if let image = vm.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else if vm.isLoading {
                ProgressView()
            } else {
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(Color.theme.secondaryText)
                    .font(.title)
            }
        }
    }
}

//               🔱
struct CoinImageView_Previews: PreviewProvider {
    static var previews: some View {
        CoinImageView(coin: dev.coin)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
