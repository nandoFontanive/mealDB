//
//  CategoryRecipesView.swift
//  mealDB
//
//  Created by Fernando Fontanive on 30/12/24.
//

import SwiftUI

struct CategoryRecipesView: View {
    @State private var selectedRecipe: RecipeRoute? = nil
    @State private var recipesArray: [RecipeObject] = []
    
    let category: String
    
    var body: some View {
            VStack {
                Divider()
                ScrollView {
                    LazyVGrid(columns: ColumnConfiguration.singleColumnConfiguration, spacing: AppSizes.paddingSmall) {
                        ForEach(recipesArray) { recipe in
                            NavigationLink(value: RecipeRoute(mealID: recipe.idMeal)) {                                RecipeCardView(recipe: recipe)
                            }
                        }
                    }
                }
            }
            .navigationTitle(category)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                recipesArray = await RecipeService.loadRecipeListFromAPI(for: category)
            }
            .navigationDestination(for: RecipeRoute.self) { route in
                SingleRecipeView(selectedSingleRecipe: route.mealID)
            }
        
        }
}
