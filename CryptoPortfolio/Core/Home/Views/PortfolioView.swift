//
//  PortfolioView.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 24.04.2023.
//

import SwiftUI

struct PortfolioView: View {
    
    @EnvironmentObject private var vm: HomeViewModel
    
    @State private var selectedCoin: CoinModel? = nil
    @State private var amount: String = ""
    @State private var checkMark: Bool = false
    @State private var showAlert: Bool = false
    
    private var message = "Enter the quantity of the selected coin, or 0 to delete 🥳"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack (alignment: .leading, spacing: 0) {
                    /// Search Bar
                    SearchBarView(searchText: $vm.searchText)
                    
                    /// ScrollView with  coins
                    logoCoinList
                    
                    /// Description
                    coinInfo
                    
                    /// Save Button
                    saveButton
                }
            }
            .background(Color.theme.background.ignoresSafeArea())
            .navigationTitle("Edit Portfolio")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { DismissButton() }
                ToolbarItem(placement: .navigationBarTrailing) { getCheckMark }
            }
            .onChange(of: vm.searchText, perform: { newValue in
                if newValue == "" {
                    removeSelection()
                }
            })
            .onTapGesture {  hideKeyboard() }
            .alert("Try again", isPresented: $showAlert) {
                Button(role: .destructive) {
                    removeSelection()
                    hideKeyboard()
                } label: {
                    Text("Clear search")
                        .accessibilityIdentifier("alert_ButtonTryAgain_ID")
                }
            } message: {
                Text(message)
            }
        }
    }
}

//                    🔱
struct PortfolioView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
            .environmentObject(dev.homeVM)
    }
}

//MARK: - Components
extension PortfolioView {
    
    private var logoCoinList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack (spacing: 11) {
                ForEach(vm.searchText.isEmpty ? vm.portfolioCoins : vm.allCoins) { coin in
                    CoinLogoView(coin: coin)
                        .frame(width: 80)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.spring()) {
                                updateSelectionAmount(coin: coin)
                            }
                        }
                        .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(selectedCoin?.id == coin.id ? Color.theme.red : Color.clear,
                                    lineWidth: 1)
                        )
                }
            }
            .padding(.vertical, 4)
            .padding(.leading, 25)
        }
    }
    
    private var coinInfo: some View {
        VStack {
            HStack {
                Text("Current price of \(selectedCoin?.symbol.uppercased() ?? ""):")
                Spacer()
                Text(selectedCoin?.currentPrice.asCurrencyWith6() ?? "")
            }
            Divider()
            HStack {
                Text(amount == "" ? "Quantity of coin" : "Clear amount")
                    .onTapGesture {
                        amount = "0"
                    }
                Spacer()
                TextField("Ex: 1.73", text: $amount)
                    .accessibilityIdentifier("amount_TextField_ID")
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.numbersAndPunctuation)
                    .autocorrectionDisabled(true)
                    .textContentType(.init(rawValue: ""))
            }
            Divider()
            HStack {
                Text("Current value")
                Spacer()
                Text(getCurrentValue().asCurrencyWith6())
            }
        }
        .padding()
        .padding(.top)
        .font(.headline)
        .foregroundColor(Color.theme.accent)
        .opacity(selectedCoin == nil ? 0.0 : 1.0)
    }
    
    private var saveButton: some View {
        VStack {
            Button {
                guard
                    let coin = selectedCoin,
                    let amount = Double(amount) else {
                    showAlert.toggle()
                    return
                }
                /// Save in Portfolio
                vm.updatePortfolio(coin: coin, amount: amount)
                
                /// Dismiss keyboard
                hideKeyboard()
                
                /// Show checkmark -> item was add
                withAnimation(.spring()) { checkMark = true }
                
                /// Remove checkmark after 3 second
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation(.spring()) {
                        checkMark = false
                    }
                }
                
                /// Clean
                removeSelection()
            } label: {
                Text("Save Currency")
                    .accessibilityIdentifier("portfolioSave_Button_ID")
                    .foregroundColor(Color.theme.accent)
                    .font(.title2 .bold())
            }.buttonMode()
        }
        .padding(.top)
        .opacity(selectedCoin == nil ? 0.0 : 1.0)
    }
    
    private var getCheckMark: some View {
        VStack {
            Image(systemName: "checkmark.shield")
                .font(.headline)
                .foregroundColor(Color.theme.green)
        }
        .opacity(checkMark ? 1.0 : 0.0)
        .padding(.top, 18)
        .padding(.trailing, 15)
    }
}

//MARK: - Private Methods
extension PortfolioView {
    
    private func getCurrentValue() -> Double {
        if let item = Double(amount) {
            return item * (selectedCoin?.currentPrice ?? 0)
        }
        return 0
    }
    
    private func removeSelection() {
        vm.searchText = ""
        selectedCoin = nil
        amount = ""
    }
    
    private func updateSelectionAmount(coin: CoinModel) {
        selectedCoin = coin
        /// This method get current amount from portfolio if exist
        guard
            let portfolioCoin = vm.portfolioCoins.first(where: { $0.id == coin.id }),
            let currentAmount = portfolioCoin.currentHoldings else {
            amount = ""
            return
        }
        amount = "\(currentAmount)"
    }
    
}
