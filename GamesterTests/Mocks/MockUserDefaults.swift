//
//  MockUserDefaults.swift
//  Gamester
//
//  Created by Ivan Evačić on 12.12.2024..
//
import Foundation

class MockUserDefaults: UserDefaults {
    private var storage: [String: Any] = [:]
    var simulateEncodingError = false
    var simulateInvalidData = false
    
    override func set(_ value: Any?, forKey defaultName: String) {
        if simulateEncodingError {
            return // Simulate encoding error by doing nothing
        }
        storage[defaultName] = value
    }
    
    override func data(forKey defaultName: String) -> Data? {
        if simulateInvalidData {
            return Data("invalid data".utf8) // Simulate corrupted data
        }
        return storage[defaultName] as? Data
    }
    
    override func removeObject(forKey defaultName: String) {
        storage[defaultName] = nil
    }
}
