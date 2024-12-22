//
//  ToolbarAppearance.swift
//  mealDB
//
//  Created by Fernando Fontanive on 21/12/24.
//

import Foundation
import UIKit

func customizeTabBarAppearance() {
    let appearance = UITabBarAppearance()
    appearance.configureWithOpaqueBackground()
    appearance.backgroundColor = UIColor.white
    UITabBar.appearance().standardAppearance = appearance
    UITabBar.appearance().scrollEdgeAppearance = appearance
}
