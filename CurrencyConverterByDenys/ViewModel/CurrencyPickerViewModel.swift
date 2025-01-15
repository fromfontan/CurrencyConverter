//
//  CurrencyPickerViewModel.swift
//  CurrencyConverterByDenys
//
//  Created by Denis Fromfontan on 15.01.2025.
//

class CurrencyPickerViewModel {
    
    // private let currencyService: CurrencyServiceProtocol
    private let apiService: APIServiceProtocol
    private var allCurrencies: [CurrencyModel] = []
    private var filteredCurrencies: [CurrencyModel] = []
    
    var onDataUpdated: (() -> Void)?
    var showError:((String)->Void)?

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
        loadCurrencies()
    }
    
    private func loadCurrencies() {
        apiService.fetchCurrencies { [weak self] result in
            self?.handleAPIResult(result)
        }
    }
    
    private func handleAPIResult(_ result: Result<[CurrencyModel], Error>) {
        switch result {
        case .success(let resultModel):
            allCurrencies = resultModel
            filteredCurrencies = allCurrencies
            onDataUpdated?()
        case .failure(let error):
            self.showError?(error.localizedDescription)
        }
    }
    
    func filterCurrencies(by searchText: String) {
        if searchText.isEmpty {
            filteredCurrencies = allCurrencies
        } else {
            filteredCurrencies = allCurrencies.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.code.lowercased().contains(searchText.lowercased()) ||
                $0.country.lowercased().contains(searchText.lowercased())
            }
        }
        onDataUpdated?()
    }
    
    func numberOfRows() -> Int {
        return filteredCurrencies.count
    }
    
    func currency(at index: Int) -> CurrencyModel {
        return filteredCurrencies[index]
    }
}
