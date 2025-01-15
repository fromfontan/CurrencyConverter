//
//  NetworkService.swift
//  CurrencyConverterByDenys
//
//  Created by Denis Fromfontan on 12.01.2025.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingFailed
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
    func request<T: Decodable>(url: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let jsonString = String(data: data ?? Data(), encoding: .utf8) {
                print("Response JSON: \(jsonString)")
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            if let apiError = try? JSONDecoder().decode(APIError.self, from: data) {
                completion(.failure(apiError))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                print("Decoding error: \(error)")
                completion(.failure(NetworkError.decodingFailed))
            }
        }

        task.resume()
    }
}
