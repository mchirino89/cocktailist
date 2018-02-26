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

extension Drink {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let nameDecoded = try container.decode(String.self, forKey: .name)
        let imageDecoded = try container.decode(URL.self, forKey: .image)
        let idDecoded = try container.decode(String.self, forKey: .id)
        self.init(name: nameDecoded, image: URL(string: "\(Constants.network.http)\(imageDecoded)")!, id: idDecoded)
    }
}
