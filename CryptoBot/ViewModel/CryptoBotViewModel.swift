//
//  CryptoBotViewModel.swift
//  CryptoBot
//
//  Created by Jason Mandozzi on 1/24/21.
//

import Foundation
import Combine

final class CryptoBotViewModel: ObservableObject {
    @Published private(set) var state = State.idle
    
    private var bag = Set<AnyCancellable>()
    
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        Publishers.system(
            initial: state,
            reduce: Self.reduce,
            scheduler: RunLoop.main,
            feedbacks: [
                Self.whenLoading(),
                Self.userInput(input: input.eraseToAnyPublisher())
            ]
        )
        .assign(to: \.state, on: self)
        .store(in: &bag)
    }
    
    deinit {
        bag.removeAll()
    }
    
    static func userInput(input: AnyPublisher<Event, Never>) -> Feedback<State, Event> {
            Feedback { _ in input }
        }
}

extension CryptoBotViewModel {
    enum State {
        case idle
        case loading
        case loaded(BtcDataItem)
        case error(Error)
    }
    
    enum Event {
        case onAppear
        case onDataLoaded(BtcDataItem)
        case onFailedToLoadData(Error)
    }
}

extension CryptoBotViewModel {
    static func reduce(_ state: State, _ event: Event) -> State {
        switch state {
        case .idle:
            // idle
            switch event {
            case .onAppear:
                // View Appeard
                return .loading
            default:
                return state
            }
        case .loading:
            // loading
            switch event {
            case .onDataLoaded(let btcData):
                // Data Loaded Succesfully
                return .loaded(btcData)
            case .onFailedToLoadData(let error):
                // Error Loading Data
                return .error(error)
            default:
                return state
            }
        case .loaded:
            // Loaded
            return state
        case .error:
            // Error
            return state
        }
    }
    
    static func whenLoading() -> Feedback<State, Event> {
        Feedback { (state: State) -> AnyPublisher<Event, Never> in
            guard case .loading = state else { return Empty().eraseToAnyPublisher() }
            
            return BinanceAPI.fetch24hrBTCData()
                .map { BtcDataItem(btcData: $0) }
                .map(Event.onDataLoaded)
                .catch { Just(Event.onFailedToLoadData($0)) }
                .eraseToAnyPublisher()
        }
    }
    
    func send(event: Event) {
           input.send(event)
       }
}

// MARK: Inner Types
extension CryptoBotViewModel {
    struct BtcDataItem: Identifiable {
        var id: Int?
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
        
        init(btcData: BtcDTO) {
            id = btcData.id
            symbol = btcData.symbol
            priceChange = btcData.priceChange
            priceChangePercent = btcData.priceChangePercent
            weightedAvgPrice = btcData.weightedAvgPrice
            prevClosePrice = btcData.prevClosePrice
            lastPrice = btcData.lastPrice
            lastQty = btcData.lastQty
            bidPrice = btcData.bidPrice
            askPrice = btcData.askPrice
            openPrice = btcData.openPrice
            highPrice = btcData.highPrice
            lowPrice = btcData.lowPrice
            volume = btcData.volume
            quoteVolume = btcData.quoteVolume
            openTime = btcData.openTime
            closeTime = btcData.closeTime
        }
    }
}
