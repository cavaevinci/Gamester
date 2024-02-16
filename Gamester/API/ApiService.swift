//
//  ApiService.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//
import Foundation

class APIService {
    func fetchGenres(apiKey: String, completion: @escaping (Result<[Genre], Error>) -> Void) {
        let urlString = "https://api.rawg.io/api/genres?key=\(Constants.API_KEY)"
        
        guard let url = URL(string: urlString) else {
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
            
            // Print raw JSON data
                       if let jsonString = String(data: data, encoding: .utf8) {
                           print("Raw JSON Response:", jsonString)
                       }
                       
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let genresResponse = try decoder.decode(GenresResponse.self, from: data)
                completion(.success(genresResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
