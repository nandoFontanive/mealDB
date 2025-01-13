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
                    .frame(width: AppSizes.categoryCardSize.width, height: AppSizes.categoryCardSize.height)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadiusConfiguration.normalCornerRadius))
                    
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
                    
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadiusConfiguration.normalCornerRadius))
                    Text(category.strCategory)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.appPrimary)
                        .padding(.horizontal, AppSizes.paddingSmall)
                        .padding(.top, AppSizes.paddingHuge)
                        .frame(width: AppSizes.categoryCardSize.width, alignment: .leading)
                }
                .frame(width: AppSizes.categoryCardSize.width, height: AppSizes.categoryCardSize.height)
            }
    }
}
