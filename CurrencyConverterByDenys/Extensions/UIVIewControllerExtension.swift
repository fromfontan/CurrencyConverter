//
//  UIVIewControllerExtension.swift
//  CurrencyConverterByDenys
//
//  Created by Denis Fromfontan on 15.01.2025.
//

import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: Text.Alert.errorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Text.Alert.buttonTitleOK, style: .default))
        self.present(alert, animated: true)
    }
}
