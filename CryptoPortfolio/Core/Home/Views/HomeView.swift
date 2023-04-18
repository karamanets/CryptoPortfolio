//
//  HomeView.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 17.04.2023.
//

import SwiftUI

struct HomeView: View {
    
    @State private var showPortfolio: Bool = false
    
    var body: some View {
        
        ZStack {
            /// background layer
            Color.theme.background
            
            /// content layer
            VStack {
                homeHeader
                Spacer(minLength: 0)
            }
        }
    }
}

//                 🔱
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HomeView()
        }
    }
}

//MARK: HomeView header
extension HomeView {
    
    private var homeHeader: some View {
        HStack {
            CircleButtonView(iconName: showPortfolio ? "plus" : "info")
                .background(CircleButtonAnimate(animate: $showPortfolio))
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
}
