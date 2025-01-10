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

struct SingleRecipeResponse: Codable {
    var meals: [SingleRecipeObject]
}

struct SingleRecipeObject: Codable, Identifiable {
    var id: String { idMeal }
    var idMeal: String
    var strMeal: String
    var strCategory: String
    var strArea: String
    var strInstructions: String
    var strMealThumb: String
    var strTags: String?

    var recipeIngredients: RecipeIngredients

    // MARK: - Novo init por parâmetros
    init(
        idMeal: String,
        strMeal: String,
        strCategory: String,
        strArea: String,
        strInstructions: String,
        strMealThumb: String,
        strTags: String? = nil,
        recipeIngredients: RecipeIngredients
    ) {
        self.idMeal = idMeal
        self.strMeal = strMeal
        self.strCategory = strCategory
        self.strArea = strArea
        self.strInstructions = strInstructions
        self.strMealThumb = strMealThumb
        self.strTags = strTags
        self.recipeIngredients = recipeIngredients
    }

    // MARK: - init(from decoder: Decoder) continua existindo
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strCategory = try container.decode(String.self, forKey: .strCategory)
        strArea = try container.decode(String.self, forKey: .strArea)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        strTags = try container.decodeIfPresent(String.self, forKey: .strTags)
        
        recipeIngredients = try RecipeIngredients(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strCategory, strArea, strInstructions, strMealThumb, strTags
    }
}

struct RecipeIngredients: Decodable {
    var ingredients: [(ingredient: String, measure: String)] = []

    // MARK: - Novo init que recebe um array de tuplas
    init(ingredients: [(String, String)]) {
        self.ingredients = ingredients
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        
        for index in 1...20 {
            let ingredientKey = "strIngredient\(index)"
            let measureKey = "strMeasure\(index)"
            
            let ingredient = try container.decodeIfPresent(String.self,
                forKey: CustomCodingKeys(stringValue: ingredientKey))
            let measure = try container.decodeIfPresent(String.self,
                forKey: CustomCodingKeys(stringValue: measureKey))
            
            if let ingredient = ingredient, !ingredient.trimmingCharacters(in: .whitespaces).isEmpty,
               let measure = measure, !measure.trimmingCharacters(in: .whitespaces).isEmpty {
                ingredients.append((ingredient, measure))
            }
        }
    }
    
    struct CustomCodingKeys: CodingKey {
        var stringValue: String
        init(stringValue: String) { self.stringValue = stringValue }
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }
}
