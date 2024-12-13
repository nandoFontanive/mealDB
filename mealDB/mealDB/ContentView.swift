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
            
            RecipesView()
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
    
    private func customizeTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white // Define o fundo branco
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}

#Preview {
    ContentView()
}
