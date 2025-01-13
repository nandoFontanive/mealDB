//
//  RecipeCardView.swift
//  mealDB
//
//  Created by Fernando Fontanive on 30/12/24.
//

import SwiftUI

struct RecipeCardView: View {
    let recipe: RecipeObject
    
    var body: some View {
        ZStack(alignment: .leading) {
            AsyncImage(url: URL(string: recipe.strMealThumb)) { returnedImage in
                returnedImage.resizable()
                    .scaledToFill()
            } placeholder: {
                Color.gray.opacity(0.3)
            }
            .frame(
//                width: AppSizes.categoryLargerCardSize.width
                height: AppSizes.categoryLargerCardSize.height
            )
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusConfiguration.normalCornerRadius))
            
            LinearGradient(
                gradient: Gradient(
                    colors: [
                        Color.clear,
                        Color.black.opacity(0.6)
                    ]
                ),
                startPoint: .top,
                endPoint: .bottom
            )
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusConfiguration.normalCornerRadius))
            
            Text(recipe.strMeal)
                .font(.title3)
                .bold()
                .foregroundStyle(Color.appPrimary)
                .padding(.horizontal, AppSizes.paddingMedium)
                .padding(.vertical, AppSizes.paddingTiny)
                .padding(.top, AppSizes.paddingHuge)
                .frame(
                    width: AppSizes.categoryLargerCardSize.width,
                    height: AppSizes.categoryLargerCardSize.height,
                    alignment: .leading
                )
                .clipShape(RoundedRectangle(cornerRadius: CornerRadiusConfiguration.normalCornerRadius))
        }
    }
}
