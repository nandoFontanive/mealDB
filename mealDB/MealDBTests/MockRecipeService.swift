//
//  MockRecipeService.swift
//  MealDBTests
//
//  Created by Fernando Fontanive on 10/01/25.
//

import Foundation
@testable import mealDB

struct MockRecipeService: RecipeServiceProtocol {
    
    var shouldReturnError: Bool = false
    
    func loadCategoriesFromAPI() async -> [CategoryObject] {
        if shouldReturnError {
            return []
        } else {
            return [
                CategoryObject(
                    idCategory: "1",
                    strCategory: "MockCategory",
                    strCategoryThumb: "https://www.example.com/mockthumb.jpg"
                )
            ]
        }
    }
    
    func loadRecipeListFromAPI(for category: String) async -> [RecipeObject] {
        if shouldReturnError {
            return []
        } else {
            return [
                RecipeObject(
                    idMeal: "100",
                    strMeal: "Mock Meal",
                    strMealThumb: "https://www.example.com/mockmeal.jpg"
                )
            ]
        }
    }
    
    func loadSingleRecipe(for selectedSingleRecipe: String) async -> SingleRecipeObject? {
        if shouldReturnError {
            return nil
        } else {
            return SingleRecipeObject(
                idMeal: "MockID",
                strMeal: "Mock Single Meal",
                strCategory: "Mock Category",
                strArea: "Mock Area",
                strInstructions: "Mock Instructions",
                strMealThumb: "https://www.example.com/mockthumb.jpg",
                strTags: "MockTag",
                recipeIngredients: RecipeIngredients(ingredients: [
                    ("MockIngredient", "1 tbsp")
                ])
            )
        }
    }
}
