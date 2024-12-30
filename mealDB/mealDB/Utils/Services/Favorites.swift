//
//  Favorites.swift
//  mealDB
//
//  Created by Fernando Fontanive on 22/12/24.
//

import Foundation
import SwiftUI

class Favorites: ObservableObject {
    @Published private var recipeIDs: Set<String> = []
    @Published var favoriteRecipes: [RecipeObject] = []
    
    private let key = "Favorites"
    
    init() {
        loadDataFromUserDefaults()
    }
    
    func contains(_ recipeID: String) -> Bool {
        recipeIDs.contains(recipeID)
    }
    
    func add(_ recipeID: String) {
        recipeIDs.insert(recipeID)
        save()
    }
    
    func remove(_ recipeID: String) {
        recipeIDs.remove(recipeID)
        save()
    }
    
    func listAll() -> Set<String> {
        return recipeIDs
    }
    
    func loadDataFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode(Set<String>.self, from: data) {
            self.recipeIDs = saved
        } else {
            self.recipeIDs = []
        }
    }
    
    func reloadFavoritedRecipes() async {
        await MainActor.run {
            favoriteRecipes.removeAll()
        }
        for favoritedMealID in recipeIDs {
                if let singlefavoritedRecipe = await RecipeService.loadSingleRecipe(for: favoritedMealID) {
                    let favoritedRecipesObject = RecipeObject(
                        idMeal: singlefavoritedRecipe.idMeal,
                        strMeal: singlefavoritedRecipe.strMeal,
                        strMealThumb: singlefavoritedRecipe.strMealThumb
                    )
                    await MainActor.run {
                        favoriteRecipes.append(favoritedRecipesObject)
                    }
            }
        
    }
}
    
    private func save() {
        if let data = try? JSONEncoder().encode(recipeIDs) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}
