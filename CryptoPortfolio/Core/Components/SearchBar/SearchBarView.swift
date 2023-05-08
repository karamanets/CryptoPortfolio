//
//  SearchBarView.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 21.04.2023.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent)
            
            TextField("Search by name or symbol ...", text: $searchText)
                .accessibilityIdentifier("home_TextField_ID")
                .keyboardType(.asciiCapable)
                .autocorrectionDisabled(true)
                .textContentType(.init(rawValue: ""))
                .foregroundColor(Color.theme.accent)
                .overlay (
                    Image(systemName: "xmark")
                        .foregroundColor(searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent)
                        .padding(.all, 12)
                        .background(Color.theme.background) /// extra press aria
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .offset(x: 5)
                        .onTapGesture {
                            hideKeyboard()
                            searchText = ""
                        }
                    ,alignment: .trailing
                )
        }
        .padding(.all, 14)
        .font(.headline)
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.2),
                        radius: 10)
        )
        .padding()
    }
}

//                  🔱
struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: .constant(""))
    }
}
