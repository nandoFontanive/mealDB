//
//  ContentView.swift
//  MealDB
//
//  Created by Fernando Fontanive on 09/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var favorites = Favorites(recipeService: RecipeService())
    private let recipeService = RecipeService()
    
    init() {
        customizeTabBarAppearance()
    }
    
    var body: some View {
        TabView {
            CategoriesView(recipeService: RecipeService())
                .tabItem {
                    Label("Categories", systemImage: "square.grid.2x2.fill")
                }
            
            RecipesListView(category: "Miscellaneous", recipeService: RecipeService())
                .tabItem {
                    Label("Recipes", systemImage: "fork.knife")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
        .tint(.appOrange)
        .foregroundStyle(.black)
        .environmentObject(favorites)
        .onAppear {
            Task {
                await favorites.reloadFavoritedRecipes()
            }
        }
    }
}

#Preview {
    ContentView()
}
