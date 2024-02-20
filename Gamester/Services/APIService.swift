//
//  ApiService.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//
import Foundation

class APIService: APIServiceProtocol {
    
    private let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T: Decodable>(from endpoint: APIEndpoint, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard var urlComponents = URLComponents(string: endpoint.urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        if case .gamesInGenre(let genreID) = endpoint {
            urlComponents.queryItems = [
                URLQueryItem(name: "key", value: Constants.API_KEY),
                URLQueryItem(name: "genres", value: "\(genreID)")
            ]
        } else {
            urlComponents.queryItems = [
                URLQueryItem(name: "key", value: Constants.API_KEY)
            ]
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            // Check for network errors
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Check for HTTP response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            // Check for successful response
            guard (200..<300).contains(httpResponse.statusCode) else {
                if httpResponse.statusCode == 401 {
                    // Attempt to decode error response
                    if let data = data {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            completion(.failure(NSError(domain: errorResponse.error, code: 401, userInfo: nil)))
                        } catch {
                            // Failed to decode error response, return generic error
                            completion(.failure(error))
                        }
                    } else {
                        // No error response data, return generic error
                        completion(.failure(NSError(domain: "Unauthorized", code: 401, userInfo: nil)))
                    }
                } else {
                    // Non-401 error, return with appropriate status code
                    completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)))
                }
                return
            }
            
            // Check for data
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 1, userInfo: nil)))
                return
            }
            
            // Decode successful response
            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                // Failed to decode response data, return decoding error
                completion(.failure(error))
            }
        }.resume()
    }

}
