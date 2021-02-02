//
//  CocktailModel.swift
//  test
//
//  Created by User on 20.11.2020.
//

import Foundation

// MARK: - Welcome
struct DrinksModel {
    let drinks: [Drink]
}

// MARK: - Drink
struct Drink {
    let strDrink: String
    let strDrinkThumb: String?
}

// MARK: - Welcome
struct FiltersModel {
    let drinks: [DrinkFilter]
}

// MARK: - Drink
struct DrinkFilter {
    let strCategory: String
}
