//
//  FavoriteTests.swift
//  MealDBTests
//
//  Created by Fernando Fontanive on 10/01/25.
//

import XCTest
@testable import mealDB

final class FavoritesTests: XCTestCase {

    override func setUpWithError() throws {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: "Favorites")
    }
    
    func testReloadFavoritedRecipes_withMockService() async throws {
        // Given
        let mockService = MockRecipeService(shouldReturnError: false)
        let favorites = Favorites(recipeService: mockService)
        
        favorites.add("MockID1")
        favorites.add("MockID2")
        favorites.add("MockID3")
        
        // When
        await favorites.reloadFavoritedRecipes()
        
        // Then
        XCTAssertEqual(favorites.favoriteRecipes.count, 3, "Should contain 3 favorited recipes.")
    }
}
