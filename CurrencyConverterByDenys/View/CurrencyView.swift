//
//  CurrencyRowView.swift
//  CurrencyConverterByDenys
//
//  Created by Denis Fromfontan on 09.01.2025.
//

import UIKit
import SnapKit

class CurrencyView: UIView {
    private var title: String
    private var amount: Double
    private var currency: String
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .lightGray.withAlphaComponent(0.7)
        return label
    }()
    
    private lazy var currencyImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        imageView.layer.cornerRadius = 22
        imageView.clipsToBounds = true
        imageView.backgroundColor = .green
        return imageView
    }()
    
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.text = currency
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .blue
        return label
    }()
    
    private lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 4
        textField.backgroundColor = .lightGray.withAlphaComponent(0.3)
        textField.text = "\(amount)"
        textField.setPadding(left: 10, right: 10)
        textField.textAlignment = .right
        return textField
    }()
    
    init(title: String, amount: Double, currency: String) {
        self.title = title
        self.amount = amount
        self.currency = currency
        
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addSubview(titleLabel)
        addSubview(currencyImageView)
        addSubview(currencyLabel)
        addSubview(amountTextField)
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.top.equalTo(20)
        }
        
        currencyImageView.snp.makeConstraints {
            $0.left.equalTo(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(14)
            $0.width.height.equalTo(44)
        }
        
        currencyLabel.snp.makeConstraints {
            $0.left.equalTo(currencyImageView.snp.right).offset(14)
            $0.centerY.equalTo(currencyImageView)
            $0.width.equalTo(40)
        }
        
        amountTextField.snp.makeConstraints {
            $0.height.equalTo(45)
            $0.left.equalTo(currencyLabel.snp.right).offset(16)
            $0.right.equalToSuperview().offset(-20)
            $0.centerY.equalTo(currencyLabel)
        }
    }
}
