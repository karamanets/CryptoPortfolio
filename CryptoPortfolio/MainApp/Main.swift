//
//  Main.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 02/05/2023.
//

import SwiftUI

struct Main: View {
    
    @StateObject private var vm: HomeViewModel
    @State private var showLaunchView: Bool = true
    
    init(vm: CoinDataServiceProtocol) {
        _vm = StateObject(wrappedValue: HomeViewModel(coinDataService: vm))
        
        /// Color for navigation title
        let navBarAppearance = UINavigationBar.appearance()
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        navBarAppearance.tintColor = UIColor(Color.theme.accent)
        /// Color for tableView background
        let tableView = UITableView.appearance()
        tableView.backgroundColor = UIColor.clear
    }
    
    var body: some View {
            ZStack {
                NavigationStack {
                    HomeView()
                }
                .environmentObject(vm)
                
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunch: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0) /// It mins it'll be the second ZStack for transition
            }
    }
}
