//
//  CategoryModels.swift
//  mealDB
//
//  Created by Fernando Fontanive on 21/12/24.
//

import Foundation

struct CategoryObject: Codable, Identifiable {
    var id: String { idCategory }
    var idCategory: String
    var strCategory: String
    var strCategoryThumb: String
}

struct CategoryRoute: Hashable {
    let categoryName: String
}

struct CategoryResponse: Codable {
    var categories: [CategoryObject]
}
