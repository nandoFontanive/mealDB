//
//  Favorites.swift
//  mealDB
//
//  Created by Fernando Fontanive on 22/12/24.
//

import Foundation
import SwiftUI

protocol FavoritesProtocol: AnyObject {
    var recipeIDs: Set<String> { get set }
    var favoriteRecipes: [RecipeObject] { get set }
    func contains(_ recipeID: String) -> Bool
    func add(_ recipeID: String)
    func remove(_ recipeID: String)
    func listAll() -> Set<String>
    func loadDataFromUserDefaults()
    func reloadFavoritedRecipes() async
}

class Favorites: ObservableObject, FavoritesProtocol {
    @Published var recipeIDs: Set<String> = []
    @Published var favoriteRecipes: [RecipeObject] = []

    private let key = "Favorites"
    private let recipeService: RecipeServiceProtocol
    
    init(recipeService: RecipeServiceProtocol) {
        self.recipeService = recipeService
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
                if let singlefavoritedRecipe = await recipeService.loadSingleRecipe(for: favoritedMealID) {
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
