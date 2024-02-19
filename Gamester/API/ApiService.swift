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
        
        if case .gamesInGenre(let genreID) = endpoint {
            var urlComponents = URLComponents(string: endpoint.urlString)!
            urlComponents.queryItems = [
                URLQueryItem(name: "key", value: Constants.API_KEY),
                URLQueryItem(name: "genres", value: "\(genreID)")
            ]
            
            guard let url = urlComponents.url else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data received", code: 1, userInfo: nil)))
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        } else {
            var urlComponents = URLComponents(string: endpoint.urlString)!
            urlComponents.queryItems = [
                URLQueryItem(name: "key", value: Constants.API_KEY),
            ]
            
            guard let url = urlComponents.url else {
                completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
                return
            }
            
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No data received", code: 1, userInfo: nil)))
                    return
                }
                
                do {
                    let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedResponse))
                } catch {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
}
