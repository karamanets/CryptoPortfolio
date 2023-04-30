//
//  SettingsView.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 30.04.2023.
//

import SwiftUI

struct SettingsView: View {
    
    @Environment(\.dismiss) var goBack
    
    let GitHubDeveloperURL: URL = URL(string: "https://github.com/karamanets")!
    let TwitterURL: URL = URL(string: "https://twitter.com/AlexKaramanets")!
    let CoinGeckoURL: URL = URL(string: "https://www.coingecko.com")!
    let Source: URL = URL(string: "https://www.youtube.com/@SwiftfulThinking")!
    
    var body: some View {
        NavigationStack {
            List {
                developer
                coinGecko
                source
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        goBack()
                    } label: {
                        Image(systemName: "arrowshape.turn.up.backward.2")
                            .font(.headline)
                            .foregroundColor(Color.theme.red)
                    }

                }
            }
        }
    }
}

//                 🔱
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
            SettingsView()
    }
}

//MARK: Components
extension SettingsView {
    
    private var developer: some View {
        Section {
            HStack {
                Image("Logo")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(color: Color.theme.red, radius: 6, x: 0, y: 0)
                VStack (alignment: .leading, spacing: 10) {
                    Text("Crypto Portfolio App 📱")
                        .font(.callout .bold())
                        .foregroundColor(Color.theme.accent)
                    
                    HStack {
                        Link("Developer GetHub ", destination: GitHubDeveloperURL)
                            .font(.callout)
                            .foregroundColor(Color.theme.accent)
                        Image(systemName: "network")
                            .foregroundColor(Color.theme.red)
                    }
                    
                    HStack {
                        Link("Developer Twitter ", destination: TwitterURL)
                            .font(.callout)
                            .foregroundColor(Color.theme.accent)
                        Image(systemName: "network")
                            .foregroundColor(Color.theme.red)
                    }
                }
            }
        } header: {
            Text("About Developer")
                .foregroundColor(Color.theme.secondaryText)
        }
    }
    
    private var coinGecko: some View {
        Section {
            HStack {
                
                Link("CoinGecko", destination: CoinGeckoURL)
                
                Image(systemName: "network")
                    .foregroundColor(Color.theme.red)
            }
        } header: {
            Text("CoinGecko API")
                .foregroundColor(Color.theme.secondaryText)
        }
    }
    
    private var source: some View {
        Section {
            VStack (alignment: .leading, spacing: 10){
                Text("Swiftful Thinking 🥳")
                    .font(.callout .bold())
                    .foregroundColor(Color.theme.accent)
                
                HStack {
                    Link("Source", destination: Source)
                        .font(.callout)
                        .foregroundColor(Color.theme.accent)
                    
                    Image(systemName: "network")
                        .foregroundColor(Color.theme.red)
                    
                }
            }
        } header: {
            Text("Course")
                .foregroundColor(Color.theme.secondaryText)
        }
    }
}
