//
//  CategoryItemView.swift
//  mealDB
//
//  Created by Fernando Fontanive on 13/12/24.
//

import SwiftUI

struct CategoryItemView: View {
    var selectedRecipeID: String? = ""
    let category: CategoryObject
    
    var body: some View {
        ZStack {
                ZStack {
                    AsyncImage(url: URL(string: category.strCategoryThumb)) { returnedImage in
                        returnedImage.resizable()
                            .scaledToFill()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .frame(width: 175, height: 117)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    
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
                    
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    Text(category.strCategory)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.top, 90)
                        .frame(width: 175, alignment: .leading)
                }
                .frame(width: 175, height: 117)
            }
    }
}

//#Preview {
//    CategoryItemView()
//}
