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
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var showDetailView: Bool = false
    
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
                NavigationLink {
                    /// Inserted Lazy View
                    LazyView<DetailView>(DetailView(coin: coin))
                } label: {
                    CoinRowView(coin: coin, showHoldingColumn: false)
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    private var portfolioCoinsList: some View {
        List {
            ForEach(vm.portfolioCoins) { coin in
                NavigationLink {
                    /// Inserted Lazy View
                    LazyView<DetailView>(DetailView(coin: coin))
                } label: {
                    CoinRowView(coin: coin, showHoldingColumn: true)
                }
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
    
    private var infoColumn: some View {
        HStack {
            HStack (spacing: 4) {
                Text("Coin")
                Image(systemName: "chevron.down")
                    .opacity( (vm.sortOptions == .rank || vm.sortOptions == .rankReversed) ? 1.0 : 0.0 )
                    .rotationEffect(Angle(degrees: vm.sortOptions == .rank ? 180 : 0))
            }
            .onTapGesture {
                withAnimation(.linear(duration: 0.5)) {
                    vm.sortOptions = vm.sortOptions == .rank ? .rankReversed :  .rank
                }
                HapticManager.notification(type: .success)
            }
            Spacer(minLength: 160)
            if showPortfolio {
                HStack (spacing: 4) {
                    Text("Holdings")
                    Image(systemName: "chevron.down")
                        .opacity( (vm.sortOptions == .holdings || vm.sortOptions == .holdingsReversed) ? 1.0 : 0.0 )
                        .rotationEffect(Angle(degrees: vm.sortOptions == .holdings ? 180 : 0 ))
                }
                .onTapGesture {
                    withAnimation(.linear(duration: 0.5)) {
                        vm.sortOptions = vm.sortOptions == .holdings ? .holdingsReversed : .holdings
                    }
                    HapticManager.notification(type: .success)
                }
            }
            Spacer(minLength: 50)
            HStack (spacing: 4) {
                Text("Price")
                Image(systemName: "chevron.down")
                    .opacity( (vm.sortOptions == .price || vm.sortOptions == .priceReversed) ? 1.0 : 0.0 )
                    .rotationEffect(Angle(degrees: vm.sortOptions ==  .price ? 180 : 0 ))
            }
            .onTapGesture {
                withAnimation(.linear(duration: 0.5)) {
                    vm.sortOptions = vm.sortOptions == .price ? .priceReversed : .price
                }
                HapticManager.notification(type: .success)
            }
            Button {
                withAnimation(.linear(duration: 0.5)) {
                    vm.reloadData()
                }
            } label: {
                Image(systemName: "goforward")
                    .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
            }
            .padding(.leading, 8)
        }
        .padding(.horizontal)
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
    }
}
