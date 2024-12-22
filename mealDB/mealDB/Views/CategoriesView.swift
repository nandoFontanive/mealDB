//
//  CategoriesView.swift
//  mealDB
//
//  Created by Fernando Fontanive on 12/12/24.
//

import SwiftUI

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
