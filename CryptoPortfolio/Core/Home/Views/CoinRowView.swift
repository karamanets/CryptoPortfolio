//
//  CoinRowView.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 19.04.2023.
//

import SwiftUI

struct CoinRowView: View {
    
    let coin: CoinModel
    let showHoldingColumn: Bool
    
    var body: some View {
        GeometryReader { geo in
            HStack (spacing: 0){
                
                leftColumn
                
                Spacer()
                
                if showHoldingColumn { centerColumn }
                
                rightColumn
                    .frame(width: geo.size.width / 3.5, alignment: .trailing)
                    .padding(.trailing, 6)
            }
            .font(.subheadline)
        }
    }
}

//                 🔱
struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin, showHoldingColumn: true)
    }
}

//MARK: - Components
private extension CoinRowView {
    
    var leftColumn: some View {
        HStack (spacing: 0) {
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            
            Circle()
                .frame(width: 30, height: 30)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundColor(Color.theme.accent)
                .padding(.leading, 6)
        }
    }
    
    var centerColumn: some View {
        VStack (alignment: .trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith6())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)
    }
    
    var rightColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "")
                .foregroundColor( ((coin.priceChangePercentage24H ?? 0 ) >= 0 ?
                                   Color.theme.green :
                                    Color.theme.red))
        }
        
    }
}
