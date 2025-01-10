//
//  CategoriesView.swift
//  mealDB
//
//  Created by Fernando Fontanive on 12/12/24.
//

import SwiftUI

struct CategoriesView: View {
    let recipeService: RecipeServiceProtocol
    @State private var categoriesArray: [CategoryObject] = []
    @State private var searchText: String = ""
    
    var filteredCategories: [CategoryObject] {
        if searchText.isEmpty {
            return categoriesArray
        } else {
            return categoriesArray.filter { $0.strCategory.localizedStandardContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                Divider()
                ScrollView {
                    LazyVGrid(columns: ColumnConfiguration.categoryColumnConfiguration, spacing: AppSizes.paddingSmall) {
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
                categoriesArray = await recipeService.loadCategoriesFromAPI()
            }
            .navigationTitle("Categories")
            .searchable(text: $searchText, prompt: "Search for categories here")
            .navigationDestination(for: CategoryRoute.self) { route in
                CategoryRecipesView(category: route.categoryName)
            }
        }
    }
}
