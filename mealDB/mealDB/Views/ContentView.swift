//
//  ContentView.swift
//  MealDB
//
//  Created by Fernando Fontanive on 09/12/24.
//

import SwiftUI

struct ContentView: View {
    init() {
        customizeTabBarAppearance()
    }
    
    var body: some View {
        TabView {
            CategoriesView()
                .tabItem {
                    Label("Categories", systemImage: "square.grid.2x2.fill")
                }
            
            RecipesListView(category: "Seafood")
                .tabItem {
                    Label("Recipes", systemImage: "fork.knife")
                }
            
            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
        .tint(.orange)
    }
}

#Preview {
    ContentView()
}
