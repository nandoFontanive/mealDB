//
//  Sizes+Extension.swift
//  mealDB
//
//  Created by Fernando Fontanive on 26/12/24.
//

import Foundation
import SwiftUI

struct AppSizes {
    static let imageTiny: CGFloat = 24
    static let imageSmall: CGFloat = 50
    static let imageMedium: CGFloat = 80
    static let imageLarge: CGFloat = 175
    
    static let categoryCardSize = CGSize(width: 175, height: 120)
    
    static let paddingTiny: CGFloat = 2
    static let paddingSmall: CGFloat = 8
    static let paddingMedium: CGFloat = 16
    static let paddingLarge: CGFloat = 20
}

struct ColumnConfiguration {
    static let categoryColumnConfiguration = [
        GridItem(.flexible(minimum: 180, maximum: 180), spacing: 10),
        GridItem(.flexible(minimum: 180, maximum: 180), spacing: 10)
    ]
}

struct CornerRadiusConfiguration {
    static let smallCornerRadius: CGFloat = 6
    static let normalCornerRadius: CGFloat = 8
    static let largeCornerRadius: CGFloat = 16
}
