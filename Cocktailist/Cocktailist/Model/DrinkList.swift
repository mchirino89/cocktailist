//
//  DrinkList.swift
//  Cocktailist
//
//  Created by Mauricio Chirino on 23/2/18.
//  Copyright © 2018 Mauricio Chirino. All rights reserved.
//

import Foundation

struct DrinkList: Decodable {
    let drinks: [Drink]
}

struct Drink: Decodable {
    
    let name: String
    let image: URL
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case name = "strDrink"
        case image = "strDrinkThumb"
        case id = "idDrink"
    }
    
}
