//
//  ApiService.swift
//  Gamester
//
//  Created by Nino on 16.02.2024..
//
import Foundation

class APIService {
    
    func fetchGameDetails(apiKey: String, gameID: Int, completion: @escaping (Result<Game, Error>) -> Void) {
        let urlString = "https://api.rawg.io/api/games/\(gameID)?key=\(Constants.API_KEY)"
        
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
            
            do {
                let gameResponse = try JSONDecoder().decode(Game.self, from: data)
                completion(.success(gameResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchGamesInGenre(apiKey: String, genreID: Int, completion: @escaping (Result<[Game], Error>) -> Void) {
        
        var urlComponents = URLComponents(string: "https://api.rawg.io/api/games")!
        urlComponents.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
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
                let gamesResponse = try JSONDecoder().decode(GamesResponse.self, from: data)
                completion(.success(gamesResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
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
            
            do {
                let genresResponse = try JSONDecoder().decode(GenresResponse.self, from: data)
                completion(.success(genresResponse.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
