//
//  ViewController.swift
//  CurrencyConverterByDenys
//
//  Created by Denis Fromfontan on 09.01.2025.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let gradientLayer = CAGradientLayer()
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Text.Label.title
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .darkGray
        return label
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .lightGray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var sourceCurrencyView: CurrencyView = {
        let view = CurrencyView()
        view.setTitle(Text.Label.source)
        view.delegate = self
        return view
    }()
    
    private lazy var targetCurrencyView: CurrencyView = {
        let view = CurrencyView()
        view.setTitle(Text.Label.target)
        view.delegate = self
        return view
    }()
    
    private lazy var borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 20
        stackView.clipsToBounds = true
        return stackView
    }()
    
    var viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        configureSubviews()
        addSubviews()
        makeConstraints()
        setDefaultValues()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = view.bounds
    }
    
    private func bindViewModel() {
        viewModel.showExchangeResult = { [weak self] result in
            DispatchQueue.main.async {
                self?.targetCurrencyView.setAmount(result)
            }
        }
        
        viewModel.showError = { [weak self] errorMessage in
            DispatchQueue.main.async {
                self?.showAlert(message: errorMessage)
                self?.targetCurrencyView.setAmount("0.00")
            }
        }
        
        viewModel.startActivityIndicator = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.startAnimating()
            }
        }
        
        viewModel.stopActivityIndicator = { [weak self] in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    private func configureSubviews() {
        setGradientBackground()
        targetCurrencyView.disableInput()
        view.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action:#selector(tapDidTouch)))
    }
    
    private func addSubviews() {
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        view.addSubview(activityIndicator)
        
        stackView.addArrangedSubview(sourceCurrencyView)
        stackView.addArrangedSubview(borderView)
        stackView.addArrangedSubview(targetCurrencyView)
    }
    
    private func makeConstraints() {
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        sourceCurrencyView.backgroundColor = .white
        
        sourceCurrencyView.snp.makeConstraints {
            $0.height.equalTo(120)
        }
        
        borderView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        targetCurrencyView.snp.makeConstraints {
            $0.height.equalTo(120)
        }
        
        stackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.left.right.equalToSuperview().inset(20).priority(.high)
            $0.width.lessThanOrEqualTo(388).priority(.required)
        }
        
    }
    
    private func setDefaultValues() {
        sourceCurrencyView.currency = viewModel.fetchFromCurreny()
        sourceCurrencyView.setAmount(String(format: "%.2f", viewModel.fetchAmount()))
        targetCurrencyView.currency = viewModel.fetchToCurrency()
        convert()
    }
    
    private func convert() {
        viewModel.convert(fromCurrency: self.sourceCurrencyView.currency, toCurrency: self.targetCurrencyView.currency, amount: self.sourceCurrencyView.getAmount())
    }
    
    private func setGradientBackground() {
        
        gradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    @objc func tapDidTouch() {
        view.endEditing(true)
    }
}

// MARK: - CurrencyViewProtocol
extension ViewController: CurrencyViewProtocol {
    
    func selectCurrencyPressed(sender: CurrencyView) {
        let vc = CurrencyPickerViewController()
        self.present(vc, animated: true)
        vc.onCurrencySelected = { [self] currency in
            sender.currency = currency
            convert()
        }
    }
    
    func didChangeAmount(to amount: Double?) {
        convert()
    }
}
