//
//  CategoriesView.swift
//  mealDB
//
//  Created by Fernando Fontanive on 12/12/24.
//

import SwiftUI

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
    //    @State private var recipesArray: [RecipeObject] = []
    @State private var selectedCategory: String? = nil
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
                            NavigationLink(value: category.strCategory) {
                                CategoryItemView(category: category)
                            }
                        }
                    }
                }
                if categoriesArray.isEmpty {
                    Text("Loading category...")
                }
            }
            .task {
                await loadData()
            }
            .navigationTitle("Categories")
            .searchable(text: $searchText, prompt: "Search categories here")
            .navigationDestination(for: String.self) { category in
                RecipesListView(category: category)
            }
        }
    }
    
    func loadData() async {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")
        else {
            print("Error: could not load categories")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedData = try? JSONDecoder().decode(CategoryResponse.self, from: data) {
                categoriesArray = decodedData.categories
            }
        } catch {
            print("Invalid categories data received")
        }
    }
}

#Preview {
    CategoriesView()
}
