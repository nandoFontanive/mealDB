//
//  Favorites.swift
//  mealDB
//
//  Created by Fernando Fontanive on 22/12/24.
//

import Foundation
import SwiftUI

class Favorites: ObservableObject {
    @Published private var recipeIDs: Set<String>
    private let key = "Favorites"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode(Set<String>.self, from: data) {
            self.recipeIDs = saved
        } else {
            self.recipeIDs = []
        }
    }
    func contains(_ recipeID: String) -> Bool {
        recipeIDs.contains(recipeID)
    }
    
    func add(_ recipeID: String) {
        recipeIDs.insert(recipeID)
        save()
    }
    
    func remove(_ recipeID: String) {
        recipeIDs.remove(recipeID)
        save()
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(recipeIDs) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
}

/*
class Favorites: ObservableObject{
    @Published private var list = [RecipeObject]()
    
    init(){
        let defaults = UserDefaults.standard
        if let savedPerson = defaults.object(forKey: "SavedFavorites") as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode([RecipeObject].self, from: savedPerson) {
                self.list = loadedPerson
            }
        }
    }
    
    func addRemove(recipe: RecipeObject){
        if list.contains(recipe){
            for i in 0..<list.count{
                if list[i] == recipe{
                    list.remove(at: i)
                    break
                }
            }
        }else{
            list.append(recipe)
        }
        save()
    }
    
    func listContains(recipe: RecipeObject) -> Bool{
        return list.contains(recipe)
    }
    
    func getList() -> [RecipeObject]{
        return list
    }
    
    func save(){
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(list) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: "SavedFavorites")
        }
    }
}
*/
