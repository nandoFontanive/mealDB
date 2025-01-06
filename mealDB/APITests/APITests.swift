//
//  APITests.swift
//  APITests
//
//  Created by Fernando Fontanive on 06/01/25.
//

import Testing
@testable import mealDB

struct APITests {

    @Test
    func testLoadCategoriesFromAPI() async throws {
        let categories = await RecipeService.loadCategoriesFromAPI()
        #expect(!categories.isEmpty, "A lista de categorias não deveria estar vazia.")
    }

    @Test
    func testLoadRecipeListForCategory() async throws {
        let recipes = await RecipeService.loadRecipeListFromAPI(for: "Vegan")
        #expect(!recipes.isEmpty, "Não deveria retornar lista vazia ao pedir 'Vegan'.")
        
        // Opcional: verificar a primeira receita
        if let firstRecipe = recipes.first {
            #expect(!firstRecipe.strMeal.isEmpty, "O nome da receita não deve estar vazio.")
        }
    }

    @Test
    func testLoadSingleRecipe() async throws {
        // Usar um ID conhecido (ex.: do site do TheMealDB)
        let knownID = "52816"
        let singleRecipe = await RecipeService.loadSingleRecipe(for: knownID)

        #expect(singleRecipe != nil, "A receita com ID \(knownID) deveria existir.")
        #expect(singleRecipe?.idMeal == knownID, "O ID da receita retornada deveria ser \(knownID).")
    }
    
    @Test
    func testLoadRecipeListWithInvalidURL() async throws {
        // Força uma URL inválida (ex.: remove “filter.php?”)
        let invalidCategory = "//invalid category//"
        let recipes = await RecipeService.loadRecipeListFromAPI(for: invalidCategory)
        
        // Espera que volte um array vazio (caso esse seja o comportamento definido)
        #expect(recipes.isEmpty, "Com categoria inválida, o app deve retornar lista vazia.")
    }
}
