//
//  DetailView.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 27.04.2023.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject private var vm: DetailViewModel
    
    private let columns: [GridItem] = [GridItem(.flexible()), GridItem(.flexible())]
    
    /// inject CoinModel
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    var body: some View {
        VStack {
            detailHeader
            
            chart
            
            ScrollView(showsIndicators: false) {
                overview
                
                divider
                details
            }
            .padding()
            .navigationBarBackButtonHidden()
        }
    }
}

//                🔱
struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
            DetailView(coin: dev.coin)
    }
}

//MARK: - Components
extension DetailView {
    
    /// Header coin name and backButton
    private var detailHeader: some View {
        HStack  {
            XMarkButton()
            Text(vm.coin.name)
                .font(.title2 .bold())
                .foregroundColor(Color.theme.accent)
            Spacer()
            HStack {
                Text(vm.coin.symbol.uppercased())
                    .font(.title2 .bold())
                    .foregroundColor(Color.theme.secondaryText)
                
                CoinImageView(coin: vm.coin)
                    .frame(width: 25, height: 25)
            }
            .padding(10)
        }
    }
    
    /// Graph for coin
    private var chart: some View {
        VStack {
            ChartView(coin: vm.coin)
        }
        .padding(.vertical, 5)
    }
    
    /// Overview for coin
    private var overview: some View {
        VStack (spacing: 20) {
            Text("Overview")
                .font(.title .bold())
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: 30) {
                ForEach(vm.overviewStatistic) { stat in
                    StatisticBarView(statistic: stat)
                }
            }
        }
    }
    
    /// Details for coin
    private var details: some View {
        VStack (spacing: 20) {
            Text("Details")
                .font(.title .bold())
                .foregroundColor(Color.theme.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVGrid(columns: columns, alignment: .leading, spacing: 30) {
                ForEach(vm.detailsStatistic) { stat in
                    StatisticBarView(statistic: stat)
                }
            }
        }
    }
    
    /// Custom Divider
    private var divider: some View {
        VStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(Color.theme.secondaryText)
                .frame(maxWidth: .infinity)
                .frame(height: 1)
        }
    }
}

