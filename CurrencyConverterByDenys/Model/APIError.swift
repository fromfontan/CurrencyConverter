//
//  APIError.swift
//  CurrencyConverterByDenys
//
//  Created by Denis Fromfontan on 12.01.2025.
//

struct APIError: Decodable, Error {
    let error: String
    let errorDescription: String

    enum CodingKeys: String, CodingKey {
        case error
        case errorDescription = "error_description"
    }
}
