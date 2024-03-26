//
//  ApiService.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//
import Foundation
import SwiftyBeaver

class APIService: APIServiceProtocol {
    
    private let session: URLSession
    
    let log = SwiftyBeaver.self
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func fetchData<T>(from endpoint: APIEndpoint, search: String, page: Int, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        guard var urlComponents = URLComponents(string: endpoint.urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            log.error("Invalid URL")
            return
        }
        
        if case .gamesInGenre(let genresIDs) = endpoint {
            urlComponents.queryItems = [
                URLQueryItem(name: "key", value: ProcessInfo.processInfo.environment["API_KEY"]),
                URLQueryItem(name: "genres", value: "\(genresIDs)"),
                URLQueryItem(name: "search", value: search),
                URLQueryItem(name: "page", value: "\(page)"),
                URLQueryItem(name: "pageSize", value: "100"),
                URLQueryItem(name: "search_exact", value: "1")
            ]
        } else {
            urlComponents.queryItems = [
                URLQueryItem(name: "key", value: ProcessInfo.processInfo.environment["API_KEY"])
            ]
        }
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            log.error("Invalid URL")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            self.log.debug("\(type(of: self)): URL called - \(url.absoluteString))")
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
                            self.log.error(error)
                            completion(.failure(error))
                        }
                    } else {
                        self.log.error(error as Any)
                        completion(.failure(NSError(domain: "Unauthorized", code: 401, userInfo: nil)))
                    }
                } else {
                    self.log.error(error as Any)
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
                self.log.debug("\(type(of: self)): Response - \(decodedResponse))")
                completion(.success(decodedResponse))
            } catch {
                self.log.error(error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchData<T>(from endpoint: APIEndpoint, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        guard var urlComponents = URLComponents(string: endpoint.urlString) else {
               completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
               log.error("Invalid URL")
               return
           }
           
           if case .gamesInGenre(let genreID) = endpoint {
               urlComponents.queryItems = [
                   URLQueryItem(name: "key", value: ProcessInfo.processInfo.environment["API_KEY"]),
                   URLQueryItem(name: "genres", value: "\(genreID)")
               ]
           } else {
               urlComponents.queryItems = [
                   URLQueryItem(name: "key", value: ProcessInfo.processInfo.environment["API_KEY"])
               ]
           }
           
           guard let url = urlComponents.url else {
               completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
               log.error("Invalid URL")
               return
           }
           
           URLSession.shared.dataTask(with: url) { (data, response, error) in
               if let error = error {
                   completion(.failure(error))
                   return
               }
               self.log.debug("\(type(of: self)): URL called - \(url.absoluteString))")
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
                               self.log.error(error)
                               completion(.failure(error))
                           }
                       } else {
                           self.log.error(error as Any)
                           completion(.failure(NSError(domain: "Unauthorized", code: 401, userInfo: nil)))
                       }
                   } else {
                       self.log.error(error as Any)
                       completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)))
                   }
                   return
               }
               
               guard let data = data else {
                   self.log.error(error as Any)
                   completion(.failure(NSError(domain: "No data received", code: 1, userInfo: nil)))
                   return
               }
               
               do {
                   let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                   self.log.debug("\(type(of: self)): Response - \(decodedResponse))")
                   completion(.success(decodedResponse))
               } catch {
                   completion(.failure(error))
               }
           }.resume()
    }

}
