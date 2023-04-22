//
//  StatisticBarSection.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 21.04.2023.
//

import SwiftUI

struct StatisticBarSection: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @Binding var showportfolio: Bool
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                HStack {
                    ForEach(vm.statistic) { stat in
                        StatisticBarView(statistic: stat)
                            .frame(width: geo.size.width / 3)
                    }
                }
                .frame(width: geo.size.width, alignment: showportfolio ? .trailing : .leading)
            }
        }
        .frame(height: 50)
    }
}

//                    🔱
struct StatisticBarSection_Previews: PreviewProvider {
    static var previews: some View {
        StatisticBarSection(showportfolio: .constant(false))
            .environmentObject(dev.homeVM)
    }
}
