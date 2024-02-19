//
//  Constants.swift
//  Gamester
//
//  Created by Nino on 14.02.2024..
//

import Foundation

struct Constants {
    static var API_KEY: String {
        guard let keysURL = Bundle.main.url(forResource: "KeysTemplate", withExtension: "plist"),
              let keysData = try? Data(contentsOf: keysURL),
              let keys = try? PropertyListSerialization.propertyList(from: keysData, options: [], format: nil) as? [String: Any],
              let apiKey = keys["API_KEY"] as? String
        else {
            fatalError("Failed to load API key from configuration file")
        }
        return apiKey
    }
}
