//
//  GenreTests.swift
//  GamesterTests
//
//  Created by Nino on 13.03.2024..
//

import XCTest
@testable import Gamester

final class GenreTests: XCTestCase {
    
    var sut: Genre!

    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func testGenreDecodingSuccess() throws {
        guard let path = Bundle(for: GenreTests.self).path(forResource: "MockGenreResponse", ofType: "json") else {
            XCTFail("MockGenreResponse.json file not found")
            return
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            XCTFail("Failed to read data from file")
            return
        }

        let decoder = JSONDecoder()
        do {
            sut = try decoder.decode(Genre.self, from: data)
            XCTAssertEqual(sut.id, 0)
            XCTAssertEqual(sut.name, "string")
            XCTAssertEqual(sut.slug, "string")
            XCTAssertEqual(sut.gamesCount, 0)
        } catch {
            XCTFail("Failed to decode JSON: \(error)")
        }
    }
    
    func testGenreDecodingFailure() {
        guard let path = Bundle(for: GenreTests.self).path(forResource: "ErrorMockGenreResponse", ofType: "json") else {
            XCTFail("ErrorMockGenreResponse.json file not found")
            return
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            XCTFail("Failed to read data from file")
            return
        }

        let decoder = JSONDecoder()
        do {
            _ = try decoder.decode(Genre.self, from: data)
            XCTFail("Expected decoding to fail, but it succeeded.")
        } catch {
            guard let decodingError = error as? DecodingError else {
                XCTFail("Unexpected error type: \(error)")
                return
            }
            switch decodingError {
            case .keyNotFound(let key, _):
                XCTAssertEqual(key.stringValue, "games_count", "Expected missing key 'games_count'")
            default:
                XCTFail("Unexpected decoding error: \(decodingError)")
            }
        }
 
    }

}
