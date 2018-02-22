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
    
    struct UI {
        static let detailsSegue = "cocktailDetailSegue"
    }
    
    struct cell {
        static let name = "cocktailCell"
        static let height: CGFloat = 180
    }
    
    struct units {
        static let beggining = 0
        static let tableSections = 1
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
    
}

func addPadding(top: Design.padding, left: Design.padding, bottom: Design.padding, right: Design.padding) -> UIEdgeInsets {
    return UIEdgeInsetsMake(top.rawValue, left.rawValue, bottom.rawValue, right.rawValue)
}
