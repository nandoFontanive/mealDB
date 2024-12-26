//
//  FavoriesView.swift
//  mealDB
//
//  Created by Fernando Fontanive on 12/12/24.
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favorites: Favorites
    @State private var selectedRecipe: RecipeRoute? = nil
    
    var body: some View {
        List(favorites.favoriteRecipes, id: \.idMeal) { recipe in
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
                    .frame(width: 48, height: 48)
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
        .onAppear {
            Task {
                await favorites.reloadFavoritedRecipes()
            }
        }
        .sheet(item: $selectedRecipe) { route in
            SingleRecipeView(selectedSingleRecipe: route.mealID)
        }
    }
}


#Preview {
    FavoritesView()
}
