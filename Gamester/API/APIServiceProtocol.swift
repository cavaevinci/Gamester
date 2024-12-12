//
//  APIServiceProtocol.swift
//  Gamester
//
//  Created by Nino on 18.02.2024..
//

import Foundation

protocol APIServiceProtocol {
    func fetchData<T: Decodable>(from endpoint: APIEndpoint, search: String, page: Int, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void)
    func fetchData<T: Decodable>(from endpoint: APIEndpoint, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}
