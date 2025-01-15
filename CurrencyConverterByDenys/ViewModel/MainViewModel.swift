//
//  MainViewModel.swift
//  CurrencyConverterByDenys
//
//  Created by Denis Fromfontan on 11.01.2025.
//
import Foundation

class MainViewModel {
    
    private let apiService: APIServiceProtocol
    private let defaultsService: DefaultsServiceProtocol
    private var fromCurrency: CurrencyModel?
    private var toCurrency: CurrencyModel?
    private var amount: Double?
    private var timer: Timer?
    var showExchangeResult:((String)->Void)?
    var showError:((String)->Void)?
    var startActivityIndicator:(()->Void)?
    var stopActivityIndicator:(()->Void)?

    init(apiService: APIServiceProtocol = APIService(), defaultsService: DefaultsServiceProtocol = DefaultsService()) {
        self.apiService = apiService
        self.defaultsService = defaultsService
        fetchDefaults()
        startTimer()
    }
    
    private func fetchDefaults() {
        self.fromCurrency = fetchFromCurreny()
        self.toCurrency = fetchToCurrency()
        self.amount = fetchAmount()
    }
    
    func fetchFromCurreny() -> CurrencyModel {
        if let fromCurrency = defaultsService.fetchFromCurrency() {
            return fromCurrency
        } else {
            return CurrencyModel(name: "United States Dollar", code: "USD", country: "United States", countryCode: "US")
        }
    }
    
    func fetchToCurrency() -> CurrencyModel {
        if let toCurrency = defaultsService.fetchToCurrency() {
            return toCurrency
        } else {
            return CurrencyModel(name: "Ukrainian Hryvnia", code: "UAH", country: "Ukraine", countryCode: "UA")
        }
    }
    
    func fetchAmount() -> Double {
        return defaultsService.fetchAmount() == 0 ? 100.00 : defaultsService.fetchAmount()!
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { _ in
            if let from = self.fromCurrency, let to = self.toCurrency, let amount = self.amount {
                self.convert(fromCurrency: from, toCurrency: to, amount: amount)
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func convert(fromCurrency: CurrencyModel, toCurrency: CurrencyModel, amount: Double) {
        self.startActivityIndicator?()
        saveData(fromCurrency: fromCurrency, toCurrency: toCurrency, amount: amount)
        apiService.getExchangeRate(fromCurrency: fromCurrency.code, toCurrency: toCurrency.code, amount: amount) { [weak self] result in
            self?.stopActivityIndicator?()
            self?.handleAPIResult(result)
        }
    }
    
    private func saveData(fromCurrency: CurrencyModel, toCurrency: CurrencyModel, amount: Double) {
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.amount = amount
        defaultsService.save(fromCurrency: fromCurrency)
        defaultsService.save(toCurrency: toCurrency)
        defaultsService.save(amount: amount)
    }
    
    private func handleAPIResult(_ result: Result<ExchangeResultModel, Error>) {
        switch result {
        case .success(let resultModel):
            self.showExchangeResult?(resultModel.amount)
        case .failure(let error):
            self.amount = nil
            if let apiError = error as? APIError {
                self.showError?(apiError.errorDescription)
            } else {
                self.showError?(error.localizedDescription)
            }
        }
    }
}
