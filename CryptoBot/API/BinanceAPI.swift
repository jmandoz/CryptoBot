//
//  BinanceAPI.swift
//  CryptoBot
//
//  Created by Jason Mandozzi on 1/24/21.
//

import Foundation
import Combine

enum BinanceAPI {
    private static let base = URL(string: "https://api.binance.com/api/v3/ticker/24hr?symbol=BTCUSDT")!
    private static let path = "/api/v3/ticker/24hr?symbol=BTCUSDT"
    private static let agent = RequestAgent()
    
    static func fetch24hrBTCData() -> AnyPublisher<BtcDTO, Error> {
        let request = URLComponents(url: base, resolvingAgainstBaseURL: true)?
            .request
        return agent.run(request!)
    }
}

private extension URLComponents {
    var request: URLRequest? {
        url.map { URLRequest.init(url: $0) }
    }
}

struct BtcDTO: Codable {
    let id: Int?
    let symbol: String?
    let priceChange: String?
    let priceChangePercent: String?
    let weightedAvgPrice: String?
    let prevClosePrice: String?
    let lastPrice: String?
    let lastQty: String?
    let bidPrice: String?
    let askPrice: String?
    let openPrice: String?
    let highPrice: String?
    let lowPrice: String?
    let volume: String?
    let quoteVolume: String?
    let openTime: Int?
    let closeTime: Int?
}

