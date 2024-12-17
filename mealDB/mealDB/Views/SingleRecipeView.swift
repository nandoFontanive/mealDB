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
    var strTags: String?

    var recipeIngredients: RecipeIngredients

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        idMeal = try container.decode(String.self, forKey: .idMeal)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strCategory = try container.decode(String.self, forKey: .strCategory)
        strArea = try container.decode(String.self, forKey: .strArea)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        strTags = try container.decodeIfPresent(String.self, forKey: .strTags)

        recipeIngredients = try RecipeIngredients(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case idMeal, strMeal, strCategory, strArea, strInstructions, strMealThumb, strTags
    }
}

struct RecipeIngredients: Decodable {
    var ingredients: [(ingredient: String, measure: String)] = []

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        
        for index in 1...20 {
            let ingredientKey = "strIngredient\(index)"
            let measureKey = "strMeasure\(index)"
            
            let ingredient = try container.decodeIfPresent(String.self, forKey: CustomCodingKeys(stringValue: ingredientKey))
            let measure = try container.decodeIfPresent(String.self, forKey: CustomCodingKeys(stringValue: measureKey))
            
            if let ingredient = ingredient, !ingredient.trimmingCharacters(in: .whitespaces).isEmpty,
               let measure = measure, !measure.trimmingCharacters(in: .whitespaces).isEmpty {
                ingredients.append((ingredient, measure))
            }
        }
    }
    
    struct CustomCodingKeys: CodingKey {
        var stringValue: String
        init(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int? { return nil }
        init?(intValue: Int) { return nil }
    }
}

struct SingleRecipeView: View {
    @Environment(\.dismiss) var dismissSingleRecipeView
    @State private var singleRecipe: SingleRecipeObject? = nil
    
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

#Preview {
    SingleRecipeView(selectedSingleRecipe: "52772")
}
