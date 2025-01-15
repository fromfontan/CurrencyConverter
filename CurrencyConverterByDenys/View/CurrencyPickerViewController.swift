//
//  CurrencyPickerViewController.swift
//  CurrencyConverterByDenys
//
//  Created by Denis Fromfontan on 11.01.2025.
//

import UIKit
import SnapKit

class CurrencyPickerViewController: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = Text.Placeholder.searchCurrency
        return searchBar
    }()
    
    private let viewModel: CurrencyPickerViewModel
    var onCurrencySelected: ((CurrencyModel) -> Void)?
    
    init(viewModel: CurrencyPickerViewModel = CurrencyPickerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white

        addSubviews()
        makeConstraints()
        bindViewModel()
        super.viewDidLoad()
    }
    
    private func bindViewModel() {
        viewModel.onDataUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.showError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(message: errorMessage)
            }
        }
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
        view.addSubview(searchBar)
    }
    
    private func makeConstraints() {
        searchBar.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.left.right.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.left.right.bottom.equalToSuperview()
        }
    }
    
}

// MARK: - UITableView Delegate & DataSource
extension CurrencyPickerViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let currency = viewModel.currency(at: indexPath.row)
        cell.textLabel?.text = currency.code
        cell.detailTextLabel?.text = currency.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = viewModel.currency(at: indexPath.row)
        onCurrencySelected?(currency)
        dismiss(animated: true)
    }
}

// MARK: - UISearchBar Delegate
extension CurrencyPickerViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCurrencies(by: searchText)
    }
}
