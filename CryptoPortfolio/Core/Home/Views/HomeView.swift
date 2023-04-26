//
//  HomeView.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 17.04.2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    @State private var showPortfolio : Bool = false /// Animation
    @State private var showSheet     : Bool = false /// Show sheet view
    
    var body: some View {
        
        ZStack {
            /// background layer
            Color.theme.background
            
            /// content layer
            VStack {
                /// Top Bar
                homeHeader
                
                /// Statistic Bar
                StatisticBarSection(showPortfolio: $showPortfolio)
                
                /// Search Bar
                SearchBarView(searchText: $vm.searchText)
                
                /// Info Column
                infoColumn
                
                /// Lists
                if !showPortfolio {
                    allCoinsList
                    .transition(.move(edge: .leading))
                }
                if showPortfolio {
                    portfolioCoinsList
                        .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
        }
        .sheet(isPresented: $showSheet) {
            PortfolioView()
                .environmentObject(vm)
        }
    }
}

//                 🔱
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
        .environmentObject(dev.homeVM)
    }
}

//MARK: - Components
extension HomeView {
    
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .background(CircleButtonAnimate(animate: $showPortfolio))
                .onTapGesture {
                    if showPortfolio {
                        /// If circle button is "plus" -> can show sheet
                        hideKeyboard()
                        showSheet.toggle()
                    }
                }
            
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .rotationEffect(Angle(degrees: showPortfolio ? 180 : 0))
                .onTapGesture {
                    withAnimation(.spring()) {
                        showPortfolio.toggle()
                    }
                }
        }
        .padding(.horizontal)
    }
    
    private var allCoinsList: some View {
        List {
            ForEach(vm.allCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: false)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                CoinRowView(coin: coin, showHoldingColumn: true)
                    .listRowInsets(.init(top: 10, leading: 0, bottom: 10, trailing: 10))
            }
        }
        .listStyle(.plain)
    }
    
    private var infoColumn: some View {
        HStack {
            Text("Coin")
            Spacer(minLength: 160)
            if showPortfolio {
                Text("Holdings")
            }
            Spacer(minLength: 50)
            Text("Price")
            
            Button {
                withAnimation(.easeInOut(duration: 2.0)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
                    .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
            }
            
        }
        .padding(.horizontal)
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
    }
}
