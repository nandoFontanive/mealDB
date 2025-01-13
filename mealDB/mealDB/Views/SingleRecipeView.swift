//
//  SingleRecipeView.swift
//  mealDB
//
//  Created by Fernando Fontanive on 16/12/24.
//

import SwiftUI

struct SingleRecipeView: View {
    @EnvironmentObject var favorites: Favorites
    @Environment(\.dismiss) var dismissSingleRecipeView
    
    @State private var singleRecipe: SingleRecipeObject? = nil
    
    let selectedSingleRecipe: String
    let service = RecipeService()
    
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
                        .frame (height: AppSizes.imageLarge)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadiusConfiguration.normalCornerRadius))
                        .padding()
                        
                        VStack {
                            HStack {
                                Text("\(singleRecipe.strMeal)")
                                    .font(.callout)
                                    .foregroundStyle(Color.appSecondary)
                                Spacer()
                                
                                Button {
                                    if favorites.contains(singleRecipe.idMeal) {
                                        favorites.remove(singleRecipe.idMeal)
                                    } else {
                                        favorites.add(singleRecipe.idMeal)
                                    }
                                } label: {
                                    Image(systemName: favorites.contains(singleRecipe.idMeal) ? "heart.fill" : "heart" )
                                        .foregroundStyle(.appOrange)
                                }
                            }
                            .padding()
                            
                            List {
                                Section {
                                    ForEach(singleRecipe.recipeIngredients.ingredients.indices, id: \.self) { index in
                                        HStack {
                                            Text(singleRecipe.recipeIngredients.ingredients[index].ingredient)
                                                .foregroundColor(Color.appPrimaryColor)
                                            Spacer()
                                            Text(singleRecipe.recipeIngredients.ingredients[index].measure)
                                                .foregroundColor(Color.appSecondaryColor)
                                        }
                                        .padding(.vertical, AppSizes.paddingTiny)
                                    }
                                }   header: {
                                    Text("Ingredients")
                                        .foregroundStyle(Color.appSecondaryColor)
                                }
                                
                                
                                Section("Procedure") {
                                    let instructionSteps = singleRecipe.strInstructions.components(separatedBy: "\r\n")
                                    ForEach(Array(instructionSteps.filter { !$0.isEmpty }.enumerated()), id: \.element) { numberList, step in
                                        HStack(alignment: .top, spacing: 10) {
                                            Text("\(numberList + 1)")
                                                .whiteNumberedSquare()
                                            
                                            Text(step)
                                                .font(.body)
                                                .foregroundColor(Color.appPrimaryColor)
                                        }
                                        .padding(.vertical, AppSizes.paddingTiny)
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
                                singleRecipe = await service.loadSingleRecipe(for: selectedSingleRecipe)
                            }
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Recipe")
                        .font(.headline)
                        .foregroundStyle(Color.appPrimary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismissSingleRecipeView()
                    }
                    .font(.headline)
                    .foregroundStyle(Color.appOrange)
                }
            }
        }
    }
}

#Preview {
    SingleRecipeView(selectedSingleRecipe: "52772")
}
