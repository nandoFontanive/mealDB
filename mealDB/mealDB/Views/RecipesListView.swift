//
//  RecipesListView.swift
//  mealDB
//
//  Created by Fernando Fontanive on 12/12/24.
//

import SwiftUI

struct RecipesListView: View {
    @EnvironmentObject var favorites: Favorites
    @State private var selectedRecipe: RecipeRoute? = nil
    @State private var recipesArray: [RecipeObject] = []
    
    let category: String
    
    var body: some View {
        List(recipesArray) { recipe in
            Button(action: {
                selectedRecipe = RecipeRoute(mealID: recipe.idMeal)
            }) {
                HStack {
                    AsyncImage(url: URL(string: recipe.strMealThumb)) { returnedRecipeImage in
                        returnedRecipeImage
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    Text(recipe.strMeal)
                        .font(.headline)
                    
                    Spacer()
                    
                    Image(systemName: favorites.contains(recipe.idMeal) ? "heart.fill" : "heart")
                        .foregroundStyle(.orange)
                        .onTapGesture {
                            if favorites.contains(recipe.idMeal) {
                                favorites.remove(recipe.idMeal)
                            } else {
                                favorites.add(recipe.idMeal)
                            }
                        }
                }
            }
        }
        .navigationTitle(category)
        .onAppear {
            Task {
                recipesArray = await RecipeService.loadRecipeListFromAPI(for: category)
            }
        }
        .sheet(item: $selectedRecipe) { route in
            SingleRecipeView(selectedSingleRecipe: route.mealID)
        }
    }
}
