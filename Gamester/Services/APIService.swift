


//
//  ApiService.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//
import Foundation

class APIService: APIServiceProtocol {
    
    private let session: URLSession
    private let apiKey: String
    
    // Dependency Injection for session and API key
    init(session: URLSession = URLSession.shared, apiKey: String = ProcessInfo.processInfo.environment["API_KEY"] ?? "") {
        self.session = session
        self.apiKey = apiKey
    }
    
    func fetchData<T>(from endpoint: APIEndpoint, search: String, page: Int, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        performRequest(endpoint: endpoint, search: search, page: page, responseType: responseType, completion: completion)
    }
    
    func fetchData<T>(from endpoint: APIEndpoint, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        performRequest(endpoint: endpoint, search: "", page: 1, responseType: responseType, completion: completion)
    }
    
    // Generic function to perform the API request
    private func performRequest<T>(endpoint: APIEndpoint, search: String, page: Int, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        
        guard let url = buildURL(for: endpoint, search: search, page: page) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            self.handleResponse(data: data, response: response, responseType: responseType, completion: completion)
        }.resume()
    }
    
    // Construct URL with query parameters
    private func buildURL(for endpoint: APIEndpoint, search: String, page: Int) -> URL? {
        guard var urlComponents = URLComponents(string: endpoint.urlString) else { return nil }
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "key", value: apiKey)
        ]
        
        switch endpoint {
        case .gamesInGenreForPlatform(let genresIDs, let platformsIDs):
            queryItems.append(URLQueryItem(name: "genres", value: genresIDs))
            queryItems.append(URLQueryItem(name: "platforms", value: platformsIDs))
        default:
            break
        }
        
        if !search.isEmpty {
            queryItems.append(URLQueryItem(name: "search", value: search))
        }
        
        queryItems.append(URLQueryItem(name: "page", value: "\(page)"))
        queryItems.append(URLQueryItem(name: "pageSize", value: "100"))
        queryItems.append(URLQueryItem(name: "search_exact", value: "1"))
        
        urlComponents.queryItems = queryItems
        return urlComponents.url
    }
    
    // Handle the HTTP response, including error handling and decoding
    private func handleResponse<T>(data: Data?, response: URLResponse?, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        guard let httpResponse = response as? HTTPURLResponse else {
            completion(.failure(APIError.invalidResponse))
            return
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            handleHTTPError(data: data, statusCode: httpResponse.statusCode, completion: completion)
            return
        }
        
        guard let data = data else {
            completion(.failure(APIError.noDataReceived))
            return
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedResponse))
        } catch {
            completion(.failure(error))
        }
    }
    
    // Handle specific HTTP errors
    private func handleHTTPError<T>(data: Data?, statusCode: Int, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        if statusCode == 401 {
            if let data = data {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                    completion(.failure(APIError.unauthorized(errorResponse.error)))
                } catch {
                    completion(.failure(error))
                }
            } else {
                completion(.failure(APIError.unauthorized("Unauthorized access")))
            }
        } else {
            completion(.failure(APIError.httpError(statusCode)))
        }
    }
}

