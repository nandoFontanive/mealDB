//
//  Colors+Extension.swift
//  mealDB
//
//  Created by Fernando Fontanive on 26/12/24.
//

import SwiftUI

extension Color {
    static let appPrimaryColor = Color("AppPrimaryColor")
    static let appSecondaryColor = Color("AppSecondaryColor")
    static let appBackgroundcolor = Color("AppBackgroundColor")
    static let appOrangeColor = Color("AppOrangeColor")
    static let appGrayColor = Color("AppGrayColor")
}

extension Text {
    func whiteNumberedSquare() -> some View {
        self
            .font(.caption)
            .fontWeight(.bold)
            .foregroundColor(Color.appBackgroundcolor)
            .frame(width: AppSizes.imageTiny, height: AppSizes.imageTiny)
            .background(Color.appGrayColor)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadiusConfiguration.smallCornerRadius))
    }
}
