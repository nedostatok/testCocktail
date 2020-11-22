//
//  CocktailModel.swift
//  test
//
//  Created by User on 20.11.2020.
//

import Foundation

enum ResponseEnum<T> {
    case Error(NSError)
    case Value(T)
}

struct DrinkModel {
    let drinkName: String
    let drinkImage: String
}

struct FilterModel {
    let filterName: String
}
