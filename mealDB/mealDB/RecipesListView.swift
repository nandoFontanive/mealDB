//
//  RecipesListView.swift
//  mealDB
//
//  Created by Fernando Fontanive on 12/12/24.
//

import SwiftUI

struct RecipesListView: View {
    let category: String
    @State private var recipesArray: [RecipeObject] = []
    
    var body: some View {
        List(recipesArray) { recipe in
            HStack {
                AsyncImage(url: URL(string: recipe.strMealThumb)) { returnedRecipeImage in
                    returnedRecipeImage
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                Text(recipe.strMeal)
                    .font(.headline)
            }
        }
        .navigationTitle(category)
            .onAppear {
                Task {
                    await loadRecipeList()
                }
            }
    }
    func loadRecipeList() async {
        guard let urlRecipeList = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)")
        else {
            print("Error: could not load recipes list by category")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: urlRecipeList)
            if let decodedData = try? JSONDecoder().decode(RecipeResponse.self, from: data) {
                recipesArray = decodedData.meals
            }
        } catch {
            print("Invalid recipes data received")
        }
    }
}
