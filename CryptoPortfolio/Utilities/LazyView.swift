//
//  LazyView.swift
//  CryptoPortfolio
//
//  Created by Alex Karamanets on 27.04.2023.
//

import SwiftUI

//MARK: LazyView allowed, don't download all views in the list instead -> download when clicked

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
