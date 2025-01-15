//
//  APIService.swift
//  CurrencyConverterByDenys
//
//  Created by Denis Fromfontan on 12.01.2025.
//

import Foundation

protocol APIServiceProtocol {
    func getExchangeRate(fromCurrency:String, toCurrency:String, amount:Double, completion: @escaping (Result<ExchangeResultModel, Error>) -> Void)
    func fetchCurrencies(completion: @escaping (Result<[CurrencyModel],Error>) -> Void)
}

final class APIService: APIServiceProtocol {
    
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func fetchCurrencies(completion: @escaping (Result<[CurrencyModel], any Error>) -> Void) {
        let url = "https://gist.githubusercontent.com/fromfontan/75af8388d833293c1e78cd658c4cdd5c/raw/51e58aa473b6a4893b0e58eafe5441d18525b51c/currencies.json"
        networkService.request(url: url, completion: completion)
    }

    func getExchangeRate(fromCurrency:String, toCurrency:String, amount:Double, completion: @escaping (Result<ExchangeResultModel, Error>) -> Void) {
        let url = "http://api.evp.lt/currency/commercial/exchange/\(amount)-\(fromCurrency)/\(toCurrency)/latest"
        networkService.request(url: url, completion: completion)
    }
}
