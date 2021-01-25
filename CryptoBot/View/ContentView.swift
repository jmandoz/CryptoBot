//
//  ContentView.swift
//  CryptoBot
//
//  Created by Jason Mandozzi on 1/23/21.
//

import SwiftUI
import SwiftUICharts

struct ContentView: View {
    let data: [Double] = [365.2, 364.2, 365.1, 366.4, 361.4, 358.6, 356.8, 357.8, 358.9, 360.2, 364.2, 345.1, 356.4, 358.6, 356.8, 357.8, 358.9, 360.2, 360.4, 345.6, 346.8, 367.8, 367.8, 364.2, 365.1, 366.4]
    
    let chartStyle = ChartStyle(backgroundColor: .white, accentColor: .white, gradientColor: GradientColors.prplNeon, textColor: .black, legendTextColor: .black, dropShadowColor: .black)
    
    var body: some View {
        NavigationView {
            VStack {
                LineView(data: data, title: "BTC", legend: "USD", style: chartStyle, valueSpecifier: "%.2f")
                    .padding()
                Spacer()
                CryptoBotView(viewModel: CryptoBotViewModel())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
