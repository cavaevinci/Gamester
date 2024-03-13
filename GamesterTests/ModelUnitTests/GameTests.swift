//
//  GameTests.swift
//  GamesterTests
//
//  Created by Nino on 13.03.2024..
//

import XCTest
@testable import Gamester

final class GameTests: XCTestCase {
    
    var sut: Game!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testGameDecodingSuccess() throws {
        guard let path = Bundle(for: GameTests.self).path(forResource: "MockGameResponse", ofType: "json") else {
            XCTFail("MockGameResponse.json file not found")
            return
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            XCTFail("Failed to read data from file")
            return
        }

        let decoder = JSONDecoder()
        do {
            sut = try decoder.decode(Game.self, from: data)
            XCTAssertEqual(sut.id, 0)
            XCTAssertEqual(sut.name, "string")
            XCTAssertEqual(sut.released, "2024-03-13")
            XCTAssertEqual(sut.rating, 0)
        } catch {
            XCTFail("Failed to decode JSON: \(error)")
        }
    }

    func testGameDecodingFailure() throws {
        guard let path = Bundle(for: GameTests.self).path(forResource: "ErrorMockGameResponse", ofType: "json") else {
            XCTFail("ErrorMockGameResponse.json file not found")
            return
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            XCTFail("Failed to read data from file")
            return
        }

        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(Game.self, from: data)
            XCTFail("Expected decoding to fail, but it succeeded.")
        } catch {
            guard let decodingError = error as? DecodingError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            switch decodingError {
            case .keyNotFound(let key, _):
                XCTAssertEqual(key.stringValue, "name", "Expected missing key 'name'")
            default:
                XCTFail("Unexpected decoding error: \(decodingError)")
            }
        }
    }

}
