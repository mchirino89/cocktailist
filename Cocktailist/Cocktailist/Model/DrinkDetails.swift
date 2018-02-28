//
//  DrinkDetails.swift
//  Cocktailist
//
//  Created by Mauricio Chirino on 23/2/18.
//  Copyright © 2018 Mauricio Chirino. All rights reserved.
//

import Foundation

struct DrinkDetails: Decodable {
    let drinksDetails: [[String: String?]]
    
    enum CodingKeys: String, CodingKey {
        case drinksDetails = "drinks"
    }
}

extension DrinkDetails {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var dictionary: [[String: String?]] = []
        do {
            dictionary = try container.decode([[String: String?]].self, forKey: .drinksDetails)
        } catch {
            print(error.localizedDescription)
        }
        self.init(drinksDetails: dictionary)
    }
}
