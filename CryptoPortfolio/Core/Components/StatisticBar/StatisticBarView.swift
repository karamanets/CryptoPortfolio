//
//  StatistikBarView.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 21.04.2023.
//

import SwiftUI

struct StatisticBarView: View {
    
    let statistic: StatisticModel
    
    var body: some View {
        VStack (alignment: .leading, spacing: 4) {
            Text(statistic.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(statistic.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            
            HStack (spacing: 4) {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees: (statistic.percentageChange ?? 0) >= 0 ? 0 : 180))
                
                Text(statistic.percentageChange?.asPercentString() ?? "")
                    .font(.caption .bold())
            }
            .foregroundColor((statistic.percentageChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(statistic.percentageChange == nil ? 0.0 : 1.0 )
        }
    }
}

//                     🔱
struct StatisticBarView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticBarView(statistic: dev.statThree)
    }
}
