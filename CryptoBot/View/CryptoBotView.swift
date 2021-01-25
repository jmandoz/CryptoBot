//
//  CryptoBotView.swift
//  CryptoBot
//
//  Created by Jason Mandozzi on 1/24/21.
//

import Foundation
import SwiftUI

struct CryptoBotView: View {
    
    @ObservedObject var viewModel: CryptoBotViewModel
    
    var body: some View {
        content
            .navigationBarTitle("Trading Bot")
            .onAppear { self.viewModel.send(event: .onAppear) }
    }
    
    private var content: some View {
        switch viewModel.state {
        case .idle:
            return Color.clear.eraseToAnyView()
        case .loading:
            return Spinner(isAnimating: true, style: .large).eraseToAnyView()
        case .error(let error):
            debugPrint(error)
            return Text(error.localizedDescription.debugDescription).eraseToAnyView()
        case .loaded(let data):
            return list(of: data).eraseToAnyView()
        }
    }
    
    private func list(of data: CryptoBotViewModel.BtcDataItem) -> some View {
        let openPriceFormatted = Double(data.openPrice!)!
        let closePriceFormatted = Double(data.lastPrice!)!
        let highPriceormatted = Double(data.highPrice!)!
        let lastQuantityFormatted = Double(data.lastQty!)!
        
        return VStack {
            HStack {
                Text(data.symbol!)
                    .bold()
                    .font(.headline)
                Spacer()
                Text(String(format: "%.2f", closePriceFormatted))
            }
            HStack {
                Text("Open Price: ")
                    .bold()
                    .font(.headline)
                Spacer()
                Text(String(format: "%.2f", openPriceFormatted))
            }
            HStack {
                Text("High Price: ")
                    .bold()
                    .font(.headline)
                Spacer()
                Text(String(format: "%.2f", highPriceormatted))
            }
            HStack {
                Text("Last Qty: ")
                    .bold()
                    .font(.headline)
                Spacer()
                Text(String(lastQuantityFormatted))
            }
        }.padding(12)
    }
}

extension View {
    func eraseToAnyView() -> AnyView { AnyView(self) }
}

