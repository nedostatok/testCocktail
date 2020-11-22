//
//  Networking.swift
//  test
//
//  Created by User on 20.11.2020.
//

import Foundation

class GetData {
    static let shared = GetData()
    
    func loadDrinks(param: String,completion: @escaping (ResponseEnum<[DrinkModel]>) -> ()) {
        
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(param)") else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                let taskError = NSError(domain: "", code: ErrorCode.taskError.rawValue, userInfo: nil)
                completion(.Error(taskError))
                return
            }
            
            guard let data = data else {
                
                let emptyData = NSError(domain: "", code: ErrorCode.emptyData.rawValue, userInfo: nil)
                completion(.Error(emptyData))
                return
            }
            
            do {
                let data = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                let drinks = data["drinks"] as! [[String : Any]]
                
                var arrayDrinks = [DrinkModel]()
                
                for i in drinks {
                    let name = i["strDrink"] as! String
                    let img = i["strDrinkThumb"] as! String
                    
                    arrayDrinks.append(DrinkModel(drinkName: name, drinkImage: img))
                }
                
                completion(.Value(arrayDrinks))
                
            } catch{
                let parseError = NSError(domain: "", code: ErrorCode.parseError.rawValue, userInfo: nil)
                completion(.Error(parseError))
            }
        }.resume()
    }

    func loadFilters(completion: @escaping (ResponseEnum<[FilterModel]>) -> ()) {
        
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list") else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                let taskError = NSError(domain: "", code: ErrorCode.taskError.rawValue, userInfo: nil)
                completion(.Error(taskError))
                return
            }
            
            guard let data = data else {
                
                let emptyData = NSError(domain: "", code: ErrorCode.emptyData.rawValue, userInfo: nil)
                completion(.Error(emptyData))
                return
            }
            
            do {
                
                let data = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String : Any]
                let drinks = data["drinks"] as! [[String : Any]]
                
                var arrayFilters = [FilterModel]()
                
                for i in drinks {
                    let name = i["strCategory"] as! String

                    arrayFilters.append(FilterModel(filterName: name))
                }
                
                completion(.Value(arrayFilters))
                
            } catch{
                let parseError = NSError(domain: "", code: ErrorCode.parseError.rawValue, userInfo: nil)
                completion(.Error(parseError))
            }
        }.resume()
    }
}
