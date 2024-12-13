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
                        ForEach(filteredCategories) { categories in
                            VStack(alignment: .leading) {
                                ZStack {
                                    VStack (alignment: .leading) {
                                        ZStack {
                                            AsyncImage(url: URL(string: categories.strCategoryThumb)) { returnedImage in
                                                returnedImage.resizable()
                                                    .scaledToFill()
                                            } placeholder: {
                                                Color.gray.opacity(0.3)
                                            }
                                            .frame(width: 175, height: 117)
                                            .clipShape(.rect(cornerRadius: 8))
                                            
                                            LinearGradient(
                                                gradient: Gradient(
                                                    colors: [
                                                        Color.clear.opacity(1),
                                                        Color.gray.opacity(0.7)
                                                    ]
                                                ),
                                                startPoint: .top,
                                                endPoint: .bottom
                                            )
                                            .clipShape(.rect(cornerRadius: 8))
                                            Text(categories.strCategory)
                                                .fontWeight(.bold)
                                                .foregroundStyle(.white)
                                                .zIndex(1)
                                                .padding(.horizontal, 8)
                                                .padding(.top, 90)
                                                .zIndex(2)
                                                .frame(
                                                    width: 175,
                                                    alignment: .leading
                                                )
                                        }
                                        .frame(width: 175, height: 117)
                                    }
                                }
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
            .searchable(text: $searchText, prompt: "Search here")
        }
        
    }
    func loadData() async {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")
        else {
            print("Error: invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedData = try? JSONDecoder().decode(CategoryResponse.self, from: data) {
                categoriesArray = decodedData.categories
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    CategoriesView()
}
