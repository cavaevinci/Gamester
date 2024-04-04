import Foundation

class MockAPIService: APIServiceProtocol {
    
    func fetchData<T>(from endpoint: APIEndpoint, search: String, page: Int, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        // Implement your mock data here
        guard let data = loadJSONData(from: "mockData.json") else {
            completion(.failure(NSError(domain: "Failed to load mock data", code: 0, userInfo: nil)))
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetchData<T>(from endpoint: APIEndpoint, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        // Implement your mock data here
        guard let data = loadJSONData(from: "mockData.json") else {
            completion(.failure(NSError(domain: "Failed to load mock data", code: 0, userInfo: nil)))
            return
        }
        
        do {
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            completion(.success(decodedData))
        } catch {
            completion(.failure(error))
        }
    }
    
    private func loadJSONData(from file: String) -> Data? {
        guard let path = Bundle.main.path(forResource: file, ofType: "json") else {
            return nil
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            return data
        } catch {
            return nil
        }
    }
}