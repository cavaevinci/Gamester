//
//  LocalStorageServiceTests.swift
//  Gamester
//
//  Created by Ivan Evačić on 12.12.2024..
//

import XCTest
@testable import Gamester

class LocalStorageServiceTests: XCTestCase {
    
    var localStorageService: LocalStorageService!
    var mockUserDefaults: MockUserDefaults!
    
    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        localStorageService = LocalStorageService(userDefaults: mockUserDefaults)
    }
    
    override func tearDown() {
        localStorageService = nil
        mockUserDefaults = nil
        super.tearDown()
    }
    
    // Test: Saving and retrieving genres successfully
    func testSaveAndRetrieveGenres_Success() {
        // Arrange
        let genres = [
            Genre(id: 1, name: "Action", slug: "action", gamesCount: 100, imageBackground: "url1"),
            Genre(id: 2, name: "Adventure", slug: "adventure", gamesCount: 200, imageBackground: "url2")
        ]
        
        // Act
        let saveResult = localStorageService.saveSelectedGenres(genres)
        let getResult = localStorageService.getSelectedGenres()
        
        // Assert
        if case .failure = saveResult {
            XCTFail("Expected success but got failure when saving genres")
        }

        switch getResult {
        case .success(let retrievedGenres):
            XCTAssertEqual(retrievedGenres, genres, "Retrieved genres should match the saved genres")
        case .failure:
            XCTFail("Expected success but got failure when retrieving genres")
        }
    }
    
    // Test: Retrieving genres with no saved data
    func testRetrieveGenres_NoData() {
        // Act
        let result = localStorageService.getSelectedGenres()
        
        // Assert
        XCTAssertEqual(result, .failure(.dataNotFound), "Retrieving genres without saved data should fail with .dataNotFound")
    }
    
    // Test: Removing genres successfully
    func testRemoveGenres_Success() {
        // Arrange
        let genres = [Genre(id: 1, name: "Action", slug: "action", gamesCount: 100, imageBackground: "url1")]
        _ = localStorageService.saveSelectedGenres(genres)
        
        // Act
        let removeResult = localStorageService.removeSelectedGenres()
        let getResult = localStorageService.getSelectedGenres()
        
        // Assert
        // Assert remove operation succeeded
        if case .failure(let error) = removeResult {
            XCTFail("Expected success when removing genres, but got failure with error: \(error)")
        }
        
        // Assert get operation after removal
        switch getResult {
        case .success(let retrievedGenres):
            XCTAssertTrue(retrievedGenres.isEmpty, "Genres should be empty after removal")
        case .failure(let error):
            XCTAssertEqual(error, .dataNotFound, "Retrieving genres after removal should fail with .dataNotFound")
        }
    }
    
}
