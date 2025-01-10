//
//  RecipeServiceTests.swift
//  MealDBTests
//
//  Created by Fernando Fontanive on 10/01/25.
//

import Testing
import XCTest

@testable import mealDB

final class RecipeServiceTests: XCTestCase {
    
    func testLoadCategoriesFromAPI_RealCall() async throws {
        // Given
        let service = RecipeService()
        
        // When
        let categories = await service.loadCategoriesFromAPI()
        
        // Then
        XCTAssertFalse(categories.isEmpty, "Should not return empty category list")
    }
    
    func testLoadRecipesFromAPI_RealCall() async throws {
        let service = RecipeService()
        let recipes = await service.loadRecipeListFromAPI(for: "Dessert")
        
        XCTAssertFalse(recipes.isEmpty, "Should not return empty recipe list")
    }
}
