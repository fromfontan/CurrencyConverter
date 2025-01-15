//
//  UIImageExtension.swift
//  CurrencyConverterByDenys
//
//  Created by Denis Fromfontan on 13.01.2025.
//

import UIKit

extension UIImageView {
    public func setFlagImage(by code: String) {
        if code == "eu" {
            self.image = UIImage(named: "EU_flag")
            return
        }
        
        guard let url = URL(string: "https://flagsapi.com/\(code)/flat/64.png") else {
            self.image = nil
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            
            if error != nil {
                DispatchQueue.main.async { self?.image = nil }
                return
            }
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                DispatchQueue.main.async { self?.image = nil }
                return
            }
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async { self?.image = nil }
                return
            }
            DispatchQueue.main.async {
                self?.image = image
            }
            
        }.resume()
    }
    
}
