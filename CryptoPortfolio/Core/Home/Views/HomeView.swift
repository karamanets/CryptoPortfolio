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
    @State private var showSheet     : Bool = false /// Show sheet add coin view
    @State private var showSettings  : Bool = false /// Show sheet Settings
    
    var body: some View {
        
        ZStack {
            /// background layer
            Color.theme.background.ignoresSafeArea()
                .sheet(isPresented: $showSheet) {
                    PortfolioView()
                        .environmentObject(vm)
                }
            
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
                    ZStack {
                        /// If Portfolio is empty -> show Text
                        if vm.portfolioCoins.isEmpty && vm.searchText.isEmpty {
                            emptyPortfolioCoinsList
                        } else {
                            portfolioCoinsList
                        }
                    }
                    .transition(.move(edge: .trailing))
                }
                Spacer(minLength: 0)
            }
        }
        .sheet(isPresented: $showSettings) {
            SettingsView()
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
                .accessibilityIdentifier("plus_info_Button_ID")
                .background(CircleButtonAnimate(animate: $showPortfolio))
                .onTapGesture {
                    if showPortfolio {
                        /// If circle button is "plus" -> can show sheet
                        hideKeyboard()
                        showSheet.toggle()
                    } else {
                        /// If circle button is "info" -> can show sheet settings
                        hideKeyboard()
                        showSettings.toggle()
                    }
                }
            
            Spacer()
            Text(showPortfolio ? "Portfolio" : "Live Prices")
                .accessibilityIdentifier("mainHeader_Label_ID")
                .font(.headline)
                .fontWeight(.heavy)
                .foregroundColor(Color.theme.accent)
            Spacer()
            CircleButtonView(iconName: "chevron.right")
                .accessibilityIdentifier("showPortfolio_Button_ID")
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
            .listRowBackground(Color.theme.background)
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
            .listRowBackground(Color.theme.background)
        }
        .listStyle(.plain)
    }
    
    private var emptyPortfolioCoinsList: some View {
        
        VStack (alignment: .center) {
            Image(systemName: "arrowshape.turn.up.backward.2.fill")
                .resizable()
                .frame(width: 70, height: 50)
                .rotationEffect(Angle(degrees: 58))
                .foregroundColor(Color.theme.red)
                .shadow(color: Color.theme.red.opacity(0.7), radius: 5, y: 5)
                .padding(.top, 50)
            
            Text("The portfolio is empty. Press plus to add some Coins")
                .font(.system(size: 23 , weight: .medium, design: .monospaced))
                .foregroundColor(Color.theme.accent)
                .multilineTextAlignment(.center)
                .shadow(color: Color.theme.red.opacity(0.7), radius: 5, y: 5)
                .padding(.top, 20)
                .padding(.horizontal)
        }
    }
    
    private var infoColumn: some View {
        HStack {
            HStack (spacing: 4) {
                Text("Coin")
                    .accessibilityIdentifier("searchOfNumber_Button_ID")
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
                        .accessibilityIdentifier("searchOfHoldings_Button_ID")
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
                    .accessibilityIdentifier("searchOfPrice_Button_ID")
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
                    .accessibilityIdentifier("refresh_Button_ID")
                    .rotationEffect(Angle(degrees: vm.isLoading ? 360 : 0), anchor: .center)
            }
            .padding(.leading, 8)
        }
        .padding(.horizontal)
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
    }
}
