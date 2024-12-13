//
//  ErrorResponse.swift
//  Gamester
//
//  Created by Nino on 20.02.2024..
//

import Foundation

// Define a custom error enum for better error handling
enum APIError: Error {
    case invalidURL
    case invalidResponse
    case httpError(Int)
    case unauthorized(String)
    case noDataReceived
}

struct ErrorResponse: Decodable {
    let error: String
}
