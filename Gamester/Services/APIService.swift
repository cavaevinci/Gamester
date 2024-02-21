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
    
    func fetchData<T>(from endpoint: APIEndpoint, search: String, page: Int, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        guard var urlComponents = URLComponents(string: endpoint.urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        if case .gamesInGenre(let genreID) = endpoint {
            urlComponents.queryItems = [
                URLQueryItem(name: "key", value: Constants.API_KEY),
                URLQueryItem(name: "genres", value: "\(genreID)"),
                URLQueryItem(name: "search", value: search),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "pageSize", value: "100"),
                URLQueryItem(name: "search_exact", value: "1")
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
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            guard (200..<300).contains(httpResponse.statusCode) else {
                if httpResponse.statusCode == 401 {
                    if let data = data {
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                            completion(.failure(NSError(domain: errorResponse.error, code: 401, userInfo: nil)))
                        } catch {
                            completion(.failure(error))
                        }
                    } else {
                        completion(.failure(NSError(domain: "Unauthorized", code: 401, userInfo: nil)))
                    }
                } else {
                    completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)))
                }
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
    
    func fetchData<T>(from endpoint: APIEndpoint, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
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
               if let error = error {
                   completion(.failure(error))
                   return
               }
               
               guard let httpResponse = response as? HTTPURLResponse else {
                   completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                   return
               }
               
               guard (200..<300).contains(httpResponse.statusCode) else {
                   if httpResponse.statusCode == 401 {
                       if let data = data {
                           do {
                               let errorResponse = try JSONDecoder().decode(ErrorResponse.self, from: data)
                               completion(.failure(NSError(domain: errorResponse.error, code: 401, userInfo: nil)))
                           } catch {
                               completion(.failure(error))
                           }
                       } else {
                           completion(.failure(NSError(domain: "Unauthorized", code: 401, userInfo: nil)))
                       }
                   } else {
                       completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)))
                   }
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
