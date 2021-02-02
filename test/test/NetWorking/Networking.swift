//
//  Networking.swift
//  test
//
//  Created by User on 20.11.2020.
//

import Foundation

class NetworkService {
    static let shared = NetworkService()
    typealias HandletForDrinks = (Result<[Drink],Error>) -> ()
    typealias HandleForFilters = (Result<[DrinkFilter],Error>) -> ()
    
    func loadDrinks(param: String,completion: @escaping HandletForDrinks) {
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?c=\(param)") else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                let taskError = NSError(domain: "", code: ErrorCode.taskError.rawValue, userInfo: nil)
                completion(.failure(taskError))
                return
            }
            
            guard let data = data else {
                
                let emptyData = NSError(domain: "", code: ErrorCode.emptyData.rawValue, userInfo: nil)
                completion(.failure(emptyData))
                return
            }
            
            do {
                guard let data = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else { return }
                guard let drinks = data["drinks"] as? [[String : Any]] else { return }
                
                var arrayDrinks = [Drink]()
                
                for i in drinks {
                    guard let name = i["strDrink"] as? String else { return }
                    guard let img = i["strDrinkThumb"] as? String else { return }
                    
                    arrayDrinks.append(Drink(strDrink: name, strDrinkThumb: img))
                }
                completion(.success(arrayDrinks))
                
            } catch{
                let parseError = NSError(domain: "", code: ErrorCode.parseError.rawValue, userInfo: nil)
                completion(.failure(parseError))
            }
        }.resume()
    }
    
    func loadFilters(completion: @escaping HandleForFilters) {
        
        guard let url = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/list.php?c=list") else { return }
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                let taskError = NSError(domain: "", code: ErrorCode.taskError.rawValue, userInfo: nil)
                completion(.failure(taskError))
                return
            }
            
            guard let data = data else {
                
                let emptyData = NSError(domain: "", code: ErrorCode.emptyData.rawValue, userInfo: nil)
                completion(.failure(emptyData))
                return
            }
            
            do {
                
                guard let data = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any] else { return }
                guard let drinks = data["drinks"] as? [[String : Any]] else { return }
                
                var arrayFilters = [DrinkFilter]()
                
                for i in drinks {
                    guard let name = i["strCategory"] as? String else { return }
                    
                    arrayFilters.append(DrinkFilter(strCategory: name))
                }
                arrayFilters.remove(at: 0)
                completion(.success(arrayFilters))
                
            } catch{
                let parseError = NSError(domain: "", code: ErrorCode.parseError.rawValue, userInfo: nil)
                completion(.failure(parseError))
            }
        }.resume()
    }
}
