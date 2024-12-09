//
//  ContentView.swift
//  MealDB
//
//  Created by Fernando Fontanive on 09/12/24.
//

import SwiftUI

struct MealResponse: Codable {
    var meals: [Meal]
}

struct Meal: Codable {
    var strMeal: String
    var strCategory: String
    var strArea: String
    var strInstructions: String
}

struct ContentView: View {
    @State private var randomMeal: Meal? = nil
    
    var body: some View {
        VStack {
            if let randomMeal = randomMeal {
                Text(randomMeal.strMeal)
                    .font(.largeTitle)
                Text(randomMeal.strArea)
                    .font(.title)
                Text(randomMeal.strCategory)
                    .font(.headline)
                Text(randomMeal.strInstructions)
                    .font(.caption)
            } else {
                Text("Loading meal...")
            }
        }
        .padding()
        .task {
            await loadData()
        }
    }
    func loadData() async {
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/random.php")
        else {
            print("Error: invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedData = try? JSONDecoder().decode(MealResponse.self, from: data) {
                randomMeal = decodedData.meals.first
            }
        } catch {
            print("Invalid data")
        }
    }
}

#Preview {
    ContentView()
}
