//
//  RecipeServices.swift
//  mealDB
//
//  Created by Fernando Fontanive on 21/12/24.
//

import Foundation
import SwiftUI

protocol RecipeServiceProtocol {
    func loadCategoriesFromAPI() async -> [CategoryObject]
    func loadRecipeListFromAPI(for category: String) async -> [RecipeObject]
    func loadSingleRecipe(for selectedSingleRecipe: String) async -> SingleRecipeObject?
}

struct RecipeService: RecipeServiceProtocol {
    func loadCategoriesFromAPI() async -> [CategoryObject] {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")
        else {
            print("Error: could not load categories")
            return []
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedData = try? JSONDecoder().decode(CategoryResponse.self, from: data) {
                return decodedData.categories
            }
        } catch {
            print("Invalid categories data received")
        }
        return []
    }
    
    func loadRecipeListFromAPI(for category: String) async -> [RecipeObject] {
        guard let urlRecipeList = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)")
        else {
            print("Error: could not load recipes list by category")
            return []
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: urlRecipeList)
            if let decodedData = try? JSONDecoder().decode(RecipeResponse.self, from: data) {
                return decodedData.meals
            }
        } catch {
            print("Invalid recipes data received")
        }
        return []
    }
    
    func loadSingleRecipe(for selectedSingleRecipe: String) async -> SingleRecipeObject? {
        guard let urlSingleRecipe = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(selectedSingleRecipe)")
        else {
            print("Error: could not load single recipe data")
            return nil
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: urlSingleRecipe)
            if let decodedData = try? JSONDecoder().decode(SingleRecipeResponse.self, from: data) {
                return decodedData.meals.first
            }
        } catch {
            print("Invalid single recipe data received")
        }
        return nil
    }
}
