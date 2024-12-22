//
//  SingleRecipeView.swift
//  mealDB
//
//  Created by Fernando Fontanive on 16/12/24.
//

import SwiftUI

struct SingleRecipeView: View {
    @Environment(\.dismiss) var dismissSingleRecipeView
    @State private var singleRecipe: SingleRecipeObject? = nil
    @State private var isFavorite: Bool = false
    
    let selectedSingleRecipe: String
    
    var body: some View {
        NavigationView {
            Group {
                if let singleRecipe = singleRecipe {
                    VStack {
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
                        
                        VStack {
                            HStack {
                                Text("\(singleRecipe.strMeal)")
                                    .font(.callout)
                                Spacer()
                                Button("", systemName: "heart") {
                                    isFavorite.toggle()
                                }
                                Image(systemName: "heart")
                            }
                            .padding()
                            
                            List {
                                Section("Ingredients") {
                                    ForEach(singleRecipe.recipeIngredients.ingredients.indices, id: \.self) { index in
                                        HStack {
                                            Text(singleRecipe.recipeIngredients.ingredients[index].ingredient)
                                                .foregroundColor(.primary)
                                            Spacer()
                                            Text(singleRecipe.recipeIngredients.ingredients[index].measure)
                                                .foregroundColor(.secondary)
                                        }
                                        .padding(.vertical, 2)
                                    }
                                }
                                
                                
                                Section("Procedure") {
                                    let instructionSteps = singleRecipe.strInstructions.components(separatedBy: "\r\n")
                                    ForEach(Array(instructionSteps.filter { !$0.isEmpty }.enumerated()), id: \.element) { numberList, step in
                                        HStack(alignment: .top, spacing: 10) {
                                            Text("\(numberList + 1)")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .frame(width: 24, height: 24)
                                                .background(Color.gray)
                                                .clipShape(RoundedRectangle(cornerRadius: 6))
                                            
                                            Text(step)
                                                .font(.body)
                                                .foregroundColor(.primary)
                                        }
                                        .padding(.vertical, 5)
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    ProgressView()
                        .onAppear {
                            Task {
                                singleRecipe = await RecipeService.loadSingleRecipe(for: selectedSingleRecipe)
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
}

#Preview {
    SingleRecipeView(selectedSingleRecipe: "52772")
}
