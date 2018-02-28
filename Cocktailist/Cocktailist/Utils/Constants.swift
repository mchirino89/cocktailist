//
//  Constants.swift
//  Cocktailist
//
//  Created by Mauricio Chirino on 21/2/18.
//  Copyright © 2018 Mauricio Chirino. All rights reserved.
//

import CoreGraphics.CGGeometry
import UIKit

struct Constants {
    
    struct json {
        static let list = "cocktailList"
        static let details = "cocktailDetails"
        static let type = "json"
    }
    
    struct network {
        static let http = "http://"
        static let imageMime = "image"
        
        
        struct URLs {
            static let root = URL(string: "https://www.thecocktaildb.com/api/json/v1/1/filter.php?g=Cocktail_glass")!
            static let cocktailURL = "https://www.thecocktaildb.com/api/json/v1/1/lookup.php"
            static let queryName = "i"
        }
    }
    
    enum drinkInfo: String {
        case title = "strDrink"
        case ingredient = "strIngredient"
        case measure = "strMeasure"
        case instructions = "strInstructions"
        case image = "strDrinkThumb"
    }
    
    struct UI {
        static let detailsSegue = "cocktailDetailSegue"
        static let preparation = "How to prepare\n"
    }
    
    struct cell {
        static let name = "cocktailCell"
        static let height: CGFloat = 180
    }
    
    struct units {
        static let beggining = 0
        static let tableSections = 1
        static let ingredientsCount = 15
    }
}

struct Design {
    
    static let cornerRadius: CGFloat = 8
    
    enum padding: CGFloat {
        case none = 0
        case medium = 16
        case minimum = 8
        case extended = 48
    }
    
    struct shadow {
        static let color = UIColor.black.cgColor
        static let radius: CGFloat = 2
        static let opacity: Float = 1/4
        static let offset = CGSize(width: 0, height: 1)
    }
    
    struct animation {
        static let duration: TimeInterval = 0.3
        static let fadeOut: CGFloat = 0
        static let visible: CGFloat = 56
    }
    
}

func addPadding(top: Design.padding, left: Design.padding, bottom: Design.padding, right: Design.padding) -> UIEdgeInsets {
    return UIEdgeInsetsMake(top.rawValue, left.rawValue, bottom.rawValue, right.rawValue)
}
