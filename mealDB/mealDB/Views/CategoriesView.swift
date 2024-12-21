//
//  CategoriesView.swift
//  mealDB
//
//  Created by Fernando Fontanive on 12/12/24.
//

import SwiftUI

struct CategoryRoute: Hashable {
    let categoryName: String
}

struct RecipeRoute: Identifiable, Hashable {
    let mealID: String
    var id: String { mealID }
}

struct CategoryResponse: Codable {
    var categories: [CategoryObject]
}

struct CategoryObject: Codable, Identifiable {
    var id: String { idCategory }
    var idCategory: String
    var strCategory: String
    var strCategoryThumb: String
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

struct CategoriesView: View {
    @State private var categoriesArray: [CategoryObject] = []
    @State private var searchText: String = ""
    
    var filteredCategories: [CategoryObject] {
        if searchText.isEmpty {
            return categoriesArray
        } else {
            return categoriesArray.filter { $0.strCategory.localizedStandardContains(searchText) }
        }
    }
    
    let columnConfiguration = [
        GridItem(.flexible(minimum: 180, maximum: 180), spacing: 10),
        GridItem(.flexible(minimum: 180, maximum: 180), spacing: 10)
    ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                ScrollView {
                    LazyVGrid(columns: columnConfiguration, spacing: 8) {
                        ForEach(filteredCategories) { category in
                            NavigationLink(value: CategoryRoute(categoryName: category.strCategory)) {                                CategoryItemView(category: category)
                            }
                        }
                    }
                }
                if categoriesArray.isEmpty {
                    ProgressView()
                }
            }
            .task {
                categoriesArray = await RecipeService.loadCategoriesFromAPI()
            }
            .navigationTitle("Categories")
            .searchable(text: $searchText, prompt: "Search for categories here")
            .navigationDestination(for: CategoryRoute.self) { route in
                RecipesListView(category: route.categoryName)
            }
        }
    }
}

#Preview {
    CategoriesView()
}
