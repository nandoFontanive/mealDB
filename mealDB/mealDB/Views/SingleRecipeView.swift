//
//  SingleRecipeView.swift
//  mealDB
//
//  Created by Fernando Fontanive on 16/12/24.
//

import SwiftUI

struct SingleRecipeResponse: Codable {
    var meals: [SingleRecipeObject]
}

struct SingleRecipeObject: Codable, Identifiable {
    var id: String { idMeal }
    var idMeal: String
    var strMeal: String
    var strCategory: String
    var strArea: String
    var strInstructions: String
    var strMealThumb: String
    var strTags: String
}

struct SingleRecipeView: View {
    @Environment(\.dismiss) var dismissSingleRecipeView
    @State private var singleRecipe: SingleRecipeObject? = nil
    
    let selectedSingleRecipe: String
    
    var body: some View {
        NavigationView {
            Group {
                if let singleRecipe = singleRecipe {
                    ScrollView {
                        VStack {
                            Text("Recipe")
                            
                            Divider()
                            
                            AsyncImage(url: URL(string: singleRecipe.strMealThumb)) { returnedSingleRecipeImage in
                                returnedSingleRecipeImage
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame (height: 175)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .padding()
                            
                            Text("\(singleRecipe.strMeal) Details")
                                .font(.headline)
                                .padding()
                            
                            Text(singleRecipe.strInstructions)
                                .font(.body)
                                .padding()
                        }
                    }
                }
                else {
                    Text("Loading...")
                        .onAppear {
                            Task {
                                await loadSingleRecipe()
                            }
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Recipe")
                        .font(.headline)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismissSingleRecipeView()
                    }
                    .font(.headline)
                }
            }
        }
    }
    
    func loadSingleRecipe() async {
        guard let urlSingleRecipe = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(selectedSingleRecipe)")
        else {
            print("Error: could not load single recipe data")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: urlSingleRecipe)
            if let decodedData = try? JSONDecoder().decode(SingleRecipeResponse.self, from: data),
               let recipe = decodedData.meals.first {
                singleRecipe = recipe
            }
        } catch {
            print("Invalid single recipe data received")
        }
    }
}
