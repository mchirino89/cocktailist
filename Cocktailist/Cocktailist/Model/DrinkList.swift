//
//  Drink.swift
//  Cocktailist
//
//  Created by Mauricio Chirino on 23/2/18.
//  Copyright © 2018 Mauricio Chirino. All rights reserved.
//

import Foundation

struct DrinkList: Decodable {
    let drinks: [Drink]
    
    enum CodingKeys: String, CodingKey {
        case drinks
    }
    
}

extension DrinkList {
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let drinks = try container.decode([Drink].self, forKey: .drinks)
        self.init(drinks: drinks)
    }
    
}

