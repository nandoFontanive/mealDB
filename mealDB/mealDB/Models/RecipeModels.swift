//
//  RecipeModels.swift
//  mealDB
//
//  Created by Fernando Fontanive on 21/12/24.
//

import Foundation

struct RecipeRoute: Identifiable, Hashable {
    let mealID: String
    var id: String { mealID }
}

struct RecipeResponse: Codable {
    var meals: [RecipeObject]
}

struct RecipeObject: Codable, Identifiable {
    var id: String { idMeal }
    var idMeal: String
    var strMeal: String
    var strMealThumb: String
}
