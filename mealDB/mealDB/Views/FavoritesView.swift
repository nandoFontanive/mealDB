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
    @State private var searchText: String = ""
    
    var filteredFavorites: [RecipeObject] {
        if searchText.isEmpty {
            return favorites.favoriteRecipes
        } else {
            return favorites.favoriteRecipes.filter { $0.strMeal.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            List(filteredFavorites, id: \.idMeal) { recipe in
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
                        .frame(width: AppSizes.imageSmall, height: AppSizes.imageSmall)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusConfiguration.normalCornerRadius))
                        
                        Text(recipe.strMeal)
                            .font(.headline)
                            .foregroundStyle(Color.appPrimary)
                        
                        Spacer()
                        
                        Image(systemName: favorites.contains(recipe.idMeal) ? "heart.fill" : "heart")
                            .foregroundStyle(.appOrange)
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
            .navigationTitle("Favorites")
            .searchable(text: $searchText, prompt: "Search for favorited recipes here")
        }
    }
}


#Preview {
    FavoritesView()
}
